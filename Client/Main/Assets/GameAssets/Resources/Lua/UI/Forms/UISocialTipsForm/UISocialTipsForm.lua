------------------------------------------------
--作者： _SqL_
--日期： 2019-04-23
--文件： UISocialTipsForm.lua
--模块： UISocialTipsForm
--描述： 社交 tips
------------------------------------------------
local UIPlayerInfoRoot = require "UI.Forms.UISocialTipsForm.Root.UIPlayerInfoRoot"

local UISocialTipsForm = {
    CloseBtn = nil,
    BtnItem = nil,
    BtnListPanel = nil,
    PlayerInfo = nil,
    PlayerInfoRoot = nil,
    AnimModule = nil,
    -- 按钮类型枚举
    MenuBtnType = {
        Undefine = 0,
        On_View = 1,                -- 查看
        On_Chat = 2,                -- 私聊
        On_Gift = 3,                -- 赠送
        On_Team = 4,                -- 组队
        On_Guild = 5,               -- 邀请加入公会
        On_AddEnemy = 6,            -- 加为仇人
        On_DelEnemy = 7,            -- 删除仇人
        On_AddShield = 8,           -- 屏蔽
        On_DelShield = 9,           -- 删除屏蔽
        On_AddFriend = 10,          -- 加为好友
        On_DelFriend = 11,          -- 删除好友
        On_Report = 12,             -- 举报
    }
}

function  UISocialTipsForm:OnRegisterEvents()
    self:RegisterEvent(UIEventDefine.UISocialTipsForm_OPEN,self.OnOpen)
    self:RegisterEvent(UIEventDefine.UISocialTipsForm_CLOSE,self.OnClose)
end

function UISocialTipsForm:OnFirstShow()
    self:FindAllComponents()
    self:OnRegUICallBack()
end

function UISocialTipsForm:OnHideBefore()
    for i = 0, self.BtnListPanel.childCount - 1 do
        self.BtnListPanel:GetChild(i).gameObject:SetActive(false)
    end
end

function UISocialTipsForm:FindAllComponents()
    local _trans = self.CSForm.transform
    self.CloseBtn = UIUtils.FindBtn(_trans, "Center/CloseBtn")
    self.BtnItem = UIUtils.FindTrans(_trans, "Center/Offset/ListPanel/Btn")
    self.BtnListPanel = UIUtils.FindTrans(_trans, "Center/Offset/ListPanel")
    local _infoRoot = UIUtils.FindTrans(_trans, "Center/Offset/PlayerInfo")
    self.PlayerInfoRoot = UIPlayerInfoRoot:New(self, _infoRoot)

    self.AnimModule = UIAnimationModule( _trans)
    self.AnimModule:AddAlphaAnimation()
end

function UISocialTipsForm:InitBtnlist(socialType)
    local _id = Utils.GetEnumNumber(tostring(socialType))
    local _list = Utils.SplitStr(DataConfig.DataSocial[tonumber(_id)].List, "_")
    local _index = 0
    for i = 1, #_list do
        if _index <= self.BtnListPanel.childCount - 1 then
            self:SetBtnList(self.BtnListPanel:GetChild(_index), tonumber(_list[i]))
        else
            self:SetBtnList(self:Clone(self.BtnItem,self.BtnListPanel), tonumber(_list[i]))
        end
        _index = _index + 1
    end
    UnityUtils.GridResetPosition(self.BtnListPanel)
end

function UISocialTipsForm:SetBtnList(trans,id)
    trans.gameObject:SetActive(true)
    local _Btn = trans:GetComponent("UIButton")
    local _label = UIUtils.FindLabel(trans, "Label")
    if id == self.MenuBtnType.On_View then
        _label.text = DataConfig.DataMessageString.Get("C_FRIEND_SCORIALITY_LOOK")
        UIUtils.AddBtnEvent(_Btn, self.OnViewBtnClick, self)
    elseif id == self.MenuBtnType.On_Chat then
        _label.text = DataConfig.DataMessageString.Get("C_FRIEND_SCORIALITY_CHAT")
        UIUtils.AddBtnEvent(_Btn, self.OnPrivateChatBtnClick, self)
    elseif id == self.MenuBtnType.On_Gift then
        _label.text = "赠送"
        UIUtils.AddBtnEvent(_Btn, self.OnGiftBtnClick, self)
    elseif id == self.MenuBtnType.On_Team then
        _label.text = DataConfig.DataMessageString.Get("C_FRIEND_SCORIALITY_TEAM")
        UIUtils.AddBtnEvent(_Btn, self.OnMakeTeamBtnClick, self)
    elseif id == self.MenuBtnType.On_Guild then
        _label.text = DataConfig.DataMessageString.Get("C_FRIEND_SCORIALITY_GUILD")
        UIUtils.AddBtnEvent(_Btn, self.OnInviteGuildBtnClick, self)
    elseif id == self.MenuBtnType.On_AddEnemy then
        _label.text = DataConfig.DataMessageString.Get("C_FRIEND_SCORIALITY_ADDENEMY")
        UIUtils.AddBtnEvent(_Btn, self.OnAddEmemyBtnClick, self)
    elseif id == self.MenuBtnType.On_DelEnemy then
        _label.text = DataConfig.DataMessageString.Get("C_FRIEND_SCORIALITY_DELETEENEMY")
        UIUtils.AddBtnEvent(_Btn, self.OnDelEmemyBtnClick, self)
    elseif id == self.MenuBtnType.On_AddShield then
        _label.text = DataConfig.DataMessageString.Get("C_FRIEND_SCORIALITY_SHIELD")
        UIUtils.AddBtnEvent(_Btn, self.OnAddShieldBtnClick, self)
    elseif id == self.MenuBtnType.On_DelShield then
        _label.text = DataConfig.DataMessageString.Get("SOCIAL_QUXIAOPINGBI")
        UIUtils.AddBtnEvent(_Btn, self.OnDelShieldBtnClick, self)
    elseif id == self.MenuBtnType.On_AddFriend then
        _label.text = DataConfig.DataMessageString.Get("C_FRIEND_SCORIALITY_ADDFRIEND")
        UIUtils.AddBtnEvent(_Btn, self.OnAddFriendBtnClick, self)
    elseif id == self.MenuBtnType.On_DelFriend then
        _label.text = DataConfig.DataMessageString.Get("C_FRIEND_SCORIALITY_DELETEFRIEND")
        UIUtils.AddBtnEvent(_Btn, self.OnDeleteFriendBtnClick, self)
    elseif id == self.MenuBtnType.On_Report then
        _label.text = "举报"
        UIUtils.AddBtnEvent(_Btn, self.OnReportBtnClick, self)
    end
