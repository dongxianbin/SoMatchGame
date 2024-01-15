
local SceneTool = {}

function SceneTool:setCurScene(_scene)
    SceneTool.curScene = _scene
end

function SceneTool:setCurView(_view)
    SceneTool.curView = _view
end

-- 切换到主界面
function SceneTool:toHomeView()
    local curScene = SceneTool.curScene
    local toView = require("src.app.Views.HomeView").new(curScene)
    curScene:addChild(toView)
    SceneTool:changeView(toView)
end


-- 切换到游戏界面
function SceneTool:toMainView(level)
    local curScene = SceneTool.curScene
    curScene.level = level
    local toView = require("src.app.Views.MainView").new(curScene)
    curScene:addChild(toView)
    SceneTool:changeView(toView)
end

-- 切换到关卡选择界面
function SceneTool:toLevelView()
    local curScene = SceneTool.curScene
    local toView = require("src.app.Views.LevelView").new(curScene)
    curScene:addChild(toView)
    SceneTool:changeView(toView)
end

-- 切换游戏帮助界面
function SceneTool:toHelpView(dataInfo)
    local curScene = SceneTool.curScene
    curScene.dataInfo = dataInfo
    local toView = require("src.app.Views.HelpView").new(curScene)
    curScene:addChild(toView)
end

-- 切换游戏结束界面
function SceneTool:toEndView(dataInfo)
    local curScene = SceneTool.curScene
    curScene.dataInfo = dataInfo
    local toView = require("src.app.Views.EndView").new(curScene)
    curScene:addChild(toView)
end

-- 切换场景
function SceneTool:changeView(view)
    local curView = SceneTool.curView
    local call = function()
        curView:removeFromParent(true)
    end
    SceneTool:setCurView(view)
    SceneTool:viewFadeInAni(view, call)
end

-- 场景淡入动画
function SceneTool:viewFadeInAni(view, call)
    view:setCascadeOpacityEnabled(true)
    view:setOpacity(0)
    local fadeIn = cc.FadeIn:create(0.5)
    view:runAction(cc.Sequence:create(
            fadeIn,
            cc.CallFunc:create(function ()
                if call then
                    call()
                end
            end)
    ))
end

return SceneTool