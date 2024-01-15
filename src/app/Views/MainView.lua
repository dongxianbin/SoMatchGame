
local MainView = class("MainView",  BaseView)
local Cell = require("src.app.Models.Cell")

function MainView:ctor(_scene)
    self._scene = _scene
    self.curLevel = self._scene.level
    self._scene.MainView = self

    self:initView()
    
end

function MainView:initView()
    local para = {
        csb = "res/MainScene.csb",
        setSize = true
    }
    local csbNode = self:createCSB(para)
    self.csbNode = csbNode
    self:addChild(csbNode)
    self:initData()
    self:initGameView(csbNode)
    self:initLevel()
end

function MainView:initData()
    self.cellTable = {}
    self.cellPosTable = {}
    self.cellBgTable = {}
    self.dirTable = {}
    self.roleTable = {}
    self.isGameOver = false
    self.birdNum = 0
    self.catchNum = 0

end

function MainView:resetCellTable()
    for i = 1, GameDatas.allRow do
        self.cellTable[i] = {}
    end 
end
-- 清空Cell
function MainView:removeAllCell()
    for row, rowTable in pairs(self.cellTable) do
        for col, cell in pairs(rowTable) do
            if cell then
                cell:removeFromParent()
                cell = nil
            end
        end
    end
    
    self:resetCellTable()
end

function MainView:initGameView(csbNode)
    local panel_root = csbNode:getChildByName("Panel_root")

    self.panel_main = panel_root:getChildByName("Panel_main")
    self:addCellBg()

    self.text_level = panel_root:getChildByName("Text_level")
    self:txtAutoWidth(self.text_level, 180)

    self.img_top = panel_root:getChildByName("img_top")

    local btn_replay = panel_root:getChildByName("btn_replay")
    local btn_level = panel_root:getChildByName("btn_level")
    self.btn_music = panel_root:getChildByName("btn_music")
    local touchHandle = handler(self, self.onTouchEventHandle)
    self.btn_music:addTouchEventListener(touchHandle)
    btn_replay:addTouchEventListener(touchHandle)
    btn_level:addTouchEventListener(touchHandle)

    local panel_dir = panel_root:getChildByName("Panel_dir")
    for i = 1, 4 do
        local btn = panel_dir:getChildByName("btn_" .. i)
        btn.tag = i
        btn:addTouchEventListener(touchHandle)
        table.insert(self.dirTable, btn)
    end
    

    -- 背景音乐开关
    self.isMusic = UserDefaulTool:getMusicEnabled()
    self:updateMusicBtn(self.btn_music, self.isMusic)
    self:playMusic(self.isMusic, GameDatas.Music_Game)

end


function MainView:onTouchEventHandle(sender, eventType)
    self:btnTouchAni(sender, eventType)
    if eventType ~= ccui.TouchEventType.ended then return end
    local name = sender:getName()
    if "btn_music" == name then
        AudioTool:addEffect(GameDatas.Music_Touch)
        self.isMusic = not self.isMusic
        UserDefaulTool:setMusicEnabled(self.isMusic)
        self:updateMusicBtn(self.btn_music, self.isMusic)
        self:playMusic(self.isMusic, GameDatas.Music_Game)
    elseif "btn_replay" == name then
        AudioTool:addEffect(GameDatas.Music_Touch)
        self:initLevel()
    elseif "btn_level" == name then
        AudioTool:addEffect(GameDatas.Music_Touch)
        SceneTool:toLevelView()
    end

    for _,btn in ipairs(self.dirTable) do
        if sender == btn then
            if not self.isGameOver then
                AudioTool:addEffect(GameDatas.Music_Move)
                local dir = btn.tag
                self:moveCell(dir)
            end
        end 
    end
end

-- 初始化关卡
function MainView:initLevel()
  
    self.isGameOver = false
    for _,role in pairs(self.roleTable) do
        if role then
            role:removeFromParent()
            role = nil
        end
    end
    self:removeAllCell()
    self.birdNum = 0
    self.catchNum = 0

    local levelDatas = GameDatas.LevelLayout[self.curLevel]
    for row = 1, #levelDatas do
        self.cellTable[row] = {}
        for col = 1, #levelDatas[row] do
            self.cellTable[row][col] = nil
            local cellType = levelDatas[row][col]
            local panel = self.cellBgTable[row][col]
            panel:hide()
            if cellType ~= 0 then
                panel:show()

                local pos = self.cellPosTable[row][col]
                local cell = Cell:create(cellType, self)
                cell:setCurPos(pos)
                cell:setRowAndCol(row, col)
                self.panel_main:addChild(cell)
                self.cellTable[row][col] = cell
                
            end
        end
    end
    local roleInfo = GameDatas.RoleInfo[self.curLevel]
    self:createRole(roleInfo)
    
