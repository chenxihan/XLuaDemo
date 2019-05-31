------------------------------------------------
--作者： dhq
--日期： 2019-05-13
--文件： UIEngagementPanel.lua
--模块： UIEngagementPanel
--描述： 婚姻订婚(缔结婚约)界面
------------------------------------------------

--//模块定义
local UIEngagementPanel = {
    --当前transform
    Trans = nil,
    --父
    Parent = nil,
    --动画模块
    AnimModule = nil,
    BackBtn = nil,
    -- 立即预约按钮
    EngBtn = nil,
}

function UIEngagementPanel:OnFirstShow(trans, parent)
    self.Trans = trans
    self.Parent = parent

    --创建动画模块
    self.AnimModule = UIAnimationModule(self.Trans)
    --添加一个动画
    self.AnimModule:AddAlphaAnimation()

    self.BackBtn = UIUtils.FindBtn(self.Trans, "BackBtn")
    UIUtils.AddBtnEvent(self.BackBtn, self.OnBackBtnClick, self)

    self.EngBtn = UIUtils.FindBtn(self.Trans, "EngBtn")
    UIUtils.AddBtnEvent(self.EngBtn, self.OnEngBtnClick, self)

    local _leftIconTrans = UIUtils.FindTrans(self.Trans, "Top/LeftIcon")
    local _rightIconTrans = UIUtils.FindTrans(self.Trans, "Top/RightIcon")
    self.LeftIcon = UnityUtils.RequireComponent(_leftIconTrans, "Funcell.GameUI.Form.UIIconBase")
    self.RightIcon = UnityUtils.RequireComponent(_rightIconTrans, "Funcell.GameUI.Form.UIIconBase")

    self.Trans.gameObject:SetActive(false)
    return self
end

function UIEngagementPanel:Show()
    --播放开启动画
    self.AnimModule:PlayEnableAnimation()
    self:UpdatePage()
end

function UIEngagementPanel:Hide()
    --播放关闭动画
    self.AnimModule:PlayDisableAnimation()
end

--关闭上层面板和此面板
function UIEngagementPanel:HideSelfAndParentPanel()
    self:Hide()
    self.Parent.MarryProcessPanel:Show()
end

-- --返回按钮
function UIEngagementPanel:OnBackBtnClick()
    self:HideSelfAndParentPanel()
end

--立即预约按钮
function UIEngagementPanel:OnEngBtnClick()
    self:Hide()
    self.Parent.AppointmentPanel:Show()
end

function UIEngagementPanel:UpdatePage()
    self.LeftIcon:UpdateIcon(318)
    self.RightIcon:UpdateIcon(319)
end

return UIEngagementPanel