-- ============================================================
-- 事件数据定义 - 剧情/随机事件
-- ============================================================

function EventDB:registerAll()
    
    -- ========== 主线剧情 ==========
    
    self:register({
        id = "game_start",
        title = "仙缘初现",
        text = [[你本是一介凡人，在尘世中碌碌无为。
一日，一封神秘信笺出现在你的枕边：
"仙缘已至，速来青云山。"

你感觉到一股莫名的力量在召唤你。
是时候做出选择了...]],
        random = false,
        choices = {
            {
                text = "前往青云山，追寻仙缘",
                resultText = "你踏上了修仙之路，命运的齿轮开始转动...",
                effects = {
                    {type = "xp", value = 10},
                    {type = "card", cardId = "qi_refining"},
                    {type = "log", text = "获得基础功法：练气诀"},
                },
                nextEvent = "arrive_qingyun",
            },
            {
                text = "无视信笺，继续平凡生活",
                resultText = "你选择了平凡，但命运不会轻易放过你...",
                effects = {
                    {type = "sanity", value = -10},
                    {type = "log", text = "你感到一阵莫名的不安..."},
                },
            },
        },
    })
    
    self:register({
        id = "arrive_qingyun",
        title = "青云山下",
        text = [[你来到了青云山脚下。
云雾缭绕的山峰直插云霄，隐约可见仙鹤盘旋。
一位白发老道在山门处等候。

"你来了。"老道淡淡地说，"我等你很久了。"
"修仙之路，有两条：正道与魔道。你选哪条？"]],
        random = false,
        choices = {
            {
                text = "拜入青云宗，修行正道",
                resultText = "你成为青云宗外门弟子，开始正道修行",
                effects = {
                    {type = "xp", value = 20},
                    {type = "karma", value = 10},
                    {type = "card", cardId = "sword_manual"},
                    {type = "card", cardId = "qingyun_mountain"},
                    {type = "log", text = "拜入青云宗，获得青云剑诀"},
                },
            },
            {
                text = "拒绝正道，探寻魔道",
                resultText = "你转身离去，魔道的种子在心中萌芽...",
                effects = {
                    {type = "xp", value = 30},
                    {type = "corruption", value = 20},
                    {type = "card", cardId = "demon_sutra"},
                    {type = "log", text = "获得天魔秘典·残卷，魔化+20"},
                },
            },
            {
                text = "两者皆不选，走自己的路",
                resultText = "你决定走一条无人走过的路",
                effects = {
                    {type = "xp", value = 15},
                    {type = "card", cardId = "taiji_scripture"},
                    {type = "log", text = "获得太极玄清道"},
                },
            },
        },
    })
    
    -- ========== 随机事件 ==========
    
    self:register({
        id = "wandering_merchant",
        title = "游方商人",
        text = [[一位游方商人出现在你面前，他的摊位上摆满了各种奇珍异宝。

"道友，要不要看看我的货？都是好东西！"
他神秘地笑着，眼中闪过一丝狡黠。]],
        random = true,
        choices = {
            {
                text = "购买灵草（消耗50灵石）",
                resultText = "你买下了一株灵草",
                effects = {
                    {type = "stones", value = -50},
                    {type = "card", cardId = "spirit_herb"},
                },
                condition = function() return Player.spiritStones >= 50 end,
            },
            {
                text = "购买神秘卷轴（消耗100灵石）",
                resultText = "你买下了一卷神秘卷轴",
                effects = {
                    {type = "stones", value = -100},
                    {type = "card", cardId = "sword_manual"},
                },
                condition = function() return Player.spiritStones >= 100 end,
            },
            {
                text = "不买，离开",
                resultText = "你转身离开，商人失望地叹了口气",
                effects = {},
            },
        },
    })
    
    self:register({
        id = "injured_cultivator",
        title = "受伤的修士",
        text = [[你在路上发现一位身受重伤的修士，他倒在血泊中，气息微弱。

"救...救我..."他艰难地伸出手。

你注意到他腰间挂着一枚品质不凡的储物袋。]],
        random = true,
        choices = {
            {
                text = "出手相救",
                resultText = "你救下了这位修士，他感激不尽",
                effects = {
                    {type = "karma", value = 15},
                    {type = "card", cardId = "friendship_token"},
                    {type = "log", text = "善有善报，获得友谊信物"},
                },
            },
            {
                text = "趁人之危，抢夺储物袋",
                resultText = "你夺走了储物袋，扬长而去...",
                effects = {
                    {type = "stones", value = 200},
                    {type = "corruption", value = 15},
                    {type = "karma", value = -20},
                    {type = "log", text = "业力-20，魔化+15"},
                },
            },
            {
                text = "视而不见，继续赶路",
                resultText = "你选择了冷漠",
                effects = {
                    {type = "sanity", value = -5},
                },
            },
        },
    })
    
    self:register({
        id = "ancient_ruins",
        title = "上古遗迹",
        text = [[你发现了一处上古修士留下的洞府遗迹。
石门半掩，里面隐约传来灵气的波动。

但同时，你也感受到了一股危险的气息。]],
        random = true,
        choices = {
            {
                text = "进入探索",
                resultText = "你在遗迹中发现了宝物",
                effects = {
                    {type = "xp", value = 50},
                    {type = "card", cardId = "thousand_year_ginseng"},
                },
            },
            {
                text = "谨慎观察后再进入",
                resultText = "你发现了隐藏的陷阱，安全获得了宝物",
                effects = {
                    {type = "xp", value = 30},
                    {type = "card", cardId = "jade_amulet"},
                    {type = "log", text = "小心驶得万年船"},
                },
            },
            {
                text = "离开，不冒险",
                resultText = "你选择了安全，但错过了一次机缘",
                effects = {},
            },
        },
    })
    
    self:register({
        id = "demon_whisper",
        title = "魔音入耳",
        text = [[夜深人静时，你听到耳边传来低语：
"力量...我可以给你力量..."
"只要你愿意付出一点点代价..."

你的内心开始动摇。]],
        random = true,
        condition = function() return Player.corruption >= 20 end,
        choices = {
            {
                text = "接受魔道的力量",
                resultText = "你接受了黑暗的馈赠，实力大增但心智受损",
                effects = {
                    {type = "xp", value = 100},
                    {type = "corruption", value = 25},
                    {type = "sanity", value = -20},
                    {type = "card", cardId = "demon_essence"},
                },
            },
            {
                text = "坚守道心，拒绝诱惑",
                resultText = "你守住了本心，道心更加坚定",
                effects = {
                    {type = "sanity", value = 10},
                    {type = "karma", value = 10},
                    {type = "log", text = "道心坚定，不为外魔所动"},
                },
            },
        },
    })
    
    self:register({
        id = "spirit_beast_attack",
        title = "妖兽来袭",
        text = [[一声咆哮打破了宁静！
一只妖兽出现在你面前，眼中闪烁着嗜血的光芒。

它的目标显然是你。]],
        random = true,
        choices = {
            {
                text = "迎战妖兽",
                resultText = "你与妖兽展开激战",
                effects = {
                    {type = "health", value = -20},
                    {type = "xp", value = 40},
                    {type = "card", cardId = "demon_core"},
                    {type = "log", text = "击杀妖兽，获得内丹"},
                },
            },
            {
                text = "使用灵石贿赂（消耗30灵石）",
                resultText = "妖兽叼走灵石，满意地离开了",
                effects = {
                    {type = "stones", value = -30},
                },
                condition = function() return Player.spiritStones >= 30 end,
            },
            {
                text = "逃跑",
                resultText = "你狼狈地逃走了",
                effects = {
                    {type = "health", value = -10},
                    {type = "sanity", value = -5},
                },
            },
        },
    })
    
    self:register({
        id = "meditation_insight",
        title = "顿悟时刻",
        text = [[打坐修炼时，你突然进入了一种玄妙的状态。
天地灵气如潮水般涌入体内，你感觉自己触碰到了大道的边缘。

这一刻，你明白了许多...]],
        random = true,
        condition = function() return Player.cultivation >= 2 end,
        choices = {
            {
                text = "全力吸收灵气",
                resultText = "你获得了大量修为",
                effects = {
                    {type = "xp", value = 80},
                    {type = "qi", value = 50},
                },
            },
            {
                text = "参悟大道至理",
                resultText = "你获得了深层的领悟",
                effects = {
                    {type = "xp", value = 40},
                    {type = "card", cardId = "insight_fragment"},
                    {type = "card", cardId = "dream_fragment"},
                },
            },
        },
    })
    
    self:register({
        id = "sect_tournament",
        title = "宗门大比",
        text = [[青云宗举办宗门大比，所有弟子都可以参加。
胜者将获得丰厚的奖励和长老的赏识。

你的实力是否足够？]],
        random = true,
        condition = function() return Event:hasEvent("arrive_qingyun") and Player.cultivation >= 2 end,
        choices = {
            {
                text = "参加大比",
                resultText = "你在比试中表现出色",
                effects = {
                    {type = "xp", value = 60},
                    {type = "stones", value = 100},
                    {type = "card", cardId = "spirit_sword"},
                    {type = "log", text = "宗门大比获胜，获得灵剑·青霜"},
                },
            },
            {
                text = "观战学习",
                resultText = "你从旁观摩，学到不少",
                effects = {
                    {type = "xp", value = 30},
                },
            },
        },
    })
    
    self:register({
        id = "fox_spirit_encounter",
        title = "狐仙奇遇",
        text = [[你在山林中遇到了一位白衣女子。
她自称白灵，是一只修炼千年的狐仙。

"凡人，你身上有有趣的气息..."她轻笑道。]],
        random = true,
        condition = function() return Player.cultivation >= 3 end,
        choices = {
            {
                text = "与她交谈",
                resultText = "白灵对你产生了兴趣，决定跟随你",
                effects = {
                    {type = "card", cardId = "fox_spirit"},
                    {type = "karma", value = 5},
                    {type = "log", text = "狐仙白灵加入了你的队伍"},
                },
            },
            {
                text = "保持警惕，离开",
                resultText = "你选择了谨慎",
                effects = {
                    {type = "sanity", value = 5},
                },
            },
        },
    })
    
    self:register({
        id = "tribulation_warning",
        title = "天劫预警",
        text = [[天空突然暗了下来，乌云密布。
你感到一股强大的威压从天而降。

这是...天劫的征兆！
你的修为已经引来了天道的注意。]],
        random = true,
        condition = function() return Player.cultivation >= 5 end,
        choices = {
            {
                text = "正面迎接天劫",
                resultText = "你硬扛天劫，虽然受伤但实力大增",
                effects = {
                    {type = "health", value = -40},
                    {type = "xp", value = 200},
                    {type = "card", cardId = "heavenly_tribulation"},
                    {type = "log", text = "渡过天劫，修为大增！"},
                },
            },
            {
                text = "使用法宝抵御",
                resultText = "你用法宝挡住了大部分天劫",
                effects = {
                    {type = "health", value = -15},
                    {type = "xp", value = 100},
                },
            },
        },
    })
end