end

-- 设置当前关卡数文本
function MainView:createRole(roleInfo)
    self.roleTable = {}
    for i,info in ipairs(roleInfo) do
        local cellType = info.cellType
        local step = info.step
        local pos = self.cellPosTable[step.row][step.col]
        local cell = Cell:create(cellType, self)
        cell:setCurPos(pos)
        cell:setRowAndCol(step.row, step.col)
        cell.tag = i
        self.panel_main:addChild(cell)
        table.insert(self.roleTable, i, cell)
        if cellType == 2 then
            cell:setLocalZOrder(10)
            self.birdNum = self.birdNum + 1
        end
    end

    self:setTopImg()
    self:setCurLevelNum()
end
-- 设置当前关卡数文本
function MainView:moveCell(dir)
    local function callback(role, nextRole, toStep, flag)
      
        role:moveToRowAndCol(toStep)
        role:setRowAndCol(toStep.row, toStep.col)
        self.roleTable[role.tag] = role

        if flag == 1 then
            AudioTool:addEffect(GameDatas.Music_Goal)
            performWithDelay(self, function ()
                self.roleTable[role.tag] = nil
                role:removeFromParent()
                role = nil
            end, 0.1)
            self.catchNum = self.catchNum + 1
            self:setTopImg()
            if self.catchNum == self.birdNum then
                self.isGameOver = true
                performWithDelay(self, function ()
                    self:gameOver()
                end, 1)
            end
        elseif flag == 2 then
            AudioTool:addEffect(GameDatas.Music_Goal)
            performWithDelay(self, function ()
                self.roleTable[nextRole.tag] = nil
                nextRole:removeFromParent()
                nextRole = nil
            end, 0.1)
            self.catchNum = self.catchNum + 1
            self:setTopImg()
            if self.catchNum == self.birdNum then
                self.isGameOver = true
                performWithDelay(self, function ()
                    self:gameOver()
                end, 1)
            end  
        end
    end

    local sIdx, eIdx, flag
    local rowIdx = 1
    local colIdx = 1
    if dir == GameDatas.Direction.up then
        sIdx = 1
        eIdx = GameDatas.allRow
        flag = 1
    elseif dir == GameDatas.Direction.down then
        sIdx = GameDatas.allRow
        eIdx = 1
        flag = -1
    elseif dir == GameDatas.Direction.left then
        sIdx = 1
        eIdx = GameDatas.allCol
        flag = 1
    elseif dir == GameDatas.Direction.right then
        sIdx = GameDatas.allCol
        eIdx = 1
        flag = -1
    end

    local isRowDir = (dir == GameDatas.Direction.up or dir == GameDatas.Direction.down)
    if isRowDir then
        for col = 1, GameDatas.allCol do
            for i = sIdx, eIdx, flag do
                rowIdx = i
                colIdx = col 
                for _, role in pairs(self.roleTable) do
                    if not self.isGameOver and role and role.cellType <= 4 and role.row == rowIdx and role.col == colIdx then
                        self:lineCheck(role, dir, callback)
                    end
                end
            end
        end
    else
        for row = 1, GameDatas.allRow do
            for i = sIdx, eIdx, flag do
                rowIdx = row
                colIdx = i
                for _, role in pairs(self.roleTable) do
                    if not self.isGameOver and role and role.cellType <= 4 and role.row == rowIdx and role.col == colIdx then
                        self:lineCheck(role, dir, callback)
                    end
                end
            end
        end
    end

end

