-- ============================================================
-- 卡牌数据定义 - 所有游戏卡牌
-- ============================================================

function CardDB:registerAll()
    
    -- ========== 基础卡牌 ==========
    
    self:register({
        id = "intro_letter",
        name = "神秘信笺",
        type = Card.TYPES.LORE,
        quality = Card.QUALITIES.MORTAL,
        element = Card.ELEMENTS.NONE,
        description = "一封泛黄的信笺，上面写着：'仙缘已至，速来青云山'",
        flavorText = "命运的齿轮开始转动...",
        power = 1, knowledge = 2, mystery = 3, danger = 0,
        tags = {"intro", "quest"},
    })
    
    self:register({
        id = "basic_qi",
        name = "灵气碎片",
        type = Card.TYPES.INGREDIENT,
        quality = Card.QUALITIES.MORTAL,
        element = Card.ELEMENTS.NONE,
        description = "天地间最基础的灵气凝聚",
        flavorText = "修道之始，始于微末",
        power = 1, knowledge = 0, mystery = 1, danger = 0,
        lifetime = 120,
        color = {0.3, 0.7, 0.9},
    })
    
    self:register({
        id = "spirit_stone",
        name = "下品灵石",
        type = Card.TYPES.ITEM,
        quality = Card.QUALITIES.MORTAL,
        element = Card.ELEMENTS.EARTH,
        description = "蕴含少量灵气的矿石，修仙界的通用货币",
        flavorText = "财可通神，亦可通仙",
        power = 0, knowledge = 0, mystery = 0, danger = 0,
        color = {0.2, 0.8, 0.3},
    })
    
    self:register({
        id = "mortal_body",
        name = "凡人之躯",
        type = Card.TYPES.INFLUENCE,
        quality = Card.QUALITIES.MORTAL,
        element = Card.ELEMENTS.NONE,
        description = "你现在的身体——脆弱、短暂、充满局限",
        flavorText = "欲修仙，先炼体",
        power = 0, knowledge = 0, mystery = 0, danger = 0,
        lifetime = 300,
        color = {0.7, 0.5, 0.3},
    })
    
    -- ========== 功法类 ==========
    
    self:register({
        id = "qi_refining",
        name = "练气诀",
        type = Card.TYPES.LORE,
        quality = Card.QUALITIES.MORTAL,
        element = Card.ELEMENTS.NONE,
        description = "最基础的修仙功法，引导天地灵气入体",
        flavorText = "气沉丹田，周天运转",
        power = 2, knowledge = 3, mystery = 1, danger = 0,
        tags = {"technique", "basic"},
    })
    
    self:register({
        id = "sword_manual",
        name = "青云剑诀",
        type = Card.TYPES.LORE,
        quality = Card.QUALITIES.SPIRIT,
        element = Card.ELEMENTS.METAL,
        description = "青云宗入门剑法，以气御剑",
        flavorText = "一剑光寒十九州",
        power = 4, knowledge = 2, mystery = 2, danger = 1,
        tags = {"technique", "sword"},
    })
    
    self:register({
        id = "demon_sutra",
        name = "天魔秘典·残卷",
        type = Card.TYPES.LORE,
        quality = Card.QUALITIES.EARTH,
        element = Card.ELEMENTS.FIRE,
        description = "上古魔道功法残卷，修炼可大幅提升实力，但会侵蚀心智",
        flavorText = "力量从来不是免费的...",
        power = 6, knowledge = 4, mystery = 5, danger = 4,
        cursed = true,
        tags = {"technique", "demonic", "forbidden"},
    })
    
    self:register({
        id = "taiji_scripture",
        name = "太极玄清道",
        type = Card.TYPES.LORE,
        quality = Card.QUALITIES.HEAVEN,
        element = Card.ELEMENTS.WATER,
        description = "道家无上心法，阴阳调和，生生不息",
        flavorText = "道生一，一生二，二生三，三生万物",
        power = 5, knowledge = 7, mystery = 6, danger = 0,
        tags = {"technique", "taoist", "supreme"},
    })
    
    self:register({
        id = "blood_art",
        name = "血炼之法",
        type = Card.TYPES.LORE,
        quality = Card.QUALITIES.DEMONIC,
        element = Card.ELEMENTS.FIRE,
        description = "以自身精血为引，强行突破境界的禁忌之法",
        flavorText = "以血为媒，以命为注",
        power = 8, knowledge = 3, mystery = 7, danger = 6,
        cursed = true,
        tags = {"technique", "demonic", "blood"},
    })
    
    -- ========== 物品类 ==========
    
    self:register({
        id = "spirit_herb",
        name = "灵草",
        type = Card.TYPES.INGREDIENT,
        quality = Card.QUALITIES.MORTAL,
        element = Card.ELEMENTS.WOOD,
        description = "生长在灵气充沛之地的草药，可炼丹或直接服用",
        flavorText = "草木有灵",
        power = 0, knowledge = 1, mystery = 1, danger = 0,
        color = {0.2, 0.7, 0.2},
    })
    
    self:register({
        id = "thousand_year_ginseng",
        name = "千年灵芝",
        type = Card.TYPES.INGREDIENT,
        quality = Card.QUALITIES.EARTH,
        element = Card.ELEMENTS.WOOD,
        description = "生长千年的灵芝，蕴含庞大的生命精华",
        flavorText = "千年等一回",
        power = 0, knowledge = 3, mystery = 4, danger = 0,
        color = {0.1, 0.9, 0.1},
    })
    
    self:register({
        id = "phoenix_feather",
        name = "凤凰羽毛",
        type = Card.TYPES.INGREDIENT,
        quality = Card.QUALITIES.HEAVEN,
        element = Card.ELEMENTS.FIRE,
        description = "神兽凤凰的羽毛，蕴含涅槃之力",
        flavorText = "浴火重生",
        power = 0, knowledge = 5, mystery = 7, danger = 2,
        color = {1.0, 0.5, 0.0},
    })
    
    self:register({
        id = "demon_core",
        name = "妖兽内丹",
        type = Card.TYPES.INGREDIENT,
        quality = Card.QUALITIES.EARTH,
        element = Card.ELEMENTS.FIRE,
        description = "妖兽修炼凝结的内丹，蕴含狂暴的力量",
        flavorText = "杀妖取丹，天经地义",
        power = 3, knowledge = 2, mystery = 4, danger = 3,
        color = {0.8, 0.1, 0.1},
    })
    
    -- ========== 法器类 ==========
    
    self:register({
        id = "spirit_sword",
        name = "灵剑·青霜",
        type = Card.TYPES.TOOL,
        quality = Card.QUALITIES.SPIRIT,
        element = Card.ELEMENTS.METAL,
        description = "以灵铁锻造的法剑，剑身泛着青色寒光",
        flavorText = "剑出如霜，寒光凛冽",
        power = 5, knowledge = 0, mystery = 2, danger = 1,
        color = {0.3, 0.6, 0.9},
    })
    
    self:register({
        id = "jade_amulet",
        name = "护身玉符",
        type = Card.TYPES.TOOL,
        quality = Card.QUALITIES.SPIRIT,
        element = Card.ELEMENTS.EARTH,
        description = "刻有防御阵法的玉符，可抵挡一次致命攻击",
        flavorText = "玉碎人全",
        power = 0, knowledge = 2, mystery = 3, danger = 0,
        color = {0.2, 0.8, 0.4},
    })
    
    self:register({
        id = "demon_blade",
        name = "魔刃·噬魂",
        type = Card.TYPES.TOOL,
        quality = Card.QUALITIES.DEMONIC,
        element = Card.ELEMENTS.FIRE,
        description = "以魔道秘法锻造的邪刃，能吞噬敌人魂魄",
        flavorText = "刀出必饮血",
        power = 8, knowledge = 0, mystery = 5, danger = 5,
        cursed = true,
        color = {0.7, 0.0, 0.0},
    })
    
    self:register({
        id = "alchemy_furnace",
        name = "炼丹炉",
        type = Card.TYPES.TOOL,
        quality = Card.QUALITIES.EARTH,
        element = Card.ELEMENTS.FIRE,
        description = "青铜炼丹炉，炉火纯青",
        flavorText = "九转丹成",
        power = 1, knowledge = 4, mystery = 3, danger = 0,
        color = {0.6, 0.3, 0.1},
    })
    
    -- ========== 追随者类 ==========
    
    self:register({
        id = "wandering_cultivator",
        name = "散修·李逍遥",
        type = Card.TYPES.FOLLOWER,
        quality = Card.QUALITIES.SPIRIT,
        element = Card.ELEMENTS.WATER,
        description = "一位游历四方的散修，剑术不凡，为人仗义",
        flavorText = "御剑乘风来，除魔天地间",
        power = 4, knowledge = 3, mystery = 2, danger = 1,
        color = {0.3, 0.5, 0.9},
    })
    
    self:register({
        id = "old_hermit",
        name = "隐世高人·玄真子",
        type = Card.TYPES.FOLLOWER,
        quality = Card.QUALITIES.HEAVEN,
        element = Card.ELEMENTS.EARTH,
        description = "隐居深山的得道高人，精通丹道与阵法",
        flavorText = "大隐隐于市，小隐隐于野",
        power = 2, knowledge = 8, mystery = 6, danger = 0,
        color = {0.8, 0.7, 0.2},
    })
    
    self:register({
        id = "demon_cultivator",
        name = "魔修·血煞",
        type = Card.TYPES.FOLLOWER,
        quality = Card.QUALITIES.DEMONIC,
        element = Card.ELEMENTS.FIRE,
        description = "堕入魔道的修士，实力强大但性情暴戾",
        flavorText = "杀一是为罪，屠万是为雄",
        power = 7, knowledge = 2, mystery = 4, danger = 6,
        cursed = true,
        color = {0.6, 0.0, 0.0},
    })
    
    self:register({
        id = "fox_spirit",
        name = "狐仙·白灵",
        type = Card.TYPES.FOLLOWER,
        quality = Card.QUALITIES.EARTH,
        element = Card.ELEMENTS.WOOD,
        description = "修炼千年的白狐化形，精通幻术与医术",
        flavorText = "千年修行，只为一人",
        power = 2, knowledge = 5, mystery = 7, danger = 1,
        color = {0.9, 0.8, 0.9},
    })
    
    -- ========== 影响/状态类 ==========
    
    self:register({
        id = "insight_fragment",
        name = "顿悟碎片",
        type = Card.TYPES.INFLUENCE,
        quality = Card.QUALITIES.SPIRIT,
        element = Card.ELEMENTS.NONE,
        description = "灵光一闪的感悟，稍纵即逝",
        flavorText = "道可道，非常道",
        power = 0, knowledge = 3, mystery = 2, danger = 0,
        lifetime = 90,
        color = {0.9, 0.9, 0.3},
    })
    
    self:register({
        id = "dream_fragment",
        name = "梦境碎片",
        type = Card.TYPES.INFLUENCE,
        quality = Card.QUALITIES.EARTH,
        element = Card.ELEMENTS.WATER,
        description = "梦境中捕捉到的一缕天机",
        flavorText = "庄周梦蝶，蝶梦庄周",
        power = 0, knowledge = 4, mystery = 5, danger = 1,
        lifetime = 60,
        color = {0.5, 0.3, 0.8},
    })
    
    self:register({
        id = "demon_essence",
        name = "魔气精华",
        type = Card.TYPES.INFLUENCE,
        quality = Card.QUALITIES.DEMONIC,
        element = Card.ELEMENTS.FIRE,
        description = "纯粹的魔道力量，使用可获得强大力量但代价沉重",
        flavorText = "力量在召唤...",
        power = 6, knowledge = 0, mystery = 4, danger = 7,
        lifetime = 45,
        cursed = true,
        color = {0.5, 0.0, 0.3},
    })
    
    self:register({
        id = "heavenly_tribulation",
        name = "天劫预兆",
        type = Card.TYPES.INFLUENCE,
        quality = Card.QUALITIES.IMMORTAL,
        element = Card.ELEMENTS.METAL,
        description = "天劫将至的征兆，既是危机也是机缘",
        flavorText = "天发杀机，移星易宿",
        power = 0, knowledge = 0, mystery = 9, danger = 9,
        lifetime = 30,
        color = {0.8, 0.8, 0.0},
    })
    
    -- ========== 地点类 ==========
    
    self:register({
        id = "qingyun_mountain",
        name = "青云山",
        type = Card.TYPES.LOCATION,
        quality = Card.QUALITIES.SPIRIT,
        element = Card.ELEMENTS.WOOD,
        description = "青云宗所在之地，灵气充沛，仙家福地",
        flavorText = "山不在高，有仙则名",
        power = 1, knowledge = 2, mystery = 3, danger = 0,
        color = {0.2, 0.6, 0.3},
    })
    
    self:register({
        id = "demon_abyss",
        name = "万魔深渊",
        type = Card.TYPES.LOCATION,
        quality = Card.QUALITIES.DEMONIC,
        element = Card.ELEMENTS.FIRE,
        description = "魔气汇聚之地，传说深渊底部封印着上古魔头",
        flavorText = "凝视深渊，深渊也在凝视你",
        power = 5, knowledge = 3, mystery = 8, danger = 8,
        cursed = true,
        color = {0.3, 0.0, 0.0},
    })
    
    self:register({
        id = "immortal_market",
        name = "修仙坊市",
        type = Card.TYPES.LOCATION,
        quality = Card.QUALITIES.EARTH,
        element = Card.ELEMENTS.NONE,
        description = "修仙者交易物品的集市，三教九流汇聚",
        flavorText = "天下熙熙，皆为利来",
        power = 0, knowledge = 2, mystery = 2, danger = 1,
        color = {0.7, 0.6, 0.3},
    })
    
    -- ========== 妖兽类 ==========
    
    self:register({
        id = "shadow_wolf",
        name = "影狼",
        type = Card.TYPES.MONSTER,
        quality = Card.QUALITIES.SPIRIT,
        element = Card.ELEMENTS.WATER,
        description = "栖息在黑暗中的妖狼，速度极快",
        flavorText = "月圆之夜，狼啸山林",
        power = 3, knowledge = 0, mystery = 1, danger = 3,
        color = {0.2, 0.2, 0.4},
    })
    
    self:register({
        id = "fire_serpent",
        name = "赤焰蟒",
        type = Card.TYPES.MONSTER,
        quality = Card.QUALITIES.EARTH,
        element = Card.ELEMENTS.FIRE,
        description = "身长数丈的火焰巨蟒，口中喷吐烈焰",
        flavorText = "蛇化为龙，不变其文",
        power = 5, knowledge = 0, mystery = 3, danger = 5,
        color = {0.9, 0.3, 0.0},
    })
    
    self:register({
        id = "ancient_demon",
        name = "上古魔物",
        type = Card.TYPES.MONSTER,
        quality = Card.QUALITIES.DEMONIC,
        element = Card.ELEMENTS.FIRE,
        description = "远古时代遗留的恐怖存在",
        flavorText = "不可名状的恐惧",
        power = 9, knowledge = 0, mystery = 7, danger = 9,
        cursed = true,
        color = {0.4, 0.0, 0.0},
    })
    
    -- ========== 灵体类 ==========
    
    self:register({
        id = "sword_spirit",
        name = "剑灵",
        type = Card.TYPES.SPIRIT,
        quality = Card.QUALITIES.HEAVEN,
        element = Card.ELEMENTS.METAL,
        description = "神剑中诞生的灵体，剑道通神",
        flavorText = "剑中有灵，灵中有剑",
        power = 6, knowledge = 4, mystery = 5, danger = 2,
        color = {0.5, 0.7, 1.0},
    })
    
    self:register({
        id = "vengeful_ghost",
        name = "怨灵",
        type = Card.TYPES.SPIRIT,
        quality = Card.QUALITIES.DEMONIC,
        element = Card.ELEMENTS.WATER,
        description = "含冤而死的修士魂魄，怨气冲天",
        flavorText = "冤魂不散，怨气难消",
        power = 3, knowledge = 1, mystery = 4, danger = 5,
        cursed = true,
        color = {0.3, 0.5, 0.7},
    })
    
    -- ========== 特殊卡牌 ==========
    
    self:register({
        id = "friendship_token",
        name = "友谊信物",
        type = Card.TYPES.ITEM,
        quality = Card.QUALITIES.SPIRIT,
        element = Card.ELEMENTS.NONE,
        description = "与同道结下的友谊信物",
        flavorText = "海内存知己，天涯若比邻",
        power = 0, knowledge = 2, mystery = 1, danger = 0,
        color = {0.9, 0.6, 0.8},
    })
    
    self:register({
        id = "heavenly_peach",
        name = "蟠桃",
        type = Card.TYPES.INGREDIENT,
        quality = Card.QUALITIES.IMMORTAL,
        element = Card.ELEMENTS.WOOD,
        description = "传说中三千年一熟的仙桃，食之可增寿千年",
        flavorText = "此桃只应天上有",
        power = 0, knowledge = 8, mystery = 9, danger = 0,
        color = {1.0, 0.7, 0.7},
    })
end
