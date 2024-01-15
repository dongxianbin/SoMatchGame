cc.FileUtils:getInstance():setPopupNotify(false)
-- cc.FileUtils:getInstance():addSearchPath("src/")
-- cc.FileUtils:getInstance():addSearchPath("res/")

local breakInfoFun,xpcallFun = require("LuaDebug")("localhost", 7003)

require("src.config")
require("src.cocos.init")

function __G__TRACKBACK__(msg)
    print("----------------------------------------")
    print("LUA ERROR: " .. tostring(msg) .. "\n")
    print(debug.traceback())
    print("----------------------------------------")
end

if DEBUG_FPS then
    cc.Director:getInstance():setDisplayStats(true)
end

function main()
    math.newrandomseed()
    local scene = require("src.app.GameScene").new()
    local director = cc.Director:getInstance()
    director:setAnimationInterval(1/60)
    if director:getRunningScene() then
        director:replaceScene(scene)
    else
        director:runWithScene(scene)
    end
end
xpcall(main,__G__TRACKBACK__)
