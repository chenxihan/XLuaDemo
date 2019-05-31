------------------------------------------------
--作者： 何健
--日期： 2019-05-23
--文件： UIGuildForm.lua
--模块： UIGuildForm
--描述： 宗派基础信息处理界面
------------------------------------------------
local L_ListItem = require "UI.Forms.UIGuildForm.GuildMemberItem"
local L_InterActive = require "UI.Forms.UIGuildForm.GuildInterActivePanel"
local L_Offical = require "UI.Forms.UIGuildForm.GuildOfficalPanel"
local L_ApplyPanel = require "UI.Forms.UIGuildForm.GuildApplyListPanel"
local L_SetPanel = require "UI.Forms.UIGuildForm.GuildSetPanel"
local L_ItemBase = CS.Funcell.Code.Logic.ItemBase
local UIGuildForm = {
    --进入宗派
    EnterSceneBtnGo = nil,
    --权限管理
    OfficalBtnGo = nil,
    --申请列表
    ApplyListBtnGo = nil,
    --帮贡图标
    ContributeIcon = nil,
    --我的帮贡数量
    MyGuildContriNumLabel = nil,
    --帮会名字
    GuildNameLabel = nil,
    --帮主名字
    LeaderNameLabel = nil,
    -- 帮会等级
    GuildLvLabel = nil,
    -- 宗派排名
    GuildRankLabel = nil,
    -- 帮会人数
    GuildNumLabel = nil,
    --帮会战力
    GuildPowerLabel = nil,
    --帮会资金
    GuildMoneyLabel = nil,
    -- 帮会宣言
    GuildNoticeLabel = nil,
    --在线人数
    GuildActiveLabel = nil,
    MemberItem = nil,
    MemberTable = nil,
    MemberTableTrans = nil,
    MemberScroll = nil,
    SelectItem = nil,

    --成员交互面板
    InterActivePanel = nil,
    --职位变更界面
    OfficalPanel = nil,
    --申请列表界面
    ApplyPanel = nil,
    --设置界面
    SetPanel = nil,
}

--继承Form函数
function UIGuildForm:OnRegisterEvents()
	self:RegisterEvent(UIEventDefine.UIGuildForm_OPEN, self.OnOpen)
    self:RegisterEvent(UIEventDefine.UIGuildForm_CLOSE, self.OnClose)
    self:RegisterEvent(LogicEventDefine.EID_EVENT_GUILD_BASEINFOCHANGE_UPDATE, self.OnUpdateForm)
    self:RegisterEvent(LogicEventDefine.EVENT_COIN_CHANGE_UPDATE, self.SetUnionContribution)
    self:RegisterEvent(LogicEventDefine.EID_EVENT_GUILD_NOTICE_RESULT, self.EventOnSetNoticeBack)
    self:RegisterEvent(LogicEventDefine.EID_EVENT_GUILD_MEMBERLIST_UPDATE, self.OnUpdateMemberList)
    self:RegisterEvent(LogicEventDefine.EID_EVENT_GUILD_INTERACTIVEPANEL_CLOSE, self.OnInterActiveClose)
    self:RegisterEvent(LogicEventDefine.EID_EVENT_GUILD_OPENSETPANEL, self.OnSetPanelOpen)
    self:RegisterEvent(LogicEventDefine.EID_EVENT_GUILD_GUILDAPPLYLIST_UPDATE, self.OnApplyListUpdate)
end

function UIGuildForm:OnFirstShow()
    self:FindAllComponents()
    self.CSForm:AddAlphaAnimation()
end
function UIGuildForm:OnHideBefore()
end
function UIGuildForm:OnShowAfter()
    GameCenter.Network.Send("MSG_Guild.ReqGuildInfo", {})
    GameCenter.Network.Send("MSG_Guild.ReqMembersListInfo", {})
    self:OnUpdateForm()
    self.InterActivePanel:Close()
    self.OfficalPanel:Close()
    self.ApplyPanel:Close()
    self.SetPanel:Close()
end

