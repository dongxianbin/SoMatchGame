DEBUG       = true
DEBUG_FPS   = false
CC_USE_FRAMEWORK = true
LOG_SWITCH  = true

CC_DESIGN_RESOLUTION = {
    width = 1280,
    height = 720,
    autoscale = "FIXED_WIDTH",
    callback = function(framesize)
        local ratio = framesize.width / framesize.height
        if ratio <= 1.7 then
            -- iPad 768*1024(1536*2048) is 4:3 screen
            return {autoscale = "FIXED_WIDTH"}
        else
            return {autoscale = "FIXED_HEIGHT"}
        end
    end
}

if not DEBUG then
    print = function(...)
    end
end
