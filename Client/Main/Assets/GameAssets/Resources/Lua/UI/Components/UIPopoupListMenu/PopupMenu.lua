------------------------------------------------
--作者： 王圣
--日期： 2019-04-22
--文件： PopoupListMenu.lua
--模块： PopoupListMenu
--描述： 下拉列菜单
------------------------------------------------

-- c#类
local PopupMenuChild = require 'UI.Components.UIPopoupListMenu.PopupMenuChild'
local PopupMenu = {
    Trans = nil,
    TempChildTrans = nil,
    NameLabel = nil,
    MenuBtn = nil,
    BackGround = nil,
    CheckMart = nil,
    IsOpen = false,
    IsMoveYDis = false,
    IsMoveToStart = false,
    MenuType = 0,
    MenuDis = 10,
    Duration = 0.5,
    Childs = List:New(),
    StartPos = Vector3.zero,
    EndPos = Vector3.zero,
    MovePos = Vector3.zero,
    MenuControl = nil,
    CurClickChildId = 0,
    --TweenPos = nil,
    --callBack
    Tick = 0,
    Time =0.5,
}

--点击Menu
function PopupMenu:OnClickMenu()
    if not self.MenuControl:CanClickMenu() then
        return
    end
    for i = 1,#self.Childs do
        self.Childs[i]:SetUnSelected()
    end
    if (self.IsOpen ~= true) then
        --打开下拉列表
        self.CheckMart.gameObject:SetActive(true)
        self.BackGround.gameObject:SetActive(false)
        --self:OpenChildList()
        local childMenu = nil
        if self.CurClickChildId == 0 then
            childMenu = self:GetFristChild()
        else
            childMenu = self:GetChildMenu(self.CurClickChildId)
        end
        self.MenuControl:UpdateMenuList(self.MenuType)
        if childMenu ~= nil then
            self:UpdateChildMenu(childMenu.FuncStartId)
        end 
        self.Tick = self.Time
    else
        --关闭下拉列表
        --self.CheckMart.gameObject:SetActive(false)
        --self.BackGround.gameObject:SetActive(true)
        --self:CloseChildList()
        self.MenuControl:UpdateMenuList(-1)
        self.Tick = self.Time
    end
end

--创建PopoupMenu
function PopupMenu:New(tempRoot, type, name, childDataList, menuCol,childMenuCall)
    local _m = Utils.DeepCopy(self)
    _m.MenuType = type
    _m.MenuControl = menuCol
    _m.Trans = UnityUtils.Clone(tempRoot.gameObject).transform
    _m.Trans.gameObject:SetActive(true)
    _m.MovePos = Vector3(0,0,0)
    _m:FindAllComponent()
    _m:SetButton()
    --设置ChildList
    _m:SetChildMenu(childDataList, childMenuCall)
    _m.NameLabel.text = name
    return _m
end

function PopupMenu:FindAllComponent()
    self.MenuBtn = self.Trans:Find("Menu"):GetComponent("UIButton")
    self.BackGround = self.Trans:Find("Menu/BackBround")
    self.CheckMart = self.Trans:Find("Menu/CheckMark")
    self.TempChildTrans = self.Trans:Find("ChildList/ChildMenuTemp")
    self.BackGround.gameObject:SetActive(true)
    self.CheckMart.gameObject:SetActive(false)
    self.NameLabel = UIUtils.RequireUILabel(self.Trans:Find("Menu/Name"))
end

function PopupMenu:SetButton()
    self.MenuBtn.onClick:Clear()
    EventDelegate.Add(self.MenuBtn.onClick, Utils.Handler(self.OnClickMenu, self))
end

--初始化菜单按钮位置
function PopupMenu:InitMenuPos(count, heigh, dis, isSetEndPos)
    local sprite = self.BackGround:GetComponent('UISprite')
    if sprite ~= nil then
        --计算起始位置
        local y = self.Trans.localPosition.y - (sprite.height + self.MenuDis) * self.MenuType
        self.StartPos = {x = self.Trans.localPosition.x,y = y, z = self.Trans.localPosition.z}--Vector3(self.Trans.localPosition.x, y, self.Trans.localPosition.z)
        self.Trans.localPosition = Vector3(self.StartPos.x,self.StartPos.y,self.StartPos.z)
        --计算结束位置
        if isSetEndPos == false then
            self.EndPos = self.StartPos
        else
            if count == -1 then
                self.EndPos = Vector3(self.StartPos.x,self.StartPos.y,self.StartPos.z)
            else   
                y = self.StartPos.y - (heigh +dis) * count
                self.EndPos = Vector3(self.StartPos.x,y,self.StartPos.z)
            end
        end
    end
end

--设置菜单按钮移动到目标位置
function PopupMenu:MoveToTargetPos()
end

--设置菜单按钮返回起始位置
function PopupMenu:MoveToStartPos()
end

--获取子菜单个数
function PopupMenu:GetChildMenuCount()
    return self.Childs:Count()
end

--获取子菜单图片高
function PopupMenu:GetChildPicH()
    if self.Childs:Count() ~= 0 then
        local child = self.Childs[1]
        if child ~= nil then
            return child.MenuHeigh
        end
    end
    return -1
end

