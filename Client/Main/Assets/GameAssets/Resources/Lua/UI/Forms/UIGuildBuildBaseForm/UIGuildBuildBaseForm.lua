------------------------------------------------
--作者： 何健
--日期： 2019-05-7
--文件： UIGuildBuildBaseForm.lua
--模块： UIGuildBuildBaseForm
--描述： 公会建筑面板
------------------------------------------------

UIGuildBuildItem = require "UI.Forms.UIGuildBuildBaseForm.UIGuildBuildItem"
UIGuildBuildUpPanel = require "UI.Forms.UIGuildBuildBaseForm.UIGuildBuildUpPanel"

local UIGuildBuildBaseForm = {
    --宗派名字
    GuildNameLabel = nil,
    --宗派等级
    GuildLevelLabel = nil,
    --宗派人数
    GuildNumLabel = nil,
    --宗派战力
    GuildPowerLabel = nil,
    --宗派工资
    GuildWagesLabel = nil,
    --领取工资按钮
    GetWagesBtn = nil,
    GetWagesRedGo = nil,
    --宗派红包按钮
    RedPackagesBtn = nil,
    BuildList = List:New(),
    --建筑升级面板
    BuildUpPanel = nil,
}

--继承Form函数
function UIGuildBuildBaseForm:OnRegisterEvents()
	self:RegisterEvent(UIEventDefine.UIGuildBuildBaseForm_OPEN, self.OnOpen)
	self:RegisterEvent(UIEventDefine.UIGuildBuildBaseForm_CLOSE, self.OnClose)
    self:RegisterEvent(LogicEventDefine.EID_EVENT_GUILD_GUILDDONATECOUNT_UPDATE, self.OnUpdateDonateCount)
    self:RegisterEvent(LogicEventDefine.EID_EVENT_GUILD_OUTLINEITEM_UPDATE, self.OnUpdateWagesCount)
    self:RegisterEvent(LogicEventDefine.EID_EVENT_GUILD_BASEINFOCHANGE_UPDATE, self.OnSetMoney)
    self:RegisterEvent(LogicEventDefine.EID_EVENT_GUILD_GUILDBUILDINGLV_UPDATE, self.OnUpdateForm)
    self:RegisterEvent(LogicEventDefine.EID_EVENT_GUILD_OPENBUILDUPPANEL, self.OnOpenBuildUpPanel)
end

function UIGuildBuildBaseForm:OnFirstShow()
    self:FindAllComponents()
    self.CSForm:AddAlphaAnimation()
end
function UIGuildBuildBaseForm:OnHideBefore()
end
function UIGuildBuildBaseForm:OnShowAfter()
    self:OnRefruseForm()
    self.BuildUpPanel:Close()
end

--查找UI上各个控件
function UIGuildBuildBaseForm:FindAllComponents()
    local trans = self.Trans

    self.GuildNameLabel = UIUtils.FindLabel(trans, "Top/GuildNameLabel")
    self.GuildLevelLabel = UIUtils.FindLabel(trans, "Top/GuildLevelLabel")
    self.GuildNumLabel = UIUtils.FindLabel(trans, "Top/GuildCountLabel")
    self.GuildPowerLabel = UIUtils.FindLabel(trans, "Top/GuildPowerLabel")
    self.GuildWagesLabel = UIUtils.FindLabel(trans, "Bottom/GuildWagesLabel")
    self.GetWagesBtn = UIUtils.FindBtn(trans, "Bottom/WagesBtn")
    self.GetWagesRedGo = UIUtils.FindGo(trans, "Bottom/WagesBtn/Red")
    self.RedPackagesBtn = UIUtils.FindBtn(trans, "Bottom/RedPackageBtn")
    self.BuildUpPanel = UIGuildBuildUpPanel:OnFirstShow(UIUtils.FindTrans(trans, "BuildUpPanel"))

    local _buildRootTrans = UIUtils.FindTrans(trans, "Center")
    if _buildRootTrans ~= nil then
        for i = 0, _buildRootTrans.childCount - 1 do
            local _build = UIGuildBuildItem:New(_buildRootTrans:GetChild(i), self)
            self.BuildList:Add(_build)
        end
    end

    UIUtils.AddBtnEvent(self.GetWagesBtn, self.OnWagesBtnClick, self)
    UIUtils.AddBtnEvent(self.RedPackagesBtn, self.OnRedPackageBtnClick, self)
end

--领取工资按钮点击
function UIGuildBuildBaseForm:OnWagesBtnClick()
    GameCenter.GuildSystem:ReqGetOfflineExpTime()
end

--宗派红包按钮点击
function UIGuildBuildBaseForm:OnRedPackageBtnClick()
    GameCenter.PushFixEvent(UIEventDefine.UIRedPacketForm_OPEN, nil, self.CSForm)
end

--刷新界面显示
function UIGuildBuildBaseForm:OnRefruseForm()
    for i = 1, #self.BuildList do
        self.BuildList[i]:OnRefruseForm()
    end
    local _data = GameCenter.GuildSystem.GuildInfo
    self.GuildNameLabel.text = _data.name
    self.GuildNumLabel.text = tostring(_data.memberNum)
    self.GuildPowerLabel.text = tostring(_data.fighting)
    self.GuildLevelLabel.text = tostring(_data.lv)
    self.GetWagesRedGo:SetActive(GameCenter.GuildSystem.CanGetOfflineExpTime)
    self.GetWagesBtn.isEnabled = self.GetWagesRedGo.activeSelf
end

--捐献次数更新时，更新界面上的红点
function UIGuildBuildBaseForm:OnUpdateDonateCount(obj, sender)
    for i = 1, #self.BuildList do
        local _buildID = tonumber(self.BuildList[i].RootTrans.name)
        if _buildID == GuildBuildEnum.GuildShrine then
            self.BuildList[i].RedPointGo:SetActive(GameCenter.MainFunctionSystem:GetAlertFlag(FunctionStartIdCode.GuildTabDonate))
        end
    end
end

--宗派工资更新时，更新界面上的红点
function UIGuildBuildBaseForm:OnUpdateWagesCount(obj, sender)    
    self.GetWagesRedGo:SetActive(GameCenter.GuildSystem.CanGetOfflineExpTime)
    self.GetWagesBtn.isEnabled = self.GetWagesRedGo.activeSelf
end

--宗派基础信息变化时，更新建筑升级界面的宗派资金
function UIGuildBuildBaseForm:OnSetMoney(obj, sender)
    self.BuildUpPanel:OnSetMoney()
end

--建筑升级返回后，更新建筑升级界面
function UIGuildBuildBaseForm:OnUpdateForm(obj, sender)
    self.BuildUpPanel:OnRefreshForm()
end

--建筑升级界面打开
function UIGuildBuildBaseForm:OnOpenBuildUpPanel(obj, sender)
    self.BuildUpPanel:Open()
end
return UIGuildBuildBaseForm