-- 以row, col 为检测点，向dir方向检测，返回碰到障碍前的那个Cell的row，col坐标
function MainView:lineCheck(role, dir, callback)
    self.lastRole = role
    local curRow = role.row
    local curCol = role.col
    local sIdx, eIdx, flag
    if dir == GameDatas.Direction.up then
        sIdx = curRow - 1
        eIdx = 1
        flag = -1
    elseif dir == GameDatas.Direction.down then
        sIdx = curRow + 1
        eIdx = GameDatas.allRow
        flag = 1
    elseif dir == GameDatas.Direction.left then
        sIdx = curCol - 1
        eIdx = 1
        flag = -1
    elseif dir == GameDatas.Direction.right then
        sIdx = curCol + 1
        eIdx = GameDatas.allCol
        flag = 1
    end
    local isRowDir = (dir == GameDatas.Direction.up or dir == GameDatas.Direction.down)
    for i = sIdx, eIdx, flag do
        local rowIdx = isRowDir and i or curRow
        local colIdx = isRowDir and curCol or i
        local cell = self.cellTable[rowIdx][colIdx]
        if cell then
            local nextRole = nil
            for _, item in pairs(self.roleTable) do
                if item.row == rowIdx and item.col == colIdx then
                    nextRole = item
                end
            end
            if nextRole then
               if dir == GameDatas.Direction.down and role.cellType == 2 then
                    if nextRole.cellType == 3 then
                        local toStep = {row = rowIdx, col = colIdx}
                        callback(role, nextRole, toStep, 1)
        
                        return
                    else
                        if isRowDir then
                            rowIdx = rowIdx - flag
                        else
                            colIdx = colIdx - flag
                        end
                        if callback then
                            local toStep = {row = rowIdx, col = colIdx}
                            callback(role, nextRole, toStep, 0)
                        end 
                        return

                    end
                elseif dir == GameDatas.Direction.up and role.cellType == 3 then
                    if nextRole.cellType == 2 then
                        local toStep = {row = rowIdx, col = colIdx}
                        callback(role, nextRole, toStep, 2)
                        return
                    else
                        if isRowDir then
                            rowIdx = rowIdx - flag
                        else
                            colIdx = colIdx - flag
                        end
                        if callback then
                            local toStep = {row = rowIdx, col = colIdx}
                            callback(role, nextRole, toStep, 0)
                        end 
                        return
                    end
                elseif nextRole.cellType >= 2 and nextRole.cellType <= 4 then
                    
                    if isRowDir then
                        rowIdx = rowIdx - flag
                    else
                        colIdx = colIdx - flag
                    end
                    if callback then
                        local toStep = {row = rowIdx, col = colIdx}
                        callback(role, nextRole, toStep, 0)
                    end 
                    return
                end
            else
                if cell.cellType == 5 then
                    if isRowDir then
                        rowIdx = rowIdx - flag
                    else
                        colIdx = colIdx - flag
                    end
                    if callback then
                        local toStep = {row = rowIdx, col = colIdx}
                        callback(role, nil, toStep, 0)
                    end 
                    return
                elseif (isRowDir and rowIdx == eIdx) or (not isRowDir and colIdx == eIdx) then
                    local toStep = {row = rowIdx, col = colIdx}
                    callback(role, nil, toStep, 0)
                    return
                end
            end
        elseif cell == nil then
           
            if isRowDir then
                rowIdx = rowIdx - flag
            else
                colIdx = colIdx - flag
            end
            
            if callback then
                local toStep = {row = rowIdx, col = colIdx}
                callback(role, nil, toStep, 0)
            end
            return
        end
    end
end


-- 设置当前关卡数文本
function MainView:setCurLevelNum()
    self.text_level:setString("LEVEL:" .. self.curLevel)
    
    UserDefaulTool:setLatestLevel(self.curLevel)
end

-- 设置图片
function MainView:setTopImg()
    
    self.img_top:loadTexture("top_img_" .. self.birdNum .. "_" .. self.catchNum .. ".png", 1)
    
    self.img_top:ignoreContentAdaptWithSize(true) 
end


-- 过关，进入下一关
function MainView:nextLevel()
    local function returnCall(name)
        if "btn_close" == name then
            UserDefaulTool:clearPassCacheData()
            SceneTool:toLevelView()
        end
    end
    
    self.curLevel = self.curLevel + 1
    if self.curLevel > GameDatas.NUM_OPEN_LEVEL then
        --提示恭喜完成所有过关
        local dataInfo = { title = "TIPS", tips = "Congratulations on passing all levels! Please return to the selection page and start over. Thank you!", callback = returnCall }
        SceneTool:toHelpView(dataInfo)
    else
        self:initLevel()
    end
end


-- 显示GameOver页面
function MainView:gameOver()
    UserDefaulTool:setPassCacheData(self.curLevel)
    AudioTool:addEffect(GameDatas.Music_Win)
 
    local function returnCall(name)
        if "btn_level" == name then
            SceneTool:toLevelView()
        elseif "btn_replay" == name then
            self:initLevel()
        elseif "btn_next" == name then
            self:nextLevel()
        end
    end

    local dataInfo = {curLevel = self.curLevel, callback = returnCall}
    SceneTool:toEndView(dataInfo)
end

-- 生成游戏背景框和坐标
function MainView:addCellBg()
    for row = 1, GameDatas.allRow do
        self.cellPosTable[row] = {}
        self.cellBgTable[row] = {}
        for col = 1, GameDatas.allCol do
            local index = (row-1)*GameDatas.allCol + col
            local panel = self.panel_main:getChildByName("Panel_" .. index)
            local pos = cc.p(panel:getPositionX(), panel:getPositionY())
            panel.row = row
            panel.col = col
            self.cellPosTable[row][col] = pos
            panel:hide()
            panel.rect = panel:getBoundingBox()
            self.cellBgTable[row][col] = panel
        end
    end
end


return MainView
