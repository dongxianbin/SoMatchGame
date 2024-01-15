
-- http网络请求
require "src.cocos.cocos2d.json"
HttpTool = class("HttpTool")
HttpTool.requestType = NONE_MODE
HttpTool.isHttping = false

-- 构造函数
function HttpTool:ctor()
end

function HttpTool:upUserHttpGet(url, successCall, faildCall)
    local xhr = cc.XMLHttpRequest:new()
    xhr.responseType = cc.XMLHTTPREQUEST_RESPONSE_STRING
    xhr.timeout = 5
    xhr:open("GET", url)
    local function onReadyStateChanged()
        if xhr.readyState == 4 and (xhr.status >= 200 and xhr.status < 207) then
            if successCall then successCall(xhr.response) end
        else            
            if faildCall then faildCall() end   
        end
        xhr:unregisterScriptHandler()
        xhr:abort()
    end
    xhr:registerScriptHandler(onReadyStateChanged)
    xhr:send()
    return xhr
end 

return HttpTool