-- ============================================================
-- 动作槽（符印）配置 - 数据驱动
-- 策划可以修改这里的槽位定义，逻辑代码无需改动
-- 字段说明：
--   id           : 槽位唯一标识（字符串）
--   name         : 显示名
--   description  : 描述
--   color        : 背景色 {r,g,b,a}
--   base_duration: 基础持续时间（秒），会与卡牌品质相乘
-- ============================================================

return {
    {
        id = "work",
        name = "修炼",
        description = "运转功法，吸纳天地灵气",
        color = {0.15, 0.4, 0.15, 0.8},
        base_duration = 60,
    },
    {
        id = "study",
        name = "研习",
        description = "研读典籍，参悟大道",
        color = {0.15, 0.15, 0.5, 0.8},
        base_duration = 60,
    },
    {
        id = "explore",
        name = "探索",
        description = "外出游历，寻访机缘",
        color = {0.4, 0.3, 0.1, 0.8},
        base_duration = 60,
    },
    {
        id = "ritual",
        name = "仪式",
        description = "举行仪式，沟通天地",
        color = {0.5, 0.1, 0.1, 0.8},
        base_duration = 60,
    },
    {
        id = "talk",
        name = "论道",
        description = "与同道交流，结交仙缘",
        color = {0.5, 0.4, 0.1, 0.8},
        base_duration = 60,
    },
    {
        id = "refine",
        name = "炼器",
        description = "炼制法宝，锻造神兵",
        color = {0.5, 0.2, 0.0, 0.8},
        base_duration = 60,
    },
    {
        id = "dream",
        name = "入梦",
        description = "进入梦境，感悟天道",
        color = {0.3, 0.1, 0.4, 0.8},
        base_duration = 60,
    },
}
