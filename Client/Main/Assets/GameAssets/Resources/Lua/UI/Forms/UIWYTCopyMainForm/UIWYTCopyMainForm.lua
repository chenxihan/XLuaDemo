------------------------------------------------
--作者： yangqf
--日期： 2019-5-13
--文件： UIWYTCopyMainForm.lua
--模块： UIWYTCopyMainForm
--描述： 万妖塔副本UI
------------------------------------------------

--//模块定义
local UIWYTCopyMainForm = {
    --右上角trans
    RightTopTrans = nil,        --transform
    --离开按钮
    LeaveBtn = nil,             --button
    --商店按钮
    ShopBtn = nil,              --button
    --当前层数
    CurLevel = nil,
    --剩余时间
    RemainTime = nil,
    --上次更新剩余时间的秒数
    FrontUpdateTime = -1,
}

--继承Form函数
function UIWYTCopyMainForm:OnRegisterEvents()
    self:RegisterEvent(UIEventDefine.UIWYTCopyMainForm_OPEN,self.OnOpen);
    self:RegisterEvent(UIEventDefine.UIWYTCopyMainForm_CLOSE,self.OnClose);
    self:RegisterEvent(LogicEventDefine.EID_EVENT_ON_MAINMENU_OPEN, self.OnMainMenuOpen);
    self:RegisterEvent(LogicEventDefine.EID_EVENT_ON_MAINMENU_CLOSE,self.OnMainMenuClose);
end

function UIWYTCopyMainForm:OnFirstShow()
    self.RightTopTrans = UIUtils.FindTrans(self.Trans, "RightTop");
    self.LeaveBtn = UIUtils.FindBtn(self.Trans, "RightTop/Leave");
    self.ShopBtn = UIUtils.FindBtn(self.Trans, "RightTop/Shop");
    UIUtils.AddBtnEvent(self.LeaveBtn, self.OnLeaveBtnClick, self);
    UIUtils.AddBtnEvent(self.ShopBtn, self.OnShopBtnClick, self);

    self.CurLevel = UIUtils.FindLabel(self.Trans, "RightTop/InfoBack/CurLevel/Value")
    self.RemainTime = UIUtils.FindLabel(self.Trans, "RightTop/InfoBack/RemainTime/Value")
    self.CSForm.UIRegion = UIFormRegion.MainRegion;
    self.CSForm:AddAlphaPosAnimation(self.RightTopTrans, 0, 1, 0, 130, 0.5, false, false);
end

function UIWYTCopyMainForm:OnShowAfter()
   self.CSForm:PlayShowAnimation(self.RightTopTrans);
   self.FrontUpdateTime = -1;
end

function UIWYTCopyMainForm:OnHideBefore()
   
end

--更新
function UIWYTCopyMainForm:Update(dt)
    if GameCenter.MapLogicSystem.ActiveLogic ~= nil and GameCenter.MapLogicSystem.ActiveLogic.RemainTime ~= nil then
        local _remianTime = math.floor(GameCenter.MapLogicSystem.ActiveLogic.RemainTime);
        if _remianTime ~= self.FrontUpdateTime then
            self.FrontUpdateTime = _remianTime;
            local _min = _remianTime // 60;
            local _sec = _remianTime - (_min * 60);
            self.RemainTime.text =  string.format("%02d:%02d", _min, _sec);
        end
    end
end

--开启事件
function UIWYTCopyMainForm:OnOpen(obj, sender)
    self.CSForm:Show(sender);
    self:RefreshPageInfo(obj);
end

--关闭事件
function UIWYTCopyMainForm:OnClose(obj, sender)
    self.CSForm:Hide();
end

--刷新界面
function UIWYTCopyMainForm:RefreshPageInfo(mapLogic)
    if mapLogic == nil then
        return;
    end
    self.CurLevel.text = tostring(mapLogic.CurLevel);
end

--主界面菜单打开处理
function UIWYTCopyMainForm:OnMainMenuOpen(obj, sender)
    self.CSForm:PlayHideAnimation(self.RightTopTrans);
end

--主界面菜单关闭处理
function UIWYTCopyMainForm:OnMainMenuClose(obj, sender)
    self.CSForm:PlayShowAnimation(self.RightTopTrans);
end

--离开按钮点击
function UIWYTCopyMainForm:OnLeaveBtnClick()
    GameCenter.MapLogicSystem:SendLeaveMapMsg(true);
end

--商店按钮点击
function UIWYTCopyMainForm:OnShopBtnClick()
    GameCenter.MainFunctionSystem:DoFunctionCallBack(FunctionStartIdCode.Mall, nil);
end

return UIWYTCopyMainForm;