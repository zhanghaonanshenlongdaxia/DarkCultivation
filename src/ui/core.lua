local UI = require("src.ui.config")
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
