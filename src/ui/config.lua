-- ============================================================
-- UI系统 - 暗黑修仙·桌面风格
-- 仿密教模拟器：所有元素是"桌面"上的物件，无界面边界
-- 行为槽：可拖动的圆形符印(右键拖动整理)
-- 卡牌：玉牌，可拖到符印上施法
-- ============================================================

UI = {}
UI.__index = UI

-- ============================================================
-- 配色 - 暗黑修仙主题
-- ============================================================
UI.PALETTE = {
    desk_dark   = {0.04, 0.02, 0.06},
    desk_mid    = {0.07, 0.04, 0.10},
    desk_light  = {0.10, 0.06, 0.14},
    desk_grain  = {0.12, 0.07, 0.16},

    gold        = {0.85, 0.65, 0.20},
    gold_dim    = {0.50, 0.38, 0.12},
    bronze      = {0.65, 0.45, 0.20},
    jade        = {0.30, 0.65, 0.55},
    cinnabar    = {0.85, 0.25, 0.20},
    ink         = {0.02, 0.01, 0.04},

    text_bright = {0.95, 0.88, 0.72},
    text_warm   = {0.85, 0.75, 0.55},
    text_dim    = {0.55, 0.50, 0.42},
    text_ghost  = {0.35, 0.32, 0.28},
    text_red    = {0.90, 0.30, 0.25},
    text_green  = {0.40, 0.80, 0.45},
    text_purple = {0.70, 0.45, 0.90},
    text_blue   = {0.45, 0.65, 0.95},
    text_gold   = {0.95, 0.78, 0.30},

    health      = {0.80, 0.20, 0.20},
    sanity      = {0.40, 0.55, 0.90},
    corruption  = {0.70, 0.15, 0.55},
    qi_bar      = {0.30, 0.80, 0.50},
    xp_bar      = {0.65, 0.35, 0.85},

    sigil_green  = {0.20, 0.55, 0.25},
    sigil_blue   = {0.20, 0.30, 0.65},
    sigil_brown  = {0.50, 0.35, 0.15},
    sigil_red    = {0.65, 0.15, 0.15},
    sigil_yellow = {0.65, 0.50, 0.15},
    sigil_orange = {0.70, 0.35, 0.10},
    sigil_purple = {0.45, 0.15, 0.55},
}

UI.SIGIL_COLORS = {
    [Board.SLOT_TYPES.WORK]    = "sigil_green",
    [Board.SLOT_TYPES.STUDY]   = "sigil_blue",
    [Board.SLOT_TYPES.EXPLORE] = "sigil_brown",
    [Board.SLOT_TYPES.RITUAL]  = "sigil_red",
    [Board.SLOT_TYPES.TALK]    = "sigil_yellow",
    [Board.SLOT_TYPES.REFINE]  = "sigil_orange",
    [Board.SLOT_TYPES.DREAM]   = "sigil_purple",
}

UI.SIGIL_GLYPHS = {
    [Board.SLOT_TYPES.WORK]    = "修",
    [Board.SLOT_TYPES.STUDY]   = "习",
    [Board.SLOT_TYPES.EXPLORE] = "游",
    [Board.SLOT_TYPES.RITUAL]  = "祭",
    [Board.SLOT_TYPES.TALK]    = "论",
    [Board.SLOT_TYPES.REFINE]  = "炼",
    [Board.SLOT_TYPES.DREAM]   = "梦",
}

UI.SIGIL_NAMES = {
    [Board.SLOT_TYPES.WORK]    = "修炼",
    [Board.SLOT_TYPES.STUDY]   = "研习",
    [Board.SLOT_TYPES.EXPLORE] = "探索",
    [Board.SLOT_TYPES.RITUAL]  = "仪式",
    [Board.SLOT_TYPES.TALK]    = "论道",
    [Board.SLOT_TYPES.REFINE]  = "炼器",
    [Board.SLOT_TYPES.DREAM]   = "入梦",
}

UI.SIGIL_HINTS = {
    [Board.SLOT_TYPES.WORK]    = "运转功法",
    [Board.SLOT_TYPES.STUDY]   = "研读典籍",
    [Board.SLOT_TYPES.EXPLORE] = "外出游历",
    [Board.SLOT_TYPES.RITUAL]  = "举行仪式",
    [Board.SLOT_TYPES.TALK]    = "论道交友",
    [Board.SLOT_TYPES.REFINE]  = "炼器炼丹",
    [Board.SLOT_TYPES.DREAM]   = "入定观想",
}

UI.ELEMENT_COLORS = {
    [Card.ELEMENTS.METAL] = {0.85, 0.80, 0.45},
    [Card.ELEMENTS.WOOD]  = {0.30, 0.70, 0.40},
    [Card.ELEMENTS.WATER] = {0.20, 0.40, 0.80},
    [Card.ELEMENTS.FIRE]  = {0.90, 0.35, 0.20},
    [Card.ELEMENTS.EARTH] = {0.70, 0.55, 0.30},
    [Card.ELEMENTS.NONE]  = {0.50, 0.50, 0.50},
}

UI.ELEMENT_GLYPHS = {
    [Card.ELEMENTS.METAL] = "金",
    [Card.ELEMENTS.WOOD]  = "木",
    [Card.ELEMENTS.WATER] = "水",
    [Card.ELEMENTS.FIRE]  = "火",
    [Card.ELEMENTS.EARTH] = "土",
    [Card.ELEMENTS.NONE]  = "—",
}

-- 符印名称映射（用于预览弹窗）
UI.SLOT_TYPE_NAMES = {
    [Board.SLOT_TYPES.WORK]    = "修炼",
    [Board.SLOT_TYPES.STUDY]   = "研习",
    [Board.SLOT_TYPES.EXPLORE] = "探索",
    [Board.SLOT_TYPES.RITUAL]  = "仪式",
    [Board.SLOT_TYPES.TALK]    = "论道",
    [Board.SLOT_TYPES.REFINE]  = "炼器",
    [Board.SLOT_TYPES.DREAM]   = "入梦",
}

-- 符印详细描述
UI.SLOT_DESCRIPTIONS = {
    [Board.SLOT_TYPES.WORK]    = "运转功法，吸纳天地灵气。可放入：功法、妖兽。",
    [Board.SLOT_TYPES.STUDY]   = "研读典籍，参悟大道。可放入：功法。",
    [Board.SLOT_TYPES.EXPLORE] = "外出游历，寻访机缘。可放入：地点、妖兽。",
    [Board.SLOT_TYPES.RITUAL]  = "举行仪式，沟通天地。可放入：影响、仪式、灵体。",
    [Board.SLOT_TYPES.TALK]    = "与同道交流，结交仙缘。可放入：弟子。",
    [Board.SLOT_TYPES.REFINE]  = "炼制法宝，锻造神兵。可放入：物品、材料、法器。",
    [Board.SLOT_TYPES.DREAM]   = "进入梦境，感悟天道。可放入：灵体。",
}


return UI
