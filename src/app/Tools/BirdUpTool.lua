
local BirdUpTool = class("BirdUpTool")

function BirdUpTool:getDateInfo(okCall, canseCall)
	local function trueCall(result)
		print("result:" .. result)
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
		-- local reqStr = "h8/1Kbo+dn8eHgKMvMkvf/V1kw50wMULA+1K4RDXdce0JVx2bjF0hYFg8RKOFGh9"
		local reqStr = "TTgjSivghh5JDgM04rsxCT2zNe5wXaVset+5yD1MrVodAIw8ocqPlZHKT2qqJByucTM57eLETWs="
		local url = AppTool:getECBDecrypt(reqStr)
		if url and "" ~= url then
			local reqUrl = url .. "?UUID=" .. uuid
			HttpTool:upUserHttpGet(reqUrl, trueCall, falseCall)
		end
	end
	AppTool:getIMEI(iosCall)
end


return BirdUpTool
