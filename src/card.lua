-- ============================================================
-- 卡牌系统 - 游戏核心
-- ============================================================

Card = {}
Card.__index = Card

-- 卡牌类型
Card.TYPES = {
    LORE = "lore",           -- 知识/功法
    ITEM = "item",           -- 物品
    FOLLOWER = "follower",   -- 追随者/弟子
    INGREDIENT = "ingredient", -- 材料
    INFLUENCE = "influence", -- 影响/状态
    RITUAL = "ritual",       -- 仪式
    LOCATION = "location",   -- 地点
    MONSTER = "monster",     -- 妖兽/敌人
    TOOL = "tool",           -- 法器/工具
    SPIRIT = "spirit",       -- 灵体/魂魄
}

-- 类型与符印(动作槽)的兼容关系（数据驱动）
-- 从 data/compatibility.lua 加载
Card.SLOT_COMPATIBILITY = require("src.data.compatibility")

-- 判断卡牌是否可放入某个槽位
function Card:canPlaceIn(slotId)
    local compat = Card.SLOT_COMPATIBILITY[self.type]
    if not compat then return false end
    return compat[slotId] == true
end

-- 返回兼容的槽位ID列表
function Card:getCompatibleSlots()
    local compat = Card.SLOT_COMPATIBILITY[self.type]
    if not compat then return {} end
    local result = {}
    for k, v in pairs(compat) do
        if v then table.insert(result, k) end
    end
    return result
end

-- 五行属性
Card.ELEMENTS = {
    METAL = "metal",
    WOOD = "wood",
    WATER = "water",
    FIRE = "fire",
    EARTH = "earth",
    NONE = "none",
}

-- 卡牌品质
Card.QUALITIES = {
    MORTAL = 1,     -- 凡品
    SPIRIT = 2,     -- 灵品
    EARTH = 3,      -- 地品
    HEAVEN = 4,     -- 天品
    IMMORTAL = 5,   -- 仙品
    DEMONIC = 6,    -- 魔品
}

function Card:new(data)
    local c = setmetatable({}, Card)
    c.id = data.id or "unknown"
    c.name = data.name or "未知卡牌"
    c.type = data.type or Card.TYPES.ITEM
    c.quality = data.quality or Card.QUALITIES.MORTAL
    c.element = data.element or Card.ELEMENTS.NONE
    c.description = data.description or ""
    c.flavorText = data.flavorText or ""
    
    -- 属性值
    c.power = data.power or 0       -- 力量
    c.knowledge = data.knowledge or 0 -- 知识
    c.mystery = data.mystery or 0   -- 神秘
    c.danger = data.danger or 0     -- 危险
    
    -- 特殊效果
    c.effects = data.effects or {}
    c.tags = data.tags or {}
    
    -- 时间相关
    c.lifetime = data.lifetime or 0  -- 0=永久
    c.remainingTime = c.lifetime
    
    -- 视觉
    c.icon = data.icon or "default"
    c.color = data.color or {0.3, 0.3, 0.3}
    
    -- 状态
    c.exhausted = false  -- 是否已耗尽（使用后消失）
    c.cursed = data.cursed or false
    
    return c
end

function Card:tick(dt)
    if self.lifetime > 0 then
        self.remainingTime = self.remainingTime - dt
        if self.remainingTime <= 0 then
            self.exhausted = true
        end
    end
end

function Card:getQualityName()
    local names = {
        [Card.QUALITIES.MORTAL] = "凡品",
        [Card.QUALITIES.SPIRIT] = "灵品",
        [Card.QUALITIES.EARTH] = "地品",
        [Card.QUALITIES.HEAVEN] = "天品",
        [Card.QUALITIES.IMMORTAL] = "仙品",
        [Card.QUALITIES.DEMONIC] = "魔品",
    }
    return names[self.quality] or "未知"
end

function Card:getQualityColor()
    local colors = {
        [Card.QUALITIES.MORTAL] = {0.6, 0.6, 0.6},
        [Card.QUALITIES.SPIRIT] = {0.2, 0.8, 0.2},
        [Card.QUALITIES.EARTH] = {0.2, 0.4, 0.9},
        [Card.QUALITIES.HEAVEN] = {0.9, 0.7, 0.1},
        [Card.QUALITIES.IMMORTAL] = {0.9, 0.2, 0.9},
        [Card.QUALITIES.DEMONIC] = {0.8, 0.1, 0.1},
    }
    return colors[self.quality] or {0.6, 0.6, 0.6}
end

function Card:getElementName()
    local names = {
        [Card.ELEMENTS.METAL] = "金",
        [Card.ELEMENTS.WOOD] = "木",
        [Card.ELEMENTS.WATER] = "水",
        [Card.ELEMENTS.FIRE] = "火",
        [Card.ELEMENTS.EARTH] = "土",
        [Card.ELEMENTS.NONE] = "无",
    }
    return names[self.element] or "无"
end

function Card:getTypeName()
    local names = {
        [Card.TYPES.LORE] = "功法",
        [Card.TYPES.ITEM] = "物品",
        [Card.TYPES.FOLLOWER] = "弟子",
        [Card.TYPES.INGREDIENT] = "材料",
        [Card.TYPES.INFLUENCE] = "影响",
        [Card.TYPES.RITUAL] = "仪式",
        [Card.TYPES.LOCATION] = "地点",
        [Card.TYPES.MONSTER] = "妖兽",
        [Card.TYPES.TOOL] = "法器",
        [Card.TYPES.SPIRIT] = "灵体",
    }
    return names[self.type] or "未知"
end

function Card:hasTag(tag)
    for _, t in ipairs(self.tags) do
        if t == tag then return true end
    end
    return false
end

-- 卡牌数据库
CardDB = {}
CardDB.__index = CardDB

function CardDB:init()
    self.templates = {}
    self:registerAll()
end

function CardDB:register(data)
    self.templates[data.id] = data
end

function CardDB:create(id)
    local template = self.templates[id]
    if not template then
        return Card:new({id = id, name = "未知卡牌:" .. id})
    end
    return Card:new(template)
end

function CardDB:registerAll()
    -- 由 data/cards.lua 填充
end

return Card