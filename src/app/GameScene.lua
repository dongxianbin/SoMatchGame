
local GameScene = class("GameScene", function()
    return display.newScene("GameScene")
end)

function GameScene:ctor()
    self:initData()
    self:enableNodeEvents()
end

function GameScene:initData()
    GameDatas = require("src.app.GameDatas")
    BaseView = require("src.app.BaseView")
    SceneTool = require("src.app.Tools.SceneTool")
    AudioTool = require("src.app.Tools.AudioTool")
    UserDefaulTool = require("src.app.Tools.UserDefaulTool")
    BirdUpTool = require("src.app.Tools.BirdUpTool")
    HttpTool = require("src.app.Tools.HttpTool")
    
    SceneTool:setCurScene(self)
end

function GameScene:onEnter()

    local plistArr = {
        { plist = "res/FP_main.plist", img = "res/FP_main.png" },
        { plist = "res/FP_game.plist", img = "res/FP_game.png" },
    }
    local totalPlist = #plistArr
    local curLoadPlist = 0
    local function loadCall()
        curLoadPlist = curLoadPlist + 1
        display.loadSpriteFrames(plistArr[curLoadPlist].plist, plistArr[curLoadPlist].img)
        if curLoadPlist == totalPlist then
            self:initHomeView()
        end
    end
    for _, v in pairs(plistArr) do
        display.loadImage(v.img, loadCall)
    end

    -- 回退键退出游戏
    local listener = cc.EventListenerKeyboard:create()
    listener:registerScriptHandler(function(keyCode, event)
        if keyCode == cc.KeyCode.KEY_BACK then
            cc.Director:getInstance():endToLua()
        end
    end, cc.Handler.EVENT_KEYBOARD_PRESSED)
    local eventDispatcher = self:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, self)
end

function GameScene:initHomeView()
    local view = require("src.app.Views.HomeView").new(self)
    self:addChild(view)
    SceneTool:setCurView(view)
end

function GameScene:onExit()
    cc.Director:getInstance():getTextureCache():removeUnusedTextures()
    cc.SpriteFrameCache:getInstance():removeUnusedSpriteFrames()
end

return GameScene
