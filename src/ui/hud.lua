local UI = require("src.ui.config")
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
