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

function UI:init()
    local fp = "font.ttf"
    self.font_xs   = love.graphics.newFont(fp, 10)
    self.font_s    = love.graphics.newFont(fp, 12)
    self.font_m    = love.graphics.newFont(fp, 14)
    self.font_l    = love.graphics.newFont(fp, 18)
    self.font_xl   = love.graphics.newFont(fp, 24)
    self.font_xxl  = love.graphics.newFont(fp, 32)
    self.font_card = love.graphics.newFont(fp, 16)
    self.font_card_big = love.graphics.newFont(fp, 20)
    self.font_sigil = love.graphics.newFont(fp, 22)
    self.font_sigil_big = love.graphics.newFont(fp, 30)

    self.cardW = 100
    self.cardH = 140
    self.sigilR = 42

    self.screenW = love.graphics.getWidth()
    self.screenH = love.graphics.getHeight()

    self.time = 0
    self.particles = {}
    self.floatTexts = {}

    self.arrayPulse = 0

    self:initSigilPositions()

    -- 符印拖动（右键拖动 / 或按住Shift+左键）
    self.dragSigil = nil
    self.dragSigilOffsetX = 0
    self.dragSigilOffsetY = 0
    self.sigilMoveMode = false  -- M键切换

    self.hoverSigil = nil

    -- 预演弹窗（拖卡到符印上时弹出，确认才开始倒计时）
    self.previewDialog = nil
end

function UI:initSigilPositions()
    local w = self.screenW
    local h = self.screenH
    local deskTop = 90
    local deskBot = h - 210

    local positions = {
        {x = 100, y = deskTop + 80},
        {x = 100, y = deskTop + 200},
        {x = 200, y = deskTop + 140},
        {x = 60,  y = deskTop + 320},
        {x = 200, y = deskTop + 320},
        {x = 100, y = deskTop + 440},
        {x = 60,  y = deskTop + 480},
    }

    for i, slot in ipairs(Board.slots) do
        if positions[i] then
            slot._x = positions[i].x
            slot._y = positions[i].y
        else
            slot._x = 100
            slot._y = deskTop + 100
        end
    end
end

function UI:update(dt)
    self.time = self.time + dt
    self.arrayPulse = (self.arrayPulse + dt * 0.6) % (math.pi * 2)

    for i = #self.particles, 1, -1 do
        local p = self.particles[i]
        p.life = p.life - dt
        p.x = p.x + p.vx * dt
        p.y = p.y + p.vy * dt
        p.alpha = math.max(0, p.life / p.maxLife)
        if p.life <= 0 then
            table.remove(self.particles, i)
        end
    end

    for i = #self.floatTexts, 1, -1 do
        local t = self.floatTexts[i]
        t.life = t.life - dt
        t.y = t.y - 25 * dt
        t.alpha = math.max(0, t.life / t.maxLife)
        if t.life <= 0 then
            table.remove(self.floatTexts, i)
        end
    end
end

function UI:floatText(x, y, text, color)
    table.insert(self.floatTexts, {
        x = x, y = y, text = text,
        color = color or {1, 1, 1},
        life = 1.5, maxLife = 1.5, alpha = 1,
    })
end

function UI:burst(x, y, color, count)
    count = count or 12
    for i = 1, count do
        local angle = love.math.random() * math.pi * 2
        local speed = 30 + love.math.random() * 60
        table.insert(self.particles, {
            x = x, y = y,
            vx = math.cos(angle) * speed,
            vy = math.sin(angle) * speed - 20,
            life = 0.6 + love.math.random() * 0.4,
            maxLife = 1.0,
            alpha = 1,
            color = color or {1, 0.8, 0.3},
            size = 2 + love.math.random() * 2,
        })
    end
end

-- ============================================================
-- 主绘制
-- ============================================================
function UI:draw()
    self:drawDesktop()
    self:drawCenterArray()
    self:drawSigils()
    self:drawHand()
    self:drawEventDialog()
    self:drawLog()
    self:drawStatusBar()
    self:drawSpeedIndicator()
    self:drawParticles()
    self:drawFloatTexts()
    self:drawPreviewDialog()

    if Player:isDead() then
        self:drawDeathScreen()
    end
end

