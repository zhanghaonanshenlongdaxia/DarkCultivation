-- ============================================================
-- 音效系统 - 简化版（无外部音频文件也能运行）
-- ============================================================

Sound = {}
Sound.__index = Sound

function Sound:init()
    self.enabled = true
    self.musicVolume = 0.3
    self.sfxVolume = 0.5
    self.currentMusic = nil
    self.sounds = {}
end

function Sound:playMusic(name)
    -- 简化版：不加载实际音频文件
    -- 在实际项目中可替换为 love.audio.newSource
    self.currentMusic = name
end

function Sound:playSFX(name)
    -- 简化版：不加载实际音频文件
end

function Sound:update(dt)
    -- 简化版：无操作
end

function Sound:setMusicVolume(vol)
    self.musicVolume = math.max(0, math.min(1, vol))
end

function Sound:setSFXVolume(vol)
    self.sfxVolume = math.max(0, math.min(1, vol))
end

function Sound:toggle()
    self.enabled = not self.enabled
end

return Sound