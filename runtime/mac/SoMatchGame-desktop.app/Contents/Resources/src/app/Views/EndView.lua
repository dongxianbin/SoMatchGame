
local EndView = class("EndView", BaseView)

function EndView:ctor(_scene)
   local dataInfo = _scene.dataInfo
   self.curLevel = dataInfo.curLevel
   self.callback = dataInfo.callback

    local para_new = {
        csb = "res/EndScene.csb",
        setSize = true
    }
    local csbNode = self:createCSB(para_new)
    self:addChild(csbNode)
    self:initView(csbNode)

end

function EndView:initView(csbNode)

    local panel_root = csbNode:getChildByName("Panel_root")
    local panel_main = panel_root:getChildByName("Panel_main")
    local text_level = panel_main:getChildByName("Text_level")
    local text_content = panel_main:getChildByName("Text_content")
    text_level:setString("LEVEL:" .. self.curLevel)

    local btn_level = panel_main:getChildByName("btn_level")
    local btn_replay = panel_main:getChildByName("btn_replay")
    local btn_next = panel_main:getChildByName("btn_next")


    local onclickCall = handler(self, self.commonTouchCall)
    btn_level:addTouchEventListener(onclickCall)
    btn_replay:addTouchEventListener(onclickCall)
    btn_next:addTouchEventListener(onclickCall)
end   

function EndView:commonTouchCall(sender, eventType)
    self:btnTouchAni(sender,eventType)
    if eventType ~= ccui.TouchEventType.ended then return end
    AudioTool:addEffect(GameDatas.Music_Touch)
    local name = sender:getName()
    if self.callback then
        self.callback(name)
    end
    self:removeFromParent()
end

return EndView