-- ============================================================
-- 卡牌类型 -> 可用动作槽 兼容性表 - 数据驱动
-- 策划修改此表即可控制哪些卡牌可以放入哪些符印
-- 外层 key = 卡牌 type（与 Card.TYPES.* 字符串值对应）
-- 内层 key = 槽位 id（与 data/slots.lua 中 id 对应）
-- ============================================================

return {
    lore       = { work = true, study = true },
    item       = { refine = true },
    follower   = { talk = true },
    ingredient = { refine = true },
    influence  = { ritual = true },
    ritual     = { ritual = true },
    location   = { explore = true },
    monster    = { explore = true, work = true },
    tool       = { refine = true },
    spirit     = { dream = true, ritual = true },
}
