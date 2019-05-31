------------------------------------------------
--作者： yangqf
--日期： 2019-5-7
--文件： UISZZQResultForm.lua
--模块： UISZZQResultForm
--描述： 勇者之巅通关结算界面
------------------------------------------------
local UIItem = require "UI.Components.UIItem";

--//模块定义
local UISZZQResultForm = {
    --关闭按钮
    CloseBtn = nil,
    --自身排名
    SelfRank = nil,
    --自身积分
    SelfScore = nil,
    --时间
    TimeLabel = nil,
    --grid
    ItemGrid = nil,
    --物品列表
    Items = nil,

    --计时器
    Timer = 0.0,
    --上一次更新的时间
    FrontUpdateTime = -1,
}

--继承Form函数
function UISZZQResultForm:OnRegisterEvents()
    self:RegisterEvent(UIEventDefine.UISZZQResultForm_OPEN, self.OnOpen)
    self:RegisterEvent(UIEventDefine.UISZZQResultForm_CLOSE, self.OnClose)
end

function UISZZQResultForm:OnFirstShow()
    self.CSForm:AddAlphaAnimation();
    self.CloseBtn = UIUtils.FindBtn(self.Trans, "Back");
    UIUtils.AddBtnEvent(self.CloseBtn, self.OnLeaveBtnClick, self);
    self.SelfRank = UIUtils.FindLabel(self.Trans, "SelfRank/Value");
    self.SelfScore = UIUtils.FindLabel(self.Trans, "SelfScore/Value");

    self.TimeLabel = UIUtils.FindLabel(self.Trans, "CloseTime");
    self.ItemGrid = UIUtils.FindGrid(self.Trans, "Grid");
    self.Items = {};
    for i = 1, 8 do
        self.Items[i] = UIItem:New(UIUtils.FindTrans(self.Trans, string.format("Grid/%d", i)));
    end
end

function UISZZQResultForm:OnShowAfter()
    self.FrontUpdateTime = -1;
    self.Timer = 15.0;
end

function UISZZQResultForm:OnHideBefore()
end

--开启事件
function UISZZQResultForm:OnOpen(obj, sender)
    self.CSForm:Show(sender)
    local _msg = obj
    if _msg ~= nil then
        local _itemCount = #_msg.rewardlist;
        local _resultItems = {};
        for i = 1, _itemCount do
            local _curCount = _resultItems[_msg.rewardlist[i].itemId];
            if _curCount ~= nil then
                _resultItems[_msg.rewardlist[i].itemId] = _curCount + _msg.rewardlist[i].num;
            else
                _resultItems[_msg.rewardlist[i].itemId] = _msg.rewardlist[i].num;
            end
        end
        local _resultItemsList = List:New();
        --注意此遍历不是按照表顺序遍历的
        for k,v in pairs(_resultItems) do
            _resultItemsList:Add({k, v})
        end

        _itemCount = #_resultItemsList;
        for i = 1, 8 do
            if i <= _itemCount then
                self.Items[i].RootGO:SetActive(true);
                self.Items[i]:InItWithCfgid(_resultItemsList[i][1], _resultItemsList[i][2], false, false);
            else
                self.Items[i].RootGO:SetActive(false);
            end
        end
        self.ItemGrid:Reposition();

        self.SelfRank.text = DataConfig.DataMessageString.Get("C_SZZQ_RESULTRANK", _msg.selfRank);
        self.SelfScore.text = DataConfig.DataMessageString.Get("C_SZZQ_TIMEMIN", _msg.selfScore);
    else
        self:OnClose(nil, nil);
    end
end

--关闭事件
function UISZZQResultForm:OnClose(obj, sender)
    self.CSForm:Hide()
end

function UISZZQResultForm:Update(dt)
    self.Timer = self.Timer - dt;
    local _curTime = math.floor(self.Timer)
    if _curTime ~= self.FrontUpdateTime then
        self.FrontUpdateTime = _curTime;
        self.TimeLabel.text = string.format("%d", _curTime);
    end

    if _curTime < 0.0 and self.CSForm.IsVisible then
        self:OnLeaveBtnClick();
    end
end

--离开按钮点击
function UISZZQResultForm:OnLeaveBtnClick()
    GameCenter.MapLogicSystem:SendLeaveMapMsg(false);
    self:OnClose(nil, nil);
end

return UISZZQResultForm;