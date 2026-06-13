-- ============================================================
-- 动作槽产出规则 - 纯卡牌驱动版
-- 每个动作槽消耗一张卡牌，产出 1~N 张新卡牌
-- 字段说明：
--   outcomes : 加权随机分支表
--     weight : 概率权重
--     when   : 条件（min_card_quality / card_type / min_mystery / min_knowledge / min_power）
--     result : 产出
--       card        : 固定产出卡牌 ID
--       random_card : 随机从池中选一张产出
--       cards       : 固定产出多张卡牌 {id1, id2, ...}
--       result_text : 描述文字
-- ============================================================

return {

    -- 修炼：根据卡牌力量产出修炼成果
    work = {
        result_text = "修炼完成",
        outcomes = {
            {
                weight = 2,
                result = { card = "basic_qi", result_text = "运转功法，凝聚灵气碎片" },
            },
            {
                weight = 1,
                when = { min_card_quality = 2 },
                result = { card = "spirit_stone", result_text = "修炼有成，凝结灵石" },
            },
            {
                weight = 1,
                when = { min_card_quality = 3, min_power = 4 },
                result = { card = "qi_refining", result_text = "功法精进，领悟练气诀" },
            },
        },
    },

    -- 研习：根据卡牌知识产出领悟
    study = {
        result_text = "研习完成",
        outcomes = {
            {
                weight = 2,
                result = { card = "insight_fragment", result_text = "灵光一闪，获得顿悟碎片" },
            },
            {
                weight = 1,
                when = { min_card_quality = 2, card_type = "lore" },
                result = { card = "taiji_scripture", result_text = "参悟典籍，领悟太极玄清道" },
            },
            {
                weight = 1,
                when = { min_card_quality = 3 },
                result = { card = "sword_manual", result_text = "研读剑谱，习得青云剑诀" },
            },
        },
    },

    -- 探索：外出游历
    explore = {
        result_text = "探索归来",
        outcomes = {
            {
                weight = 3,
                result = { card = "spirit_herb", result_text = "采集到灵草" },
            },
            {
                weight = 2,
                result = { card = "spirit_stone", result_text = "发现灵石矿脉" },
            },
            {
                weight = 2,
                result = { card = "shadow_wolf", result_text = "遭遇影狼！" },
            },
            {
                weight = 1,
                when = { min_card_quality = 3 },
                result = { card = "qingyun_mountain", result_text = "发现青云山仙府" },
            },
            {
                weight = 1,
                when = { min_mystery = 4 },
                result = { card = "immortal_market", result_text = "误入修仙坊市" },
            },
        },
    },

    -- 仪式：消耗卡牌获得强大效果
    ritual = {
        result_text = "仪式完成",
        outcomes = {
            {
                weight = 1,
                result = { card = "demon_essence", result_text = "仪式成功，凝聚魔气精华" },
            },
            {
                weight = 1,
                when = { min_card_quality = 3 },
                result = { card = "demon_sutra", result_text = "感应到天魔秘典残卷" },
            },
            {
                weight = 1,
                when = { min_card_quality = 4 },
                result = { card = "blood_art", result_text = "领悟血炼之法" },
            },
        },
    },

    -- 论道：与同道交流
    talk = {
        result_text = "论道结束",
        outcomes = {
            {
                weight = 2,
                result = { card = "friendship_token", result_text = "结下友谊，获得信物" },
            },
            {
                weight = 1,
                when = { card_type = "follower" },
                result = { card = "wandering_cultivator", result_text = "结识散修李逍遥" },
            },
            {
                weight = 1,
                when = { min_card_quality = 3 },
                result = { card = "old_hermit", result_text = "得遇隐世高人玄真子" },
            },
        },
    },

    -- 炼器：炼制法宝
    refine = {
        result_text = "炼制完成",
        outcomes = {
            {
                weight = 2,
                result = { card = "spirit_stone", result_text = "炼器失败，只余灵石残渣" },
            },
            {
                weight = 1,
                when = { min_card_quality = 2, card_type = "ingredient" },
                result = {
                    result_text = "成功炼制出法器！",
                    random_card = { "spirit_sword", "jade_amulet", "alchemy_furnace" },
                },
            },
            {
                weight = 1,
                when = { min_card_quality = 4 },
                result = { card = "demon_blade", result_text = "以魔道秘法炼成魔刃噬魂" },
            },
        },
    },

    -- 入梦：进入梦境
    dream = {
        result_text = "梦醒时分",
        outcomes = {
            {
                weight = 2,
                result = { card = "dream_fragment", result_text = "捕捉到梦境碎片" },
            },
            {
                weight = 1,
                when = { min_mystery = 3 },
                result = { card = "insight_fragment", result_text = "梦中悟道，获得顿悟" },
            },
            {
                weight = 1,
                when = { min_mystery = 5 },
                result = { card = "heavenly_tribulation", result_text = "梦见天劫预兆！" },
            },
        },
    },
}
