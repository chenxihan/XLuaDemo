------------------------------------------------
--作者： dhq
--日期： 2019-05-13
--文件： UICupidPanel.lua
--模块： UICupidPanel
--描述： 婚姻红娘界面
------------------------------------------------

--//模块定义
local UICupidPanel = {
    --当前transform
    Trans = nil,
    --父
    Parent = nil,
    --动画模块
    AnimModule = nil,
    BackBtn = nil,
    MarryBtn = nil,
    DivorceBtn = nil,
    MarryUIGo = nil,
    DivorceUIGo = nil,
}

function UICupidPanel:OnFirstShow(trans, parent)
    self.Trans = trans
    self.Parent = parent

    --创建动画模块
    self.AnimModule = UIAnimationModule(self.Trans)
    --添加一个动画
    self.AnimModule:AddAlphaAnimation()

    self.BackBtn = UIUtils.FindBtn(self.Trans, "BackBtn")
    UIUtils.AddBtnEvent(self.BackBtn, self.OnBackBtnClick, self)
    self.MarryBtn = UIUtils.FindBtn(self.Trans, "MarryUI/MarryBtn")
    UIUtils.AddBtnEvent(self.MarryBtn, self.OnMarryBtnClick, self)
    self.DivorceBtn = UIUtils.FindBtn(self.Trans, "MarryUI/DivorceBtn")
    UIUtils.AddBtnEvent(self.DivorceBtn, self.OnDivorceBtnClick, self)

    self.EnforceBtn = UIUtils.FindBtn(self.Trans, "DivorceUI/EnforceBtn")
    UIUtils.AddBtnEvent(self.EnforceBtn, self.OnEnforceBtnClick, self)
    self.DetermineBtn = UIUtils.FindBtn(self.Trans, "DivorceUI/DetermineBtn")
    UIUtils.AddBtnEvent(self.DetermineBtn, self.OnDetermineBtnClick, self)

    self.MarryUIGo = UIUtils.FindGo(self.Trans, "MarryUI")
    self.DivorceUIGo = UIUtils.FindGo(self.Trans, "DivorceUI")
    
    self.MarryUIGo:SetActive(true)
    self.DivorceUIGo:SetActive(false)
    self.Trans.gameObject:SetActive(false)
    return self
end

function UICupidPanel:Show()
    --播放开启动画
    self.AnimModule:PlayEnableAnimation()
end

function UICupidPanel:Hide()
    --播放关闭动画
    self.AnimModule:PlayDisableAnimation()
    self.Parent:IsHideInfoPanel(false);
end

function UICupidPanel:HideSelf()
    self.AnimModule:PlayDisableAnimation()
end

function UICupidPanel:OnBackBtnClick()
    if self.MarryUIGo.activeSelf then
        self:Hide()
    else
        self.MarryUIGo:SetActive(true)
        self.DivorceUIGo:SetActive(false)
    end
end

function UICupidPanel:OnMarryBtnClick()
    self.Parent.MarryProcessPanel:Show()
    self:HideSelf()
end

function UICupidPanel:OnDivorceBtnClick()
    self.DivorceUIGo:SetActive(true)
    self.MarryUIGo:SetActive(false)
end

function UICupidPanel:OnEnforceBtnClick()
    
end

function UICupidPanel:OnDetermineBtnClick()
    
end

return UICupidPanel