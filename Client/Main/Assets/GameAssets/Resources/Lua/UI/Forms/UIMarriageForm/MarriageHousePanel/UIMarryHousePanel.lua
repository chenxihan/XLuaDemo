------------------------------------------------
--作者： dhq
--日期： 2019-05-13
--文件： UIMarryHousePanel.lua
--模块： UIMarryHousePanel
--描述： 婚姻仙居界面
------------------------------------------------

local UIHousePreviewPanel = require "UI.Forms.UIMarriageForm.MarriageHousePanel.UIHousePreviewPanel"
local UIHouseAttrItem = require "UI.Forms.UIMarriageForm.MarriageHousePanel.UIHouseAttrItem"

--//模块定义
local UIMarryHousePanel = {
    --当前transform
    Trans = nil,
    --父
    Parent = nil,
    --动画模块
    AnimModule = nil,

    --预览按钮
    PreVieBtn = nil,
    UpgradeBtn = nil,
    OverfulfilBtn = nil,
    --仙居预览界面
    HousePreviewPanel = nil,
    MainPanelGo = nil,
    --升级
    UpgradeGo = nil,
    --突破
    OverfulfilGo = nil,
    --等级
    LevelLabel = nil,
    --战斗力
    FightPowerLabel = nil,
    --属性对象
    AttrGo = nil,
    AttrItemList = nil,
    --升级消耗物品的UIItem列表
    ConsumeGrid = nil,
    ConsumeItemList = nil,

    OverfulfilAttrItemList = nil,
    OverfulfilAttrGo = nil,
    OverfulfilConsumeGrid = nil,
    OverfulfilConsumeItemList = nil,
    --一键提升
    QuickUpgradeBtn = nil,
    UpgradeData = nil,
    OverfulfilData = nil,
}

function UIMarryHousePanel:OnFirstShow(trans, parent)
    self.Trans = trans
    self.Parent = parent

    --创建动画模块
    self.AnimModule = UIAnimationModule(self.Trans)
    --添加一个动画
    self.AnimModule:AddAlphaAnimation()

    self.PreVieBtn = UIUtils.FindBtn(self.Trans, "MainPanel/Left/PreVieBtn")
    UIUtils.AddBtnEvent(self.PreVieBtn, self.OnPreVieBtnClick, self)
    self.UpgradeBtn = UIUtils.FindBtn(self.Trans, "MainPanel/UpgradeBtn")
    UIUtils.AddBtnEvent(self.UpgradeBtn, self.OnUpgradeBtnClick, self)
    self.OverfulfilBtn = UIUtils.FindBtn(self.Trans, "MainPanel/OverfulfilBtn")
    UIUtils.AddBtnEvent(self.OverfulfilBtn, self.OnOverfulfilBtnClick, self)

    self.UpgradeGo = UIUtils.FindGo(self.Trans, "MainPanel/Upgrade")
    self.OverfulfilGo = UIUtils.FindGo(self.Trans, "MainPanel/Overfulfil")
    
    self.HousePreviewPanel = UIHousePreviewPanel:OnFirstShow(UIUtils.FindTrans(self.Trans, "PreviewPanel"), self)
    self.MainPanelGo = UIUtils.FindGo(self.Trans, "MainPanel")

    self.LevelLabel = UIUtils.FindLabel(self.Trans, "MainPanel/Left/Level/Label")
    self.FightPowerLabel = UIUtils.FindLabel(self.Trans, "MainPanel/Left/FightPower/FightPowerLabel")

    -----------------升级-----------------
    self.AttrItemList = List:New();
    self.AttrGo = UIUtils.FindGo(self.Trans, "MainPanel/Upgrade/Attr/Grid/Container")
    local _attrItem = UIHouseAttrItem:New(self.AttrGo);
    self.AttrItemList:Add(_attrItem);

    self.ConsumeGrid = UIUtils.FindGrid(self.Trans, "MainPanel/Upgrade/Consume/Grid")
    -- 获取升级材料消耗的Item列表
    self.ConsumeItemList = List:New();
    for _id = 1, 4 do
        local _item = UIUtils.FindTrans(self.Trans, string.format( "MainPanel/Upgrade/Consume/Grid/%s", tostring(_id)));
        local _consItem = UIUtils.RequireUIItem(_item)
        _consItem.transform.gameObject:SetActive(false)
        self.ConsumeItemList:Add(_consItem)
    end

    -----------------突破-----------------
    self.OverfulfilAttrItemList = List:New();
    self.OverfulfilAttrGo = UIUtils.FindGo(self.Trans, "MainPanel/Overfulfil/Attr/Grid/Container")
    local _overfulfilAttrItem = UIHouseAttrItem:New(self.OverfulfilAttrGo);
    self.OverfulfilAttrItemList:Add(_overfulfilAttrItem);

    self.OverfulfilConsumeGrid = UIUtils.FindGrid(self.Trans, "MainPanel/Overfulfil/Consume/Grid")
    -- 获取升级材料消耗的Item列表
    self.OverfulfilConsumeItemList = List:New();
    for _id = 1, 6 do
        local _ofItem = UIUtils.FindTrans(self.Trans, string.format( "MainPanel/Overfulfil/Consume/Grid/%s", tostring(_id)));
        local _ofConsItem = UIUtils.RequireUIItem(_ofItem)
        _ofConsItem.transform.gameObject:SetActive(false)
        self.OverfulfilConsumeItemList:Add(_ofConsItem)
    end
    
    self.QuickUpgradeBtn = UIUtils.FindBtn(self.Trans, "MainPanel/Upgrade/QuickUpgradeBtn")

    self.Trans.gameObject:SetActive(false)
    return self
