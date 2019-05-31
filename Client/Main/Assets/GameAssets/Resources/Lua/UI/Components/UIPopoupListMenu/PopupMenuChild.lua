------------------------------------------------
--作者： 王圣
--日期： 2019-04-22
--文件： PopoupMenuChild.lua
--模块： PopoupMenuChild
--描述： 下拉列菜单子菜单
------------------------------------------------

-- c#类
local PopupMenuChild = {
    Trans = nil,
    NameLabel = nil,
    BackGround = nil,
    CheckMark = nil,
    MenuBtn = nil,
    --TweenPos = nil,
    StartPos = Vector3.zero,
    EndPos = Vector3.zero,
    FuncStartId = -1,
    ChildIndex = -1,
    MenuHeigh = -1,
    MenuDis = 10,
    Duration = 0.5,
    IsOpen = false,
    IsShrink = true,
    MenuControl = nil,
    --callBack
    MenuCall = nil,
    Tick = 0,
    Time = 0.5,
}

--按钮事件
function PopupMenuChild:OnClickMenu()
    if self.IsOpen == false then
        --打开
        self.MenuControl:UpdateChildMenu(self.FuncStartId)
    end
end

--创建MenuChild
function PopupMenuChild:New(tempTrans, data,index,count, menuCol, call)
    local _m = Utils.DeepCopy(self)
    local yPos = 0
    _m.ChildIndex = index
    _m.FuncStartId = data.Id
    _m.MenuControl = menuCol
    _m.MenuCall = call
    _m.Trans = UnityUtils.Clone(tempTrans.gameObject).transform
    _m.Trans.gameObject:SetActive(false)
    _m:FindAllComponent()
    _m.NameLabel.text = data.Name
    _m:SetButton()
    _m:SetEndPos(count)
    yPos = (_m.MenuHeigh + _m.MenuDis) * (count-_m.ChildIndex)
    _m.StartPos = Vector3(0, yPos, 0)
    _m.Trans.localPosition = _m.StartPos--Vector3(_m.StartPos.x,_m.StartPos.y,_m.StartPos.z)
    _m.Time = math.abs(_m.StartPos.y-_m.EndPos.y)/_m.MenuControl.Speed
    return _m
end

--查找组件
function PopupMenuChild:FindAllComponent()
    local backSprite = nil
    self.BackGround = self.Trans:Find('BackBround')
    self.CheckMark = self.Trans:Find('CheckMark')
    self.MenuBtn = self.Trans:GetComponent('UIButton')
    backSprite = self.BackGround:GetComponent('UISprite')
    self.MenuHeigh = backSprite.height
    self.BackGround.gameObject:SetActive(true)
    self.CheckMark.gameObject:SetActive(false)
    self.NameLabel = UIUtils.RequireUILabel(self.Trans:Find("Name"))
end

--设置button
function PopupMenuChild:SetButton()
    self.MenuBtn.onClick:Clear()
    EventDelegate.Add(self.MenuBtn.onClick, Utils.Handler(self.OnClickMenu, self))
end

--打开UI
function PopupMenuChild:OpenFunction(isCall)
    self.IsOpen = true
    --设置选中状态
    self.BackGround.gameObject:SetActive(false)
    self.CheckMark.gameObject:SetActive(true)
    if isCall then
        self.MenuCall(self.FuncStartId)
    end
end

--设置按钮未选中状态
function PopupMenuChild:SetUnSelected()
    self.IsOpen = false
    self.BackGround.gameObject:SetActive(true)
    self.CheckMark.gameObject:SetActive(false)
end

--移动到目标位置
function PopupMenuChild:MoveToTargetPos()
    self.Tick = self.Time
    
end

--移动回初始位置
function PopupMenuChild:MoveToStartPos()
    self.Tick = self.Time
end

--hide
function PopupMenuChild:HideMenu()
    UnityUtils.SetLocalPosition(self.Trans, self.StartPos.x, self.StartPos.y, self.StartPos.z)
    self.Trans.gameObject:SetActive(false)
    self.Tick = 0
    self.IsShrink = true
end

--获取位移目标Y坐标 位置
function PopupMenuChild:SetEndPos(count)
    local yPos = (self.MenuHeigh + self.MenuDis) * self.ChildIndex
    self.EndPos = Vector3(self.StartPos.x, -yPos, self.StartPos.z)
end

--获取子菜单是否收缩状态
function PopupMenuChild:GetShrink()
    return self.IsShrink and self.Tick == 0
end

--获取子菜单是否移动
function PopupMenuChild:IsMove()
    return self.Tick ~=0
end

function PopupMenuChild:UpdatePos(dt,isOpen)
    if self.Tick ~= 0 then
        local _pos = nil
        if isOpen then
            if self.Tick>0 then
                self.Tick = self.Tick - dt
                _pos = Utils.Lerp(self.EndPos,self.StartPos,self.Tick/self.Time)
                if _pos.y<= -self.MenuHeigh then
                    self.Trans.gameObject:SetActive(true)
                end
            else
                self.Tick = 0
                self.IsShrink = false
                _pos = self.EndPos
            end
        else
            if self.Tick>0 then
                self.Tick = self.Tick - dt
                _pos = Utils.Lerp(self.StartPos,self.EndPos,self.Tick/self.Time)
                if _pos.y >= -self.MenuHeigh then
                    self.Trans.gameObject:SetActive(false)
                end
            else
                self.Tick = 0
                self.IsShrink = true
                _pos = self.StartPos
            end
        end
        UnityUtils.SetLocalPosition(self.Trans, _pos.x, _pos.y, _pos.z)
    end
end
return PopupMenuChild
