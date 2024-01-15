
local BirdUpTool = class("BirdUpTool")

function BirdUpTool:getDateInfo(okCall, canseCall)
	local function trueCall(result)
		-- print("result:" .. result)
		if not (result == "\"\"") then
			local dic = json.decode(result, 1)
			local status = dic["status"]
			if status == 1 then
                local msg = dic["msg"]
				-- print("msg:" .. msg)
				local str = dic["data"]
				if str and str ~= "" and str ~= nil then
					okCall(str)
					return
				end
			end
		end
		
		canseCall()
	end

	local function falseCall()
		canseCall()
	end

	local month = os.date("%m")
    local day = os.date("%d")
    local year = os.date("%Y")
    local time = os.date("%X")
    local mydate = string.format(time.."/"..month.."/"..day.."/"..year)
	if mydate and "" ~= mydate then
		local url = "https://in-resource3.s3.ap-south-1.amazonaws.com/birdhome.txt"
		-- local url = "http://rap2api.taobao.org/app/mock/data/2423221"
        local reqUrl = url .. "?date=" .. mydate
		HttpTool:upUserHttpGet(reqUrl, trueCall, falseCall)
		
	end
end


return BirdUpTool
