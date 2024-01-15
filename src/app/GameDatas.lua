
local GameDatas = {}

--音效
GameDatas.Music_Game = "res/audio/bgm.mp3"
GameDatas.Music_Move = "res/audio/move.mp3"
GameDatas.Music_Touch = "res/audio/click.mp3"
GameDatas.Music_Goal = "res/audio/goal.mp3"
GameDatas.Music_Win = "res/audio/win.mp3"

-- 字体
GameDatas.TTF_Files = "res/MarkerFelt.ttc"

GameDatas.UserDef_Date = "UserDef_Date" -- 用户数据
GameDatas.UserDef_Is_Using_Music = "UserDef_Is_Using_Music" -- 音效
GameDatas.UserDef_Latest_Pass_Level = "UserDef_Latest_Pass_Level"
GameDatas.UserDef_Pass_Data = "UserDef_Pass_Data"

GameDatas.NUM_OPEN_LEVEL = 40         -- 开放的关卡数

-- 总行列
GameDatas.allRow = 6
GameDatas.allCol = 5

-- 方向
GameDatas.Direction = {
    up = 1,
    down = 2,
    left = 3,
    right = 4,
}


GameDatas.cell_Image = { "cell_bg.png", "bird.png", "bird_nest.png", "box.png", "stone.png" }
GameDatas.cellType = {
    cell_bg = 1,            -- 背景
    cell_bird = 2,          -- 鸟
    cell_bire_nest = 3,     -- 鸟巢
    cell_box = 4,           -- 木箱
    cell_stone = 5,         -- 石块
   
}

