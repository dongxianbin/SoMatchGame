
local LevelView = class("LevelView", BaseView)

function LevelView:ctor(_scene)
    self.scene = _scene
    self.passCircleViews = {}

    local para_new = {
        csb = "res/LevelScene.csb",
        setSize = true
    }
    local csbNode = self:createCSB(para_new)
    self:addChild(csbNode)
    self:initView(csbNode)
    self:initData()
end

function LevelView:initView(csbNode)
    local panel_root = csbNode:getChildByName("Panel_root")
    local btn_home = panel_root:getChildByName("btn_home")

    local onclickCall = handler(self, self.commonTouchCall)
    btn_home:addTouchEventListener(onclickCall)

    local panel_list = panel_root:getChildByName("Panel_list")
    self.List_item = panel_list:getChildByName("ListView")
    self.Panel_item = panel_list:getChildByName("Panel_item"):hide()
    self.List_item:setScrollBarEnabled(false)
    
end

function LevelView:initData()
    local arr = UserDefaulTool:getPassCacheData()
    self.curLevel = #arr + 1
    self:initListView(arr)

end

function LevelView:commonTouchCall(sender, eventType)
    if eventType ~= ccui.TouchEventType.ended then
        return
    end
    AudioTool:addEffect(GameDatas.Music_Touch)
    local name = sender:getName()
    if "btn_home" == name then
        SceneTool:toHomeView()
    end

    local isCtIt = sender.isCtIt
    if isCtIt then
        if sender.pslevel <= self.curLevel then
            -- 点击关卡按钮进入相应关卡
            SceneTool:toMainView(sender.pslevel)
        else
            local dataInfo = { title = "TIPS", tips = "This level cannot be opened. Please pass the previous level first.", callback = nil }
            SceneTool:toHelpView(dataInfo)
        end
        return
    end
end

function LevelView:initListView(cachePassDt)
    local total = GameDatas.NUM_OPEN_LEVEL or 0
    local defCol = 4    -- 每行最多多少个
    local row = 0       -- 一共多少行
    local lastCol = 0   -- 最后一行个数
    if total > 0 then
        if total % defCol == 0 then
            row = total / defCol
            lastCol = defCol
        else
            row = math.floor(total / defCol) + 1
            lastCol = total % defCol
        end
    end

    if row <= 0 then
        return
    end

    local cacheMap = {}
    for _, v in ipairs(cachePassDt) do
        cacheMap[v] = v
    end
    local v = tostring(self.curLevel)
    cacheMap[v] = v

    local onclickCall = handler(self, self.commonTouchCall)
    local index = 0
    local circleViews = {}
    self.passCircleViews = circleViews
    for i = 1, row do
        local rv = self.Panel_item:clone():show()
        for j = 1, defCol do
            index = index + 1
            local it = rv:getChildByName(string.format("Panel_%d", j))
            local txt = it:getChildByName("Text_num")
            txt:setString(index)
            it.txt = txt
            table.insert(circleViews, it)

            it.isCtIt = true
            it.pslevel = index
            it.img_bg = it:getChildByName("img_bg")
            
            local isCurLevel = tostring(index) == cacheMap[tostring(self.curLevel)]
            self:updateCircleItView(it, cacheMap[tostring(index)], isCurLevel)

            if i == row then
                --最后一行
                if j > lastCol then
                    it:setVisible(false)
                end
            end
            if it:isVisible() then
                it:addTouchEventListener(onclickCall)
            end
        end
        self.List_item:pushBackCustomItem(rv)
    end
end

function LevelView:updateCircleItView(it, isBright, isCurLevel)
    if not it or not it.txt then
        return
    end
    if isCurLevel then -- 即将进入的关卡
        it.img_bg:loadTexture("level_sel.png", ccui.TextureResType.plistType)
        it.txt:setTextColor(cc.c3b(255, 199, 78))
    else
        if isBright then -- 已经完成的关卡
            it.img_bg:loadTexture("level_sel.png", ccui.TextureResType.plistType)
            it.txt:setTextColor(cc.c3b(248, 255, 255))
        else    -- 还未完成的关卡
            it.img_bg:loadTexture("level_lock.png", ccui.TextureResType.plistType)
            it.txt:hide()
        end
    end
end

-- function LevelView:getPassCacheData()
--     local arr = {}
--     -- local strs = cc.UserDefault:getInstance():getStringForKey(GameDatas.UserDef_Pass_Data, "")
--     local strs = UserDefaulTool:getPassCacheData()
--     if "" ~= strs then
--         arr = string.split(strs, ",") or {}
--     end
--     return arr
-- end

return LevelView