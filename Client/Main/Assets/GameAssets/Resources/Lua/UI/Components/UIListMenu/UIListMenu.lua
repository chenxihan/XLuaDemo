------------------------------------------------
--作者： 何健
--日期： 2019-04-15
--文件： UIListMenu.lua
--模块： UIListMenu,UIlistMenuIconData,UIListMenuIcon
--描述： 列表菜单
------------------------------------------------
-- C#
local GameObject = CS.UnityEngine.GameObject

local UIListMenuIcon = require "UI.Components.UIListMenu.UIListMenuIcon"
local UIlistMenuIconData = require "UI.Components.UIListMenu.UIlistMenuIconData"

local UIListMenu = {
    Trans = nil,                        -- Transform
    CenterRes = nil,                    -- GameObject
    ResIconList = List:New(),           -- List<UIListMenuIcon>
    LeftIcon = nil,                     -- UIListMenuIcon
    RightIcon = nil,                    -- UIListMenuIcon
    IconList = List:New(),              -- List<UIListMenuIcon>
    IconDataList = List:New(),          -- List<UIlistMenuIconData>
    ParentForm = nil,                   -- UINormalForm
    Table = nil,                        -- UITable
    SelectCallBacks = List:New(),       -- List<MyAction<int, bool>> 回调列表
    IsHideIconByFunc = false,           -- 是否根据功能隐藏菜单按钮
    IsInit = false,                     -- 是否初始化
}

--创建一个新的对象
function UIListMenu:OnFirstShow(owner, trans)
    local _m = Utils.DeepCopy(self)
    _m.Trans = trans
    _m.ParentForm = owner
    _m:FindAllComponents()
    LuaBehaviourManager:Add(_m.Trans, _m)
    return _m
 end

 --查找组件
 function UIListMenu:FindAllComponents()
    if self.IsInit then
        return
    end

    local trans = self.Trans:Find("Table")
    for i = 1, trans.childCount, 1 do
        if i == 1 then
            local LeftRes = trans:GetChild(i - 1).gameObject
            self.LeftIcon = UIListMenuIcon:New(LeftRes, self)
        elseif i == trans.childCount then
            local RightRes =  trans:GetChild(i - 1).gameObject
            self.RightIcon = UIListMenuIcon:New(RightRes, self)
        else
            self.CenterRes =  trans:GetChild(i - 1).gameObject
            self.CenterRes.gameObject:SetActive(false)
            self.ResIconList:Add(UIListMenuIcon:New(self.CenterRes, self))
        end
    end

    self.Table = self.Trans:Find("Table"):GetComponent("UITable")
    IsInit = true;
 end
 function UIListMenu:AddIcon(id, text, funcCode, normalSpr, selectSpr, selectSpr2)
        local data = UIlistMenuIconData:New()
        data.ID = id
        data.Text = text
        data.FuncID = funcCode
        if funcCode ~= nil then
            data.FuncInfo =  GameCenter.MainFunctionSystem:GetFunctionInfo(funcCode)
        else
            data.FuncInfo = nil
        end
        data.NormalSpr = normalSpr
        data.SelectSpr = selectSpr
        data.SelectSpr2 = selectSpr2
        self.IconDataList:Add(data)
        self:RefreshIcon()
 end
 function UIListMenu:RemoveIcon(id)
    for i = 1, #self.IconDataList do
        if self.IconDataList[i].ID == id then
            self.IconDataList:RemoveAt(i)
        end
    end
    self:RefreshIcon()
 end
 function UIListMenu:RemoveAll()
    self.IconDataList:Clear()
    self:RefreshIcon()
 end
 function UIListMenu:SetSelectById(id)
     for i = 1, #self.IconList do
         if self.IconList[i].Data.ID == id then
             self:SetSelectByIndex(i)
             break
         end
    end