--查找UI上各个控件
function UIGuildForm:FindAllComponents()
    local trans = self.Trans

    self.EnterSceneBtnGo = UIUtils.FindGo(trans, "Bottom/EnterSceneBtn")
    self.OfficalBtnGo = UIUtils.FindGo(trans, "Bottom/GuildOfficalBtn")
    self.ApplyListBtnGo = UIUtils.FindGo(trans, "Bottom/GuildApplyBtn")

    self.MyGuildContriNumLabel = UIUtils.FindLabel(trans, "Bottom/ContributeLabel")
    self.GuildLvLabel          = UIUtils.FindLabel(trans, "Center/GuildLv")
    self.GuildNameLabel        = UIUtils.FindLabel(trans, "Center/GuildName")
    self.LeaderNameLabel       = UIUtils.FindLabel(trans, "Center/LeaderName")
    self.GuildNumLabel         = UIUtils.FindLabel(trans, "Center/GuildNum")
    self.GuildPowerLabel       = UIUtils.FindLabel(trans, "Center/GuildFight")
    self.GuildMoneyLabel       = UIUtils.FindLabel(trans, "Center/GuildMoney")
    self.GuildNoticeLabel      = UIUtils.FindLabel(trans, "Center/Declaration")
    self.GuildRankLabel        = UIUtils.FindLabel(trans, "Center/Rank")
    self.GuildActiveLabel      = UIUtils.FindLabel(trans, "Center/GuildActiveNum")
    self.MemberItem   = L_ListItem:OnFirstShow(UIUtils.FindTrans(trans, "Center/ListScroll/Container/UIItem"))
    self.MemberTable  = UIUtils.FindTable(trans, "Center/ListScroll/Container")
    self.MemberTableTrans  = UIUtils.FindTrans(trans, "Center/ListScroll/Container")
    self.MemberScroll = UIUtils.FindScrollView(trans, "Center/ListScroll")

    self.OfficalPanel = L_Offical:OnFirstShow(UIUtils.FindTrans(trans, "Offical"))
    self.SetPanel = L_SetPanel:OnFirstShow(UIUtils.FindTrans(trans, "SetPanel"))
    self.ApplyPanel = L_ApplyPanel:OnFirstShow(UIUtils.FindTrans(trans, "ApplyPanel"))
    self.InterActivePanel = L_InterActive:OnFirstShow(UIUtils.FindTrans(trans, "InterActive"))
    self.ContributeIcon = UnityUtils.RequireComponent(UIUtils.FindTrans(trans, "Bottom/ContributeLabel/Sprite"), "Funcell.GameUI.Form.UIIconBase")
    local btn = UIUtils.FindBtn(trans, "Bottom/EnterSceneBtn")
    UIUtils.AddBtnEvent(btn, self.EnterSceneBtnClick, self)
    btn = UIUtils.FindBtn(trans, "Bottom/GuildOfficalBtn")
    UIUtils.AddBtnEvent(btn, self.OnClickOfficalBtn, self)
    btn = UIUtils.FindBtn(trans, "Bottom/GuildApplyBtn")
    UIUtils.AddBtnEvent(btn, self.OnClickApplyListBtn, self)
end

--进入宗派场景
function UIGuildForm:EnterSceneBtnClick()
    GameCenter.Network.Send("MSG_Guild.ReqEnterGuild", {})
end

--打开权限管理界面
function UIGuildForm:OnClickOfficalBtn()
    self.OfficalPanel:Open()
end

--打开申请列表界面
function UIGuildForm:OnClickApplyListBtn()
    self.ApplyPanel:Open()
end

--成员列表点击
function UIGuildForm:OnClickList(item)
    if self.SelectItem ~= nil then
    self.SelectItem:OnSetIsEnable(true)
    end
    self.SelectItem = item
    self.SelectItem:OnSetIsEnable(false)
    self.InterActivePanel.Go:SetActive(true)

    if self.SelectItem.Data ~= nil then
        self.InterActivePanel:OnUpdateItem(self.SelectItem.Data)
    end
end

