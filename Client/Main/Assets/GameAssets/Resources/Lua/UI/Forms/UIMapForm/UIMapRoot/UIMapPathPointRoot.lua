------------------------------------------------
--作者： _SqL_
--日期： 2019-04-17
--文件： UIMapPathPointRoot.lua
--模块： UIMapPathPointRoot
--描述： PathPoint Root
------------------------------------------------
-- lua 引用
local UIMapCommonItem = require("UI.Forms.UIMapForm.UIMapItem.UIMapCommonItem")

-- C# 引用
local PathMove = CS.Funcell.Code.Logic.PathMove

local UIMapPathPointRoot = {
    Index = 1,
    -- 是否在移动
    IsMoving = false,
    -- 终点
    EndPoint = Vector2.zero,

    Owner = nil,
    -- 当前对像的Transform
    Trans =nil,
    -- Point Trans
    PointTrans = nil,
    -- 父节点Transform
    ParentNodeTrans = nil,
    -- 寻路点之间的距离
    MoveDistanceList = List:New(),
    -- MoveTargetPoint List
    MoveTargetPointList = List:New(),
    -- 寻路点 list
    PathFindingPointList = List:New(),
    -- 容器
    PathFindingPointItemContaner = List:New(),
}

-- 初始化
function UIMapPathPointRoot:New(owner, trans)
    self.Owner = owner
    self.Trans = trans
    self:FindAllComponents()
    return self
end

function UIMapPathPointRoot:FindAllComponents()
    self.ParentNodeTrans = self.Trans:Find("All")
    self.PointTrans = self.Trans:Find("All/pathres")
end

-- 释放资源
function UIMapPathPointRoot:UnInitPathPoint()
    for i = 0, self.ParentNodeTrans.childCount - 1 do
        self.ParentNodeTrans:GetChild(i).gameObject:SetActive(false)
    end
    self.PathFindingPointItemContaner:Clear()
    self.PathFindingPointList:Clear()
    self.MoveTargetPointList:Clear()
    self.MoveDistanceList:Clear()
    self.Index = 1
end

-- 资源初始化
function UIMapPathPointRoot:InitPathFindingPointRes()
    local _index = 0
    for i = 1, self.PathFindingPointList:Count() do
        local _pointItem  = nil
        if _index < self.ParentNodeTrans.childCount then
            _pointItem = UIMapCommonItem:New(self.ParentNodeTrans:GetChild(_index))
        else
            _pointItem = UIMapCommonItem:Clone(self.PointTrans.gameObject, self.ParentNodeTrans)
        end
        _pointItem:SetInfo("", self.Owner:WorldPosToMapPos(Vector3(self.PathFindingPointList[i].Pos.x, 0.0, self.PathFindingPointList[i].Pos.y)))
        self.PathFindingPointItemContaner:Add(_pointItem)
        _index = _index + 1
    end
end

-- 计算寻路点
function UIMapPathPointRoot:InitPathFindongPoint()
    local _end
    local _start
    local _dir = Vector2.zero
    local _curPos
    local _singlePointDis = 3       -- 单点代表的距离
    local _pointCount = 0           -- 寻路点数量
    if self.MoveTargetPointList:Count() then
        for i = 2, self.MoveTargetPointList:Count() do
            _end = self.MoveTargetPointList[i]
            _start = self.MoveTargetPointList[i - 1]
            local _dis = Utils.Distance(Vector2(_start.x, _start.y), Vector2(_end.x, _end.y))
            if _dis > 0 then
                _dir = (_end - _start).normalized
                _curPos = _start + _dir
                local _pt = {}
                _pt.Pos = _curPos
                _pt.Dis = _singlePointDis * self.PathFindingPointList:Count()
                self.PathFindingPointList:Add(_pt)
                _pointCount = math.ceil(_dis / _singlePointDis)
                for i = 1, _pointCount - 1 do
                    local _temp = {}
                    _curPos = _curPos + _dir * _singlePointDis
                    _temp.Pos = _curPos
                    _temp.Dis = _singlePointDis * self.PathFindingPointList:Count()
                    self.PathFindingPointList:Add(_temp)
                end
            end
        end
    end
end

-- 初始化寻路点
function UIMapPathPointRoot:InitPathPoint(pathPointList)
    if pathPointList:Count() >= 2 then
        for k, v in pairs(pathPointList) do
            self.MoveTargetPointList:Add(v)
            if k == 1 then
                self.MoveDistanceList:Add(0)
            else                
                local _start = Vector2(v.x, v.y)
                local _end = Vector2(pathPointList[k - 1].x, pathPointList[k - 1].y)
                local _dis = Utils.Distance(_start, _end)
                self.MoveDistanceList:Add(_dis + self.MoveDistanceList[k - 1])
            end
        end
    end
    self:InitPathFindongPoint()
    self:InitPathFindingPointRes()
end

-- 刷新移动路径
function UIMapPathPointRoot:UpdatePathFindingPoint(localPlayer)

    if PathMove.StateIsPathMove(localPlayer.Fsm.CurrentState) then
         local _move = PathMove.StateAsPathMove(localPlayer.Fsm.CurrentState)
         local _userDataPath = _move.UserData.Path
         local _previousFramePos = Vector2.zero        -- 上一帧位置
         local _movingDis = 0                          -- 移动的距离
         local _dis = Utils.Distance(Vector2(self.EndPoint.x, self.EndPoint.y),
            Vector2(_userDataPath[_userDataPath.Count - 1].x, _userDataPath[_userDataPath.Count - 1].y))
         if not self.IsMoving or _dis ~= 0 then
            local _pathPointList = List:New(_userDataPath)
            -- for i = 0, _userDataPath.Count - 1 do
            --     _pathPointList:Add(_userDataPath[i])
            -- end
            self.EndPoint = _userDataPath[_userDataPath.Count - 1]
            self:UnInitPathPoint()
            self:InitPathPoint(_pathPointList)
            self.IsMoving = true
            self.Index = 1
            _previousFramePos = Vector2.zero
            _movingDis = 0
        end

        if self.MoveTargetPointList:Count() > 0 then
            if _movingDis <= 0 then
                _previousFramePos = self.MoveTargetPointList[1]
            end
            _movingDis = _movingDis + Utils.Distance(Vector2(_previousFramePos.x, _previousFramePos.y), Vector2(localPlayer.Position2d.x, localPlayer.Position2d.y))

            if self.PathFindingPointList[self.Index].Dis < _movingDis then
                self.PathFindingPointItemContaner[self.Index]:Close()
                _previousFramePos = localPlayer.Position2d
                self.Index = self.Index + 1
            end
        end
    else
        self.IsMoving = false
        self:UnInitPathPoint()
    end
end

return UIMapPathPointRoot