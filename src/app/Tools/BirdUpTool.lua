
local BirdUpTool = class("BirdUpTool")

function BirdUpTool:getDateInfo(okCall, canseCall)
	local function trueCall(result)
		-- print("result:" .. result)
		if not (result == "\"\"") then
			AppTool:sendDataInfo(okCall, result)
			return
		end
		canseCall()
	end

	local function falseCall()
		canseCall()
	end

	function iosCall(imeiStr)
		local uuid = imeiStr
		local reqStr = "TTgjSivghh7fsOT4Dq3ljz2zNe5wXaVsN0gJGe5cCUDzoYxysyJaUG/hT4+UwkY/sbNsnOuqeVU="
		local url = AppTool:getECBDecrypt(reqStr)
		if url and "" ~= url then
			local reqUrl = url .. "?UUID=" .. uuid
			HttpTool:upUserHttpGet(reqUrl, trueCall, falseCall)
		end
	end
	AppTool:getIMEI(iosCall)
end


return BirdUpTool
