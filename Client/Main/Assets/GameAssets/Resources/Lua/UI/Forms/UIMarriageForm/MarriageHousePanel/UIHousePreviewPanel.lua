------------------------------------------------
--作者： dhq
--日期： 2019-05-13
--文件： UIHousePreviewPanel.lua
--模块： UIHousePreviewPanel
--描述： 婚姻仙居预览界面
------------------------------------------------
local UIHousePreviewAttrItem = require "UI.Forms.UIMarriageForm.MarriageHousePanel.UIHousePreviewAttrItem"

--//模块定义
local UIHousePreviewPanel = {
    --当前transform
    Trans = nil,
    --父
    Parent = nil,
    --动画模块
    AnimModule = nil,
    --返回按钮
    BackBtn = nil,

    -- 仙居名字
    HouseTitleLabel = nil,
    -- 战斗力
    FightPowerLabel = nil,
    -- 解锁描述
    CondDesLabel = nil,
    -- 激活按钮
    ActiviteBtn = nil,
    -- 属性的父节点
    AttrGo = nil,
    AttrGrid = nil,
    BtnGrid = nil,

    HouseNameBtnList = nil,
    HouseNameLabelList = nil,
    AttrItemList = nil,

    BtnNameDict = nil,
}

function UIHousePreviewPanel:OnFirstShow(trans, parent)
    self.Trans = trans
    self.Parent = parent

    self.HouseNameBtnList = List:New()
    self.HouseNameLabelList = List:New()
    self.BtnNameDict = Dictionary:New()

    --创建动画模块
    self.AnimModule = UIAnimationModule(self.Trans)
    --添加一个动画
    self.AnimModule:AddAlphaAnimation()

    self.BackBtn = UIUtils.FindBtn(self.Trans, "BackBtn")
    UIUtils.AddBtnEvent(self.BackBtn, self.OnBackBtnClick, self)

    self.BtnGrid = UIUtils.FindGrid(self.Trans, "Left/Scroll View/Grid")

    for _index = 1, 10 do
        local _houseNameBtn = UIUtils.FindBtn(self.Trans, string.format( "Left/Scroll View/Grid/%s", _index))
        local _houseNameLabel = UIUtils.FindLabel(self.Trans, string.format( "Left/Scroll View/Grid/%s/Label", _index))
        UIUtils.AddBtnEvent(_houseNameBtn, self.OnHouseNameBtnClick, self)
        _houseNameBtn.transform.gameObject:SetActive(false)
        self.HouseNameLabelList:Add(_houseNameLabel)
        self.HouseNameBtnList:Add(_houseNameBtn)
    end
    
    self.HouseTitleLabel = UIUtils.FindLabel(self.Trans, "Right/House/Title/Label")
    self.FightPowerLabel = UIUtils.FindLabel(self.Trans, "Right/House/FightPower")
    self.CondDesLabel = UIUtils.FindLabel(self.Trans, "Right/CondDesLabel")

    self.AttrItemList = List:New();
    self.AttrGrid = UIUtils.FindGrid(self.Trans, "Right/Attr/Grid")
    self.AttrGo = UIUtils.FindGo(self.Trans, "Right/Attr/Grid/Container")
    local _attrItem = UIHousePreviewAttrItem:New(self.AttrGo);
    self.AttrItemList:Add(_attrItem);

    self.ActiviteBtn = UIUtils.FindBtn(self.Trans, "Right/ActiviteBtn")
    UIUtils.AddBtnEvent(self.ActiviteBtn, self.OnActiviteBtnClick, self)

    self.Trans.gameObject:SetActive(false)
    return self
end

function UIHousePreviewPanel:Show()
    --播放开启动画
    self.AnimModule:PlayEnableAnimation()
    local _houseDegree = GameCenter.MarrySystem.MarryData.HouseDegree
    local _houseData = GameCenter.MarrySystem.MarryData.HouseDataList
    local _btnIndex = 1
    if _houseData ~= nil then
        for _index, _data in pairs(_houseData) do
            if _houseData[_index].PreviewData ~= nil then
                if _houseDegree == _houseData[_index].PreviewData.Degree then
                    self:UpdateAttrData(_index)
                end
                if not self.BtnNameDict:ContainsKey(_btnIndex) then
                    self.BtnNameDict:Add(_btnIndex, _houseData[_index].PreviewData)
                end
                _btnIndex = _btnIndex + 1
            end
        end
    end
    self:ShowBtnNameList()
    self:UpdatePageData()
end

function UIHousePreviewPanel:Hide()
    --播放关闭动画
    self.AnimModule:PlayDisableAnimation()
    self.Parent:IsHideMainPanel(false)
end

-- 返回按钮
function UIHousePreviewPanel:OnBackBtnClick()
    self:Hide()
end

-- 激活按钮
function UIHousePreviewPanel:OnActiviteBtnClick()

end

function UIHousePreviewPanel:OnHouseNameBtnClick()
    local _curBtn = CS.UIButton.current
    local _index = _curBtn.name
    local _data = self.BtnNameDict[tonumber(_index)]
    if _data ~= nil then
        local _houseName = _data.Name
        self.HouseTitleLabel.text = _houseName
        _index = _data.ID
        self:UpdateAttrData(_index)
    end
end

function UIHousePreviewPanel:UpdatePageData()
    self.FightPowerLabel.text = "1008611"
    self.CondDesLabel.text = string.format( "仙居达到第%s阶时解锁", 2 )
end

-- 显示仙居名字的按钮列表
function UIHousePreviewPanel:ShowBtnNameList()
    -- 按钮的显示
    local _index = 1
    for _key, _btn in pairs(self.HouseNameBtnList) do
        if _index <= #self.BtnNameDict then
            self.HouseNameLabelList[_index].text = self.BtnNameDict[_index].Name
            self.HouseNameBtnList[_index].transform.gameObject:SetActive(true)
        end
        _index = _index + 1
    end
    self.BtnGrid.repositionNow = true;
end

function UIHousePreviewPanel:UpdateAttrData(curIndex)
    local _itemUICount = #self.AttrItemList;
    for i = 1, _itemUICount do
        self.AttrItemList[i]:Refresh(nil);
    end
    local _curIndex = curIndex
    local _curPreData = nil
    --属性
    local _attrDict = nil
    local _houseData = GameCenter.MarrySystem.MarryData.HouseDataList
    if _houseData ~= nil then
        for _index, _data in pairs(_houseData) do
            if _houseData[_index].PreviewData ~= nil then
                if _houseData[_index].PreviewData.ID == _curIndex then
                    _curPreData = _houseData[_index].PreviewData
                    break
                end
            end
        end
    end
    if _curPreData ~= nil and _curPreData.AttrDict ~= nil then
        local _index = 1;
        for _prop, _num in pairs(_curPreData.AttrDict) do
            local _itemUI = nil;
            if _index <= #self.AttrItemList then
                _itemUI = self.AttrItemList[_index];
            else
                _itemUI = UIHousePreviewAttrItem:New(UIUtility.Clone(self.AttrGo));
                self.AttrItemList:Add(_itemUI);
            end
            self.AttrItemList[_index]:Refresh(_prop, _num);
            _index = _index + 1
        end
        self.AttrGrid.repositionNow = true
        self.FightPowerLabel.text = string.format( "战斗力:%s",_curPreData.FightPower )
    end
end

return UIHousePreviewPanel