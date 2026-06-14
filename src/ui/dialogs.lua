local UI = require("src.ui.config")
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
