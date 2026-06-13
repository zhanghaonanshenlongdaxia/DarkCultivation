-- ============================================================
-- 事件系统 - 剧情/随机事件
-- ============================================================

Event = {}
Event.__index = Event

function Event:init()
    self.currentEvent = nil
    self.eventQueue = {}
    self.eventTimer = 0
    self.eventInterval = 120  -- 每120秒触发随机事件
    self.storyProgress = 0
    self.completedEvents = {}
    self.eventLog = {}
end

function Event:trigger(eventId)
    local template = EventDB:get(eventId)
    if not template then return end
    
    self.currentEvent = {
        id = eventId,
        title = template.title,
        text = template.text,
        choices = template.choices or {},
        duration = template.duration or 0,
        timer = 0,
        autoResolve = template.autoResolve or false,
    }
    
    table.insert(self.eventLog, {time = os.time(), event = eventId})
    Player:addLog("【事件】" .. template.title)
end

function Event:update(dt)
    -- 当前事件计时
    if self.currentEvent then
        self.currentEvent.timer = self.currentEvent.timer + dt
        if self.currentEvent.autoResolve and 
           self.currentEvent.timer >= self.currentEvent.duration then
            self:resolveEvent(1)  -- 自动选择第一个选项
        end
    end
    
    -- 随机事件计时
    if not self.currentEvent then
        self.eventTimer = self.eventTimer + dt
        if self.eventTimer >= self.eventInterval then
            self.eventTimer = 0
            self:triggerRandomEvent()
        end
    end
end

function Event:triggerRandomEvent()
    local available = {}
    for id, template in pairs(EventDB.templates) do
        if template.random and not self.completedEvents[id] then
            if not template.condition or template.condition() then
                table.insert(available, id)
            end
        end
    end
    
    if #available > 0 then
        local id = available[love.math.random(#available)]
        self:trigger(id)
    end
end

function Event:resolveEvent(choiceIndex)
    if not self.currentEvent then return end
    
    local choice = self.currentEvent.choices[choiceIndex]
    if not choice then return end
    
    -- 应用选择效果
    if choice.effects then
        for _, effect in ipairs(choice.effects) do
            self:applyEffect(effect)
        end
    end
    
    -- 后续事件
    if choice.nextEvent then
        self:trigger(choice.nextEvent)
    end
    
    Player:addLog(choice.resultText or "做出了选择...")
    self.completedEvents[self.currentEvent.id] = true
    self.currentEvent = nil
end

function Event:applyEffect(effect)
    local etype = effect.type
    local value = effect.value or 0
    
    if etype == "xp" then
        Player:addXP(value)
    elseif etype == "health" then
        Player:addHealth(value)
    elseif etype == "sanity" then
        Player:addSanity(value)
    elseif etype == "corruption" then
        Player:addCorruption(value)
    elseif etype == "qi" then
        Player:addQi(value)
    elseif etype == "stones" then
        Player:addStones(value)
    elseif etype == "blood" then
        Player:addBlood(value)
    elseif etype == "karma" then
        Player:addKarma(value)
    elseif etype == "card" then
        local card = CardDB:create(effect.cardId)
        if card then
            Board:addCardToHand(card)
        end
    elseif etype == "log" then
        Player:addLog(effect.text or "")
    end
end

function Event:hasEvent(id)
    return self.completedEvents[id] == true
end

-- 事件数据库
EventDB = {}
EventDB.__index = EventDB

function EventDB:init()
    self.templates = {}
    self:registerAll()
end

function EventDB:register(data)
    self.templates[data.id] = data
end

function EventDB:get(id)
    return self.templates[id]
end

function EventDB:registerAll()
    -- 由 data/events.lua 填充
end

return Event