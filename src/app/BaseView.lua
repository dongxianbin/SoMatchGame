
BaseView = class("BaseView", function()
    local ui = ccui.Layout:create()
    ui:setContentSize(display.size)
    ui:setTouchEnabled(true)
    return ui
end)


function BaseView:createCSB(para)
    para = para or {}
    local ui = cc.CSLoader:createNode(para.csb)
    if para.setSize then
        ui:setContentSize(para.size or display.size)
        ccui.Helper:doLayout(ui)
    end
    ui:setAnchorPoint(para.anchorPoint or cc.p(0.5, 0.5))
    ui:setPosition(para.pos or display.center)
    return ui
end

function BaseView:btnTouchAni(sender, eventType)
    local btn = (sender:getChildByName("btn") or sender:getChildByName("img") or sender:getChildByName("text")) or sender
    local scale = btn:getScale()
    if eventType == ccui.TouchEventType.began then
        btn:setScale(scale * 1.1)
    elseif eventType == ccui.TouchEventType.ended or eventType == ccui.TouchEventType.canceled then
        btn:setScale(scale / 1.1)
    end
end

function BaseView:IsInTable(value, tab)
    for k,v in ipairs(tab) do
      if v == value then
        return true;
      end
    end
    return false;
end

function BaseView:getNodeChildrensName(node)
    for i = 1, node:getChildrenCount(), 1 do
        print(node:getChildren()[i]:getName())
    end
end


-- 更新背景音乐按钮显示
function BaseView:updateMusicBtn(btn, isEnabled)
    local music_on = "btn_music_on.png"
    local music_off = "btn_music_off.png"
    if isEnabled then
        btn:loadTextures(music_on, music_on, music_on, ccui.TextureResType.plistType)
    else
        btn:loadTextures(music_off, music_off, music_off, ccui.TextureResType.plistType)
    end
end

-- 播放背景音乐
function BaseView:playMusic(isEnabled, music_name)
    if isEnabled then
        AudioTool:addMusic(music_name)
    else
        AudioTool:stopMusic()
    end
end

-- 适配文字
function BaseView:txtAutoWidth(txt, max)
    local width = txt:getContentSize().width
    if width > max then
        local scale = max / width
        txt:setScale(scale)
    end
end

-- time为秒，转化为需要显示的时间字符串
function BaseView:timeStr(time,isShowMin)
    local t1,t2,t3 = 86400, 3600, 60

    if isShowMin then
        if time >= t2 then -- 时
            local hour =  math.floor(time / t2)
            local min = math.floor((time % t2) / t3)
            local sin =  (time % t2) % t3
            return string.format("%02d:%02d",min,sin)
        elseif time >= t3 then -- 分
            local min = math.floor(time / t3)
            local sin =  time % t3
            return string.format("%02d:%02d",min,sin)
        else -- 秒
            return string.format("00:%02d",time)
        end
    end
    
    if time >= t2 then -- 时
        local hour =  math.floor(time / t2)
        local min = math.floor((time % t2) / t3)
        local sin =  (time % t2) % t3
        return string.format("%02d:%02d:%02d",hour,min,sin)
    elseif time >= t3 then -- 分
        local min = math.floor(time / t3)
        local sin =  time  % t3
        return string.format("00:%02d:%02d",min,sin)
    else -- 秒
        return string.format("00:00:%02d",time)
    end
   
end

