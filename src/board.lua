-- ============================================================
-- 棋盘系统 - 动作槽（数据驱动版）
-- 所有槽位/产出规则/兼容性都从 data/ 目录加载，逻辑只负责解释
-- ============================================================

-- 数据驱动加载（在 Board 类外部的 require 时执行一次）
local SlotsConfig     = require("src.data.slots")
local VerbsConfig     = require("src.data.verbs")

Board = {}
Board.__index = Board

-- 槽位 id -> 槽位索引，方便按 id 查找
Board.SLOT_BY_ID = {}
for i, s in ipairs(SlotsConfig) do
    Board.SLOT_BY_ID[s.id] = i
end

-- 动作槽 id 列表（兼容老接口 Board.SLOT_TYPES.*）
Board.SLOT_TYPES = {}
for _, s in ipairs(SlotsConfig) do
    Board.SLOT_TYPES[s.id:upper()] = s.id
end

-- ========== 通用执行器 ==========

-- 解析 when 条件是否满足
local function checkWhen(when, card)
    if not when then return true end
    if when.min_card_quality and card.quality < when.min_card_quality then return false end
    if when.card_type and card.type ~= when.card_type then return false end
    if when.min_mystery and card.mystery < when.min_mystery then return false end
    if when.min_knowledge and card.knowledge < when.min_knowledge then return false end
    if when.min_power and card.power < when.min_power then return false end
    return true
end

-- 把 result 模板字段应用到一张卡牌，返回 result 表
local function applyResultTemplate(tmpl, card)
    local r = {
        text = "", newCard = nil,
        xp = tmpl.xp or 0, qi = tmpl.qi or 0, stones = tmpl.stones or 0,
        health = tmpl.health or 0, sanity = tmpl.sanity or 0,
        corruption = tmpl.corruption or 0, blood = tmpl.blood or 0,
        karma = tmpl.karma or 0,
    }
    if card then
        if tmpl.xp_mul_power       then r.xp = r.xp + card.power * tmpl.xp_mul_power end
        if tmpl.xp_mul_knowledge   then r.xp = r.xp + card.knowledge * tmpl.xp_mul_knowledge end
        if tmpl.xp_mul_mystery     then r.xp = r.xp + card.mystery * tmpl.xp_mul_mystery end
        if tmpl.xp_mul_danger      then r.xp = r.xp + card.danger * tmpl.xp_mul_danger end
        if tmpl.qi_mul_power       then r.qi = r.qi + card.power * tmpl.qi_mul_power end
        if tmpl.qi_mul_mystery     then r.qi = r.qi + card.mystery * tmpl.qi_mul_mystery end
        if tmpl.stones_mul_mystery then r.stones = r.stones + card.mystery * tmpl.stones_mul_mystery end
    end
    if tmpl.card then
        r.newCard = CardDB:create(tmpl.card)
    elseif tmpl.random_card then
        local pool = tmpl.random_card
        local pick = pool[love.math.random(#pool)]
        r.newCard = CardDB:create(pick)
    end
    return r
end

-- 把 result 里的 text 模板占位符替换
local function formatText(tmpl, result)
    if not tmpl or tmpl == "" then return "" end
    local s = tmpl
    s = s:gsub("{xp}", tostring(math.floor(result.xp)))
    s = s:gsub("{qi}", tostring(math.floor(result.qi)))
    s = s:gsub("{stones}", tostring(math.floor(result.stones)))
    s = s:gsub("{health}", tostring(math.floor(result.health)))
    s = s:gsub("{sanity}", tostring(math.floor(result.sanity)))
    s = s:gsub("{corruption}", tostring(math.floor(result.corruption)))
    return s
end

-- 合并两个 result（第二个覆盖非零字段）
local function mergeResult(a, b)
    for k, v in pairs(b) do
        if k == "newCard" or k == "text" then
            if v then a[k] = v end
        else
            a[k] = (a[k] or 0) + v
        end
    end
    return a
end

-- 根据 verb 公式计算产出
local function calculateFromFormula(slotId, card)
    local verb = VerbsConfig[slotId]
    if not verb then
        return { text = "", xp = 0, qi = 0, stones = 0, health = 0, sanity = 0, corruption = 0, blood = 0, karma = 0 }
    end

    -- 1) 基础结果
    local result = applyResultTemplate(verb, card)
    local usedText = verb.result_text

    -- 2) 加权随机分支
    if verb.outcomes then
        local candidates = {}
        local total = 0
        for _, o in ipairs(verb.outcomes) do
            if checkWhen(o.when, card) then
                table.insert(candidates, o)
                total = total + (o.weight or 1)
            end
        end
        if total > 0 then
            local roll = love.math.random() * total
            local acc = 0
            for _, o in ipairs(candidates) do
                acc = acc + (o.weight or 1)
                if roll <= acc then
                    local sub = applyResultTemplate(o.result, card)
                    if o.result.result_text then usedText = o.result.result_text end
                    mergeResult(result, sub)
                    break
                end
            end
        end
    end

    result.text = formatText(usedText, result)
    return result
