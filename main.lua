-- ============================================================
-- 暗黑修仙 · Dark Cultivation
-- 基于密教模拟器玩法的中国暗黑修仙卡牌游戏
-- ============================================================

-- 加载模块
require("src.player")
require("src.card")
require("src.board")
require("src.event")
require("src.ui")
require("src.sound")
require("src.data.cards")
require("src.data.events")
require("src.data.verbs")

function love.load()
    love.math.setRandomSeed(os.time())
    
    -- 初始化系统
    Player:init()
    Board:init()
    Event:init()
    UI:init()
    Sound:init()
    
    -- 初始卡牌
    CardDB:init()
    EventDB:init()
    
    -- 发放初始手牌（从 data/starting_deck.lua 加载）
    local startingDeck = require("src.data.starting_deck")
    for _, cardId in ipairs(startingDeck) do
        Board:addCardToHand(CardDB:create(cardId))
    end

    -- 初始剧情
    Event:trigger("game_start")
    
    -- 音乐
    Sound:playMusic("ambient")
end

function love.update(dt)
    UI:update(dt)
    -- 倍速(Board 可以调快调慢, UI 以正常速度)
    local sdt = dt * (Player.gameSpeed or 1)
    Board:update(sdt)
    Event:update(dt)
    Sound:update(dt)
end

function love.draw()
    UI:draw()
end

function love.mousepressed(x, y, button)
    UI:mousepressed(x, y, button)
end

function love.mousereleased(x, y, button)
    UI:mousereleased(x, y, button)
end

function love.mousemoved(x, y, dx, dy)
    UI:mousemoved(x, y, dx, dy)
end

function love.keypressed(key)
    UI:keypressed(key)
end

function love.resize(w, h)
    UI:resize(w, h)
end