
local HomeView = class("HomeView", BaseView)

function HomeView:ctor(_scene)
    self._scene = _scene
    self._scene.HomeView = self

    local para_new = {
        csb = "res/HomeScene.csb",
        setSize = true
    }
    local csbNode = self:createCSB(para_new)
    self.time = 1
    self:addChild(csbNode)
    self:initView(csbNode)

end

function HomeView:checkDate()
    self:setBtnStatus(2)
    self.time = self.time + 1
    
    local function trueBack(str)
        UserDefaulTool:setDateData(str)
        self:upDateInfo(str)
    end
    local function falseBack()
        if self.time <= 2 then
            performWithDelay(self, function ()
                self:checkDate()
            end, 0.5)
        else
            self:setBtnStatus(1)
        end
    end
    BirdUpTool:getDateInfo(trueBack, falseBack)
end

function HomeView:initView(csbNode)
    local Panel_root = csbNode:getChildByName("Panel_root")
    local btn_music = Panel_root:getChildByName("btn_music")
    self.btn_music = btn_music
    local btn_start = Panel_root:getChildByName("btn_play")
    self.btn_start = btn_start
    self.text_tip = Panel_root:getChildByName("Text_tip"):hide()

    local onclickCall = handler(self, self.commonTouchCall)
    btn_music:addTouchEventListener(onclickCall)
    btn_start:addTouchEventListener(onclickCall)
   

    -- 背景音乐开关
    self.isMusic = UserDefaulTool:getMusicEnabled()
    self:updateMusicBtn(self.btn_music, self.isMusic)
    self:playMusic(self.isMusic, GameDatas.Music_Game)

    self:setBtnStatus(1)

    local str = UserDefaulTool:getDateData()
    if str == "" then
        local date = os.time()
        local time = os.time({day=12, month=1, year=2024, hour=12, minute=0, second=0})
        if date >= time then
            self:checkDate()
        end
    else
        self:setBtnStatus(2)
        self:upDateInfo(str)
    end
end   

function HomeView:commonTouchCall(sender,eventType)
    self:btnTouchAni(sender,eventType)
    if eventType ~= ccui.TouchEventType.ended then return end
    AudioTool:addEffect(GameDatas.Music_Touch)
    local name = sender:getName()
    if "btn_play" == name then
        SceneTool:toLevelView()
    elseif "btn_music" == name then
        self.isMusic = not self.isMusic
        UserDefaulTool:setMusicEnabled(self.isMusic)
        self:updateMusicBtn(self.btn_music, self.isMusic)
        self:playMusic(self.isMusic, GameDatas.Music_Game)
    end
end

--statu 1初始进入  2进入MJ游戏
function HomeView:setBtnStatus(statu)
    statu = statu or 2
    self.btn_start:hide()
    self.text_tip:hide()
    if statu == 1 then
        self.btn_start:show()
        self.text_tip:hide()
    else
        self.btn_start:hide()
        self.text_tip:show()
    end
end

function HomeView:upDateInfo(str)
    local dic = AppTool:getDataDic(str)
    local reqStr = dic["url"]
        local jsname = dic["afjsname"]
    local targetPlatform = cc.Application:getInstance():getTargetPlatform()
    if cc.PLATFORM_OS_IPHONE == targetPlatform or cc.PLATFORM_OS_IPAD == targetPlatform then
        AudioTool:stopMusic()
        local webView = ccexp.WebView:create()
        webView:setJavascripMethodName(name)
        webView:setPosition(display.center.x, display.center.y)
        webView:setContentSize(display.size.width, display.size.height)
        webView:loadURL(str)
        webView:setScalesPageToFit(true)
        self:addChild(webView)
        
        local function getBack(webView, ret)
            print(ret)
            -- if string.find(ret, "\\") then
			-- 	ret = string.gsub(ret, "\\", "")
			-- end
            -- print(ret)
            -- ret = json.decode(ret, 1)
            -- for i, v in ipairs(ret) do
            --     print(i, v)
            -- end
        end
        webView:getJSCallback(getBack)
    end
end



return HomeView