-- ============================================================
-- 桌面背景 - 古代风水地形桌
-- 灵感：古代修士在紫檀木桌上铺开山河社稷图
-- ============================================================
function UI:drawDesktop()
    local w, h = self.screenW, self.screenH

    -- 底层：深色紫檀木底色
    love.graphics.setColor(0.03, 0.02, 0.04, 1)
    love.graphics.rectangle("fill", 0, 0, w, h)

    -- 木纹纹理：横向流动的紫檀木纹
    for i = 0, 60 do
        local y = i * (h / 60)
        local alpha = 0.03 + (i % 5) * 0.008
        local r = 0.06 + (i % 3) * 0.02
        local g = 0.03 + (i % 4) * 0.01
        local b = 0.06 + (i % 3) * 0.015
        love.graphics.setColor(r, g, b, alpha)
        love.graphics.rectangle("fill", 0, y, w, 1.5)
    end

    -- 竖向木纹节疤
    for i = 0, 15 do
        local seed = i * 173
        local x = (seed * 7 % w)
        local y = (seed * 11 % h)
        local len = 40 + (i * 23 % 80)
        love.graphics.setColor(0.08, 0.04, 0.07, 0.15)
        love.graphics.rectangle("fill", x - 1, y, 3, len)
    end

    -- 中央区域：微微凸起的"山河社稷图"区域（古代卷轴质感）
    local mapX = w * 0.08
    local mapY = h * 0.12
    local mapW = w * 0.84
    local mapH = h * 0.76

    -- 卷轴底色（古宣纸色）
    love.graphics.setColor(0.08, 0.05, 0.10, 0.6)
    love.graphics.rectangle("fill", mapX, mapY, mapW, mapH, 6)

    -- 卷轴边框（青铜轴）
    love.graphics.setColor(self.PALETTE.bronze[1] * 0.3, self.PALETTE.bronze[2] * 0.3, self.PALETTE.bronze[3] * 0.3, 0.5)
    love.graphics.setLineWidth(2)
    love.graphics.rectangle("line", mapX, mapY, mapW, mapH, 6)
    love.graphics.setLineWidth(1)

    -- 山河纹理：远山轮廓（水墨画风格）
    local mountainBase = mapY + mapH * 0.55
    for m = 0, 5 do
        local mx = mapX + mapW * (m * 0.18 + 0.05)
        local mh = mapH * (0.12 + (m % 3) * 0.08)
        local mw = mapW * (0.08 + (m % 2) * 0.04)
        -- 山体
        for layer = 0, 3 do
            local alpha = 0.04 + layer * 0.02
            local offset = layer * 15
            love.graphics.setColor(0.10, 0.07, 0.12, alpha)
            love.graphics.polygon("fill",
                mx - mw - offset, mountainBase,
                mx, mountainBase - mh - offset * 0.5,
                mx + mw + offset, mountainBase
            )
        end
        -- 山顶雪线
        love.graphics.setColor(0.15, 0.12, 0.18, 0.08)
        love.graphics.polygon("fill",
            mx - mw * 0.4, mountainBase - mh * 0.6,
            mx, mountainBase - mh,
            mx + mw * 0.4, mountainBase - mh * 0.6
        )
    end

    -- 河流：蜿蜒穿过桌面
    love.graphics.setColor(0.06, 0.08, 0.14, 0.25)
    love.graphics.setLineWidth(3)
    local riverPoints = {}
    for t = 0, 1, 0.02 do
        local rx = mapX + mapW * 0.15 + t * mapW * 0.7
        local ry = mapY + mapH * 0.3 + math.sin(t * math.pi * 2.5 + self.time * 0.02) * mapH * 0.15 + t * mapH * 0.35
        table.insert(riverPoints, rx)
        table.insert(riverPoints, ry)
    end
    love.graphics.line(riverPoints)
    love.graphics.setLineWidth(1)

    -- 河流支流
    love.graphics.setColor(0.06, 0.08, 0.14, 0.12)
    love.graphics.setLineWidth(1.5)
    local branchX = mapX + mapW * 0.35
    local branchY = mapY + mapH * 0.42
    love.graphics.line(branchX, branchY, branchX + mapW * 0.08, branchY + mapH * 0.06)
    love.graphics.line(branchX + mapW * 0.06, branchY + mapH * 0.02, branchX + mapW * 0.12, branchY - mapH * 0.02)
    love.graphics.setLineWidth(1)

    -- 云雾：飘渺在山间
    for i = 0, 8 do
        local cx = mapX + mapW * (0.1 + i * 0.1)
        local cy = mapY + mapH * (0.25 + math.sin(i * 1.7 + self.time * 0.03) * 0.1)
        local cr = mapW * (0.04 + (i % 3) * 0.02)
        local alpha = 0.03 + math.sin(self.time * 0.15 + i) * 0.015
        love.graphics.setColor(0.12, 0.10, 0.16, alpha)
        love.graphics.ellipse("fill", cx, cy, cr, cr * 0.4)
    end

    -- 金色星点：散布的灵气光点
    for i = 0, 120 do
        local seed = i * 197
        local sx = mapX + (seed * 13 % mapW)
        local sy = mapY + (seed * 17 % mapH)
        local flicker = 0.3 + 0.7 * math.abs(math.sin(self.time * 0.3 + i * 0.7))
        love.graphics.setColor(self.PALETTE.gold[1] * 0.15, self.PALETTE.gold[2] * 0.15, self.PALETTE.gold[3] * 0.15, 0.15 * flicker)
        love.graphics.circle("fill", sx, sy, 1.2)
    end

    -- 四角装饰：青铜包角纹样
    local cornerR = 18
    local corners = {
        {mapX, mapY},
        {mapX + mapW, mapY},
        {mapX, mapY + mapH},
        {mapX + mapW, mapY + mapH},
    }
    love.graphics.setColor(self.PALETTE.bronze[1] * 0.4, self.PALETTE.bronze[2] * 0.4, self.PALETTE.bronze[3] * 0.4, 0.6)
    for _, c in ipairs(corners) do
        love.graphics.arc("line", "open", c[1], c[2], cornerR, 0, math.pi/2)
    end
    -- 四角内侧金线
    love.graphics.setColor(self.PALETTE.gold_dim[1] * 0.3, self.PALETTE.gold_dim[2] * 0.3, self.PALETTE.gold_dim[3] * 0.3, 0.4)
    for _, c in ipairs(corners) do
        love.graphics.arc("line", "open", c[1], c[2], cornerR - 4, 0, math.pi/2)
    end

    -- 桌面边缘光晕（模拟烛光照明）
    love.graphics.setColor(self.PALETTE.gold[1] * 0.03, self.PALETTE.gold[2] * 0.03, self.PALETTE.gold[3] * 0.03, 0.3)
    love.graphics.ellipse("fill", w * 0.5, h * 0.5, w * 0.6, h * 0.5)
end

-- ============================================================
-- 顶部状态条 - 极简风格，只保留标题和操作提示
-- ============================================================
function UI:drawStatusBar()
    local w = self.screenW
    local barH = 48

    -- 半透明底条
    love.graphics.setColor(0.03, 0.02, 0.04, 0.75)
    love.graphics.rectangle("fill", 0, 0, w, barH)

    -- 底部分割线
    love.graphics.setColor(self.PALETTE.gold_dim[1] * 0.4, self.PALETTE.gold_dim[2] * 0.4, self.PALETTE.gold_dim[3] * 0.4, 0.6)
    love.graphics.setLineWidth(1)
    love.graphics.line(0, barH, w, barH)

    -- 标题
    love.graphics.setFont(self.font_l)
    love.graphics.setColor(self.PALETTE.gold)
    love.graphics.print("暗 黑 修 仙", 20, 8)
    love.graphics.setFont(self.font_xs)
    love.graphics.setColor(self.PALETTE.text_dim)
    love.graphics.print("Dark Cultivation", 22, 32)

    -- 境界 + 年份
    love.graphics.setFont(self.font_m)
    love.graphics.setColor(self.PALETTE.text_purple)
    love.graphics.print("【" .. Player:getCultivationName() .. "】", 200, 6)
    love.graphics.setFont(self.font_xs)
    love.graphics.setColor(self.PALETTE.text_warm)
    love.graphics.print("历 " .. Player.turn .. " 载", 200, 28)

    -- 操作提示
    love.graphics.setFont(self.font_xs)
    love.graphics.setColor(self.PALETTE.text_ghost)
    love.graphics.printf("拖卡至符印  ·  右键拖动符印整理  ·  [M]整理  [1-5]倍速  [R]重启  [ESC]退出", w - 720, 16, 700, "right")
end

-- ============================================================
-- 倍速指示
-- ============================================================
function UI:drawSpeedIndicator()
    -- 显示在左下角
    local w = self.screenW
    local h = self.screenH
    local x = 16
    local y = h - 50

    -- 标签
    love.graphics.setFont(self.font_xs)
    love.graphics.setColor(self.PALETTE.text_ghost)
    love.graphics.print("倍速", x, y)

    -- 倍速按钮
    local labels = {"0.5x", "1x", "2x", "3x", "4x"}
    local startX = x + 40
    for i, lbl in ipairs(labels) do
        local bx = startX + (i - 1) * 42
        local by = y - 4
        local bw = 36
        local bh = 20

        local active = (i == Player.speedIndex)
        if active then
            love.graphics.setColor(self.PALETTE.gold[1] * 0.4, self.PALETTE.gold[2] * 0.4, self.PALETTE.gold[3] * 0.4, 0.9)
            love.graphics.rectangle("fill", bx, by, bw, bh, 4)
            love.graphics.setColor(self.PALETTE.gold)
        else
            love.graphics.setColor(self.PALETTE.ink[1], self.PALETTE.ink[2], self.PALETTE.ink[3], 0.6)
            love.graphics.rectangle("fill", bx, by, bw, bh, 4)
            love.graphics.setColor(self.PALETTE.gold_dim)
        end
        love.graphics.setLineWidth(1)
        love.graphics.rectangle("line", bx, by, bw, bh, 4)

        love.graphics.setFont(self.font_xs)
        love.graphics.setColor(active and self.PALETTE.gold or self.PALETTE.text_dim)
        love.graphics.printf(lbl, bx, by + 4, bw, "center")

        self.speedButtons = self.speedButtons or {}
        self.speedButtons[i] = {x = bx, y = by, w = bw, h = bh, idx = i}
    end
