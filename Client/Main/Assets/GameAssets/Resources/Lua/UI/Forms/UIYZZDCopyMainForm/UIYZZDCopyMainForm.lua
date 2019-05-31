------------------------------------------------
--作者： yangqf
--日期： 2019-5-7
--文件： UIYZZDCopyMainForm.lua
--模块： UIYZZDCopyMainForm
--描述： 勇者之巅副本UI
------------------------------------------------
local UIItem = require "UI.Components.UIItem";

--//模块定义
local UIYZZDCopyMainForm = {
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
    --当前击杀数
    CurKillCount = nil,
    --物品的grid
    ItemGrid = nil,
    --奖励的物品
    AwardItems = nil,
    --上次更新剩余时间的秒数
    FrontUpdateTime = -1,
}

--继承Form函数
function UIYZZDCopyMainForm:OnRegisterEvents()
    self:RegisterEvent(UIEventDefine.UIYZZDCopyMainForm_OPEN,self.OnOpen);
    self:RegisterEvent(UIEventDefine.UIYZZDCopyMainForm_CLOSE,self.OnClose);
    self:RegisterEvent(LogicEventDefine.EID_EVENT_ON_MAINMENU_OPEN, self.OnMainMenuOpen);
    self:RegisterEvent(LogicEventDefine.EID_EVENT_ON_MAINMENU_CLOSE,self.OnMainMenuClose);
end

function UIYZZDCopyMainForm:OnFirstShow()
    self.RightTopTrans = UIUtils.FindTrans(self.Trans, "RightTop");
    self.LeaveBtn = UIUtils.FindBtn(self.Trans, "RightTop/Leave");
    self.ShopBtn = UIUtils.FindBtn(self.Trans, "RightTop/Shop");
    UIUtils.AddBtnEvent(self.LeaveBtn, self.OnLeaveBtnClick, self);
    UIUtils.AddBtnEvent(self.ShopBtn, self.OnShopBtnClick, self);

    self.CurLevel = UIUtils.FindLabel(self.Trans, "Left/Back/Title/Level")
    self.RemainTime = UIUtils.FindLabel(self.Trans, "Left/Back/Back/TimeValue")
    self.CurKillCount = UIUtils.FindLabel(self.Trans, "Left/Back/Back/KillCount")
    self.ItemGrid = UIUtils.FindGrid(self.Trans, "Left/Back/Back/Grid")
    self.AwardItems = {};
    for i = 1, 4 do
        self.AwardItems[i] = UIItem:New(UIUtils.FindTrans(self.Trans, string.format("Left/Back/Back/Grid/%d", i)));
    end

    self.CSForm.UIRegion = UIFormRegion.MainRegion;
    self.CSForm:AddAlphaPosAnimation(self.RightTopTrans, 0, 1, 0, 130, 0.5, false, false);
end

function UIYZZDCopyMainForm:OnShowAfter()
   self.CSForm:PlayShowAnimation(self.RightTopTrans);
   self.FrontUpdateTime = -1;
end

function UIYZZDCopyMainForm:OnHideBefore()
   
end

--更新
function UIYZZDCopyMainForm:Update(dt)
    Debug.Log("===========XXXXXXXXXXXXXX")
    if GameCenter.MapLogicSystem.ActiveLogic ~= nil and GameCenter.MapLogicSystem.ActiveLogic.RemainTime ~= nil then
        local _remianTime = math.floor(GameCenter.MapLogicSystem.ActiveLogic.RemainTime);
        if _remianTime ~= self.FrontUpdateTime then
            self.FrontUpdateTime = _remianTime;
            local _min = _remianTime // 60;
            local _sec = _remianTime - (_min * 60);
            self.RemainTime.text =  DataConfig.DataMessageString.Get("C_SZZQ_TIME", _min, _sec);
        end
    end
end

--开启事件
function UIYZZDCopyMainForm:OnOpen(obj, sender)
    self.CSForm:Show(sender);
    self:RefreshPageInfo(obj);
end

--关闭事件
function UIYZZDCopyMainForm:OnClose(obj, sender)
    self.CSForm:Hide();
end

--刷新界面
function UIYZZDCopyMainForm:RefreshPageInfo(msg)
    if msg == nil then
        return;
    end
    self.CurLevel.text = DataConfig.DataMessageString.Get("C_YZZD_CURLEVEL", msg.floor);
    self.CurKillCount.text = DataConfig.DataMessageString.Get("C_YZZD_CURKILL", msg.nowNum, msg.needNum);
    local _infoCount = #msg.info
    for i = 1, 4 do
        if i <= _infoCount then
            self.AwardItems[i].RootGO:SetActive(true);
            self.AwardItems[i]:InItWithCfgid(msg.info[i].modelId, msg.info[i].num, false, false);
        else
            self.AwardItems[i].RootGO:SetActive(false);
        end
    end
    self.ItemGrid:Reposition();
end

--主界面菜单打开处理
function UIYZZDCopyMainForm:OnMainMenuOpen(obj, sender)
    self.CSForm:PlayHideAnimation(self.RightTopTrans);
end

--主界面菜单关闭处理
function UIYZZDCopyMainForm:OnMainMenuClose(obj, sender)
    self.CSForm:PlayShowAnimation(self.RightTopTrans);
end

--离开按钮点击
function UIYZZDCopyMainForm:OnLeaveBtnClick()
    GameCenter.MapLogicSystem:SendLeaveMapMsg(true);
end

--商店按钮点击
function UIYZZDCopyMainForm:OnShopBtnClick()
    GameCenter.MainFunctionSystem:DoFunctionCallBack(FunctionStartIdCode.Mall, nil);
end

return UIYZZDCopyMainForm;