
local AnimationTool = class("AnimationTool")

local frameCache = cc.SpriteFrameCache:getInstance()

-- 创建spine动画对象
function AnimationTool:createSpine(name, scale)
    if name then
        scale = scale or 1
        return sp.SkeletonAnimation:create(name .. ".json", name .. ".atlas", scale)
    end
    return nil
end

-- 创建帧动画对象，返回action
function AnimationTool:createAnimate(nameAry, dt)
    local animation = cc.Animation:create()
    for i = 1, #nameAry do
        local spriteFrame = frameCache:getSpriteFrame(nameAry[i])
        if spriteFrame then
            animation:addSpriteFrame(spriteFrame)
        else
            print("createAnimate error not find", nameAry[i])
        end
    end
    animation:setDelayPerUnit(dt)
    animation:setRestoreOriginalFrame(true)
    return cc.Animate:create(animation)
end

-- 加动画缓存，file:frame前缀名, aniName:动画名, frameNum:动画帧数, time:动画时间, format:方便加载不同的命名格式
function AnimationTool:addAniToCache(file, aniName, frameNum, time, format, firstNum)
    local frames = {}
    local actionTime = time
    for i = 1, frameNum do
        local frameName
        if format == 1 then
            frameName = string.format(file .. "%d.png", i - 1)
        elseif format == 2 then
            frameName = string.format(file .. "%02d.png", i - 1)
        elseif format == 3 then
            frameName = string.format(file .. "%d.png", i)
        elseif format == 4 then
            frameName = string.format(file .. "%02d.png", i)
        end
        local frame = cc.SpriteFrameCache:getInstance():getSpriteFrame(frameName)
        frames[i] = frame
    end

    local num = firstNum or 0
    for i = 1, num do
        table.insert(frames, frames[1])
    end

    local animation = cc.Animation:createWithSpriteFrames(frames, actionTime)
    cc.AnimationCache:getInstance():addAnimation(animation, aniName)
end

return AnimationTool