end

-- ============================================================
-- 中央法阵
-- ============================================================
function UI:drawCenterArray()
    local w = self.screenW
    local cx = w * 0.55
    local cy = self.screenH * 0.50
    local r = 130

    self:drawBaguaArray(cx, cy, r)
end

function UI:drawBaguaArray(cx, cy, r)
    local pulse = 0.5 + 0.5 * math.sin(self.arrayPulse)

    love.graphics.setColor(self.PALETTE.gold_dim[1], self.PALETTE.gold_dim[2], self.PALETTE.gold_dim[3], 0.6)
    love.graphics.setLineWidth(1)
    love.graphics.circle("line", cx, cy, r)
    love.graphics.circle("line", cx, cy, r - 8)

    love.graphics.setColor(self.PALETTE.bronze[1], self.PALETTE.bronze[2], self.PALETTE.bronze[3], 0.7)
    love.graphics.setLineWidth(1.5)
    local r2 = r - 22
    for i = 0, 7 do
        local a1 = (i / 8) * math.pi * 2 + self.time * 0.05
        local a2 = ((i + 1) / 8) * math.pi * 2 + self.time * 0.05
        local x1 = cx + math.cos(a1) * r2
        local y1 = cy + math.sin(a1) * r2
        local x2 = cx + math.cos(a2) * r2
        local y2 = cy + math.sin(a2) * r2
        love.graphics.line(x1, y1, x2, y2)
    end

    local yrad = r2 - 8
    love.graphics.setColor(self.PALETTE.text_bright[1], self.PALETTE.text_bright[2], self.PALETTE.text_bright[3], 0.85)
    love.graphics.circle("fill", cx, cy, yrad, 8)
    love.graphics.setColor(self.PALETTE.ink[1], self.PALETTE.ink[2], self.PALETTE.ink[3], 0.95)
    love.graphics.circle("fill", cx, cy, yrad, math.pi, math.pi * 2, 8)

    love.graphics.setColor(self.PALETTE.ink[1], self.PALETTE.ink[2], self.PALETTE.ink[3], 1)
    love.graphics.circle("fill", cx, cy - yrad/2, yrad/6)
    love.graphics.setColor(self.PALETTE.text_bright[1], self.PALETTE.text_bright[2], self.PALETTE.text_bright[3], 1)
    love.graphics.circle("fill", cx, cy + yrad/2, yrad/6)

    local baguaNames = {"乾","兑","离","震","巽","坎","艮","坤"}
    for i = 1, 8 do
        local a = ((i - 1) / 8) * math.pi * 2 - math.pi/2 + self.time * 0.04
        local tx = cx + math.cos(a) * (r2 - 32)
        local ty = cy + math.sin(a) * (r2 - 32)
        love.graphics.setFont(self.font_s)
        love.graphics.setColor(self.PALETTE.gold)
        love.graphics.printf(baguaNames[i], tx - 10, ty - 8, 20, "center")
    end

    love.graphics.setFont(self.font_s)
    love.graphics.setColor(self.PALETTE.text_purple)
    love.graphics.printf(Player:getCultivationName(), cx - 50, cy - 20, 100, "center")
    love.graphics.setFont(self.font_xs)
    love.graphics.setColor(self.PALETTE.text_dim)
    love.graphics.printf("历 " .. Player.turn .. " 载", cx - 50, cy + 10, 100, "center")

    for i = 0, 7 do
        local a = (i / 8) * math.pi * 2 + self.arrayPulse * 0.5
        local px = cx + math.cos(a) * (r - 4)
        local py = cy + math.sin(a) * (r - 4)
        local alpha = 0.4 + 0.6 * math.sin(self.arrayPulse * 2 + i)
        love.graphics.setColor(self.PALETTE.gold[1], self.PALETTE.gold[2], self.PALETTE.gold[3], alpha)
        love.graphics.circle("fill", px, py, 2.5)
    end
end

-- ============================================================
-- 符印(行为槽)
-- ============================================================
function UI:drawSigils()
    for i, slot in ipairs(Board.slots) do
        self:drawSigil(slot, i)
    end
end

