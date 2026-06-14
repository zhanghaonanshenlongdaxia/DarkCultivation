local UI = require("src.ui.config")

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
