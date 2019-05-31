------------------------------------------------
--作者： 何健
--日期： 2019-05-13
--文件： UIGuildListForm.lua
--模块： UIGuildListForm
--描述： 宗派列表排行及个人排行界面
------------------------------------------------

local UIGuildListPanel = require "UI.Forms.UIGuildListForm.UIGuildListPanel"
local UIMemberListPanel = require "UI.Forms.UIGuildListForm.UIMemberListPanel"
local UIGuildListNomalPanel = require "UI.Forms.UIGuildListForm.UIGuildListNomalPanel"

local UIGuildListForm ={
    --我的排名
    MyRankLabel = nil,
    --我的战力
    MyFightLabel = nil,
    --宗派排名
    GuildRankLabel = nil,
    --查看个人排行按钮
    CheckMemberListBtn = nil,
    CheckMemberListGo = nil,
    --查看宗派排行按钮
    CheckGuildListBtn = nil,
    CheckGuildListGo = nil,
    --描述TIPS
    DescTipsLabel = nil,
    --个人排行面板
    MemberListPanel = nil,
    --宗派排行面板
    GuildListPanel = nil,
    --宗派排行面板（非领地战时）
    GuildListNormalPanel = nil,
    BottomGo = nil
}

local GuildListPanelEnum = {
    GuildList = 1,
    MemberList = 2,
    GuildListNomal = 3
}

--继承Form函数
function UIGuildListForm:OnRegisterEvents()
	self:RegisterEvent(UIEventDefine.UIGuildListForm_OPEN,self.OnOpen)
	self:RegisterEvent(UIEventDefine.UIGuildListForm_CLOSE,self.OnClose)
	self:RegisterEvent(LogicEventDefine.EID_EVENT_GUILD_MEMBERLIST_UPDATE,self.OnMemberListUpdate)
	self:RegisterEvent(LogicEventDefine.EID_EVENT_GUILD_CREATEGUILD_RECOMMENDGUILDLIST_UPDATE,self.OnGuildNomalListUpdate)
end

function UIGuildListForm:OnFirstShow()
    self:FindAllComponents()
    self.CSForm:AddAlphaAnimation()
end
function UIGuildListForm:OnHideBefore()
end
function UIGuildListForm:OnShowAfter()
    if GameCenter.GuildSystem.IsGuildFight then
        self:OnSetFormShow(GuildListPanelEnum.MemberList)
    else
        GameCenter.GuildSystem:ReqRecommendGuild(1);
        self:OnSetFormShow(GuildListPanelEnum.GuildListNomal)
    end
end

--查找UI上各个控件
function UIGuildListForm:FindAllComponents()
    self.MyRankLabel = UIUtils.FindLabel(self.Trans, "Bottom/MyRankLabel/Label")
    self.MyFightLabel = UIUtils.FindLabel(self.Trans, "Bottom/MyFightLabel/Label")
    self.GuildRankLabel = UIUtils.FindLabel(self.Trans, "Bottom/GuildRankLabel/Label")
    self.DescTipsLabel = UIUtils.FindLabel(self.Trans, "Bottom/TipsLabel")

    self.CheckGuildListBtn = UIUtils.FindBtn(self.Trans, "Bottom/CheckGuildBtn")
    self.CheckGuildListGo = UIUtils.FindGo(self.Trans, "Bottom/CheckGuildBtn")
    self.CheckMemberListBtn = UIUtils.FindBtn(self.Trans, "Bottom/CheckMemberBtn")
    self.CheckMemberListGo = UIUtils.FindGo(self.Trans, "Bottom/CheckMemberBtn")
    self.BottomGo = UIUtils.FindGo(self.Trans, "Bottom")

    self.GuildListPanel = UIGuildListPanel:OnFirstShow(UIUtils.FindTrans(self.Trans, "GuildPanel"))
    self.MemberListPanel = UIMemberListPanel:OnFirstShow(UIUtils.FindTrans(self.Trans, "MemberPanel"))
    self.GuildListNormalPanel = UIGuildListNomalPanel:OnFirstShow(UIUtils.FindTrans(self.Trans, "GuildListPanel"))

    UIUtils.AddBtnEvent(self.CheckGuildListBtn, self.OnClickCheckGuildListBtn, self)
    UIUtils.AddBtnEvent(self.CheckMemberListBtn, self.OnClickCheckMemberListBtn, self)
end

function UIGuildListForm:OnClickCheckGuildListBtn()
    self:OnSetFormShow(GuildListPanelEnum.GuildList)
end
function UIGuildListForm:OnClickCheckMemberListBtn()
    self:OnSetFormShow(GuildListPanelEnum.MemberList)
end

function UIGuildListForm:OnSetFormShow(type)
    if type == GuildListPanelEnum.GuildList then
        self.GuildListPanel:Open()
        self.MemberListPanel:Close()
        self.GuildListNormalPanel:Close()
        self.CheckMemberListGo:SetActive(true)
        self.CheckGuildListGo:SetActive(false)
        self.BottomGo:SetActive(true)
        self.DescTipsLabel.text = "宗派排名前3名可获得领地（今日23：00结算）"
    elseif type == GuildListPanelEnum.MemberList then
        self.GuildListPanel:Close()
        self.MemberListPanel:Open()
        self.GuildListNormalPanel:Close()
        self.CheckMemberListGo:SetActive(false)
        self.CheckGuildListGo:SetActive(true)
        self.BottomGo:SetActive(true)
        self.DescTipsLabel.text = "宗派排名前3名可获得称号（战斗力每小时刷新一次）"
        GameCenter.GuildSystem:ReqMembersListInfo()
    else
        self.GuildListPanel:Close()
        self.MemberListPanel:Close()
        self.GuildListNormalPanel:Open()
        self.BottomGo:SetActive(false)
    end
    self.MyRankLabel.text = tostring(GameCenter.GuildSystem.MyRankNum)
    self.MyFightLabel.text = tostring(GameCenter.GameSceneSystem:GetLocalPlayer().FightPower)
    self.GuildRankLabel.text = tostring(GameCenter.GuildSystem.GuildInfo.RankNum)
end

function UIGuildListForm:OnMemberListUpdate(obj, sender)
    self.MemberListPanel:OnRefreshForm(GameCenter.GuildSystem.GuildMemberList)
    self.MyRankLabel.text = tostring(GameCenter.GuildSystem.MyRankNum)
end
function UIGuildListForm:OnGuildNomalListUpdate(obj, sender)
    self.GuildListNormalPanel:OnRefreshForm()
end
return UIGuildListForm