-- 查找多重table，所有不为nil的元素位置是否连在一起的
function BaseView:getIsLian(mytable, row, col)

    local rows = row
    local cols = col
    local visited = {}

    -- 初始化visited数组
    for i = 1, rows do
        visited[i] = {}
        for j = 1, cols do
            visited[i][j] = false
        end
    end

    local function bfs(startRow, startCol)
        local queue = {} -- 使用队列来进行广度优先搜索
        table.insert(queue, {row = startRow, col = startCol})
        visited[startRow][startCol] = true
        
        local directions = {
            { -1, 0 }, -- 上
            { 1, 0 }, -- 下
            { 0, -1 }, -- 左
            { 0, 1 } -- 右
        }
        
        while #queue > 0 do
            local current = table.remove(queue, 1)
            local currentRow = current.row
            local currentCol = current.col
            
            for _, direction in ipairs(directions) do
                local newRow = currentRow + direction[1]
                local newCol = currentCol + direction[2]
                
                if newRow >= 1 and newRow <= rows and newCol >= 1 and newCol <= cols and not visited[newRow][newCol] then
                    if mytable[newRow][newCol] ~= nil then
                        visited[newRow][newCol] = true
                        table.insert(queue, {row = newRow, col = newCol})
                    end
                end
            end
        end
    end

    local found = false
    for i = 1, rows do
        for j = 1, cols do
            if mytable[i][j] ~= nil and not visited[i][j] then
                bfs(i, j)
                found = true
                break
            end
        end
        if found then
            break
        end
    end

    local allVisited = true
    for i = 1, rows do
        for j = 1, cols do
            if mytable[i][j] ~= nil and not visited[i][j] then
                allVisited = false
                break
            end
        end
        
        if not allVisited then
            break
        end
    end

    return allVisited
end

-- 将数字三位三位分开，如1000->1,000;1000000->1,000,000
function BaseView:toString_thousand(num, sign)
    local str = tostring(num)
    local strLen = string.len(str)

    if strLen <= 3 then
        return str
    end

    local len = strLen % 3 == 0 and strLen / 3 - 1 or math.floor(strLen / 3)
    local arr = {}
    for i = 1, len do
        local start = strLen - (i * 3) + 1
        local newStr = string.sub(str, start, start + 3)
        table.insert(arr, newStr)

        str = string.gsub(str, newStr, "", 1)
    end

    local sign = sign or ","
    local newStr = ""
    for i = #arr, 1, -1 do
        newStr = newStr .. sign .. arr[i]
    end

    return str .. newStr
end

-- 显示弹窗文字
function BaseView:showTipText(parent, str, pos, color, isMove)
    local pos = pos or cc.p(display.width / 2, display.height / 2 + 50)
    local color = color or cc.c3b(255, 216, 33)
    local text = ccui.Text:create(str, GameDatas.TTF_Files, 36)
    text:setTextColor(color)
    text:setPosition(pos)
    parent:addChild(text)

    local fadeOut = cc.FadeOut:create(1)
    local spawn = cc.Sequence:create(fadeOut)
    if isMove then
        local moveUp = cc.MoveBy:create(1, cc.p(0, 150))
        spawn = cc.Sequence:create(moveUp, fadeOut)
    end
    local seq = cc.Sequence:create(spawn, cc.RemoveSelf:create())
    text:runAction(seq)
    
    return text
end

-- 数字滚动动画
function BaseView:numScrollAni(txt_num, curNum, addNum, endCall)
    local curNum = curNum
    local unit = math.ceil(addNum / 60)
    local total = curNum + addNum

    local function update()
        curNum = curNum + unit
        if curNum > total then
            curNum = total
            if self.updateNumScheduler ~= nil then
                local scheduler = cc.Director:getInstance():getScheduler()
                scheduler:unscheduleScriptEntry(self.updateNumScheduler)
                self.updateNumScheduler = nil
                if endCall then
                    endCall()
                end
            end
        end
        local num = self:toString_thousand(curNum)
        txt_num:setString(num)
    end

    if self.updateNumScheduler == nil then
        local scheduler = cc.Director:getInstance():getScheduler()
        self.updateNumScheduler = scheduler:scheduleScriptFunc(update, unit / addNum, false)
    end
end

-- 变大变小动画
function BaseView:nodeScaleAni(node)
    local delay = cc.DelayTime:create(0.1)
    node:runAction(cc.RepeatForever:create(
        cc.Sequence:create(
            cc.ScaleTo:create(1, 1),
            -- delay,
            cc.ScaleTo:create(1, 0.5)
        )
    ))
end

return BaseView