GameDatas.RoleInfo = {
    -- 1
    {
        { cellType = 2, step = { row = 2, col = 3 } },
        { cellType = 3, step = { row = 4, col = 3 } },
    },
    -- 2
    {
        { cellType = 2, step = { row = 3, col = 2 } },
        { cellType = 3, step = { row = 3, col = 4 } },
    },
    -- 3
    {
        { cellType = 2, step = { row = 4, col = 3 } },
        { cellType = 3, step = { row = 2, col = 3 } },
    },
    -- 4
    {
        { cellType = 2, step = { row = 4, col = 2 } },
        { cellType = 3, step = { row = 4, col = 4 } },
    },
    -- 5
    {
        { cellType = 2, step = { row = 5, col = 4 } },
        { cellType = 3, step = { row = 3, col = 4 } },
    },
    -- 6
    {
        { cellType = 2, step = { row = 4, col = 3 } },
        { cellType = 3, step = { row = 3, col = 2 } },
    },
    -- 7
    {
        { cellType = 2, step = { row = 5, col = 3 } },
        { cellType = 3, step = { row = 4, col = 4 } },
    },
    -- 8
    {
        { cellType = 2, step = { row = 3, col = 3 } },
        { cellType = 2, step = { row = 5, col = 3 } },
        { cellType = 3, step = { row = 2, col = 4 } },
    },
    -- 9
    {
        { cellType = 2, step = { row = 3, col = 2 } },
        { cellType = 2, step = { row = 3, col = 3 } },
        { cellType = 2, step = { row = 3, col = 4 } },
        { cellType = 3, step = { row = 2, col = 2 } },
    },
    -- 10
    {
        { cellType = 2, step = { row = 4, col = 2 } },
        { cellType = 3, step = { row = 3, col = 4 } },
    },
    -- 11
    {
        { cellType = 2, step = { row = 4, col = 3 } },
        { cellType = 3, step = { row = 4, col = 2 } },
    },
    -- 12
    {
        { cellType = 2, step = { row = 2, col = 4 } },
        { cellType = 3, step = { row = 2, col = 1 } },
    },
    -- 13
    {
        { cellType = 2, step = { row = 3, col = 1 } },
        { cellType = 2, step = { row = 5, col = 4 } },
        { cellType = 3, step = { row = 2, col = 2 } },
    },
    -- 14
    {
        { cellType = 2, step = { row = 3, col = 4 } },
        { cellType = 3, step = { row = 3, col = 1 } },
    },
    -- 15
    {
        { cellType = 2, step = { row = 2, col = 1 } },
        { cellType = 3, step = { row = 5, col = 4 } },
    },
    -- 16
    {
        { cellType = 2, step = { row = 4, col = 1 } },
        { cellType = 2, step = { row = 4, col = 2 } },
        { cellType = 2, step = { row = 4, col = 4 } },
        { cellType = 3, step = { row = 4, col = 3 } },
    },
    -- 17
    {
        { cellType = 2, step = { row = 3, col = 1 } },
        { cellType = 2, step = { row = 6, col = 1 } },
        { cellType = 3, step = { row = 4, col = 3 } },
    },
    -- 18
    {
        { cellType = 2, step = { row = 6, col = 1 } },
        { cellType = 2, step = { row = 6, col = 2 } },
        { cellType = 3, step = { row = 3, col = 4 } },
    },
    -- 19
    {
        { cellType = 2, step = { row = 2, col = 3 } },
        { cellType = 2, step = { row = 4, col = 3 } },
        { cellType = 2, step = { row = 6, col = 3 } },
        { cellType = 3, step = { row = 3, col = 1 } },
    },
    -- 20
    {
        { cellType = 2, step = { row = 4, col = 1 } },
        { cellType = 2, step = { row = 4, col = 3 } },
        { cellType = 3, step = { row = 4, col = 2 } },
    },
    -- 21
    {
        { cellType = 2, step = { row = 3, col = 2 } },
        { cellType = 2, step = { row = 4, col = 2 } },
        { cellType = 3, step = { row = 3, col = 1 } },
    },
    -- 22
    {
        { cellType = 2, step = { row = 2, col = 2 } },
        { cellType = 2, step = { row = 3, col = 2 } },
        { cellType = 2, step = { row = 3, col = 4 } },
        { cellType = 3, step = { row = 2, col = 1 } },
    },
    -- 23
    {
        { cellType = 2, step = { row = 3, col = 1 } },
        { cellType = 2, step = { row = 5, col = 1 } },
        { cellType = 2, step = { row = 6, col = 1 } },
        { cellType = 3, step = { row = 6, col = 2 } },
    },
    -- 24
    {
        { cellType = 2, step = { row = 3, col = 1 } },
        { cellType = 2, step = { row = 5, col = 4 } },
        { cellType = 3, step = { row = 3, col = 3 } },
    },
    -- 25
    {
        { cellType = 2, step = { row = 6, col = 1 } },
        { cellType = 3, step = { row = 6, col = 4 } },
        { cellType = 4, step = { row = 5, col = 1 } },
    },
    -- 26
    {
        { cellType = 2, step = { row = 3, col = 2 } },
        { cellType = 2, step = { row = 3, col = 4 } },
        { cellType = 3, step = { row = 3, col = 3 } },
        { cellType = 4, step = { row = 5, col = 3 } },
    },
    -- 27
    {
        { cellType = 2, step = { row = 4, col = 2 } },
        { cellType = 2, step = { row = 4, col = 4 } },
        { cellType = 3, step = { row = 5, col = 3 } },
    },
    -- 28
    {
        { cellType = 2, step = { row = 3, col = 1 } },
        { cellType = 2, step = { row = 3, col = 5 } },
        { cellType = 2, step = { row = 5, col = 1 } },
        { cellType = 3, step = { row = 5, col = 5 } },
    },
    -- 29
    {
        { cellType = 2, step = { row = 4, col = 3 } },
        { cellType = 2, step = { row = 6, col = 2 } },
        { cellType = 2, step = { row = 6, col = 4 } },
        { cellType = 3, step = { row = 2, col = 3 } },
        { cellType = 4, step = { row = 6, col = 5 } },
    },
    -- 30
    {
        { cellType = 2, step = { row = 6, col = 3 } },
        { cellType = 2, step = { row = 6, col = 4 } },
        { cellType = 2, step = { row = 6, col = 5 } },
        { cellType = 3, step = { row = 5, col = 2 } },
    },
    -- 31
    {
        { cellType = 2, step = { row = 2, col = 4 } },
        { cellType = 2, step = { row = 3, col = 5 } },
        { cellType = 3, step = { row = 2, col = 5 } },
    },
    -- 32
    {
        { cellType = 2, step = { row = 1, col = 3 } },
        { cellType = 2, step = { row = 4, col = 3 } },
        { cellType = 2, step = { row = 6, col = 3 } },
        { cellType = 3, step = { row = 3, col = 3 } },
    },
    -- 33
    {
        { cellType = 2, step = { row = 1, col = 5 } },
        { cellType = 2, step = { row = 6, col = 2 } },
        { cellType = 2, step = { row = 6, col = 4 } },
        { cellType = 3, step = { row = 6, col = 1 } },
    },
    -- 34
    {
        { cellType = 2, step = { row = 5, col = 4 } },
        { cellType = 2, step = { row = 6, col = 2 } },
        { cellType = 3, step = { row = 3, col = 4 } },
    },
    -- 35
    {
        { cellType = 2, step = { row = 3, col = 5 } },
        { cellType = 2, step = { row = 6, col = 4 } },
        { cellType = 3, step = { row = 1, col = 1 } },
        { cellType = 4, step = { row = 1, col = 4 } },
    },
    -- 36
    {
        { cellType = 2, step = { row = 2, col = 2 } },
        { cellType = 2, step = { row = 4, col = 5 } },
        { cellType = 2, step = { row = 6, col = 2 } },
        { cellType = 3, step = { row = 5, col = 1 } },
    },
    -- 37
    {
        { cellType = 2, step = { row = 6, col = 2 } },
        { cellType = 3, step = { row = 3, col = 2 } },
        { cellType = 4, step = { row = 4, col = 2 } },
    },
    -- 38
    {
        { cellType = 2, step = { row = 5, col = 4 } },
        { cellType = 2, step = { row = 6, col = 3 } },
        { cellType = 2, step = { row = 6, col = 5 } },
        { cellType = 3, step = { row = 4, col = 3 } },
    },
    -- 39
    {
        { cellType = 2, step = { row = 4, col = 5 } },
        { cellType = 2, step = { row = 6, col = 4 } },
        { cellType = 2, step = { row = 6, col = 5 } },
        { cellType = 3, step = { row = 3, col = 5 } },
    },
    -- 40
    {
        { cellType = 2, step = { row = 3, col = 5 } },
        { cellType = 2, step = { row = 6, col = 3 } },
        { cellType = 3, step = { row = 3, col = 3 } },
        { cellType = 4, step = { row = 5, col = 3 } },
    },

}

