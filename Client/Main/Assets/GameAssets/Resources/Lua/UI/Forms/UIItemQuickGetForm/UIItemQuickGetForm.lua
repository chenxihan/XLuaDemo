------------------------------------------------
--作者： yangqf
--日期： 2019-5-30
--文件： UIItemQuickGetForm.lua
--模块： UIItemQuickGetForm
--描述： 物品快速获取界面
------------------------------------------------

local UIItemQuickGetFunc = require "UI.Forms.UIItemQuickGetForm.UIItemQuickGetFunc";

--//模块定义
local UIItemQuickGetForm = {
    --关闭按钮
    CloseBtn = nil,
    --物品名字
    ItemName = nil,
    --物品icon
    ItemIcon = nil,
    --滑动列表
    ScrollView = nil,
    --grid
    Grid = nil,
    GridTrans = nil,
    --背景图片
    BackTex = nil,
    --功能资源
    FuncItemRes = nil,
    --功能资源列表
    FuncItemList = nil,
}

--继承Form函数
function UIItemQuickGetForm:OnRegisterEvents()
    self:RegisterEvent(UIEventDefine.UIItemQuickGetForm_OPEN,self.OnOpen);
    self:RegisterEvent(UIEventDefine.UIItemQuickGetForm_CLOSE,self.OnClose);
end

function UIItemQuickGetForm:OnFirstShow()
    self.CSForm:AddAlphaAnimation();
    self.CSForm.UIRegion = UIFormRegion.TopRegion;

    self.CloseBtn = UIUtils.FindBtn(self.Trans, "CloseBtn");
    UIUtils.AddBtnEvent(self.CloseBtn, self.OnCloseBtnClick, self);
    self.ItemName = UIUtils.FindLabel(self.Trans, "Back/Name/Value");
    self.ItemIcon = UIUtils.RequireUIIconBase(UIUtils.FindTrans(self.Trans, "Back/Icon"));
    self.ScrollView = UIUtils.FindScrollView(self.Trans, "Back/Scroll");
    self.Grid = UIUtils.FindGrid(self.Trans, "Back/Scroll/Grid");
    self.GridTrans = self.Grid.transform;
    self.BackTex = UIUtils.FindTex(self.Trans, "Back");
    self.FuncItemRes = UIUtils.FindTrans(self.Trans, "Back/Scroll/Grid/ItemRes");

    self.FuncItemList = List:New();
    for i = 0, self.GridTrans.childCount - 1 do
        self.FuncItemList:Add(UIItemQuickGetFunc:New(self.GridTrans:GetChild(i), self));
    end
end

function UIItemQuickGetForm:OnShowAfter()
    self.CSForm:LoadTexture(self.BackTex, AssetUtils.GetImageAssetPath(ImageTypeCode.UI, "bag_getbg2"));
end

function UIItemQuickGetForm:OnHideBefore()
end

--开启事件
function UIItemQuickGetForm:OnOpen(obj, sender)
    self.CSForm:Show(sender);
    self:RefreshPageInfo(obj);
end

--关闭事件
function UIItemQuickGetForm:OnClose(obj, sender)
    self.CSForm:Hide();
end

--关闭按钮
function UIItemQuickGetForm:OnCloseBtnClick()
    self:OnClose(nil, nil);
end

--刷新界面
function UIItemQuickGetForm:RefreshPageInfo(itemConfig)
    if itemConfig == nil or itemConfig.GetText == nil or string.len(itemConfig.GetText) <= 0 then
        self:OnClose(nil, nil);
        return;
    end

    self.ItemIcon:UpdateIcon(itemConfig.Icon);
    local _getCfg = Utils.SplitStrBySeps(itemConfig.GetText, {';','_'});
    local _count = #_getCfg;
    if _count <= 0 then
        self:OnClose(nil, nil);
        return;
    end

    for i = 1, _count do
        local _usedUI = nil;
        if i <= #self.FuncItemList then
            _usedUI = self.FuncItemList[i];
        else
            _usedUI = UIItemQuickGetFunc:New(UIUtils.Clone(self.FuncItemRes), self);
            self.FuncItemList:Add(_usedUI);
        end

        _usedUI:Refresh(tonumber(_getCfg[i][1]), _getCfg[i][3], tonumber(_getCfg[i][2]));
    end
    self.Grid:Reposition();
    self.ScrollView:ResetPosition();

    self.CSForm:RemoveChildTransAnimation(self.GridTrans);
    self.CSForm:AddChildAlphaPosAnimation(self.GridTrans, 0, 1, 50, 0, 0.2, 0.1, false, false);
    self.CSForm:PlayChildShowAnimation(self.GridTrans);
end

return UIItemQuickGetForm;