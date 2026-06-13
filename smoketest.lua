-- ============================================================
-- 冒烟测试 - 纯卡牌驱动版
-- 验证：槽位创建、卡牌放入、完成产出新卡牌
-- ============================================================

-- 重定向 print 到文件
local reportPath = love.filesystem.getSaveDirectory() .. "/smoke_report.txt"
local reportFile = io.open(reportPath, "w")
local function log(msg)
    if reportFile then
        reportFile:write(msg .. "\n")
        reportFile:flush()
    end
end
print = log

print("love.load entered at " .. os.time())

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
print("all files loaded")

-- 初始化
Player:init()
Board:init()
Event:init()
UI:init()
Sound:init()
CardDB:init()
EventDB:init()
print("init done")

-- 测试辅助
local okCount = 0
local failCount = 0
local function check(cond, label)
    if cond then
        okCount = okCount + 1
        print("OK  " .. label)
    else
        failCount = failCount + 1
        print("FAIL " .. label)
    end
end

-- 测试 1：槽位数量
check(#Board.slots == 7, "Board.slots == 7")

-- 测试 2：槽位 id
check(Board.slots[1].id == "work", "slot[1] id = work")
check(Board.slots[2].id == "study", "slot[2] id = study")

-- 测试 3：发放起始手牌
local startingDeck = require("src.data.starting_deck")
for _, cardId in ipairs(startingDeck) do
    Board:addCardToHand(CardDB:create(cardId))
end
check(#Board.hand == 5, "starting hand count = 5")
print("hand cards: " .. table.concat(startingDeck, ", "))

-- 测试 4：将第一张卡牌放入 work 槽
local card = Board.hand[1]
check(card ~= nil, "hand[1] exists")
print("card name = " .. card.name .. " type = " .. card.type)

local placed = Board:placeCardInSlot(card, 1)
check(placed, "place card in slot 1")
check(Board.slots[1].active == true, "slot 1 active")
check(#Board.hand == 4, "hand count = 4 after place")

-- 测试 5：模拟槽位完成（直接调用 completeSlot）
local slot = Board.slots[1]
local handBefore = #Board.hand
Board:completeSlot(slot)
check(slot.active == false, "slot 1 cleared after complete")
check(slot.card == nil, "slot 1 card nil after complete")

-- 测试 6：产出卡牌
local handAfter = #Board.hand
check(handAfter >= handBefore, "hand count >= before (got new cards)")
print("hand count after complete: " .. handAfter)

-- 测试 7：预览结果
local card2 = Board.hand[1]
if card2 then
    local preview = Board:previewResult(Board.slots[2], card2)
    check(preview ~= nil, "preview result exists")
    check(preview.cards ~= nil, "preview has cards table")
    print("preview text: " .. (preview.text or "nil"))
end

-- 测试 8：兼容性
local compat = require("src.data.compatibility")
check(compat.lore.work == true, "compat lore.work")

-- 测试 9：Player 不再有数值属性
check(Player.health == nil, "Player.health removed")
check(Player.spiritQi == nil, "Player.spiritQi removed")
check(Player.cultivation == nil, "Player.cultivation removed")

-- 测试 10：Player 保留日志和倍速
check(Player.log ~= nil, "Player.log exists")
check(Player.gameSpeed ~= nil, "Player.gameSpeed exists")

-- 总结
print("")
print("OK=" .. okCount .. " FAIL=" .. failCount)
if failCount == 0 then
    print("ALL PASSED")
else
    print("SOME FAILED")
end
print("DONE")

if reportFile then
    reportFile:close()
end

love.event.quit()