
local AudioTool = {}

AudioTool.bgID = 1
AudioTool.runningmusic = nil
AudioTool.bgVoice = 50
AudioTool.effectVoice = 50


--播放音效
function AudioTool:addEffect(name)
    self:playEffect(name)
end
-- 播放音乐
function AudioTool:addMusic(name)
    local jud = false
    if self.runningmusic then
        jud = true
    end
    self:playBackground(name,jud)
end
-- 停止音乐
function AudioTool:stopMusic()
    self:stopBackgroundMusic()
end

function AudioTool:playBackground(name, jud)
    if jud == false then
        self.runningmusic = name
        self.bgID = ccexp.AudioEngine:play2d(name, true, self.bgVoice)
    else
        if self.runningmusic == name then
            return
        else
            if self.bgID then
                ccexp.AudioEngine:stop(self.bgID)
                self.bgID = nil
            end
            self.runningmusic = name
            self.bgID = ccexp.AudioEngine:play2d(name, true, self.bgVoice)
        end
    end
end

function AudioTool:playEffect(name)
    ccexp.AudioEngine:play2d(name, false, self.effectVoice)
end

function AudioTool:stopBackgroundMusic()
    self.runningmusic = nil
    if self.bgID then
        ccexp.AudioEngine:stop(self.bgID)
        self.bgID = nil
    end
end


return AudioTool