end

-- 查看角色信息
function UISocialTipsForm:OnViewBtnClick()
    GameCenter.MainFunctionSystem:DoFunctionCallBack(FunctionStartIdCode.LookOtherPlayer, self.PlayerInfo.PlayerId)
    self:OnCLose();
end

-- 私聊
function UISocialTipsForm:OnPrivateChatBtnClick()
    if DataConfig.DataGlobal[1474].Params == "1" then
        GameCenter.MsgPromptSystem:ShowPrompt( "不是好友不能进行聊天" )
        return  
    end
    if GameCenter.FriendSystem:IsShield(self.PlayerInfo.PlayerId) then
        local roleName = GameCenter.FriendSystem:GetName( self.PlayerInfo.PlayerId, FriendType.Shield );
        GameCenter.MsgPromptSystem:ShowPrompt(string.format("%s 被屏蔽", roleName));
    else
        GameCenter.FriendSystem:ReqChat( self.PlayerInfo.PlayerId, self.PlayerInfo.name, self.PlayerInfo.career, self.PlayerInfo.lv)
    end
    self:OnCLose()
end

-- 组队
function UISocialTipsForm:OnMakeTeamBtnClick()
    GameCenter.TeamSystem:ReqInvite(self.PlayerInfo.PlayerId);
    self:OnCLose()
end

-- 赠送
function UISocialTipsForm:OnGiftBtnClick()
    if GameCenter.FriendSystem:IsFriend(self.PlayerInfo.PlayerId) then
        Debug.LogError("赠送")
    else
        GameCenter.MsgPromptSystem:ShowPrompt( "不是好友不能赠送" );
    end
    self:OnCLose()
end

-- 邀请入帮
function UISocialTipsForm:OnInviteGuildBtnClick()
    if GameCenter.FriendSystem:IsFriend(self.PlayerInfo.PlayerId) then
        GameCenter.GuildSystem:ReqInvitePlayer(self.PlayerInfo.PlayerId)
    else
        GameCenter.MsgPromptSystem:ShowPrompt( "不是好友不能邀请入帮" );
    end
    self:OnCLose()
end

-- 删除好友
function UISocialTipsForm:OnDeleteFriendBtnClick()
    GameCenter.FriendSystem:DeleteConfirmation(FriendType.Friend, self.PlayerInfo.PlayerId)
    self:OnCLose()
end

-- 添加好友
function UISocialTipsForm:OnAddFriendBtnClick()
    GameCenter.FriendSystem:AddRelation(FriendType.Friend, self.PlayerInfo.PlayerId)
    self:OnCLose()
end

-- 删除仇人
function UISocialTipsForm:OnDelEmemyBtnClick()
    GameCenter.FriendSystem:DeleteConfirmation(FriendType.Enemy, self.PlayerInfo.PlayerId);
    self:OnCLose()
end

-- 添加仇人
function UISocialTipsForm:OnAddEmemyBtnClick()
    GameCenter.FriendSystem:AddConfirmation(FriendType.Enemy, self.PlayerInfo.PlayerId);
    self:OnCLose()
end

-- 添加屏蔽
function UISocialTipsForm:OnAddShieldBtnClick()
    GameCenter.FriendSystem:AddConfirmation(FriendType.Shield, self.PlayerInfo.PlayerId);
    self:OnCLose()
end

-- 删除屏蔽
function UISocialTipsForm:OnDelShieldBtnClick()
    GameCenter.FriendSystem:DeleteConfirmation(FriendType.Shield, self.PlayerInfo.PlayerId);
    self:OnCLose()
end

-- 举报
function UISocialTipsForm:OnReportBtnClick()
    GameCenter.PushFixEvent(UIEventDefine.UIReportForm_OPEN, self.PlayerInfo.PlayerId)
end

function UISocialTipsForm:OnRegUICallBack()
    UIUtils.AddBtnEvent(self.CloseBtn, self.OnCLose, self)
end


function UISocialTipsForm:OnOpen(obj, sender)
    self.CSForm:Show(sender)
    if obj then
        self.PlayerInfo = obj
        self:InitBtnlist(obj.Type)
        self.PlayerInfoRoot:SetPalyerInfo(obj)
    end
    self.AnimModule:PlayEnableAnimation()
end

function UISocialTipsForm:OnCLose(obj, sender)
    self.CSForm:Hide()
end

function UISocialTipsForm:Clone(go, parent)
    local _trans = GameObject.Instantiate(go).transform
    UnityUtils.ResetTransform( _trans)
    if parent then
        _trans:SetParent(parent)
    end
    UnityUtils.ResetTransform( _trans)
    return _trans
end

return UISocialTipsForm