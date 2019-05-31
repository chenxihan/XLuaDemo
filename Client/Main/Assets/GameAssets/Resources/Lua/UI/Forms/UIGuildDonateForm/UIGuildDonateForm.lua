------------------------------------------------
--作者： 何健
--日期： 2019-05-27
--文件： UIGuildDonateForm.lua
--模块： UIGuildDonateForm
--描述： 宗派捐献界面
------------------------------------------------
local L_DonateItem = require "UI.Forms.UIGuildDonateForm.UIGuildDonateItem"
local L_ItemBase = CS.Funcell.Code.Logic.ItemBase
local UIGuildDonateForm = {
    --关闭按钮
    CloseBtn = nil,
    --我的帮贡
    MyContributeLabel = nil,
    --宗派资金
    GuildMoneyLabel = nil,
    GuildMoneyIcon = nil,
    DonateItemList = List:New(),
}

function UIGuildDonateForm:OnRegisterEvents()
	self:RegisterEvent(UIEventDefine.UIGuildDonateForm_OPEN, self.OnOpen)
	self:RegisterEvent(UIEventDefine.UIGuildDonateForm_CLOSE, self.OnClose)
    self:RegisterEvent(LogicEventDefine.EID_EVENT_GUILD_BASEINFOCHANGE_UPDATE, self.OnUpdateForm)
    self:RegisterEvent(LogicEventDefine.EVENT_COIN_CHANGE_UPDATE, self.OnUpdateMyContribute)
    self:RegisterEvent(LogicEventDefine.EID_EVENT_GUILD_GUILDDONATECOUNT_UPDATE, self.OnUpdateDonateCount)
end

function UIGuildDonateForm:OnFirstShow()
    self:FindAllComponents()
    self.CSForm:AddAlphaAnimation()
end

function UIGuildDonateForm:OnShowAfter()
    self:OnUpdateForm()
    self:OnUpdateDonateCount()
    self:OnUpdateMyContribute()
    GameCenter.Network.Send("MSG_Guild.ReqGuildDonateCount", {})
end

function UIGuildDonateForm:FindAllComponents()
    self.CloseBtn = UIUtils.FindBtn(self.Trans, "CloseBtn")
    UIUtils.AddBtnEvent(self.CloseBtn, self.OnClickCloseBtn, self)
    local _icon = UIUtils.RequireUIIconBase(UIUtils.FindTrans(self.Trans, "Bottom/MyDonateLabel/Icon"))
    _icon:UpdateIcon(L_ItemBase.GetItemIcon(UnityUtils.GetObjct2Int(ItemTypeCode.UnionContribution)))
    self.MyContributeLabel = UIUtils.FindLabel(self.Trans, "Bottom/MyDonateLabel")
    self.GuildMoneyLabel = UIUtils.FindLabel(self.Trans, "Bottom/GuildMoneyLabel")
    self.GuildMoneyIcon = UIUtils.RequireUIIconBase(UIUtils.FindTrans(self.Trans, "Bottom/GuildMoneyLabel/Icon"))
    self.GuildMoneyIcon:UpdateIcon(865)
    local _itemTrans = UIUtils.FindTrans(self.Trans, "Center/Center")
    local i = 1
    for _, v in pairs(DataConfig.DataGuildDonate) do
        if _itemTrans.childCount >= i then
            local _item = _itemTrans:GetChild(i - 1)
            self.DonateItemList:Add(L_DonateItem:OnFirstShow(_item, v))
            i = i + 1
        end
    end
end

--点击界面上关闭按钮
function UIGuildDonateForm:OnClickCloseBtn()
    self:OnClose()
end

--宗派基本数据更新时，更新宗派资金
function UIGuildDonateForm:OnUpdateForm(obj, sender)
    self.GuildMoneyLabel.text = tostring(GameCenter.GuildSystem.GuildInfo.guildMoney)
end

--捐献次数更新时，更新捐献按钮状态
function UIGuildDonateForm:OnUpdateDonateCount(obj, sender)
    for i = 1, #self.DonateItemList do
        self.DonateItemList[i]:OnSetBtnGray(GameCenter.GuildSystem.GuildDonateCount > 0)
    end
end

--货币更新时，更新我的会贡
function UIGuildDonateForm:OnUpdateMyContribute(obj, sender)
    if obj ~= nil then
        local _type = tonumber(obj)
        if _type ~= UnityUtils.GetObjct2Int(ItemTypeCode.UnionContribution) then
            return
        end
    end
    self.MyContributeLabel.text = tostring(GameCenter.ItemContianerSystem:GetEconomyWithType(ItemTypeCode.UnionContribution))
end
return UIGuildDonateForm