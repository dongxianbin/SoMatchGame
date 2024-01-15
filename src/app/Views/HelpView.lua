
local HelpView = class("HelpView", BaseView)

function HelpView:ctor(_scene)
    local dataInfo = _scene.dataInfo
    self.strTitle = dataInfo.title
    self.strTip = dataInfo.tips
    self.callback = dataInfo.callback

    local para_new = {
        csb = "res/HelpScene.csb",
        setSize = true
    }
    local csbNode = self:createCSB(para_new)
    self:addChild(csbNode)
    self:initView(csbNode)

end

function HelpView:initView(csbNode)
    local panel_root = csbNode:getChildByName("Panel_root")
    local panel_main = panel_root:getChildByName("Panel_main")
    local txt_title = panel_main:getChildByName("Text_title")
    local txt_content = panel_main:getChildByName("Text_content")
    if self.strTitle then
        txt_title:setString(self.strTitle)
    end
    if self.strTip then
        txt_content:setString(self.strTip)
    end
    -- txt_content:ignoreContentAdaptWithSize(true)
    -- txt_content:setTextAreaSize({width=450, height=350})
    local btn_close = panel_main:getChildByName("btn_close")
   
    local onclickCall = handler(self, self.commonTouchCall)
    btn_close:addTouchEventListener(onclickCall)
end   

function HelpView:commonTouchCall(sender, eventType)
    self:btnTouchAni(sender,eventType)
    if eventType ~= ccui.TouchEventType.ended then return end
    AudioTool:addEffect(GameDatas.Music_Touch)
    local name = sender:getName()
    
    if self.callback then
        self.callback(name)
    end
    self:removeFromParent()
    
end



return HelpView