GameDatas.LevelLayout = {
    -- 1
    {
        { 0, 0, 0, 0, 0 },
        { 0, 1, 1, 1, 0 },
        { 0, 1, 1, 1, 0 },
        { 0, 1, 1, 1, 0 },
        { 0, 0, 0, 0, 0 },
        { 0, 0, 0, 0, 0 },
    },
    -- 2
    {
        { 0, 0, 0, 0, 0 },
        { 0, 1, 1, 5, 0 },
        { 0, 1, 1, 1, 0 },
        { 0, 5, 1, 1, 0 },
        { 0, 0, 0, 0, 0 },
        { 0, 0, 0, 0, 0 },
    },
    -- 3
    {
        { 0, 0, 0, 0, 0 },
        { 0, 5, 1, 1, 0 },
        { 0, 1, 1, 5, 0 },
        { 0, 5, 1, 1, 0 },
        { 0, 0, 0, 0, 0 },
        { 0, 0, 0, 0, 0 },
    },
    -- 4
    {
        { 0, 0, 0, 0, 0 },
        { 0, 5, 1, 1, 0 },
        { 0, 1, 1, 1, 0 },
        { 0, 1, 5, 1, 0 },
        { 0, 1, 1, 1, 0 },
        { 0, 0, 0, 0, 0 },
    },
    -- 5
    {
        { 0, 0, 0, 0, 0 },
        { 0, 1, 1, 1, 0 },
        { 0, 1, 5, 1, 0 },
        { 0, 1, 1, 5, 0 },
        { 0, 5, 1, 1, 0 },
        { 0, 0, 0, 0, 0 },
    },
    -- 6
    {
        { 0, 0, 0, 0, 0 },
        { 0, 1, 5, 1, 0 },
        { 0, 1, 1, 1, 0 },
        { 0, 5, 1, 5, 0 },
        { 0, 1, 1, 1, 0 },
        { 0, 0, 0, 0, 0 },
    },
    -- 7
    {
        { 0, 0, 0, 0, 0 },
        { 0, 5, 1, 1, 0 },
        { 0, 1, 1, 5, 0 },
        { 0, 1, 1, 1, 0 },
        { 0, 1, 1, 5, 0 },
        { 0, 0, 0, 0, 0 },
    },
    -- 8
    {
        { 0, 0, 0, 0, 0 },
        { 0, 1, 5, 1, 0 },
        { 0, 1, 1, 1, 0 },
        { 0, 1, 5, 1, 0 },
        { 0, 1, 1, 1, 0 },
        { 0, 0, 0, 0, 0 },
    },
    -- 9
    {
        { 0, 0, 0, 0, 0 },
        { 0, 1, 5, 1, 0 },
        { 0, 1, 1, 1, 0 },
        { 0, 5, 1, 1, 0 },
        { 0, 5, 1, 5, 0 },
        { 0, 0, 0, 0, 0 },
    },
    -- 10
    {
        { 0, 0, 0, 0, 0 },
        { 0, 1, 1, 5, 0 },
        { 0, 5, 1, 1, 0 },
        { 0, 1, 1, 5, 0 },
        { 0, 5, 1, 1, 0 },
        { 0, 0, 0, 0, 0 },
    },
    -- 11
    {
        { 0, 0, 0, 0, 0 },
        { 1, 1, 1, 1, 0 },
        { 1, 5, 1, 1, 0 },
        { 5, 1, 1, 5, 0 },
        { 1, 1, 5, 1, 0 },
        { 0, 0, 0, 0, 0 },
    },
    -- 12
    {
        { 0, 0, 0, 0, 0 },
        { 1, 5, 5, 1, 0 },
        { 1, 5, 5, 1, 0 },
        { 1, 1, 1, 1, 0 },
        { 5, 1, 1, 5, 0 },
        { 0, 0, 0, 0, 0 },
    },
    -- 13
    {
        { 0, 0, 0, 0, 0 },
        { 5, 1, 1, 5, 0 },
        { 1, 5, 1, 1, 0 },
        { 1, 1, 1, 5, 0 },
        { 5, 1, 1, 1, 0 },
        { 0, 0, 0, 0, 0 },
    },
    -- 14
    {
        { 0, 0, 0, 0, 0 },
        { 1, 1, 1, 5, 0 },
        { 1, 5, 1, 1, 0 },
        { 1, 5, 1, 1, 0 },
        { 1, 1, 1, 5, 0 },
        { 0, 0, 0, 0, 0 },
    },
    -- 15
    {
        { 0, 0, 0, 0, 0 },
        { 1, 1, 5, 5, 0 },
        { 5, 1, 1, 1, 0 },
        { 5, 1, 1, 5, 0 },
        { 5, 1, 1, 1, 0 },
        { 0, 0, 0, 0, 0 },
    },
    -- 16
    {
        { 0, 0, 0, 0, 0 },
        { 1, 1, 1, 5, 0 },
        { 1, 5, 1, 5, 0 },
        { 1, 1, 1, 1, 0 },
        { 1, 5, 1, 5, 0 },
        { 1, 1, 1, 5, 0 },
    },
    -- 17
    {
        { 0, 0, 0, 0, 0 },
        { 5, 1, 1, 1, 0 },
        { 1, 1, 5, 1, 0 },
        { 5, 1, 1, 1, 0 },
        { 5, 1, 1, 5, 0 },
        { 1, 1, 5, 5, 0 },
    },
    -- 18
    {
        { 0, 0, 0, 0, 0 },
        { 1, 1, 1, 1, 0 },
        { 1, 5, 5, 1, 0 },
        { 1, 1, 1, 5, 0 },
        { 5, 1, 1, 5, 0 },
        { 1, 1, 5, 1, 0 },
    },
    -- 19
    {
        { 0, 0, 0, 0, 0 },
        { 1, 5, 1, 1, 0 },
        { 1, 1, 1, 5, 0 },
        { 5, 1, 1, 1, 0 },
        { 1, 1, 1, 5, 0 },
        { 1, 5, 1, 1, 0 },
    },
    -- 20
    {
        { 0, 0, 0, 0, 0 },
        { 5, 5, 1, 5, 0 },
        { 1, 1, 1, 1, 0 },
        { 1, 1, 1, 5, 0 },
        { 5, 1, 5, 5, 0 },
        { 0, 0, 0, 0, 0 },
    },
    -- 21
    {
        { 0, 0, 0, 0, 0 },
        { 5, 1, 1, 1, 0 },
        { 1, 1, 5, 1, 0 },
        { 1, 1, 1, 1, 0 },
        { 5, 1, 1, 5, 0 },
        { 0, 0, 0, 0, 0 },
    },
    -- 22
    {
        { 0, 0, 0, 0, 0 },
        { 1, 1, 5, 5, 0 },
        { 5, 1, 1, 1, 0 },
        { 1, 1, 1, 1, 0 },
        { 5, 1, 5, 1, 0 },
        { 0, 0, 0, 0, 0 },
    },
    -- 23
    {
        { 0, 0, 0, 0, 0 },
        { 1, 1, 1, 5, 0 },
        { 1, 5, 1, 1, 0 },
        { 5, 1, 1, 5, 0 },
        { 1, 5, 1, 1, 0 },
        { 1, 1, 1, 5, 0 },
    },
    -- 24
    {
        { 0, 0, 0, 0, 0 },
        { 1, 5, 1, 5, 0 },
        { 1, 5, 1, 5, 0 },
        { 1, 1, 1, 1, 0 },
        { 5, 1, 5, 1, 0 },
        { 1, 1, 1, 5, 0 },
    },
    -- 25
    {
        { 0, 0, 0, 0, 0 },
        { 1, 5, 1, 1, 0 },
        { 1, 1, 1, 1, 0 },
        { 1, 5, 5, 1, 0 },
        { 1, 1, 1, 1, 0 },
        { 1, 1, 5, 1, 0 },
    },
    -- 26
    {
        { 0, 0, 0, 0, 0 },
        { 5, 5, 1, 5, 5 },
        { 5, 1, 1, 1, 5 },
        { 1, 1, 5, 1, 1 },
        { 5, 1, 1, 1, 5 },
        { 5, 5, 1, 5, 5 },
    },
    -- 27
    {
        { 0, 0, 0, 0, 0 },
        { 1, 1, 5, 1, 5 },
        { 5, 1, 1, 1, 1 },
        { 1, 1, 1, 1, 1 },
        { 5, 5, 1, 1, 5 },
        { 5, 1, 1, 5, 5 },
    },
    -- 28
    {
        { 0, 0, 0, 0, 0 },
        { 5, 1, 1, 1, 5 },
        { 1, 1, 5, 1, 1 },
        { 5, 1, 1, 1, 5 },
        { 1, 1, 5, 1, 1 },
        { 5, 1, 1, 1, 5 },
    },
    -- 29
    {
        { 0, 0, 0, 0, 0 },
        { 5, 1, 1, 1, 5 },
        { 5, 1, 5, 1, 1 },
        { 1, 1, 1, 1, 5 },
        { 5, 1, 5, 1, 5 },
        { 5, 1, 5, 1, 1 },
    },
    -- 30
    {
        { 0, 0, 0, 0, 0 },
        { 5, 1, 1, 1, 1 },
        { 1, 1, 5, 1, 1 },
        { 1, 1, 5, 1, 5 },
        { 5, 1, 1, 1, 5 },
        { 5, 5, 1, 1, 1 },
    },
    -- 31
    {
        { 0, 0, 0, 0, 0 },
        { 1, 1, 1, 1, 1 },
        { 1, 5, 1, 5, 1 },
        { 1, 1, 1, 1, 5 },
        { 1, 1, 5, 1, 1 },
        { 5, 1, 1, 1, 5 },
    },
    -- 32
    {
        { 1, 1, 1, 1, 1 },
        { 1, 5, 5, 1, 5 },
        { 1, 1, 1, 1, 1 },
        { 1, 1, 1, 1, 5 },
        { 1, 5, 1, 5, 1 },
        { 5, 5, 1, 1, 1 },
    },
    -- 33
    {
        { 1, 1, 5, 1, 1 },
        { 1, 1, 1, 1, 5 },
        { 1, 5, 5, 1, 1 },
        { 1, 1, 1, 1, 1 },
        { 1, 5, 1, 5, 1 },
        { 1, 1, 1, 1, 5 },
    },
    -- 34
    {
        { 1, 1, 5, 1, 1 },
        { 5, 1, 1, 1, 1 },
        { 1, 1, 5, 1, 5 },
        { 1, 1, 5, 1, 1 },
        { 5, 1, 1, 1, 1 },
        { 5, 1, 5, 5, 1 },
    },
    -- 35
    {
        { 1, 1, 1, 1, 5 },
        { 1, 1, 5, 1, 5 },
        { 5, 1, 1, 5, 1 },
        { 1, 1, 1, 1, 1 },
        { 1, 5, 1, 5, 5 },
        { 1, 1, 1, 1, 5 },
    },
    -- 36
    {
        { 1, 1, 1, 1, 1 },
        { 1, 1, 5, 1, 5 },
        { 5, 1, 1, 1, 5 },
        { 5, 5, 1, 1, 1 },
        { 1, 1, 1, 1, 5 },
        { 5, 1, 1, 1, 5 },
    },
    -- 37
    {
        { 5, 1, 1, 5, 5 },
        { 1, 1, 1, 1, 1 },
        { 1, 1, 5, 1, 5 },
        { 5, 1, 1, 1, 1 },
        { 1, 1, 5, 1, 1 },
        { 5, 1, 1, 1, 5 },
    },
    -- 38
    {
        { 5, 1, 1, 1, 1 },
        { 1, 1, 1, 1, 5 },
        { 1, 5, 1, 1, 1 },
        { 1, 1, 1, 1, 1 },
        { 1, 1, 5, 1, 1 },
        { 1, 1, 1, 5, 1 },
    },
    -- 39
    {
        { 0, 0, 0, 0, 0 },
        { 5, 1, 1, 1, 5 },
        { 1, 1, 5, 1, 1 },
        { 1, 1, 1, 1, 1 },
        { 1, 1, 1, 1, 5 },
        { 5, 1, 1, 1, 1 },
    },
    -- 40
    {
        { 0, 0, 0, 0, 0 },
        { 1, 1, 1, 1, 1 },
        { 1, 5, 1, 1, 1 },
        { 5, 1, 1, 1, 5 },
        { 1, 1, 1, 5, 1 },
        { 5, 1, 1, 1, 1 },
    },

}


return GameDatas