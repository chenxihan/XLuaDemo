------------------------------------------------
--作者： dhq
--日期： 2019-05-13
--文件： UIPreviewItem.lua
--模块： UIPreviewItem
--描述： 婚姻称号预览界面
------------------------------------------------
local UIPreviewItem = require "UI.Forms.UIMarriageForm.MarriageInfoPanel.UIPreviewItem"
--//模块定义
local UIAppellationPreviewPanel = {
    --当前transform
    Trans = nil,
    --父
    Parent = nil,
    --动画模块
    AnimModule = nil,
    BackBtn = nil,
    Grid = nil,
    --滑动区域称号的Item列表
    ItemList = nil,
    ItemRes = nil,
    --称号的数据
    TitleData = nil,
}

function UIAppellationPreviewPanel:OnFirstShow(trans, parent)
    self.Trans = trans
    self.Parent = parent

    --创建动画模块
    self.AnimModule = UIAnimationModule(self.Trans)
    --添加一个动画
    self.AnimModule:AddAlphaAnimation()

    self.BackBtn = UIUtils.FindBtn(self.Trans, "BackBtn")
    UIUtils.AddBtnEvent(self.BackBtn, self.OnBackBtnClick, self)

    self.ItemList = List:New();
    self.Grid = UIUtils.FindGrid(self.Trans, "Scroll View/Grid");
    self.ItemRes = UIUtils.FindGo(self.Trans, "Scroll View/Grid/Item");
    local _uiItem = UIPreviewItem:New(self.ItemRes, self);
    self.ItemList:Add(_uiItem);

    self.Trans.gameObject:SetActive(false)
    return self
end

function UIAppellationPreviewPanel:Show()
    --播放开启动画
    self.AnimModule:PlayEnableAnimation()
    self.TitleData = GameCenter.MarrySystem.MarryData.TitleDataList
    self:UpdateData();
end

function UIAppellationPreviewPanel:Hide()
    --播放关闭动画
    self.AnimModule:PlayDisableAnimation()
    self.Parent:IsHideInfoPanel(false);
end

function UIAppellationPreviewPanel:OnBackBtnClick()
    self:Hide()
end

-- 更新界面的数据
function UIAppellationPreviewPanel:UpdateData()
    if self.TitleData == nil then
        Debug.LogError("UIAppellationPreviewPanel TitleData is nil!")
        return
    end
    local _itemUICount = #self.ItemList;
    for i = 1, _itemUICount do
        self.ItemList[i]:Refresh(nil);
    end
    local _itemCount = #self.TitleData;
    for i = 1, _itemCount do
        local _dataInfo = self.TitleData[i]
        local _itemUI = nil;
        if i <= #self.ItemList then
            _itemUI = self.ItemList[i];
        else
            _itemUI = UIPreviewItem:New(UIUtility.Clone(self.ItemRes), self);
            self.ItemList:Add(_itemUI);
        end
        self.ItemList[i]:Refresh(_dataInfo);
    end
    self.Grid.repositionNow = true;
end

return UIAppellationPreviewPanel