end

function UIMarryHousePanel:Show(childId)
    --播放开启动画
    self.AnimModule:PlayEnableAnimation()
    local _houseDegree = GameCenter.MarrySystem.MarryData.HouseDegree
    local _houseLevel = GameCenter.MarrySystem.MarryData.HouseLevel
    local _houseData = GameCenter.MarrySystem.MarryData.HouseDataList
    if _houseData ~= nil then
        for _index, _data in pairs(_houseData) do
            if _data.Degree == _houseDegree and _data.Level == _houseLevel then
                self.UpgradeData = _houseData[_index].UpgradeData
                break
            end
        end
    end
    if _houseData ~= nil then
        for _index, _data in pairs(_houseData) do
            if _houseData[_index].OverfulfilData ~= nil then
                if _data.Degree == _houseDegree then
                    self.OverfulfilData = _houseData[_index].OverfulfilData
                    break
                end
            end
        end
    end
    self:IsHideMainPanel(false)
    self:UpdateUpgradeData()
end

function UIMarryHousePanel:Hide()
    --播放关闭动画
    self.AnimModule:PlayDisableAnimation()
    self.HousePreviewPanel:Hide()
end

function UIMarryHousePanel:OnPreVieBtnClick()
    self.HousePreviewPanel:Show()
    self:IsHideMainPanel(true)
end

-- 升级按钮
function UIMarryHousePanel:OnUpgradeBtnClick()
    self.UpgradeGo:SetActive(true)
    self.OverfulfilGo:SetActive(false)
    self:UpdateUpgradeData()
end

-- 突破按钮
function UIMarryHousePanel:OnOverfulfilBtnClick()
    self.UpgradeGo:SetActive(false)
    self.OverfulfilGo:SetActive(true)
    self:UpdateOverfulfilData()
end

function UIMarryHousePanel:IsHideMainPanel(state)
    if state then
        self.MainPanelGo:SetActive(false);
    else
        self.MainPanelGo:SetActive(true);
    end
end

