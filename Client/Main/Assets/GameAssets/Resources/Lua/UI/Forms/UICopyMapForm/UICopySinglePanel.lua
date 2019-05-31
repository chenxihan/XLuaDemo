------------------------------------------------
--作者： yangqf
--日期： 2019-04-28
--文件： UICopySinglePanel.lua
--模块： UICopySinglePanel
--描述： 单人副本分页
------------------------------------------------

local UIListMenu = require "UI.Components.UIListMenu.UIListMenu"
local UITowerPanel = require "UI.Forms.UICopyMapForm.UITowerCopyPanel"
local UIStarPanel = require "UI.Forms.UICopyMapForm.UIStarCopyPanel"

--//模块定义
local UICopySinglePanel = {
    --当前transform
    Trans = nil,
    --父
    Parent = nil,
    --动画模块
    AnimModule = nil,
    --列表菜单
    ListMenu = nil,
    --爬塔副本
    TowerCopyPanel = nil,
    --星级副本
    StarCopyPanel = nil,
}

function UICopySinglePanel:OnFirstShow(trans, parent, rootForm)
    self.Trans = trans;
    self.Parent = parent;
    self.RootForm = rootForm;

    --创建动画模块
    self.AnimModule = UIAnimationModule(self.Trans);
    --添加一个动画
    self.AnimModule:AddAlphaAnimation();

    self.ListMenu = UIListMenu:OnFirstShow(self.Parent.CSForm, UIUtils.FindTrans(self.Trans, "UIListMenu"));
    self.ListMenu:ClearSelectEvent();
    self.ListMenu:AddSelectEvent(Utils.Handler(self.OnMenuSelect, self));
    self.ListMenu:AddIcon(UISingleCopyPanelEnum.TowerPanel, "爬塔副本", FunctionStartIdCode.TowerCopyMap);
    self.ListMenu:AddIcon(UISingleCopyPanelEnum.StarPanel, "星级副本", FunctionStartIdCode.StarCopyMap);

    self.TowerCopyPanel = UITowerPanel:OnFirstShow(UIUtils.FindTrans(self.Trans, "TowerCopy"), self, self.RootForm);
    self.StarCopyPanel = UIStarPanel:OnFirstShow(UIUtils.FindTrans(self.Trans, "StarCopy"), self, self.RootForm);

    self.Trans.gameObject:SetActive(false);
    return self;
end

function UICopySinglePanel:Show(childId)
    if childId ~= nil then
        self.ListMenu:SetSelectById(childId);
    else
        self.ListMenu:SetSelectById(UISingleCopyPanelEnum.TowerPanel);
    end
    --播放开启动画
    self.AnimModule:PlayEnableAnimation();
end

function UICopySinglePanel:Hide()
    --播放关闭动画
    self.AnimModule:PlayDisableAnimation();
end

function UICopySinglePanel:OnMenuSelect(id, select)
    if select then
        if id == UISingleCopyPanelEnum.TowerPanel then
            self.TowerCopyPanel:Show();
        elseif id == UISingleCopyPanelEnum.StarPanel then
            self.StarCopyPanel:Show();
        end
    else
        if id == UISingleCopyPanelEnum.TowerPanel then
            self.TowerCopyPanel:Hide();
        elseif id == UISingleCopyPanelEnum.StarPanel then
            self.StarCopyPanel:Hide();
        end
    end
end

--刷新挑战副本
function UICopySinglePanel:OnTowerCopyUpdate()
    self.TowerCopyPanel:RefreshPage();
end

--刷新星级副本
function UICopySinglePanel:OnStarCopyUpdate()
    self.StarCopyPanel:RefreshPage();
end

return UICopySinglePanel;