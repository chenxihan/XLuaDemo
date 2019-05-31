------------------------------------------------
--作者： dhq
--日期： 2019-05-13
--文件： UIMarryProcessPanel.lua
--模块： UIMarryProcessPanel
--描述： 婚姻流程界面
------------------------------------------------

--//模块定义
local UIMarryProcessPanel = {
    --当前transform
    Trans = nil,
    --父
    Parent = nil,
    --动画模块
    AnimModule = nil,
    BackBtn = nil,
    ProposeBtn = nil,
    EngagementBtn = nil,
    AppointmentBtn = nil,
    InviteBtn = nil,
    MarriedBtn = nil,
}

function UIMarryProcessPanel:OnFirstShow(trans, parent)
    self.Trans = trans
    self.Parent = parent

    --创建动画模块
    self.AnimModule = UIAnimationModule(self.Trans)
    --添加一个动画
    self.AnimModule:AddAlphaAnimation()

    self.BackBtn = UIUtils.FindBtn(self.Trans, "BackBtn")
    UIUtils.AddBtnEvent(self.BackBtn, self.OnBackBtnClick, self)

    self.ProposeBtn = UIUtils.FindBtn(self.Trans, "ProposeBtn")
    UIUtils.AddBtnEvent(self.ProposeBtn, self.OnProposeBtnClick, self)
    self.EngagementBtn = UIUtils.FindBtn(self.Trans, "EngagementBtn")
    UIUtils.AddBtnEvent(self.EngagementBtn, self.OnEngagementBtnClick, self)
    self.AppointmentBtn = UIUtils.FindBtn(self.Trans, "AppointmentBtn")
    UIUtils.AddBtnEvent(self.AppointmentBtn, self.OnAppointmentBtnClick, self)
    self.InviteBtn = UIUtils.FindBtn(self.Trans, "InviteBtn")
    UIUtils.AddBtnEvent(self.InviteBtn, self.OnInviteBtnClick, self)
    self.ConductBtn = UIUtils.FindBtn(self.Trans, "ConductBtn")
    UIUtils.AddBtnEvent(self.ConductBtn, self.OnConductBtnClick, self)
    self.MarriedBtn = UIUtils.FindBtn(self.Trans, "MarriedBtn")
    UIUtils.AddBtnEvent(self.MarriedBtn, self.OnMarriedBtnClick, self)

    self.Trans.gameObject:SetActive(false)
    return self
end

function UIMarryProcessPanel:Show()
    --播放开启动画
    self.AnimModule:PlayEnableAnimation()
end

function UIMarryProcessPanel:Hide()
    --播放关闭动画
    self.AnimModule:PlayDisableAnimation()
end

--关闭红娘面板和此面板，单独把CupidPanel拿出来写主要是玩家点ListMenu的时候需要关闭掉所有面板
function UIMarryProcessPanel:HideSelfAndCupidPanel()
    self.Parent.MarryProcessPanel:Hide()
    self.Parent.CupidPanel:Show()
end

--返回按钮
function UIMarryProcessPanel:OnBackBtnClick()
    self:HideSelfAndCupidPanel()
end

--求婚按钮
function UIMarryProcessPanel:OnProposeBtnClick()
    --self:Hide()
    self.Parent.MarryTypePanel:Show()
    self:Hide()
end

--订婚按钮(缔结婚姻)
function UIMarryProcessPanel:OnEngagementBtnClick()
    self.Parent.EngagementPanel:Show()
    self:Hide()
end

--预约婚宴按钮
function UIMarryProcessPanel:OnAppointmentBtnClick()
    self.Parent.AppointmentPanel:Show()
    self:Hide()
end

--邀请宾客按钮
function UIMarryProcessPanel:OnInviteBtnClick()
    self.Parent.InvitePanel:Show()
    self:Hide()
end

--举办婚宴按钮
function UIMarryProcessPanel:OnConductBtnClick()
    --self.Parent.AppointmentPanel:Show()
    --self:Hide()
end

--神仙眷侣按钮
function UIMarryProcessPanel:OnMarriedBtnClick()
    self.Parent.EngagementPanel:Show()
    self:Hide()
end

return UIMarryProcessPanel