-- 刷新升级的数据
function UIMarryHousePanel:UpdateUpgradeData()

    local _itemUICount = #self.AttrItemList;
    for i = 1, _itemUICount do
        self.AttrItemList[i]:Refresh(nil);
    end
    if self.UpgradeData ~= nil then
        --属性的显示
        local _attrDict = self.UpgradeData.AttrDict
        local _index = 1;
        for _prop, _num in pairs(_attrDict) do
            local _itemUI = nil;
            if _index <= #self.AttrItemList then
                _itemUI = self.AttrItemList[_index];
            else
                _itemUI = UIHouseAttrItem:New(UIUtility.Clone(self.AttrGo));
                self.AttrItemList:Add(_itemUI);
            end
            self.AttrItemList[_index]:Refresh(_prop, _num);
            _index = _index + 1
        end
        --升级消耗的物品
        local _arard = self.UpgradeData.UpNeedItem
        local _itemArr = Utils.SplitStr(_arard, ';')
        for i = 1, #_itemArr do
            if #self.ConsumeItemList >= i then
                local _strs = Utils.SplitStr(_itemArr[i], '_')
                if #_strs >= 1 then
                    local _id = tonumber(_strs[1]) and tonumber(_strs[1]) or -1
                    local _num = tonumber(_strs[2]) and tonumber(_strs[2]) or -1
                    --local _bind = tonumber(_strs[3]) and tonumber(_strs[3]) or -1
                    --self.ConsumeItemList[i]:InitializationWithIdAndNum(_id, _num, _bind == 1, false)
                    self.ConsumeItemList[i]:InitializationWithIdAndNum(_id, _num, false, false)
                    self.ConsumeItemList[i].transform.gameObject:SetActive(true)
                end
            end
        end
        --战力
        self.FightPowerLabel.text = self.UpgradeData.FightPower
        --当前阶数
        self.LevelLabel.text = string.format( "第%s阶",self.UpgradeData.Degree )
    end
    self.ConsumeGrid.repositionNow = true;
end

-- 刷新突破界面的数据
function UIMarryHousePanel:UpdateOverfulfilData()

    local _itemUICount = #self.OverfulfilAttrItemList;
    for i = 1, _itemUICount do
        self.OverfulfilAttrItemList[i]:Refresh(nil);
    end
    --属性的显示
    if self.OverfulfilData ~= nil then
        if self.OverfulfilData.AttrDict ~= nil then
            local _attrDict = self.OverfulfilData.AttrDict
            local _index = 1;
            for _prop, _num in pairs(_attrDict) do
                local _itemUI = nil;
                if _index <= #self.OverfulfilAttrItemList then
                    _itemUI = self.OverfulfilAttrItemList[_index];
                else
                    _itemUI = UIHouseAttrItem:New(UIUtility.Clone(self.OverfulfilAttrGo));
                    self.OverfulfilAttrItemList:Add(_itemUI);
                end
                self.OverfulfilAttrItemList[_index]:Refresh(_prop, _num);
                _index = _index + 1
            end
    
            local _arard = self.UpgradeData.UpNeedItem
            local _itemArr = Utils.SplitStr(_arard, ';')
            for i = 1, #_itemArr do
                if #self.OverfulfilConsumeItemList >= i then
                    local _strs = Utils.SplitStr(_itemArr[i], '_')
                    if #_strs >= 1 then
                        local _id = tonumber(_strs[1]) and tonumber(_strs[1]) or -1
                        local _num = tonumber(_strs[2]) and tonumber(_strs[2]) or -1
                        --local _bind = tonumber(_strs[3]) and tonumber(_strs[3]) or -1
                        --self.OverfulfilConsumeItemList[i]:InitializationWithIdAndNum(_id, _num, _bind == 1, false)
                        self.OverfulfilConsumeItemList[i]:InitializationWithIdAndNum(_id, _num, false, false)
                        self.OverfulfilConsumeItemList[i].transform.gameObject:SetActive(true)
                    end
                end
            end
        end
        self.OverfulfilConsumeGrid.repositionNow = true;
    end
end

return UIMarryHousePanel