function UI:drawSigil(slot, index)
    local r = self.sigilR
    local x = slot._x
    local y = slot._y

    if self.dragSigil == slot then
        local mx, my = love.mouse.getPosition()
        x = mx - self.dragSigilOffsetX
        y = my - self.dragSigilOffsetY
    end

    slot._drawX = x
    slot._drawY = y

    local isHover = self.hoverSigil == index
    local isDraggingCard = Board.dragCard ~= nil
    local isAvailable = isDraggingCard and not slot.active and Board.dragCard:canPlaceIn(slot.id)
    local isIncompatible = isDraggingCard and not slot.active and not Board.dragCard:canPlaceIn(slot.id)

    local sigilColor = self.PALETTE[self.SIGIL_COLORS[slot.id] or "sigil_green"]

    -- 可放置: 绿色脉冲
    if isAvailable then
        local pulse = 0.5 + 0.5 * math.sin(self.time * 6)
        for k = 3, 1, -1 do
            love.graphics.setColor(self.PALETTE.text_green[1], self.PALETTE.text_green[2], self.PALETTE.text_green[3], 0.20 * pulse)
            love.graphics.circle("line", x, y, r + k * 3)
        end
    end

    -- 不兼容: 暗红提示(但允许放下时仅暗色)
    if isIncompatible then
        love.graphics.setColor(self.PALETTE.text_red[1], self.PALETTE.text_red[2], self.PALETTE.text_red[3], 0.4)
        love.graphics.setLineWidth(2)
        love.graphics.circle("line", x, y, r + 4)
        love.graphics.setLineWidth(1)
        -- 画个禁止符号（斜线）
        love.graphics.setColor(self.PALETTE.text_red[1], self.PALETTE.text_red[2], self.PALETTE.text_red[3], 0.7)
        love.graphics.setLineWidth(2.5)
        love.graphics.line(x - r * 0.7, y - r * 0.7, x + r * 0.7, y + r * 0.7)
        love.graphics.setLineWidth(1)
    end

    -- 阴影
    love.graphics.setColor(0, 0, 0, 0.5)
    love.graphics.circle("fill", x + 2, y + 3, r)

    -- 底盘
    love.graphics.setColor(self.PALETTE.ink[1], self.PALETTE.ink[2], self.PALETTE.ink[3], 0.95)
    love.graphics.circle("fill", x, y, r)

    -- 主题色填充
    local alpha = 0.7
    if slot.active then alpha = 0.45 end
    if isAvailable then alpha = 0.9 end
    if isIncompatible then alpha = 0.25 end  -- 变暗
    love.graphics.setColor(sigilColor[1], sigilColor[2], sigilColor[3], alpha)
    love.graphics.circle("fill", x, y, r - 4)

    -- 内部圆环
    love.graphics.setColor(sigilColor[1] * 0.5, sigilColor[2] * 0.5, sigilColor[3] * 0.5)
    love.graphics.setLineWidth(2)
    love.graphics.circle("line", x, y, r - 8)
    love.graphics.setLineWidth(1)

    -- 符咒纹路
    love.graphics.setColor(self.PALETTE.gold[1], self.PALETTE.gold[2], self.PALETTE.gold[3], 0.5)
    love.graphics.setLineWidth(1)
    love.graphics.circle("line", x, y, r - 14)

    -- 中心文字
    love.graphics.setFont(self.font_sigil_big)
    love.graphics.setColor(self.PALETTE.text_bright)
    love.graphics.printf(self.SIGIL_GLYPHS[slot.id] or "?", x - 20, y - 18, 40, "center")

    -- 名字
    love.graphics.setFont(self.font_xs)
    love.graphics.setColor(self.PALETTE.gold)
    love.graphics.printf(self.SIGIL_NAMES[slot.id] or "", x - 30, y + 22, 60, "center")

    -- 活动中的进度
    if slot.active and slot.card then
        local p = slot.progress / slot.duration
        love.graphics.setColor(self.PALETTE.gold[1], self.PALETTE.gold[2], self.PALETTE.gold[3], 0.8)
        love.graphics.setLineWidth(3)
        love.graphics.arc("line", x, y, r - 14, -math.pi/2, -math.pi/2 + p * math.pi * 2)
        love.graphics.setLineWidth(1)

        -- 剩余时间(秒)
        local remaining = math.max(0, slot.duration - slot.progress)
        love.graphics.setFont(self.font_xs)
        love.graphics.setColor(self.PALETTE.gold)
        love.graphics.printf(string.format("%.0fs", remaining), x - 20, y - 6, 40, "center")

        -- 在卡牌名下方显示卡名
        love.graphics.setFont(self.font_xs)
        love.graphics.setColor(self.PALETTE.text_bright)
        love.graphics.printf(slot.card.name, x - 40, y + r + 4, 80, "center")
    end

    -- 完成闪烁
    if slot.result then
        local blink = 0.5 + 0.5 * math.sin(self.time * 4)
        love.graphics.setColor(self.PALETTE.text_green[1], self.PALETTE.text_green[2], self.PALETTE.text_green[3], blink)
        love.graphics.setLineWidth(3)
        love.graphics.circle("line", x, y, r + 2)
        love.graphics.setLineWidth(1)

        love.graphics.setFont(self.font_xs)
        love.graphics.setColor(self.PALETTE.text_green)
        love.graphics.printf("完成", x - 20, y + 38, 40, "center")
    end

    -- 悬停高亮
    if isHover and not isDraggingCard and not self.dragSigil then
        love.graphics.setColor(self.PALETTE.gold[1], self.PALETTE.gold[2], self.PALETTE.gold[3], 0.4)
        love.graphics.setLineWidth(2)
        love.graphics.circle("line", x, y, r + 3)
        love.graphics.setLineWidth(1)

        -- 显示描述提示
        love.graphics.setFont(self.font_xs)
        love.graphics.setColor(self.PALETTE.text_warm)
        love.graphics.printf(self.SIGIL_HINTS[slot.id] or "", x - 60, y - r - 16, 120, "center")
    end

    -- 移动模式提示
    if self.sigilMoveMode then
        love.graphics.setColor(self.PALETTE.gold[1], self.PALETTE.gold[2], self.PALETTE.gold[3], 0.3)
        love.graphics.setLineWidth(1)
        love.graphics.circle("line", x, y, r + 5)
    end
end

function UI:getSigilAt(x, y)
    for i, slot in ipairs(Board.slots) do
        local dx = x - (slot._drawX or slot._x or 0)
        local dy = y - (slot._drawY or slot._y or 0)
        if dx * dx + dy * dy <= self.sigilR * self.sigilR then
            return i, slot
        end
    end
    return nil, nil
end