end
function UIListMenu:SetSelectByIndex(index)
    -- 先执行取消选中
    for i = 1, #self.IconList do
        if i ~= index then
            self.IconList[i]:IsSelect(false);
        end
    end

    if self.ParentForm ~= nil  then
        if not self.ParentForm.IsVisible then
            return
        end
    end

    -- 再执行选中
    for i = 1, #self.IconList do
        if i == index then
            self.IconList[i]:IsSelect(true)
        end
    end
end

--添加回调
function UIListMenu:AddSelectEvent(func)
    if self.SelectCallBacks:Contains(func) then
        return
    end
    self.SelectCallBacks:Add(func)
end

--删除回调
function UIListMenu:RemoveSelectEvent(func)
    self.SelectCallBacks:Remove(func)
end

function UIListMenu:ClearSelectEvent()
    self.SelectCallBacks:Clear()
end

--设置红点
function UIListMenu:SetRedPoint(id, show)
    for i = 1, #self.IconList do
        if self.IconList[i].Data.ID == id and self.IconList[i].Data.FuncInfo == nil then
            self.IconList[i].Data.ShowRedPoint = show
            self.IconList[i].RedPoint:SetActive(show)
        end
    end
end

--设置显示内容
function UIListMenu:SetIconText(id, text)
    for i = 1, #self.IconList do
        local icon = self.IconList[i]
        if icon.Data.ID == id then
            icon.Data.Text = text;
            icon:SetInfo(icon.Data)
        end
    end
end

-- //帧更新
function UIListMenu:Update()
    local repos = false
    for i = 1, #self.IconList do
        local icon = self.IconList[i]
        if icon.Data.FuncInfo ~= nil then
            if icon.Data.FuncInfo.IsShowRedPoint ~= icon.RedPoint.activeSelf then
                icon.RedPoint:SetActive(icon.Data.FuncInfo.IsShowRedPoint)
            end
            if icon.Data.FuncInfo.IsVisible ~= icon.RootGo.activeSelf and self.IsHideIconByFunc then
                repos = true
                icon.RootGo:SetActive(icon.Data.FuncInfo.IsVisible)
            end
        end
    end
    if repos then
        self.Table:Reposition()
    end
end

function UIListMenu:RefreshIcon()
    self.IconList:Clear()
    self.LeftIcon.RootGo:SetActive(false)
    self.RightIcon.RootGo:SetActive(false)
    for i = 1, #self.ResIconList do
        self.ResIconList[i].RootGo:SetActive(false)
    end
    local resIndex = 1
    for i = 1, #self.IconDataList do
        if i == 1 then
            self.LeftIcon.RootGo.name = string.format("%03d", i - 1)
            self.LeftIcon:SetInfo(self.IconDataList[i])
            self.LeftIcon.RootGo:SetActive(true)
            self.IconList:Add(self.LeftIcon)
        elseif i == #self.IconDataList then
            self.RightIcon.RootGo.name = string.format("%03d", i - 1)
            self.RightIcon:SetInfo(self.IconDataList[i])
            self.RightIcon.RootGo:SetActive(true)
            self.IconList:Add(self.RightIcon)
        else
            local icon = nil
            if resIndex <= #self.ResIconList then
                icon = self.ResIconList[resIndex]
            else
                icon = UIListMenuIcon:New(UnityUtils.Clone(self.CenterRes), self)
                self.ResIconList:Add(icon)
            end

            icon.RootGo.name = string.format("%03d", i - 1)
            icon:SetInfo(self.IconDataList[i])
            icon.RootGo:SetActive(true)
            self.IconList:Add(icon)
            resIndex = resIndex + 1
        end
    end
    self.Table.repositionNow = true
end

function UIListMenu:OnSelectChanged(icon)
    self:DoCallBack(icon.Data.ID, icon.Select)
end

function UIListMenu:DoCallBack(id, select)
    for i = 1, #self.SelectCallBacks do
        if self.SelectCallBacks[i] ~= nil then
            self.SelectCallBacks[i](id, select)
        end
    end
end

function UIListMenu:OnDisable()
    self:SetSelectByIndex(-1)
end
return UIListMenu