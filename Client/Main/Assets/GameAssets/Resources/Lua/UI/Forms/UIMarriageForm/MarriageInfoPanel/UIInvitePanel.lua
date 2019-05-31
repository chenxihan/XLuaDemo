------------------------------------------------
--作者： dhq
--日期： 2019-05-13
--文件： UIInvitePanel.lua
--模块： UIInvitePanel
--描述： 婚姻邀请界面
------------------------------------------------
local UIInviteFriendItem = require "UI.Forms.UIMarriageForm.MarriageInfoPanel.UIInviteFriendItem"

--//模块定义
local UIInvitePanel = {
    --当前transform
    Trans = nil,
    --父
    Parent = nil,
    --动画模块
    AnimModule = nil,
    BackBtn = nil,

    TypeNameLabel = nil,
    TypeDesLabel = nil,
    InviteNumLabel = nil,
    AddBtn = nil,
    FriendBtn = nil,
    GroupBtn = nil,
    OtherBtn = nil,
    FriendListGrid = nil,
    FriendItemList = nil,
    FriendItemGo = nil,
    InvitedList = nil,
    InvitedFriendsList = nil,
    FriendData = 
    {
        {Id = 1, Name = "曹操"},
        {Id = 2, Name = "刘备"},
        {Id = 3, Name = "孙权"},
        {Id = 4, Name = "周瑜"},
        {Id = 5, Name = "关羽"},
        {Id = 6, Name = "张飞"},
        {Id = 7, Name = "赵云"},
    },
}

function UIInvitePanel:OnFirstShow(trans, parent)
    self.Trans = trans
    self.Parent = parent
    self.InvitedFriendsList = List:New()
    --创建动画模块
    self.AnimModule = UIAnimationModule(self.Trans)
    --添加一个动画
    self.AnimModule:AddAlphaAnimation()

    self.BackBtn = UIUtils.FindBtn(self.Trans, "BackBtn")
    UIUtils.AddBtnEvent(self.BackBtn, self.OnBackBtnClick, self)

    self.TypeNameLabel = UIUtils.FindLabel(self.Trans, "Des/TypeName")
    self.TypeDesLabel = UIUtils.FindLabel(self.Trans, "Des/Des")
    self.InviteNumLabel = UIUtils.FindLabel(self.Trans, "InviteDes/Num/Label")

    self.AddBtn = UIUtils.FindBtn(self.Trans, "InviteDes/AddBtn")
    UIUtils.AddBtnEvent(self.AddBtn, self.OnAddBtnClick, self)

    self.FriendBtn = UIUtils.FindBtn(self.Trans, "WaittingInvitingList/FriendBtn")
    UIUtils.AddBtnEvent(self.FriendBtn, self.OnFriendBtnClick, self)
    self.GroupBtn = UIUtils.FindBtn(self.Trans, "WaittingInvitingList/GroupBtn")
    UIUtils.AddBtnEvent(self.GroupBtn, self.OnGroupBtnClick, self)
    self.OtherBtn = UIUtils.FindBtn(self.Trans, "WaittingInvitingList/OtherBtn")
    UIUtils.AddBtnEvent(self.OtherBtn, self.OnOtherBtnClick, self)

    self.FriendListGrid = UIUtils.FindGrid(self.Trans, "WaittingInvitingList/Scroll View/Grid")
    self.FriendItemList = List:New()
    self.FriendItemGo = UIUtils.FindGo(self.Trans, "WaittingInvitingList/Scroll View/Grid/FriendItem")
    local _friedItem = UIInviteFriendItem:New(self.FriendItemGo, self)
    self.FriendItemList:Add(_friedItem)

    self.InvitedGrid = UIUtils.FindGrid(self.Trans, "InvitedList/Scroll View/Grid")
    self.InvitedList = List:New()
    self.InvitedNameLabel = UIUtils.FindLabel(self.Trans, "InvitedList/Scroll View/Grid/Name")
    self.InvitedNameLabel.gameObject:SetActive(false)
    self.InvitedList:Add(self.InvitedNameLabel)

    self.Trans.gameObject:SetActive(false)
    return self
end

function UIInvitePanel:Show()
    --播放开启动画
    self.AnimModule:PlayEnableAnimation()
    self:UpdateData()
end

function UIInvitePanel:Hide()
    --播放关闭动画
    self.AnimModule:PlayDisableAnimation()
    self.InvitedFriendsList:Clear()
    for i = 1, #self.InvitedList do
        self.InvitedList[i].gameObject:SetActive(false)
    end
end

--关闭上层面板和此面板
function UIInvitePanel:HideSelfAndParentPanel()
    self:Hide()
    self.Parent.MarryProcessPanel:Show()
end

-- --返回按钮
function UIInvitePanel:OnBackBtnClick()
    self:HideSelfAndParentPanel()
end

--增加邀请人数按钮
function UIInvitePanel:OnAddBtnClick()
    
end

-- 请求好友列表
function UIInvitePanel:OnFriendBtnClick()

end

-- 请求帮会的好友列表
function UIInvitePanel:OnGroupBtnClick()

end

-- 请求其他玩家的列表
function UIInvitePanel:OnOtherBtnClick()

end

function UIInvitePanel:UpdateData()
    local _itemUICount = #self.FriendItemList;
    for i = 1, _itemUICount do
        self.FriendItemList[i]:Refresh(nil);
    end
    local _itemCount = #self.FriendData;
    for i = 1, _itemCount do
        local _dataInfo = self.FriendData[i]
        local _friendItem = nil;
        if i <= #self.FriendItemList then
            _friendItem = self.FriendItemList[i];
        else
            local _cloneGo = UIUtility.Clone(self.FriendItemGo)
            _friendItem = UIInviteFriendItem:New(_cloneGo, self);
            self.FriendItemList:Add(_friendItem);
        end
        self.FriendItemList[i]:Refresh(_dataInfo);
    end
    self.FriendListGrid.repositionNow = true;
end

function UIInvitePanel:UpdateInvitedList(invitedName)
    if self.InvitedFriendsList:Contains(invitedName) then
        return
    end
    self.InvitedFriendsList:Add(invitedName)
    local _itemUICount = #self.InvitedList;
    for i = 1, _itemUICount do
        self.InvitedList[i].gameObject:SetActive(false)
    end
    local _dataCount = #self.InvitedFriendsList
    for i = 1, _dataCount do
        local _name = self.InvitedFriendsList[i]
        local _invitedNameGo = nil;
        if i <= #self.InvitedList then
            _invitedNameGo = self.InvitedList[i];
        else
            _invitedNameGo = UIUtility.Clone(self.InvitedNameLabel.gameObject)
            local _invitedNameLabel = UIUtils.RequireUILabel(_invitedNameGo.transform)
            self.InvitedList:Add(_invitedNameLabel);
        end
        self.InvitedList[i].text = _name
        self.InvitedList[i].gameObject:SetActive(true)
    end
    self.InvitedGrid.repositionNow = true;
end

return UIInvitePanel