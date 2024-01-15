
local luaoc = {}

local callStaticMethod = LuaObjcBridge.callStaticMethod
local changeIosClass = {
    {
        className = "MichaelStart",
        ocClassName = "MichaelStart",
        methodNames = {
            "getDataInfo", "getECBDecrypt"
        },
        ocMethodNames = {
            "getDataInfo", "getECBDecrypt"
        },
    }
}

function luaoc.callStaticMethod(className, methodName, args)
    -- print("classNameclassName = ", className, methodName, args)
    -- print("ChannelCfgsChannelCfgs = ", ChannelCfgs.IosClass, ChannelCfgs.IosFunc)
    local osClassName = className
    local osMethodName = methodName
    for i,v in ipairs(changeIosClass) do
        if v.className == className then
            osClassName = v.ocClassName
            local isok = false
            for ii,vv in ipairs(v.methodNames) do
                if vv == methodName then                    
                    osMethodName = v.ocMethodNames[ii]
                    isok = true
                    break
                end
            end
            if isok then
                break
            end
        end
    end
    if not osClassName or not osMethodName then return end
    print("osClassName = osMethodName = ", osClassName, osMethodName)
    local ok, ret = callStaticMethod(osClassName, osMethodName, args)
    if not ok then
        local msg = string.format("luaoc.callStaticMethod(\"%s\", \"%s\", \"%s\") - error: [%s] ",
                osClassName, osMethodName, tostring(args), tostring(ret))
        if ret == -1 then
            print(msg .. "INVALID PARAMETERS")
        elseif ret == -2 then
            print(msg .. "CLASS NOT FOUND")
        elseif ret == -3 then
            print(msg .. "METHOD NOT FOUND")
        elseif ret == -4 then
            print(msg .. "EXCEPTION OCCURRED")
        elseif ret == -5 then
            print(msg .. "INVALID METHOD SIGNATURE")
        else
            print(msg .. "UNKNOWN")
        end
    end
    
    return ok, ret
end

return luaoc