-- 界面数据更新
function UIGuildForm:OnUpdateForm(obj, sender)
    local _info = GameCenter.GuildSystem.GuildInfo

    self.MyGuildContriNumLabel.text = tostring(GameCenter.ItemContianerSystem:GetEconomyWithType(ItemTypeCode.UnionContribution))
    self.GuildNameLabel.text = _info.name
    self.LeaderNameLabel.text = _info.leaderName
    self.GuildLvLabel.text = UIUtils.CSFormat(DataConfig.DataMessageString.Get("UI_GUILED_LEVELNUM"), _info.lv)
    self.GuildPowerLabel.text = tostring(_info.fighting)
    self.GuildMoneyLabel.text = tostring(_info.guildMoney)
    if _info.notice == nil or _info.notice == "" then
        self.GuildNoticeLabel.text = DataConfig.DataMessageString.Get("GUILD_NOTICE_EDIT")
    else
        self.GuildNoticeLabel.text = _info.notice
    end
    self.ContributeIcon:UpdateIcon(L_ItemBase.GetItemIcon(UnityUtils.GetObjct2Int(ItemTypeCode.UnionContribution)))
    self.GuildRankLabel.text = tostring(_info.RankNum)
    self.GuildNumLabel.text = tostring(_info.memberNum)

    self:OnSetButtonShow()
    self.SetPanel:OnUpdateForm()
end

--帮贡变化
function UIGuildForm:SetUnionContribution(obj, sender)
    if obj ~= nil then
        local _type = UnityUtils.GetObjct2Int(obj)
        if _type == UnityUtils.GetObjct2Int(ItemTypeCode.UnionContribution) then
            self.MyGuildContriNumLabel.text = tostring(GameCenter.ItemContianerSystem:GetEconomyWithType(ItemTypeCode.UnionContribution))
        end
    end
end

--公告设置返回
function UIGuildForm:EventOnSetNoticeBack(obj, sender)
    if obj ~= nil then
        self.GuildNoticeLabel.text = tostring(obj)
    end
end

--成员列表更新
function UIGuildForm:OnUpdateMemberList(obj, sender)
    self.OfficalPanel:OnUpdateItem()
    self:OnRefruseMemberList()
    local _info = GameCenter.GuildSystem.GuildInfo
    local _guildConfig = DataConfig.DataGuildUp[10000 + _info.lv]
    if _guildConfig ~= nil then
        self.GuildActiveLabel.text = UIUtils.CSFormat("{0}/{1} ( [ff0000]在线{2}人[-] )", _info.memberNum, _guildConfig.BaseNum, GameCenter.GuildSystem:OnGetOnLineNum())
    end
end

--事件触发交互面板关闭
function UIGuildForm:OnInterActiveClose(obj, sender)
    self.InterActivePanel:Close()
    if self.SelectItem ~= nil then
        self.SelectItem:OnSetIsEnable(true)
    end
end

--事件触发设置面板开启
function UIGuildForm:OnSetPanelOpen(obj, sender)
    self.SetPanel:Open()
end

--事件触发申请列表更新
function UIGuildForm:OnApplyListUpdate(obj, sender)
    if self.ApplyPanel.Go.activeSelf then
        self.ApplyPanel:OnUpdateForm()
    end
end

--列表滑动区更新
function UIGuildForm:OnRefruseMemberList()
    local _info = GameCenter.GuildSystem.GuildMemberList
    for i = 0, self.MemberTableTrans.childCount - 1 do
        local go = self.MemberTableTrans:GetChild(i).gameObject
        go:SetActive(false)
    end

    for i = 0, _info.Count - 1 do
        local go = nil;
        if i >= self.MemberTableTrans.childCount then
            go = self.MemberItem:Clone()
        else
            go = L_ListItem:OnFirstShow(self.MemberTableTrans:GetChild(i))
        end
        if go ~= nil then
            go.CallBack = Utils.Handler(self.OnClickList, self)
            go:SetData(_info[i]);
            go.Go:SetActive(true);
        else
            go.Go:SetActive(false);
        end
    end
    self.MemberTable:Reposition()
    self.MemberScroll:ResetPosition()
end

-- 根据玩家职位设置界面按钮显示
function UIGuildForm:OnSetButtonShow()
    local g = DataConfig.DataGuildOfficial[GameCenter.GuildSystem.Rank]
    if g ~= nil then
        self.EnterSceneBtnGo:SetActive(true)
        self.OfficalBtnGo:SetActive(g.ModifyOfficeAccording == 1)
    else
        self.EnterSceneBtnGo:SetActive(false)
        self.OfficalBtnGo:SetActive(false)
    end
end
return UIGuildForm