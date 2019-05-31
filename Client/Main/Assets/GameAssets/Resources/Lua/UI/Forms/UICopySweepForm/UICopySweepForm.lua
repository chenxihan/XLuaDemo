------------------------------------------------
--作者： yangqf
--日期： 2019-05-22
--文件： UICopySweepForm.lua
--模块： UICopySweepForm
--描述： 副本扫荡界面
------------------------------------------------

local UIItem = require "UI.Components.UIItem";

--//模块定义
local UICopySweepForm = {
    --取消按钮
    CanelBtn = nil,
    --确定按钮
    OkBtn = nil,
    --描述
    DescLabel = nil,
    --物品
    Item = nil,

    --副本ID
    CopyId = 0;
}

--继承Form函数
function UICopySweepForm:OnRegisterEvents()
    self:RegisterEvent(UIEventDefine.UICopySweepForm_OPEN, self.OnOpen);
    self:RegisterEvent(UIEventDefine.UICopySweepForm_CLOSE, self.OnClose);
end

function UICopySweepForm:OnFirstShow()
    self.CSForm:AddAlphaAnimation();

    self.CanelBtn = UIUtils.FindBtn(self.Trans, "Canel");
    UIUtils.AddBtnEvent(self.CanelBtn, self.OnCanelBtnClick, self);
    self.OkBtn = UIUtils.FindBtn(self.Trans, "OK");
    UIUtils.AddBtnEvent(self.OkBtn, self.OnOkBtnClick, self);
    self.DescLabel = UIUtils.FindLabel(self.Trans, "Desc");
    self.Item = UIItem:New(UIUtils.FindTrans(self.Trans, "UIItem"));
end

function UICopySweepForm:OnShowAfter()
end

function UICopySweepForm:OnHideBefore()
end

--开启事件
function UICopySweepForm:OnOpen(obj, sender)
    self.CSForm:Show(sender);
    local _copyCfg = obj;
    self.CopyId = _copyCfg.Id;
    if _copyCfg == nil then
        self:OnClose(nil, nil);
        return;
    end

    local _needItem = Utils.SplitStr(_copyCfg.Sweep, '_');
    if _needItem == nil or #_needItem < 2 then
        self:OnClose(nil, nil);
        return;
    end
    self.Item:InItWithCfgid(_needItem[1], _needItem[2], false, true);
    self.Item:BindBagNum();
end

--关闭事件
function UICopySweepForm:OnClose(obj, sender)
    self.CSForm:Hide();
end

--点击关闭按钮
function UICopySweepForm:OnCanelBtnClick()
    self:OnClose(nil, nil);
end

--点击确定按钮
function UICopySweepForm:OnOkBtnClick()
    GameCenter.CopyMapSystem:ReqSweepCopyMap(self.CopyId);
    self:OnClose(nil, nil);
end

return UICopySweepForm;