end

-- ========== 类方法 ==========

function Board:init()
    self.hand = {}
    self.maxHandSize = 7
    self.slots = {}
    self:createSlots()
    self.timers = {}
    self.dragging = nil
    self.dragCard = nil
    self.dragOffsetX = 0
    self.dragOffsetY = 0
    self.hoverSlot = nil
end

function Board:createSlots()
    -- 从 SlotsConfig 数据生成槽位
    self.slots = {}
    for i, s in ipairs(SlotsConfig) do
        table.insert(self.slots, {
            id = s.id,
            name = s.name,
            description = s.description,
            card = nil,
            result = nil,
            progress = 0,
            duration = 0,
            active = false,
            x = 0, y = 0, w = 180, h = 60,
            color = s.color,
            base_duration = s.base_duration or 60,
        })
    end
end

function Board:addCardToHand(card)
    if #self.hand < self.maxHandSize then
        table.insert(self.hand, card)
        return true
    end
    return false
end

function Board:removeCardFromHand(card)
    for i, c in ipairs(self.hand) do
        if c == card then
            table.remove(self.hand, i)
            return true
        end
    end
    return false
end

function Board:placeCardInSlot(card, slotIndex)
    local slot = self.slots[slotIndex]
    if not slot then return false end
    if slot.active then return false end
    self:removeCardFromHand(card)
    slot.card = card
    slot.active = true
    slot.progress = 0
    slot.duration = self:getSlotDuration(slot, card)
    slot.result = nil
    Player:addLog("将【" .. card.name .. "】放入【" .. slot.name .. "】")
    return true
end

function Board:getSlotDuration(slot, card)
    -- 基础时间来自数据 base_duration，按品质递减
    local base = slot.base_duration or 60
    local qualityMod = 1 - (card.quality - 1) * 0.1
    return math.max(20, base * qualityMod)
end

function Board:update(dt)
    for _, slot in ipairs(self.slots) do
        if slot.active and slot.card then
            slot.progress = slot.progress + dt
            if slot.progress >= slot.duration then
                self:completeSlot(slot)
            end
        end
    end
    for i = #self.hand, 1, -1 do
        local card = self.hand[i]
        card:tick(dt)
        if card.exhausted then
            table.remove(self.hand, i)
            Player:addLog("【" .. card.name .. "】消散了...")
        end
    end
end

function Board:completeSlot(slot)
    local card = slot.card
    if not card then return end

    local result = self:calculateResult(slot, card)
    slot.result = result
    slot.active = false
    slot.card = nil
    slot.progress = 0

    self:applyResult(slot, result)

    if result.newCard then
        self:addCardToHand(result.newCard)
    end

    local hasAnyEffect = result.newCard ~= nil
        or result.xp ~= 0 or result.qi ~= 0 or result.stones ~= 0
        or result.health ~= 0 or result.sanity ~= 0 or result.corruption ~= 0
        or result.blood ~= 0 or result.karma ~= 0

    if not hasAnyEffect then
        if #self.hand < self.maxHandSize then
            self:addCardToHand(card)
            Player:addLog("【" .. slot.name .. "】完成，但无所得，【" .. card.name .. "】返回手中")
            result.text = "一无所获，卡牌返回手中"
        else
            Player:addLog("【" .. slot.name .. "】完成，但手牌已满，【" .. card.name .. "】消散")
            result.text = "一无所获，卡牌消散"
        end
    else
        Player:addLog("【" .. slot.name .. "】完成：" .. result.text)
    end
end

function Board:previewResult(slot, card)
    return self:calculateResult(slot, card)
end

function Board:calculateResult(slot, card)
    return calculateFromFormula(slot.id, card)
end

function Board:applyResult(slot, result)
    Player:addXP(result.xp)
    Player:addQi(result.qi)
    Player:addStones(result.stones)
    Player:addHealth(result.health)
    Player:addSanity(result.sanity)
    Player:addCorruption(result.corruption)
    Player:addBlood(result.blood)
    Player:addKarma(result.karma)
end

function Board:getSlotAt(x, y)
    for i, slot in ipairs(self.slots) do
        if x >= slot.x and x <= slot.x + slot.w and
           y >= slot.y and y <= slot.y + slot.h then
            return i, slot
        end
    end
    return nil, nil
end

function Board:getCardAt(x, y, cardW, cardH)
    for i = #self.hand, 1, -1 do
        local cx, cy = self:getCardPosition(i)
        if x >= cx and x <= cx + cardW and
           y >= cy and y <= cy + cardH then
            return self.hand[i], i
        end
    end
    return nil, nil
end

function Board:getCardPosition(index)
    local w = love.graphics.getWidth()
    local handH = 200
    local cardW = 110
    local cardSpacing = 95
    local totalW = cardSpacing * (#self.hand - 1) + cardW
    local startX = (w - totalW) / 2
    local cardY = love.graphics.getHeight() - handH + 35
    return startX + (index - 1) * cardSpacing, cardY
end

return Board
