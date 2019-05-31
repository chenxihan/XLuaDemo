------------------------------------------------
--作者： yangqf
--日期： 2019-5-7
--文件： UIDNYFCopyMainForm.lua
--模块： UIDNYFCopyMainForm
--描述： 大能遗府副本界面
------------------------------------------------

local UICopyStarTipsPanel = require "UI.Forms.UIDNYFCopyMainForm.UICopyStarTipsPanel"

--//模块定义
local UIDNYFCopyMainForm = {
    --右上角trans
    RightTopTrans = nil,        --transform
    --离开按钮
    LeaveBtn = nil,             --button
    --商店按钮
    ShopBtn = nil,              --button
    --副本描述
    Desc = nil,
    --星级展示界面
    StarTipsPanel = nil,
    --3星时间
    Star3Time = 180,
    --2星时间
    Star2Time = 120,
    --副本描述
    DescCfg = nil,
}

--继承Form函数
function UIDNYFCopyMainForm:OnRegisterEvents()
    self:RegisterEvent(UIEventDefine.UIDNYFCopyMainForm_OPEN,self.OnOpen);
    self:RegisterEvent(UIEventDefine.UIDNYFCopyMainForm_CLOSE,self.OnClose);
    self:RegisterEvent(LogicEventDefine.EID_EVENT_ON_MAINMENU_OPEN, self.OnMainMenuOpen);
    self:RegisterEvent(LogicEventDefine.EID_EVENT_ON_MAINMENU_CLOSE,self.OnMainMenuClose);
end

function UIDNYFCopyMainForm:OnFirstShow()
    self.RightTopTrans = UIUtils.FindTrans(self.Trans, "RightTop");
    self.LeaveBtn = UIUtils.FindBtn(self.Trans, "RightTop/Leave");
    self.ShopBtn = UIUtils.FindBtn(self.Trans, "RightTop/Shop");
    UIUtils.AddBtnEvent(self.LeaveBtn, self.OnLeaveBtnClick, self);
    UIUtils.AddBtnEvent(self.ShopBtn, self.OnShopBtnClick, self);
    self.CSForm.UIRegion = UIFormRegion.MainRegion;
    self.CSForm:AddAlphaPosAnimation(self.RightTopTrans, 0, 1, 0, 130, 0.5, false, false);

    self.Desc = UIUtils.FindLabel(self.Trans, "Left/Desc");
    self.StarTipsPanel = UICopyStarTipsPanel:OnFirstShow(UIUtils.FindTrans(self.Trans, "LeftTop/StarTips"), self, self);
    local _timeCfg = DataConfig.DataGlobal[1294];
    if _timeCfg ~= nil then
        local _timeList = Utils.SplitStr(_timeCfg.Params, ';');
        self.Star2Time = _timeList[1];
        self.Star3Time = _timeList[2];
    end

    self.DescCfg = List:New();
    self.DescCfg:Add("将怪物拉到一起击杀会大幅提高效率");
    self.DescCfg:Add("优先击杀小怪");
    self.DescCfg:Add("优先击杀小怪");
    self.DescCfg:Add("优先击杀BOSS");
    self.DescCfg:Add("优先击杀小怪");
    self.DescCfg:Add("收集符文后攻击暴涨");
    self.DescCfg:Add("优先找到特殊怪进行击杀");
    self.DescCfg:Add("优先击杀BOSS");
end

function UIDNYFCopyMainForm:OnShowAfter()
   self.CSForm:PlayShowAnimation(self.RightTopTrans);
   self.FrontUpdateTime = -1;
end

function UIDNYFCopyMainForm:OnHideBefore()
   
end

--更新
function UIDNYFCopyMainForm:Update(dt)
    self.StarTipsPanel:Update(dt);
end

--开启事件
function UIDNYFCopyMainForm:OnOpen(msg, sender)
    self.CSForm:Show(sender);
    local _copyCfg = DataConfig.DataCloneMap[msg.copyId];
    if _copyCfg ~= nil then
        self.StarTipsPanel:Show(_copyCfg, self.Star3Time, self.Star2Time);
    end
    if msg.type > 0 and msg.type <= #self.DescCfg then
        self.Desc.text = self.DescCfg[msg.type];
    end
end

--关闭事件
function UIDNYFCopyMainForm:OnClose(obj, sender)
    self.CSForm:Hide();
end

--主界面菜单打开处理
function UIDNYFCopyMainForm:OnMainMenuOpen(obj, sender)
    self.CSForm:PlayHideAnimation(self.RightTopTrans);
end

--主界面菜单关闭处理
function UIDNYFCopyMainForm:OnMainMenuClose(obj, sender)
    self.CSForm:PlayShowAnimation(self.RightTopTrans);
end

--离开按钮点击
function UIDNYFCopyMainForm:OnLeaveBtnClick()
    GameCenter.MapLogicSystem:SendLeaveMapMsg(true);
end

--商店按钮点击
function UIDNYFCopyMainForm:OnShopBtnClick()
    GameCenter.MainFunctionSystem:DoFunctionCallBack(FunctionStartIdCode.Mall, nil);
end

return UIDNYFCopyMainForm;