
AppTool = class("AppTool")

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

function AppTool:logEvent(data)
    local args = {data = data}
    local ok,ret = self:callNative("MichaelStart", "logEvent", args)
    if ok and ret and 1 == ret then
       
    end    
end

function AppTool:getIMEI(iosCall)
    local key = "App_ASID_String"
    local imei = cc.UserDefault:getInstance():getStringForKey(key, "")
    if imei and imei ~= "" then
        if iosCall then
            iosCall(imei)
        end
        return imei
    else
        local function iosImeiCall(imeiStr)
            cc.UserDefault:getInstance():setStringForKey(key, imeiStr)
            if iosCall then
              iosCall(imeiStr)
            end
        end
        local args = {callback = iosImeiCall}
        local ok,ret = self:callNative("MichaelStart", "getIMEI", args)
        if ok and ret and "" ~= ret then
            cc.UserDefault:getInstance():setStringForKey(key, ret)
            imei = ret
        end
    end
    return imei
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