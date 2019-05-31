------------------------------------------------
--作者： yangqf
--日期： 2019-04-18
--文件： UIPlaneCopyMainForm.lua
--模块： UIPlaneCopyMainForm
--描述： 位面副本UI
------------------------------------------------

--//模块定义
local UIPlaneCopyMainForm = {
    RightTopTrans = nil,        --transform
    LeaveBtn = nil,             --button
    ShopBtn = nil,              --button
}

--继承Form函数
function UIPlaneCopyMainForm:OnRegisterEvents()
    self:RegisterEvent(UIEventDefine.UIPlaneCopyMainForm_OPEN, self.OnOpen)
    self:RegisterEvent(UIEventDefine.UIPlaneCopyMainForm_CLOSE, self.OnClose)
    self:RegisterEvent(LogicEventDefine.EID_EVENT_ON_MAINMENU_OPEN, self.OnMainMenuOpen)
    self:RegisterEvent(LogicEventDefine.EID_EVENT_ON_MAINMENU_CLOSE, self.OnMainMenuClose)
end

function UIPlaneCopyMainForm:OnFirstShow()
    self.RightTopTrans = UIUtils.FindTrans(self.Trans, "RightTop")
    self.LeaveBtn = UIUtils.FindBtn(self.Trans, "RightTop/Leave")
    self.ShopBtn = UIUtils.FindBtn(self.Trans, "RightTop/Shop")
    UIUtils.AddBtnEvent(self.LeaveBtn, self.OnLeaveBtnClick, self)
    UIUtils.AddBtnEvent(self.ShopBtn, self.OnShopBtnClick, self)

    self.CSForm:AddAlphaPosAnimation(self.RightTopTrans, 0, 1, 0, 130, 0.5, false, false)
end

function UIPlaneCopyMainForm:OnShowAfter()
   self.CSForm:PlayShowAnimation(self.RightTopTrans)
end

function UIPlaneCopyMainForm:OnHideBefore()
   
end

--开启事件
function UIPlaneCopyMainForm:OnOpen(obj, sender)
    self.CSForm:Show(sender)
end

--关闭事件
function UIPlaneCopyMainForm:OnClose(obj, sender)
    self.CSForm:Hide()
end

--主界面菜单打开处理
function UIPlaneCopyMainForm:OnMainMenuOpen(obj, sender)
    self.CSForm:PlayHideAnimation(self.RightTopTrans)
end

--主界面菜单关闭处理
function UIPlaneCopyMainForm:OnMainMenuClose(obj, sender)
    self.CSForm:PlayShowAnimation(self.RightTopTrans)
end

--离开按钮点击
function UIPlaneCopyMainForm:OnLeaveBtnClick()
    GameCenter.MapLogicSystem:SendLeaveMapMsg(false)
	GameCenter.PushFixEvent(LogicEventDefine.EID_EVENT_INITIATIVE_EXIT_PLANECOPY)
end

--商店按钮点击
function UIPlaneCopyMainForm:OnShopBtnClick()
    GameCenter.MainFunctionSystem:DoFunctionCallBack(FunctionStartIdCode.Mall, nil)
end

return UIPlaneCopyMainForm;