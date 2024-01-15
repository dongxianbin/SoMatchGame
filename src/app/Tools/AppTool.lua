
AppTool = class("AppTool")
-- local Cfg = require("src.Game.GameCfgs")

-- function AppTool.shared()
--     if nil == _G["AppTool.obj"] then
--         _G["AppTool.obj"] = AppTool.new()
--     end
--     return _G["AppTool.obj"]
-- end

function AppTool:ctor()
end


function AppTool:sendDataInfo(call, result)
    local args = {data = result}
    local ok,ret = self:callNative("MichaelStart", "getDataInfo", args)
    if ok and ret and "" ~= ret then
        -- UserDefaulTool:setDateData(ret)
        if call then
            call(ret)
        end
    end    
end

function AppTool:getECBDecrypt(reqStr)
    local args = {reqStr = reqStr}
    local ok,ret = self:callNative("MichaelStart", "getECBDecrypt", args)
    if ok and ret and "" ~= ret then
        return ret
    end
    return ""   
end

function AppTool:getDataDic(str)
    if string.find(str, "\\") then
        str = string.gsub(str, "\\", "")
        -- print(ret)
    end
    local dic = json.decode(str, 1)
    return dic
end

function AppTool:refreshAll()
  
    local director = cc.Director:getInstance()
    if director:getRunningScene() then director:getRunningScene():stopAllActions() end

    director:getTextureCache():removeAllTextures()
    cc.SpriteFrameCache:getInstance():removeSpriteFrames()
    ReloadLua()
end

function AppTool:callNative(className, methodName, args, sigs)
    local ok,ret
    local targetPlatform = cc.Application:getInstance():getTargetPlatform()
    if cc.PLATFORM_OS_IPHONE == targetPlatform or cc.PLATFORM_OS_IPAD == targetPlatform then
        ok,ret  = luaoc.callStaticMethod(className,methodName,args)
        if not ok then
            print("luac error:", ret)
        else
            print("luac success:", ret)
        end
    end
    return ok,ret
end   
return AppTool