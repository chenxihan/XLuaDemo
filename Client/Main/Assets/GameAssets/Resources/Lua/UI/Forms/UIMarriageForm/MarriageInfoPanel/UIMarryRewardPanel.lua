------------------------------------------------
--作者： dhq
--日期： 2019-05-13
--文件： UIMarryRewardPanel.lua
--模块： UIMarryRewardPanel
--描述： 婚姻奖励界面
------------------------------------------------
local UIMarryRewardItem = require "UI.Forms.UIMarriageForm.MarriageInfoPanel.UIMarryRewardItem"

--//模块定义
local UIMarryRewardPanel = {
    --当前transform
    Trans = nil,
    --父
    Parent = nil,
    --动画模块
    AnimModule = nil,
    BackBtn = nil,
    --Comonent列表
    ItemList = nil,
    ItemRes = nil,
    --需要的数据
    IntimacyData = nil,
}

function UIMarryRewardPanel:OnFirstShow(trans, parent)
    self.Trans = trans
    self.Parent = parent

    --创建动画模块
    self.AnimModule = UIAnimationModule(self.Trans)
    --添加一个动画
    self.AnimModule:AddAlphaAnimation()

    self.BackBtn = UIUtils.FindBtn(self.Trans, "BackBtn")
    UIUtils.AddBtnEvent(self.BackBtn, self.OnBackBtnClick, self)

    self.ItemList = List:New();
    self.ItemRes = UIUtils.FindGo(self.Trans, "Scroll View/Grid/Container");
    local _uiItem = UIMarryRewardItem:New(self.ItemRes);
    self.ItemList:Add(_uiItem);

    self.IntimacyData = GameCenter.MarrySystem.MarryData.IntimacyDataList
    self.Trans.gameObject:SetActive(false)
    return self
end

function UIMarryRewardPanel:Show()
    --播放开启动画
    self.AnimModule:PlayEnableAnimation()
    self:UpdateData()
end

function UIMarryRewardPanel:Hide()
    --播放关闭动画
    self.AnimModule:PlayDisableAnimation()
    self.Parent:IsHideInfoPanel(false);
end

function UIMarryRewardPanel:OnBackBtnClick()
    self:Hide()
end

function UIMarryRewardPanel:UpdateData()
    if self.IntimacyData == nil then
        Debug.LogError("UIMarryRewardPanel IntimacyData is nil!")
        return
    end
    local _itemUICount = #self.ItemList;
    for i = 1, _itemUICount do
        self.ItemList[i]:Refresh(nil);
    end
    local _itemCount = #self.IntimacyData;
    for i = 1, _itemCount do
        local _dataInfo = self.IntimacyData[i]
        local _itemUI = nil;
        if i <= #self.ItemList then
            _itemUI = self.ItemList[i];
        else
            _itemUI = UIMarryRewardItem:New(UIUtility.Clone(self.ItemRes));
            self.ItemList:Add(_itemUI);
        end
        self.ItemList[i]:Refresh(_dataInfo);
    end
end

return UIMarryRewardPanel