-- ============================================================
-- 手牌
-- ============================================================
function UI:drawHand()
    local w = self.screenW
    local h = self.screenH
    local handH = 180
    local handY = h - handH

    love.graphics.setColor(self.PALETTE.desk_dark[1], self.PALETTE.desk_dark[2], self.PALETTE.desk_dark[3], 0.6)
    love.graphics.rectangle("fill", 0, handY, w, handH)

    love.graphics.setColor(self.PALETTE.gold_dim)
    love.graphics.setLineWidth(1)
    love.graphics.line(0, handY, w, handY)

    love.graphics.setFont(self.font_s)
    love.graphics.setColor(self.PALETTE.gold)
    love.graphics.print("玉 牌 匣", 20, handY + 6)
    love.graphics.setFont(self.font_xs)
    love.graphics.setColor(self.PALETTE.text_dim)
    love.graphics.print("手牌 " .. #Board.hand .. " / " .. Board.maxHandSize, 20, handY + 26)

    if Player.turn % 3 == 0 and not Board.dragCard then
        love.graphics.setFont(self.font_xs)
        love.graphics.setColor(self.PALETTE.text_ghost)
        love.graphics.printf("下回合可抽 " .. Player.drawCount .. " 张新牌", w - 220, handY + 8, 200, "right")
    end

    local count = #Board.hand
    if count == 0 then
        love.graphics.setFont(self.font_m)
        love.graphics.setColor(self.PALETTE.text_ghost)
        love.graphics.printf("手牌已空 · 待新牌", 0, handY + 80, w, "center")
        return
    end

    local cardSpacing = 90
    local totalW = cardSpacing * (count - 1) + self.cardW
    local startX = (w - totalW) / 2
    local cardY = handY + 38

    for i, card in ipairs(Board.hand) do
        local x = startX + (i - 1) * cardSpacing
        local y = cardY
        card._x = x
        card._y = y
    end

    for i, card in ipairs(Board.hand) do
        if Board.dragCard ~= card then
            self:drawCard(card, card._x, card._y, false)
        end
    end

    if Board.dragCard then
        local mx, my = love.mouse.getPosition()
        local dx = mx - Board.dragOffsetX
        local dy = my - Board.dragOffsetY
        self:drawCard(Board.dragCard, dx, dy, true)
    end
end

-- ============================================================
-- 卡牌绘制
-- ============================================================
function UI:drawCard(card, x, y, dragging)
    local w = self.cardW
    local h = self.cardH

    if dragging then
        y = y - 12
        love.graphics.setColor(0, 0, 0, 0.6)
        love.graphics.rectangle("fill", x + 4, y + 6, w, h, 6)
    end

    local qColor = card:getQualityColor()

    love.graphics.setColor(0.12, 0.08, 0.18, 0.98)
    love.graphics.rectangle("fill", x, y, w, h, 6)

    love.graphics.setColor(qColor[1] * 0.8, qColor[2] * 0.8, qColor[3] * 0.8)
    love.graphics.setLineWidth(2)
    love.graphics.rectangle("line", x, y, w, h, 6)

    love.graphics.setColor(self.PALETTE.gold_dim)
    love.graphics.setLineWidth(1)
    love.graphics.rectangle("line", x + 4, y + 4, w - 8, h - 8, 4)

    love.graphics.setColor(qColor[1] * 0.4, qColor[2] * 0.4, qColor[3] * 0.4, 0.8)
    love.graphics.rectangle("fill", x + 6, y + 6, w - 12, 4, 2)

    love.graphics.setFont(self.font_xs)
    love.graphics.setColor(qColor)
    love.graphics.print("【" .. card:getQualityName() .. "】", x + 8, y + 8)

    love.graphics.setColor(self.PALETTE.text_dim)
    love.graphics.print(card:getTypeName(), x + w - 30, y + 8)

    love.graphics.setFont(self.font_card_big)
    love.graphics.setColor(self.PALETTE.text_bright)
    love.graphics.printf(card.name, x + 4, y + 26, w - 8, "center")

    love.graphics.setColor(self.PALETTE.gold_dim)
    love.graphics.line(x + 12, y + 50, x + w - 12, y + 50)

    local elemColor = self.ELEMENT_COLORS[card.element] or self.PALETTE.text_dim
    local elemGlyph = self.ELEMENT_GLYPHS[card.element] or "—"
    local icx = x + w/2
    local icy = y + 72

    love.graphics.setColor(0.04, 0.02, 0.07, 0.95)
    love.graphics.circle("fill", icx, icy, 14)
    love.graphics.setColor(elemColor[1] * 0.7, elemColor[2] * 0.7, elemColor[3] * 0.7)
    love.graphics.setLineWidth(1.5)
    love.graphics.circle("line", icx, icy, 14)
    love.graphics.setLineWidth(1)

    love.graphics.setFont(self.font_l)
    love.graphics.setColor(elemColor)
    love.graphics.printf(elemGlyph, icx - 12, icy - 12, 24, "center")

    local statY = y + 94
    local statX = x + 6
    if card.power > 0 then
        self:drawStatBadge(statX, statY, "攻", card.power, self.PALETTE.health)
        statX = statX + 28
    end
    if card.knowledge > 0 then
        self:drawStatBadge(statX, statY, "悟", card.knowledge, self.PALETTE.sanity)
        statX = statX + 28
    end
    if card.mystery > 0 then
        self:drawStatBadge(statX, statY, "玄", card.mystery, self.PALETTE.text_purple)
    end

    if card.danger > 0 then
        self:drawStatBadge(x + 6, statY + 16, "危", card.danger, self.PALETTE.text_red)
    end

    love.graphics.setFont(self.font_xs)
    love.graphics.setColor(self.PALETTE.text_dim)
    local desc = card.description
    if #desc > 14 then desc = string.sub(desc, 1, 12) .. ".." end
    love.graphics.printf(desc, x + 4, y + 116, w - 8, "center")

    if card.lifetime > 0 then
        love.graphics.setFont(self.font_xs)
        love.graphics.setColor(self.PALETTE.text_red)
        love.graphics.print("限 " .. math.ceil(card.remainingTime), x + w - 32, y + h - 14)
    end

    if card.cursed then
        love.graphics.setColor(0.7, 0.1, 0.1, 0.25)
        love.graphics.rectangle("fill", x, y, w, h, 6)
        love.graphics.setFont(self.font_xs)
        love.graphics.setColor(self.PALETTE.text_red)
        love.graphics.print("咒", x + w/2 - 6, y + 4)
    end

    if dragging then
        love.graphics.setColor(self.PALETTE.gold[1], self.PALETTE.gold[2], self.PALETTE.gold[3], 0.5)
        love.graphics.setLineWidth(2.5)
        love.graphics.rectangle("line", x - 2, y - 2, w + 4, h + 4, 7)
        love.graphics.setLineWidth(1)
    end
end

function UI:drawStatBadge(x, y, label, value, color)
    local bw = 26
    local bh = 14
    love.graphics.setColor(color[1] * 0.3, color[2] * 0.3, color[3] * 0.3, 0.9)
    love.graphics.rectangle("fill", x, y, bw, bh, 3)
    love.graphics.setColor(color)
    love.graphics.setLineWidth(1)
    love.graphics.rectangle("line", x, y, bw, bh, 3)
    love.graphics.setFont(self.font_xs)
    love.graphics.setColor(self.PALETTE.text_bright)
    love.graphics.printf(label .. value, x, y + 1, bw, "center")
end

-- ============================================================
-- 预演弹窗（拖卡到符印上时弹出，确认/取消）
-- ============================================================
function UI:drawPreviewDialog()
    if not self.previewDialog then return end

    local d = self.previewDialog
    local w = self.screenW
    local h = self.screenH
    local dialogW = 520
    local dialogH = 380
    local dx = (w - dialogW) / 2
    local dy = (h - dialogH) / 2 - 20

    -- 背景遮罩
    love.graphics.setColor(0, 0, 0, 0.75)
    love.graphics.rectangle("fill", 0, 0, w, h)

    -- 古卷
    love.graphics.setColor(self.PALETTE.desk_light[1], self.PALETTE.desk_light[2], self.PALETTE.desk_light[3], 0.98)
    love.graphics.rectangle("fill", dx, dy, dialogW, dialogH, 8)

    -- 卷轴端
    love.graphics.setColor(self.PALETTE.bronze)
    love.graphics.rectangle("fill", dx - 8, dy, 16, dialogH, 4)
    love.graphics.rectangle("fill", dx + dialogW - 8, dy, 16, dialogH, 4)
    love.graphics.setColor(self.PALETTE.gold_dim)
    love.graphics.rectangle("line", dx - 8, dy, 16, dialogH, 4)
    love.graphics.rectangle("line", dx + dialogW - 8, dy, 16, dialogH, 4)

    -- 主框
    love.graphics.setColor(self.PALETTE.gold)
    love.graphics.setLineWidth(2)
    love.graphics.rectangle("line", dx, dy, dialogW, dialogH, 8)
    love.graphics.setLineWidth(1)

    -- 标题
    love.graphics.setFont(self.font_xl)
    love.graphics.setColor(self.PALETTE.gold)
    love.graphics.printf("预 演 · 即将发生", dx + 20, dy + 18, dialogW - 40, "center")

    love.graphics.setColor(self.PALETTE.cinnabar)
    love.graphics.setLineWidth(1)
    love.graphics.line(dx + 80, dy + 50, dx + dialogW - 80, dy + 50)

    -- 展示: 卡牌 -> 符印
    local card = d.card
    local slot = d.slot
    local slotName = self.SLOT_TYPE_NAMES[slot.id] or "?"
    local sigilColor = self.PALETTE[self.SIGIL_COLORS[slot.id] or "sigil_green"]

    -- 卡牌名 + 符印名
    love.graphics.setFont(self.font_m)
    love.graphics.setColor(self.PALETTE.text_bright)
    love.graphics.printf("【" .. card.name .. "】  →  " .. slotName, dx + 30, dy + 64, dialogW - 60, "center")

    -- 持续时间
    local dur = Board:getSlotDuration(slot, card)
    local realDur = dur / (Player.gameSpeed or 1)
    love.graphics.setFont(self.font_s)
    love.graphics.setColor(self.PALETTE.text_warm)
    love.graphics.printf(string.format("倒计时: %d 秒 (倍速 %sx => %d 秒)", dur, Player.gameSpeed, realDur), dx + 30, dy + 90, dialogW - 60, "center")

    -- 描述
    love.graphics.setColor(self.PALETTE.text_dim)
    love.graphics.printf(self.SLOT_DESCRIPTIONS[slot.id] or "", dx + 30, dy + 112, dialogW - 60, "center")

    -- 预演结果
    love.graphics.setFont(self.font_m)
    love.graphics.setColor(self.PALETTE.gold)
    love.graphics.printf("【可能收获】", dx + 30, dy + 142, dialogW - 60, "left")

    local result = d.preview
    local ry = dy + 168
    love.graphics.setFont(self.font_s)
    love.graphics.setColor(self.PALETTE.text_bright)

    local lines = {}
    if result.text and result.text ~= "" then
        table.insert(lines, "· " .. result.text)
    end
    if result.xp and result.xp ~= 0 then
        table.insert(lines, "· 修为 +" .. result.xp)
    end
    if result.qi and result.qi ~= 0 then
        table.insert(lines, "· 灵气 +" .. result.qi)
    end
    if result.stones and result.stones ~= 0 then
        table.insert(lines, "· 灵石 +" .. result.stones)
    end
    if result.health and result.health ~= 0 then
        local prefix = result.health > 0 and "+" or ""
        table.insert(lines, "· 生命 " .. prefix .. result.health)
    end
    if result.sanity and result.sanity ~= 0 then
        local prefix = result.sanity > 0 and "+" or ""
        table.insert(lines, "· 神智 " .. prefix .. result.sanity)
    end
    if result.corruption and result.corruption ~= 0 then
        table.insert(lines, "· 魔化 +" .. result.corruption)
    end
    if result.karma and result.karma ~= 0 then
        local prefix = result.karma > 0 and "+" or ""
        table.insert(lines, "· 业力 " .. prefix .. result.karma)
    end
    if result.blood and result.blood ~= 0 then
        table.insert(lines, "· 精血 +" .. result.blood)
    end
    if result.newCard then
        table.insert(lines, "· 可能获得新卡: " .. result.newCard.name)
    end

    -- 风险提示
    if card.danger > 0 then
        table.insert(lines, "⚠ 危险度: " .. card.danger)
    end

    -- 如果探索类, 提示随机性
    if slot.id == Board.SLOT_TYPES.EXPLORE then
        table.insert(lines, "🎲 探索结果随机(30%灵石/20%灵气/20%灵草/30%受伤)")
    end

    if #lines == 0 then
        table.insert(lines, "· 暂无具体收益, 卡牌将返还手中")
    end

    for _, line in ipairs(lines) do
        love.graphics.printf(line, dx + 30, ry, dialogW - 60, "left")
        ry = ry + 18
    end

    -- 按钮
    local btnW = 110
    local btnH = 36
    local gap = 30
    local totalBtnW = btnW * 2 + gap
    local btnY = dy + dialogH - 60
    local confirmX = dx + (dialogW - totalBtnW) / 2
    local cancelX = confirmX + btnW + gap

    -- 确认
    love.graphics.setColor(self.PALETTE.qi_bar[1] * 0.3, self.PALETTE.qi_bar[2] * 0.3, self.PALETTE.qi_bar[3] * 0.3, 0.95)
    love.graphics.rectangle("fill", confirmX, btnY, btnW, btnH, 4)
    love.graphics.setColor(self.PALETTE.qi_bar)
    love.graphics.setLineWidth(2)
    love.graphics.rectangle("line", confirmX, btnY, btnW, btnH, 4)
    love.graphics.setLineWidth(1)

    love.graphics.setFont(self.font_m)
    love.graphics.setColor(self.PALETTE.text_bright)
    love.graphics.printf("开 始 修 行", confirmX, btnY + 9, btnW, "center")

    -- 取消
    love.graphics.setColor(self.PALETTE.text_red[1] * 0.2, self.PALETTE.text_red[2] * 0.2, self.PALETTE.text_red[3] * 0.2, 0.9)
    love.graphics.rectangle("fill", cancelX, btnY, btnW, btnH, 4)
    love.graphics.setColor(self.PALETTE.text_red)
    love.graphics.setLineWidth(2)
    love.graphics.rectangle("line", cancelX, btnY, btnW, btnH, 4)
    love.graphics.setLineWidth(1)

    love.graphics.setFont(self.font_m)
    love.graphics.setColor(self.PALETTE.text_bright)
    love.graphics.printf("取 消", cancelX, btnY + 9, btnW, "center")

    d._confirmBounds = {x = confirmX, y = btnY, w = btnW, h = btnH}
    d._cancelBounds = {x = cancelX, y = btnY, w = btnW, h = btnH}
end

-- ============================================================
-- 事件对话框
-- ============================================================
function UI:drawEventDialog()
    local event = Event.currentEvent
    if not event then return end

    local w = self.screenW
    local h = self.screenH
    local dialogW = 540
    local dialogH = 380
    local dx = (w - dialogW) / 2
    local dy = (h - dialogH) / 2 - 30

    love.graphics.setColor(0, 0, 0, 0.75)
    love.graphics.rectangle("fill", 0, 0, w, h)

    love.graphics.setColor(self.PALETTE.desk_light[1], self.PALETTE.desk_light[2], self.PALETTE.desk_light[3], 0.98)
    love.graphics.rectangle("fill", dx, dy, dialogW, dialogH, 8)

    love.graphics.setColor(self.PALETTE.bronze)
    love.graphics.rectangle("fill", dx - 8, dy, 16, dialogH, 4)
    love.graphics.rectangle("fill", dx + dialogW - 8, dy, 16, dialogH, 4)
    love.graphics.setColor(self.PALETTE.gold_dim)
    love.graphics.rectangle("line", dx - 8, dy, 16, dialogH, 4)
    love.graphics.rectangle("line", dx + dialogW - 8, dy, 16, dialogH, 4)

    love.graphics.setColor(self.PALETTE.gold)
    love.graphics.setLineWidth(2)
    love.graphics.rectangle("line", dx, dy, dialogW, dialogH, 8)
    love.graphics.setLineWidth(1)

    love.graphics.setFont(self.font_xl)
    love.graphics.setColor(self.PALETTE.gold)
    love.graphics.printf(event.title, dx + 20, dy + 22, dialogW - 40, "center")

    love.graphics.setColor(self.PALETTE.cinnabar)
    love.graphics.setLineWidth(1)
    love.graphics.line(dx + 80, dy + 58, dx + dialogW - 80, dy + 58)

    love.graphics.setFont(self.font_m)
    love.graphics.setColor(self.PALETTE.text_warm)
    love.graphics.printf(event.text, dx + 30, dy + 70, dialogW - 60, "left")

    local btnX = dx + 40
    local btnY = dy + dialogH - 100
    local btnW = dialogW - 80
    local btnH = 32

    for i, choice in ipairs(event.choices) do
        local by = btnY + (i - 1) * 36
        local enabled = true
        if choice.condition and not choice.condition() then
            enabled = false
        end

        if enabled then
            love.graphics.setColor(0.10, 0.06, 0.16, 0.95)
        else
            love.graphics.setColor(0.06, 0.04, 0.10, 0.7)
        end
        love.graphics.rectangle("fill", btnX, by, btnW, btnH, 4)

        love.graphics.setColor(enabled and self.PALETTE.gold or self.PALETTE.gold_dim)
        love.graphics.setLineWidth(1.5)
        love.graphics.rectangle("line", btnX, by, btnW, btnH, 4)
        love.graphics.setLineWidth(1)

        love.graphics.setColor(self.PALETTE.gold)
        love.graphics.circle("fill", btnX + 16, by + btnH/2, 11)
        love.graphics.setColor(self.PALETTE.ink)
        love.graphics.circle("fill", btnX + 16, by + btnH/2, 9)
        love.graphics.setFont(self.font_s)
        love.graphics.setColor(self.PALETTE.gold)
        love.graphics.printf(tostring(i), btnX + 10, by + btnH/2 - 8, 12, "center")

        love.graphics.setFont(self.font_m)
        love.graphics.setColor(enabled and self.PALETTE.text_bright or self.PALETTE.text_ghost)
        love.graphics.print(choice.text, btnX + 36, by + 8)

        if not enabled and choice.disabledHint then
            love.graphics.setFont(self.font_xs)
            love.graphics.setColor(self.PALETTE.text_red)
            love.graphics.print(choice.disabledHint, btnX + 36, by + 22)
        end

        choice._bounds = {x = btnX, y = by, w = btnW, h = btnH}
    end
end

-- ============================================================
-- 日志
-- ============================================================
function UI:drawLog()
    local w = self.screenW
    local h = self.screenH
    local panelX = w - 220
    local panelY = 100
    local panelW = 200
    local panelH = h - 290

    love.graphics.setFont(self.font_m)
    love.graphics.setColor(self.PALETTE.gold)
    love.graphics.print("【 修 仙 日 志 】", panelX, panelY - 28)

    love.graphics.setFont(self.font_xs)
    love.graphics.setColor(self.PALETTE.text_ghost)
    love.graphics.print("~~~ 往事如烟  依次铭刻 ~~~", panelX, panelY + panelH + 8)

    love.graphics.setFont(self.font_xs)
    local y = panelY
    local maxLines = math.floor(panelH / 16)
    local logs = Player.log
    local startIdx = math.max(1, #logs - maxLines + 1)

    for i = startIdx, #logs do
        local msg = logs[i]
        local alpha = 0.25 + 0.75 * ((i - startIdx) / math.max(1, #logs - startIdx))
        local color = self.PALETTE.text_warm

        if string.find(msg, "【事件】") then color = self.PALETTE.gold end
        if string.find(msg, "完成") then color = self.PALETTE.text_green end
        if string.find(msg, "消散") or string.find(msg, "受伤") then color = self.PALETTE.text_red end
        if string.find(msg, "咒") or string.find(msg, "魔化") then color = self.PALETTE.text_purple end
        if string.find(msg, "获得") then color = self.PALETTE.text_blue end
        if string.find(msg, "倍速") then color = self.PALETTE.qi_bar end

        love.graphics.setColor(color[1], color[2], color[3], alpha)
        love.graphics.printf(msg, panelX, y, panelW, "left")
        y = y + 16
    end
end

-- ============================================================
-- 粒子和飘字
-- ============================================================
function UI:drawParticles()
    for _, p in ipairs(self.particles) do
        love.graphics.setColor(p.color[1], p.color[2], p.color[3], p.alpha)
        love.graphics.circle("fill", p.x, p.y, p.size)
    end
end

function UI:drawFloatTexts()
    love.graphics.setFont(self.font_m)
    for _, t in ipairs(self.floatTexts) do
        love.graphics.setColor(t.color[1], t.color[2], t.color[3], t.alpha)
        love.graphics.printf(t.text, t.x - 50, t.y, 100, "center")
    end
end

-- ============================================================
-- 死亡画面
-- ============================================================
function UI:drawDeathScreen()
    local w, h = self.screenW, self.screenH
    love.graphics.setColor(0, 0, 0, 0.85)
    love.graphics.rectangle("fill", 0, 0, w, h)

    love.graphics.setFont(self.font_xxl)
    love.graphics.setColor(self.PALETTE.cinnabar)
    love.graphics.printf("道 消 身 陨", 0, h/2 - 80, w, "center")

    love.graphics.setFont(self.font_l)
    love.graphics.setColor(self.PALETTE.text_warm)
    love.graphics.printf(Player:getDeathReason(), 0, h/2 - 10, w, "center")

    love.graphics.setFont(self.font_m)
    love.graphics.setColor(self.PALETTE.gold)
    love.graphics.printf("最终境界：" .. Player:getCultivationName(), 0, h/2 + 30, w, "center")
    love.graphics.printf("历经 " .. Player.turn .. " 载", 0, h/2 + 60, w, "center")

    love.graphics.setColor(self.PALETTE.text_dim)
    love.graphics.printf("按 R 键重入轮回", 0, h/2 + 100, w, "center")
end

-- ============================================================
-- 输入处理
-- ============================================================
function UI:mousepressed(x, y, button)
    -- 预演弹窗处理
    if self.previewDialog then
        local d = self.previewDialog
        if d._confirmBounds then
            local b = d._confirmBounds
            if x >= b.x and x <= b.x + b.w and y >= b.y and y <= b.y + b.h then
                -- 确认: 真正放入
                local card = d.card
                local slotIndex = d.slotIndex
                -- 实际放入
                local slot = Board.slots[slotIndex]
                Board:removeCardFromHand(card)
                slot.card = card
                slot.active = true
                slot.progress = 0
                slot.duration = Board:getSlotDuration(slot, card)
                slot.result = nil
                self:burst(slot._drawX or slot._x, slot._drawY or slot._y, self.PALETTE.gold, 20)
                Player:addLog("将【" .. card.name .. "】放入【" .. slot.name .. "】开始修行")
                self.previewDialog = nil
                Board.dragCard = nil
                Board.dragging = false
                return
            end
        end
        if d._cancelBounds then
            local b = d._cancelBounds
            if x >= b.x and x <= b.x + b.w and y >= b.y and y <= b.y + b.h then
                -- 取消: 卡牌返回手牌
                self.previewDialog = nil
                Board.dragCard = nil
                Board.dragging = false
                return
            end
        end
        -- 点击其他位置也视为取消
        self.previewDialog = nil
        Board.dragCard = nil
        Board.dragging = false
        return
    end

    -- 事件对话框
    if Event.currentEvent then
        for i, choice in ipairs(Event.currentEvent.choices) do
            if choice._bounds then
                local b = choice._bounds
                if x >= b.x and x <= b.x + b.w and y >= b.y and y <= b.y + b.h then
                    if choice.condition and not choice.condition() then return end
                    Event:resolveEvent(i)
                    return
                end
            end
        end
        return
    end

    -- 倍速按钮
    if self.speedButtons then
        for _, b in ipairs(self.speedButtons) do
            if x >= b.x and x <= b.x + b.w and y >= b.y and y <= b.y + b.h then
                Player.speedIndex = b.idx
                Player.gameSpeed = Player.speedLevels[Player.speedIndex]
                local name = "正常"
                if Player.gameSpeed == 0.5 then name = "慢速" end
                if Player.gameSpeed == 1 then name = "正常" end
                if Player.gameSpeed == 2 then name = "2倍速" end
                if Player.gameSpeed == 3 then name = "3倍速" end
                if Player.gameSpeed == 4 then name = "4倍速" end
                Player:addLog("【倍速】切换为 " .. name)
                return
            end
        end
    end

    -- 右键拖动符印
    if button == 2 then
        local sigilIndex, sigil = self:getSigilAt(x, y)
        if sigil then
            self.dragSigil = sigil
            self.dragSigilOffsetX = x - (sigil._x or 0)
            self.dragSigilOffsetY = y - (sigil._y or 0)
            return
        end
    end

    -- M 模式: 左键也能拖符印
    if button == 1 and self.sigilMoveMode then
        local sigilIndex, sigil = self:getSigilAt(x, y)
        if sigil then
            self.dragSigil = sigil
            self.dragSigilOffsetX = x - (sigil._x or 0)
            self.dragSigilOffsetY = y - (sigil._y or 0)
            return
        end
    end

    -- 左键: 取结果
    if button == 1 then
        local sigilIndex, sigil = self:getSigilAt(x, y)
        if sigilIndex and sigil then
            if sigil.result then
                self:burst(sigil._drawX or sigil._x, sigil._drawY or sigil._y, self.PALETTE.qi_bar, 10)
                sigil.result = nil
                return
            end
        end
    end

    -- 左键: 开始拖卡 (从手牌)
    if button == 1 and not Board.dragCard then
        local card, cardIndex = Board:getCardAt(x, y, self.cardW, self.cardH)
        if card then
            Board.dragCard = card
            Board.dragging = true
            local cx = card._x or 0
            local cy = card._y or 0
            Board.dragOffsetX = x - cx
            Board.dragOffsetY = y - cy
            self:burst(cx + self.cardW/2, cy + self.cardH/2, self.PALETTE.gold, 8)
        end
    end
end

function UI:mousereleased(x, y, button)
    -- 释放符印(整理模式)
    if self.dragSigil then
        self.dragSigil._x = self.dragSigil._drawX
        self.dragSigil._y = self.dragSigil._drawY
        self.dragSigil = nil
        return
    end

    -- 释放卡牌: 弹出预演对话框
    if Board.dragCard and button == 1 then
        local sigilIndex, sigil = self:getSigilAt(x, y)
        if sigilIndex and sigil and not sigil.active then
            if Board.dragCard:canPlaceIn(sigil.id) then
                -- 兼容, 弹出预演
                local preview = Board:previewResult(sigil, Board.dragCard)
                self.previewDialog = {
                    card = Board.dragCard,
                    slot = sigil,
                    slotIndex = sigilIndex,
                    preview = preview,
                }
            else
                -- 不兼容
                self:burst(sigil._drawX or sigil._x, sigil._drawY or sigil._y, self.PALETTE.text_red, 8)
                self:floatText(sigil._drawX or sigil._x, sigil._drawY or sigil._y - 50,
                    "【" .. Board.dragCard:getTypeName() .. "】无法放入【" .. (self.SLOT_TYPE_NAMES[sigil.id] or "?") .. "】",
                    self.PALETTE.text_red)
                Board.dragCard = nil
                Board.dragging = false
            end
        else
            -- 没在符印上释放: 卡牌返回
            Board.dragCard = nil
            Board.dragging = false
        end
    end
end

function UI:mousemoved(x, y, dx, dy)
    self.hoverSigil = nil
    for i, slot in ipairs(Board.slots) do
        local sx = slot._drawX or slot._x or 0
        local sy = slot._drawY or slot._y or 0
        local ddx = x - sx
        local ddy = y - sy
        if ddx * ddx + ddy * ddy <= self.sigilR * self.sigilR then
            self.hoverSigil = i
            break
        end
    end
end

function UI:keypressed(key)
    if key == "r" and Player:isDead() then
        love.event.quit("restart")
    end
    if key == "escape" then
        love.event.quit()
    end
    if key == "m" then
        self.sigilMoveMode = not self.sigilMoveMode
        if self.sigilMoveMode then
            Player:addLog("【整理模式】左键拖动符印重新整理桌面(右键随时可拖)")
        else
            Player:addLog("【施法模式】拖动玉牌至符印, 右键拖动符印")
        end
    end

    -- 倍速快捷键 1-5
    if key == "1" then
        Player.speedIndex = 1
        Player.gameSpeed = Player.speedLevels[1]
        Player:addLog("【倍速】切换为 慢速 (0.5x)")
    elseif key == "2" then
        Player.speedIndex = 2
        Player.gameSpeed = Player.speedLevels[2]
        Player:addLog("【倍速】切换为 正常 (1x)")
    elseif key == "3" then
        Player.speedIndex = 3
        Player.gameSpeed = Player.speedLevels[3]
        Player:addLog("【倍速】切换为 2倍速 (2x)")
    elseif key == "4" then
        Player.speedIndex = 4
        Player.gameSpeed = Player.speedLevels[4]
        Player:addLog("【倍速】切换为 3倍速 (3x)")
    elseif key == "5" then
        Player.speedIndex = 5
        Player.gameSpeed = Player.speedLevels[5]
        Player:addLog("【倍速】切换为 4倍速 (4x)")
    end
end

function UI:resize(w, h)
    self.screenW = w
    self.screenH = h
end

return UI
