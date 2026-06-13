-- ============================================================
-- 玩家初始数据 - 数据驱动
-- 策划修改这里即可调整初始资源/属性/境界升级公式
-- ============================================================

return {
    -- 基础资源
    health            = 100,
    maxHealth         = 100,
    sanity            = 100,
    maxSanity         = 100,
    corruption        = 0,
    maxCorruption     = 100,
    spiritQi          = 0,
    spiritStones      = 0,
    bloodEssence      = 0,
    karma             = 0,

    -- 境界
    cultivation       = 1,
    cultivationXP     = 0,
    cultivationXPNeeded = 100,
    cultivationNames = {
        "凡人", "练气期", "筑基期", "金丹期",
        "元婴期", "化神期", "合体期", "大乘期", "渡劫期"
    },
    -- 升级时获得的属性加成
    levelUpHealthBonus = 20,
    levelUpSanityBonus = 10,
    levelUpXPMultiplier = 2,   -- 下一境界所需经验 *= 该值

    -- 时间/抽卡
    turn = 1,
    drawCount = 3,
    heartDemon = 0,
    fortune = 0,

    -- 倍速档位
    speedLevels = {0.5, 1, 2, 3, 4},
    speedIndex = 2,           -- 默认 1 (0.5x 是 1, 1x 是 2)
}