--获取子菜单之间间距
function PopupMenu:GetChildDis()
    if self.Childs:Count() ~= 0 then
        local child = self.Childs[1]
        if child ~= nil then
            return child.MenuDis
        end
    end
    return -1
end

function PopupMenu:SetChildMenu(childDataList, call)
    for i = 1, #childDataList do
        local child = PopupMenuChild:New(self.TempChildTrans, childDataList[i],i,#childDataList,self.MenuControl,call)
        self.Childs:Add(child)
    end
end

function PopupMenu:GetChildMenu(id)
    for i = 1, #self.Childs do
        if self.Childs[i].FuncStartId == id then
            return self.Childs[i]
        end
    end
    return nil
end

--获取第一个child
function PopupMenu:GetFristChild()
    if self.Childs:Count()>=1 then
        return self.Childs[1]
    end
    return nil
end

--打开下拉列表
function PopupMenu:OpenChildList()
    for i = 1, #self.Childs do
        if self.Childs[i] ~= nil then
            self.Childs[i]:MoveToTargetPos()
        end
    end
    self.CheckMart.gameObject:SetActive(true)
    self.BackGround.gameObject:SetActive(false)
    self.IsOpen = true
end

--关闭下来列表
function PopupMenu:CloseChildList(index)
    for i = 1, #self.Childs do
        if self.Childs[i] ~= nil then
            self.Childs[i]:SetUnSelected()
            self.Childs[i]:MoveToStartPos()
        end
    end
    if index ~= -1 then
        self.CheckMart.gameObject:SetActive(false)
        self.BackGround.gameObject:SetActive(true)
        self.CurClickChildId = 0
    end
    self.IsOpen = false
end

 --重置Menu位置
function PopupMenu:ResetPos()
    self.Time = math.abs( self.StartPos.y-self.Trans.localPosition.y )/self.MenuControl.Speed
    self.Tick = self.Time
    self.IsMoveToStart = true
    --self.Trans.localPosition = Vector3(self.StartPos.x,self.StartPos.y,self.StartPos.z)
end

function PopupMenu:ResetSelect()
    self.CheckMart.gameObject:SetActive(false)
    self.BackGround.gameObject:SetActive(true)
end

--获取Y坐标位移距离
function PopupMenu:GetMoveDisY()
    return self.EndPos.y - self.StartPos.y
end

--是否在Start位置
function PopupMenu:IsOnStartPos()
    if self.Trans.localPosition.y == self.StartPos.y then
        return true
    end
    return false
end
--子菜单是否处于关闭状态
function PopupMenu:IsChildShrink()
    local isShrink = true
    for i = 1,#self.Childs do
        if not self.Childs[i]:GetShrink() then
            isShrink = false
        end
    end
    return isShrink
end

--判断子菜单是否还在移动
function PopupMenu:HaveChildMove()
    local have = false
    for i = 1,#self.Childs do
        if self.Childs[i]:IsMove() then
            have = true
        end
    end
    return have
end

--设置Menu位置
function PopupMenu:SetMenuMovePos(yDis)
    local _startPos = Vector3(self.StartPos)
    self.MovePos.x = _startPos.x
    self.MovePos.y = _startPos.y+yDis
    self.MovePos.z = _startPos.z
    self.Time = math.abs( yDis/self.MenuControl.Speed )
    self.Tick = self.Time
    self.IsMoveYDis = true
    --self.Trans.localPosition = Vector3(_startPos.x,_startPos.y+yDis,_startPos.z)
end

--Hide
function PopupMenu:HideMenu()
    UnityUtils.SetLocalPosition(self.Trans, self.StartPos.x, self.StartPos.y, self.StartPos.z)
    for i = 1,#self.Childs do
        self.Childs[i]:HideMenu()
    end
    self.Tick = 0
    self.IsOpen = false
    self.CurClickChildId = 0
end

--更新子菜单
function PopupMenu:UpdateChildMenu(id)
    local isCall = true
    local clickMenu = nil
    for i = 1, #self.Childs do
        self.Childs[i]:SetUnSelected()
    end
    if self.CurClickChildId == id then
        isCall = false
    else 
        self.CurClickChildId = id
    end
    clickMenu = self:GetChildMenu(id)
    clickMenu:OpenFunction(isCall)
end

function PopupMenu:UpdatePos(dt)
    if self.Tick ~=0 then
        local _pos = nil
        if self.IsMoveYDis then
            if self.Tick>0 then
                self.Tick = self.Tick-dt
                _pos = Utils.Lerp(self.MovePos,self.StartPos,self.Tick/self.Time)
            else
                self.Tick = 0
                self.IsMoveYDis = false
                _pos = self.MovePos
            end
            UnityUtils.SetLocalPosition(self.Trans, _pos.x, _pos.y, _pos.z)
        end
        if self.IsMoveToStart then
            if self.Tick>0 then
                self.Tick = self.Tick-dt
                _pos = Utils.Lerp(self.StartPos,self.MovePos,self.Tick/self.Time)
            else
                self.Tick = 0
                self.IsMoveToStart = false
                _pos = self.StartPos
            end
            UnityUtils.SetLocalPosition(self.Trans, _pos.x, _pos.y, _pos.z)
        end
    end
    if self.Childs then
        for i = 1,#self.Childs do
            self.Childs[i]:UpdatePos(dt,self.IsOpen)
        end
    end
end
return PopupMenu
