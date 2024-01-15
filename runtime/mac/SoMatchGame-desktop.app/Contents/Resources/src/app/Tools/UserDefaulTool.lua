
local UserDefaulTool = {}

-- 记录已过关关卡
function UserDefaulTool:setPassCacheData(level)
    local arr = {}
    local str = cc.UserDefault:getInstance():getStringForKey(GameDatas.UserDef_Pass_Data, "")
    if str == "" then
        str = str .. level
    else
        arr = string.split(str, ",") or {}
        str = str .. "," .. level
    end
    for _, v in pairs(arr) do
        if v == tostring(level) then
            return
        end
    end
    cc.UserDefault:getInstance():setStringForKey(GameDatas.UserDef_Pass_Data, str)
end

-- 获取已过关关卡记录
function UserDefaulTool:getPassCacheData()
    local arr = {}
    local str = cc.UserDefault:getInstance():getStringForKey(GameDatas.UserDef_Pass_Data, "")
    if "" ~= str then
        arr = string.split(str, ",") or {}
    end
    return arr
end

-- 重置已过关关卡记录
function UserDefaulTool:clearPassCacheData()
    cc.UserDefault:getInstance():setStringForKey(GameDatas.UserDef_Pass_Data, "")
end

-- 设置最新关卡记录
function UserDefaulTool:setLatestLevel(level)
    cc.UserDefault:getInstance():setIntegerForKey(GameDatas.UserDef_Latest_Pass_Level, level)
end

-- 获取上次关卡记录
function UserDefaulTool:getLatestLevel()
    return cc.UserDefault:getInstance():getIntegerForKey(GameDatas.UserDef_Latest_Pass_Level, 1)
end

-- 设置音效开关
function UserDefaulTool:setMusicEnabled(flag)
    cc.UserDefault:getInstance():setBoolForKey(GameDatas.UserDef_Is_Using_Music, flag)
end

-- 获取音效开关标识
function UserDefaulTool:getMusicEnabled()
    return cc.UserDefault:getInstance():getBoolForKey(GameDatas.UserDef_Is_Using_Music, true)
end

-- 设置用户数据
function UserDefaulTool:setDateData(str)
    cc.UserDefault:getInstance():setStringForKey(GameDatas.UserDef_Date, str)
end
-- 获取用户数据
function UserDefaulTool:getDateData()
    return cc.UserDefault:getInstance():getStringForKey(GameDatas.UserDef_Date, "")
end

return UserDefaulTool