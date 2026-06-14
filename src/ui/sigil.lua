local UI = require("src.ui.config")
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

