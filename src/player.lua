-- ============================================================
-- 玩家系统 - 修仙者属性、资源、境界（数据驱动版）
-- 所有初始值/升级公式来自 data/player_init.lua
-- ============================================================

local PlayerInit = require("src.data.player_init")

Player = {}
Player.__index = Player

function Player:init()
    for k, v in pairs(PlayerInit) do
        self[k] = v
    end
    -- 运行期状态
    self.techniques = {}
    self.affinities = { metal = 0, wood = 0, water = 0, fire = 0, earth = 0 }
    self.statusEffects = {}
    self.log = {}
    self.maxLog = 50
    self.gameSpeed = self.speedLevels[self.speedIndex] or 1
end

function Player:cycleSpeed()
    self.speedIndex = (self.speedIndex % #self.speedLevels) + 1
    self.gameSpeed = self.speedLevels[self.speedIndex]
    local name = "正常"
    if self.gameSpeed == 0.5 then name = "慢速"
    elseif self.gameSpeed == 1 then name = "正常"
    elseif self.gameSpeed == 2 then name = "2倍速"
    elseif self.gameSpeed == 3 then name = "3倍速"
    elseif self.gameSpeed == 4 then name = "4倍速" end
    self:addLog("【倍速】切换为 " .. name)
end

function Player:getCultivationName()
    return self.cultivationNames[self.cultivation] or "未知"
end

function Player:addXP(amount)
    self.cultivationXP = self.cultivationXP + amount
    while self.cultivationXP >= self.cultivationXPNeeded and self.cultivation < 9 do
        self.cultivationXP = self.cultivationXP - self.cultivationXPNeeded
        self.cultivation = self.cultivation + 1
        self.cultivationXPNeeded = self.cultivationXPNeeded * (self.levelUpXPMultiplier or 2)
        self:addLog("突破！晋升为【" .. self:getCultivationName() .. "】")
        self.maxHealth = self.maxHealth + (self.levelUpHealthBonus or 20)
        self.health = self.maxHealth
        self.maxSanity = self.maxSanity + (self.levelUpSanityBonus or 10)
        self.sanity = self.maxSanity
    end
end

function Player:addHealth(amount)
    self.health = math.min(self.maxHealth, self.health + amount)
end

function Player:addSanity(amount)
    self.sanity = math.min(self.maxSanity, self.sanity + amount)
end

function Player:addCorruption(amount)
    self.corruption = math.min(self.maxCorruption, self.corruption + amount)
    if self.corruption >= 80 then
        self:addLog("警告：魔气入体，即将堕入魔道...")
    end
end

function Player:addQi(amount)
    self.spiritQi = self.spiritQi + amount
end

function Player:addStones(amount)
    self.spiritStones = self.spiritStones + amount
end

function Player:addBlood(amount)
    self.bloodEssence = self.bloodEssence + amount
end

function Player:addKarma(amount)
    self.karma = self.karma + amount
end

function Player:addLog(text)
    table.insert(self.log, 1, text)
    if #self.log > self.maxLog then
        table.remove(self.log)
    end
end

function Player:isDead()
    return self.health <= 0 or self.sanity <= 0 or self.corruption >= self.maxCorruption
end

function Player:getDeathReason()
    if self.health <= 0 then return "肉身陨落，魂飞魄散..."
    elseif self.sanity <= 0 then return "神智崩溃，走火入魔..."
    elseif self.corruption >= self.maxCorruption then return "彻底堕入魔道，化为邪魔..."
    end
    return "未知原因"
end

function Player:getStatusSummary()
    return string.format(
        "【%s】生命:%d/%d 神智:%d/%d 魔化:%d%% 灵气:%d 灵石:%d",
        self:getCultivationName(),
        self.health, self.maxHealth,
        self.sanity, self.maxSanity,
        self.corruption,
        self.spiritQi, self.spiritStones
    )
end

return Player
