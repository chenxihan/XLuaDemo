------------------------------------------------
--作者： dhq
--日期： 2019-05-16
--文件： UIInviteFriendItem.lua
--模块： UIInviteFriendItem
--描述： 邀请好友界面好友列表
------------------------------------------------
local UIInviteFriendItem = {
    --root
    RootGo = nil,
    Trans = nil,
    Parent = nil,
    Info = nil,
    -- 名字
    NameLabel = nil,
    -- 邀请按钮
    InviteBtn = nil,
}

function UIInviteFriendItem:New(go, parent)
    local _result = Utils.DeepCopy(self);
    _result.RootGo = go;
    _result.Trans = go.transform;
    _result.Parent = parent;
    _result:OnFirstShow();
    return _result
end

function UIInviteFriendItem:OnFirstShow()
    self.NameLabel = UIUtils.FindLabel(self.Trans, "Name");
    self.InviteBtn = UIUtils.FindBtn(self.Trans, "InviteBtn");
end

--刷新
function UIInviteFriendItem:Refresh(info)
    self.Info = info;
    if self.Info ~= nil then
        self.NameLabel.text = self.Info.Name
        UIUtils.AddBtnEvent(self.InviteBtn, self.OnInviteBtnClick, self)
    end
end

-- 邀请好友按钮
function UIInviteFriendItem:OnInviteBtnClick()
    Debug.Log(string.format( "邀请了%s", self.Info.Name ))
    --self.Parent.InvitedFriendsList:Add(self.Info.Name)
    self.Parent:UpdateInvitedList(self.Info.Name)
end

return UIInviteFriendItem