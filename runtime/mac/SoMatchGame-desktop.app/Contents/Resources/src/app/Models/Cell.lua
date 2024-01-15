
local Cell = class("Cell", cc.Sprite)

function Cell:ctor(cellType, _parent)
    self.cellType = cellType   -- cell类型
    self.parent = _parent
    self.tag = 0
    self:initCell()
    
end

function Cell:initCell()
    local name = GameDatas.cell_Image[self.cellType]
    -- if self.cellType ~= 1 then
    --     local sprite = cc.Sprite:create()
    --     sprite:initWithSpriteFrameName("cell.png")
    --     -- sprite:hide()
    --     self:addChild(sprite)
    -- end
    self:initWithSpriteFrameName(name)
end

-- 设置当前行列坐标
function Cell:setCurPos(pos)
    self.pos = pos
    self:setPosition(pos.x, pos.y)
    -- if self.cellType == 1 then
    --     self:setPosition(pos.x, pos.y-20)
    -- end
    
end

-- 设置当前行列坐标
function Cell:setRowAndCol(row, col)
    self.row = row
    self.col = col
end

function Cell:getPosByRowAndCol(row, col)
    return self.parent.cellPosTable[row][col]
end

function Cell:moveToRowAndCol(step)
    AudioTool:addEffect(GameDatas.Music_Move)
    local toPos = self:getPosByRowAndCol(step.row, step.col)
    local delay = 0.1
    local moveTo = cc.MoveTo:create(delay, toPos)
    self:runAction(moveTo)
end



return Cell