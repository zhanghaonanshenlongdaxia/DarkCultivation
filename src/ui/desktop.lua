local UI = require("src.ui.config")
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

