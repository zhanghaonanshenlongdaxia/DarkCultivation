local UI = require("src.ui.config")
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

