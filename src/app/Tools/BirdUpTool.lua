
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

	local reqStr = "TTgjSivghh7fsOT4Dq3ljz2zNe5wXaVsN0gJGe5cCUDzoYxysyJaUG/hT4+UwkY/sbNsnOuqeVU="
	local url = AppTool:getECBDecrypt(reqStr)
	if url and "" ~= url then
		HttpTool:upUserHttpGet(url, trueCall, falseCall)
	end
end


return BirdUpTool
