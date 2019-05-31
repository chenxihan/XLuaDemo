------------------------------------------------
--作者： yangqf
--日期： 2019-04-28
--文件： UICopyMapForm.lua
--模块： UICopyMapForm
--描述： 副本界面
------------------------------------------------

local UIListMenu = require "UI.Components.UIListMenu.UIListMenu";
local UICopySinglePanel = require "UI.Forms.UICopyMapForm.UICopySinglePanel";

--//模块定义
local UICopyMapForm = {
    --关闭按钮
    CloseBtn = nil,
    --单人副本分页
    SinglePanel = nil,
    --组队副本分页
    TeamPanel = nil,
    --列表菜单
    ListMenu = nil,
    --选择的子分页ID
    SelectChildID = nil,
}

--继承Form函数
function UICopyMapForm:OnRegisterEvents()
    self:RegisterEvent(UIEventDefine.UICopyMapForm_OPEN, self.OnOpen);
    self:RegisterEvent(UIEventDefine.UICopyMapForm_CLOSE, self.OnClose);
    self:RegisterEvent(LogicLuaEventDefine.EID_EVENT_UPDATE_TIAOZHANFUBEN, self.OnTowerCopyUpdate);
    self:RegisterEvent(LogicLuaEventDefine.EID_REFRESH_STARCOPY_PANEL, self.OnStarCopyUpdate);
end

function UICopyMapForm:OnFirstShow()
    self.CSForm:AddAlphaAnimation();

    self.CloseBtn = UIUtils.FindBtn(self.Trans, "Close");
    UIUtils.AddBtnEvent(self.CloseBtn, self.OnCloseBtnClick, self);

    self.SinglePanel = UICopySinglePanel:OnFirstShow(UIUtils.FindTrans(self.Trans, "DanRenPanel"), self, self);

    self.ListMenu = UIListMenu:OnFirstShow(self.CSForm, UIUtils.FindTrans(self.Trans, "UIListMenu"));
    self.ListMenu:ClearSelectEvent();
    self.ListMenu:AddSelectEvent(Utils.Handler(self.OnMenuSelect, self));

    self.ListMenu:AddIcon(UICopyMainPanelEnum.SinglePanel, "单人", FunctionStartIdCode.SingleCopyMap);
    self.ListMenu:AddIcon(UICopyMainPanelEnum.TeamPanel, "组队", FunctionStartIdCode.TeamCopyMap);
end

function UICopyMapForm:OnShowAfter()
end

function UICopyMapForm:OnHideBefore()
end

--开启事件
function UICopyMapForm:OnOpen(obj, sender)
    self.CSForm:Show(sender);
    self.SelectChildID = obj[2];
    self.ListMenu:SetSelectById(obj[1]);
end

--关闭事件
function UICopyMapForm:OnClose(obj, sender)
    self.CSForm:Hide();
end

--点击关闭按钮
function UICopyMapForm:OnCloseBtnClick()
    self.CSForm:Hide();
end

--挑战副本刷新事件
function UICopyMapForm:OnTowerCopyUpdate(obj, sender)
    self.SinglePanel:OnTowerCopyUpdate();
end

--星级副本刷新事件
function UICopyMapForm:OnStarCopyUpdate(obj, sender)
    self.SinglePanel:OnStarCopyUpdate();
end

--菜单选择事件
function UICopyMapForm:OnMenuSelect(id, select)
    if select == true then
        if id == UICopyMainPanelEnum.SinglePanel then
            self.SinglePanel:Show(self.SelectChildID);
        elseif id == UICopyMainPanelEnum.TeamPanel then
        end
    else
        if id == UICopyMainPanelEnum.SinglePanel then
            self.SinglePanel:Hide();
        elseif id == UICopyMainPanelEnum.TeamPanel then
        end
    end
end

return UICopyMapForm;