------------------------------------------------
--作者： dhq
--日期： 2019-05-13
--文件： UIAppointmentPanel.lua
--模块： UIAppointmentPanel
--描述： 婚姻预约婚礼界面
------------------------------------------------
local UIAppointmentTimeItem = require "UI.Forms.UIMarriageForm.MarriageInfoPanel.UIAppointmentTimeItem"

--//模块定义
local UIAppointmentPanel = {
    --当前transform
    Trans = nil,
    --父
    Parent = nil,
    --动画模块
    AnimModule = nil,
    BackBtn = nil,

    LNameLabel = nil,
    RNameLabel = nil,
    CountLabel = nil,
    QueBtn = nil,
    TipsGo = nil,

    
    RewradGrid = nil,
    RewardItemList = nil,

    TimeItemGrid = nil,
    -- 预约按钮
    ReserveBtn = nil,
    TimeItemList = nil,

    TimeItemData = nil,
}

local TestTimeItemData = 
{
    {Time = "09:30-10:00", States = 0},
    {Time = "10:00-10:30", States = 0},
    {Time = "10:30-11:00", States = 1},
    {Time = "11:00-11:30", States = 1},
    {Time = "12:00-12:30", States = 1},
}

function UIAppointmentPanel:OnFirstShow(trans, parent)
    self.Trans = trans
    self.Parent = parent

    self.TimeItemData = TestTimeItemData
    --创建动画模块
    self.AnimModule = UIAnimationModule(self.Trans)
    --添加一个动画
    self.AnimModule:AddAlphaAnimation()

    self.BackBtn = UIUtils.FindBtn(self.Trans, "BackBtn")
    UIUtils.AddBtnEvent(self.BackBtn, self.OnBackBtnClick, self)

    self.LNameLabel = UIUtils.FindLabel(self.Trans, "Left/Title/LName")
    self.RNameLabel = UIUtils.FindLabel(self.Trans, "Left/Title/RName")

    self.CountLabel = UIUtils.FindLabel(self.Trans, "Left/Count/Num")

    self.QueBtn = UIUtils.FindBtn(self.Trans, "Left/QueBtn")
    UIUtils.AddBtnEvent(self.QueBtn, self.OnQueBtnClick, self)
    self.TipsGo = UIUtils.FindGo(self.Trans, "Left/Tips")

    self.ReserveBtn = UIUtils.FindBtn(self.Trans, "Right/ReserveBtn")
    UIUtils.AddBtnEvent(self.ReserveBtn, self.OnReserveBtnClick, self)

    self.RewradGrid = UIUtils.FindGrid(self.Trans, "Left/Reward/Grid")
    self.RewardItemList = List:New()
    for _index = 1, 5 do
        local _itemTrans = UIUtils.FindTrans(self.Trans, string.format( "Left/Reward/Grid/%s", _index ))
        local _uiItem = UIUtils.RequireUIItem(_itemTrans)
        _uiItem.transform.gameObject:SetActive(false)
        self.RewardItemList:Add(_uiItem)
    end

    self.TimeItemGrid = UIUtils.FindGrid(self.Trans, "Right/Scroll View/Grid")
    self.TimeItemList = List:New()
    self.TimeItemGo = UIUtils.FindGo(self.Trans, "Right/Scroll View/Grid/TimeItem")
    local _timeItem = UIAppointmentTimeItem:New(self.TimeItemGo, self)
    self.TimeItemList:Add(_timeItem)

    self.Trans.gameObject:SetActive(false)
    return self
end

function UIAppointmentPanel:Show()
    --播放开启动画
    self.AnimModule:PlayEnableAnimation()
    self:UpdatePage()
end

function UIAppointmentPanel:Hide()
    --播放关闭动画
    self.AnimModule:PlayDisableAnimation()
end

--关闭上层面板和此面板
function UIAppointmentPanel:HideSelfAndParentPanel()
    self:Hide()
    self.Parent.MarryProcessPanel:Show()
end

-- --返回按钮
function UIAppointmentPanel:OnBackBtnClick()
    self:HideSelfAndParentPanel()
end

--预约按钮
function UIAppointmentPanel:OnReserveBtnClick()
    --self:Hide()
end

-- 问题按钮
function UIAppointmentPanel:OnQueBtnClick()
    if self.TipsGo.activeSelf then
        self.TipsGo:SetActive(false)
    else
        self.TipsGo:SetActive(true)
    end
end

function UIAppointmentPanel:UpdatePage()
    local _lp = GameCenter.GameSceneSystem:GetLocalPlayer();
    if _lp ~= nil then
        self.LNameLabel.text = _lp.Name
        self.RNameLabel.text = _lp.Name
    end
    self.CountLabel.text = string.format( "剩余预约婚礼次数:%s次", 3 )
    self:UpdateTimeItemData()
    self:UpdateRewardItem()
end

-- 刷新右边时间数据的Item
function UIAppointmentPanel:UpdateTimeItemData()
    local _itemUICount = #self.TimeItemList;
    for i = 1, _itemUICount do
        self.TimeItemList[i]:Refresh(nil);
    end
    local _itemCount = #self.TimeItemData;
    for i = 1, _itemCount do
        local _dataInfo = self.TimeItemData[i]
        local _timeItem = nil;
        if i <= #self.TimeItemList then
            _timeItem = self.TimeItemList[i];
        else
            _timeItem = UIAppointmentTimeItem:New(UIUtility.Clone(self.TimeItemGo), self);
            self.TimeItemList:Add(_timeItem);
        end
        self.TimeItemList[i]:Refresh(_dataInfo);
    end
    self.TimeItemGrid.repositionNow = true;
end

function UIAppointmentPanel:UpdateRewardItem()
    local _reward = "1003_10_0;1004_10_0;1005_10_0";
    local _itemArr = Utils.SplitStr(_reward, ';')
    for i = 1, #_itemArr do
        if #self.RewardItemList >= i then
            local _strs = Utils.SplitStr(_itemArr[i], '_')
            if #_strs >= 3 then
                local _id = tonumber(_strs[1]) and tonumber(_strs[1]) or -1
                local _num = tonumber(_strs[2]) and tonumber(_strs[2]) or -1
                local _bind = tonumber(_strs[3]) and tonumber(_strs[3]) or -1
                self.RewardItemList[i]:InitializationWithIdAndNum(_id, _num, _bind == 1, false)
                self.RewardItemList[i].transform.gameObject:SetActive(true)
            end
        end
    end
    self.RewradGrid.repositionNow = true;
end

return UIAppointmentPanel