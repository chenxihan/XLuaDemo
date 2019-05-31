------------------------------------------------
--作者： yangqf
--日期： 2019-5-7
--文件： UIYZZDEndForm.lua
--模块： UIYZZDEndForm
--描述： 勇者之巅通关结算界面
------------------------------------------------
local UIItem = require "UI.Components.UIItem";

--//模块定义
local UIYZZDEndForm = {
    --最大通关层数
    MaxLevelLabel = nil,
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
function UIYZZDEndForm:OnRegisterEvents()
    self:RegisterEvent(UIEventDefine.UIYZZDEndForm_OPEN, self.OnOpen)
    self:RegisterEvent(UIEventDefine.UIYZZDEndForm_CLOSE, self.OnClose)
end

function UIYZZDEndForm:OnFirstShow()
    self.CSForm:AddAlphaAnimation();
    self.MaxLevelLabel = UIUtils.FindLabel(self.Trans, "MaxLevel/Value");
    self.TimeLabel = UIUtils.FindLabel(self.Trans, "CloseTime");
    self.ItemGrid = UIUtils.FindGrid(self.Trans, "Grid");
    self.Items = {};
    for i = 1, 8 do
        self.Items[i] = UIItem:New(UIUtils.FindTrans(self.Trans, string.format("Grid/%d", i)));
    end
end

function UIYZZDEndForm:OnShowAfter()
    self.FrontUpdateTime = -1;
    self.Timer = 15.0;
end

function UIYZZDEndForm:OnHideBefore()
end

--开启事件
function UIYZZDEndForm:OnOpen(obj, sender)
    self.CSForm:Show(sender)
    local _msg = obj
    if _msg ~= nil then
        local _itemCount = #_msg.info;
        local _resultItems = {};
        for i = 1, _itemCount do
            local _curCount = _resultItems[_msg.info[i].modelId];
            if _curCount ~= nil then
                _resultItems[_msg.info[i].modelId] = _curCount + _msg.info[i].num;
            else
                _resultItems[_msg.info[i].modelId] = _msg.info[i].num;
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
        self.MaxLevelLabel.text = DataConfig.DataMessageString.Get("C_YZZDRESULT_LEVEL", _msg.maxFloor);
    else
        self:OnClose(nil, nil);
    end
end

--关闭事件
function UIYZZDEndForm:OnClose(obj, sender)
    self.CSForm:Hide()
end

function UIYZZDEndForm:Update(dt)
    if self.Timer > 0.0 then
        self.Timer = self.Timer - dt;
        local _curTime = math.floor(self.Timer)
        if _curTime < 0.0 then
            self:OnLeaveBtnClick();
        else
            if _curTime ~= self.FrontUpdateTime then
                self.FrontUpdateTime = _curTime;
                self.TimeLabel.text = string.format("%d", _curTime);
            end
        end
    end
  
end

--离开按钮点击
function UIYZZDEndForm:OnLeaveBtnClick()
    GameCenter.MapLogicSystem:SendLeaveMapMsg(false);
    self:OnClose(nil, nil);
end

return UIYZZDEndForm;