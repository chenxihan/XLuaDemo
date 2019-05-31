------------------------------------------------
--作者： yangqf
--日期： 2019-04-28
--文件： UIStarCopyPanel.lua
--模块： UIStarCopyPanel
--描述： 星级副本分页
------------------------------------------------
local UIStarCopyAwardIcon = require "UI.Forms.UICopyMapForm.UIStarCopyAwardIcon";
local UIStarCopyIcon = require "UI.Forms.UICopyMapForm.UIStarCopyIcon";
local UIItem = require "UI.Components.UIItem";

--//模块定义
local UIStarCopyPanel = {
    --当前transform
    Trans = nil,
    --父
    Parent = nil,
    --动画模块
    AnimModule = nil,

    --挑战按钮
    EnterBtn = nil,
    --扫荡按钮
    SweepBtn = nil,
    --星数奖励物品
    StartAwardItems = nil,
    --奖励展示物品
    AwardItems = nil,
    --子副本列表
    ChildCopys = nil,
    --选择的副本
    SelectCopyCfg = nil;
    
    --扫荡需求战斗力
    SweepNeedPower = nil,
    --我的战斗力
    MyPower = nil,
    --扫荡战力是否满足
    SweepPowerEnough = false,
    --星数奖励的配置
    StarAwardCfg = nil,
    --再次进入副本消耗的物品
    AgainEnterCost = nil,
}

function UIStarCopyPanel:OnFirstShow(trans, parent, rootForm)
    self.Trans = trans;
    self.Parent = parent;
    self.RootForm = rootForm;
    
    self.AnimModule = UIAnimationModule(self.Trans);
    self.AnimModule:AddAlphaAnimation();

    self.EnterBtn = UIUtils.FindBtn(self.Trans, "Down/EnterBtn");
    UIUtils.AddBtnEvent(self.EnterBtn, self.OnEnterBtnClick, self);
    self.SweepBtn = UIUtils.FindBtn(self.Trans, "Down/SweepBtn");
    UIUtils.AddBtnEvent(self.SweepBtn, self.OnSweepBtnClick, self);

    self.StartAwardItems = {};
    for i = 1, 4 do
        self.StartAwardItems[i] = UIStarCopyAwardIcon:New(UIUtils.FindTrans(self.Trans, string.format("Down/%d", i)), i - 1);
    end

    self.AwardItems = {};
    for i = 1, 3 do
        self.AwardItems[i] = UIItem:New(UIUtils.FindTrans(self.Trans, string.format("Center/%d", i)));
    end

    self.ChildCopys = {};
    for i = 1, 5 do
        self.ChildCopys[i] = UIStarCopyIcon:New(UIUtils.FindTrans(self.Trans, string.format("Top/%d", i)), self, self.RootForm);
    end

    local _gCfg = DataConfig.DataGlobal[1502];
    if _gCfg ~= nil then
        self.StarAwardCfg = Utils.SplitStrByTableS(_gCfg.Params);
    end

    _gCfg = DataConfig.DataGlobal[1509];
    if _gCfg ~= nil then
        local _costCfg = Utils.SplitStr(_gCfg.Params, '_');
        if #_costCfg >= 2 then
            self.AgainEnterCost = {};
            self.AgainEnterCost[1] = DataConfig.DataItem[_costCfg[1]];
            self.AgainEnterCost[2] = _costCfg[2];
        end
        
    end

    self.SweepNeedPower = UIUtils.FindLabel(self.Trans, "Down/SweepPower/Value");
    self.MyPower = UIUtils.FindLabel(self.Trans, "Down/MyPower/Value");

    self.Trans.gameObject:SetActive(false);
    return self;
end

function UIStarCopyPanel:Show()
    GameCenter.CopyMapSystem:ReqOpenStarPanel();
    self.AnimModule:PlayEnableAnimation();
    self:RefreshPage(true);
end

function UIStarCopyPanel:Hide()
    self.AnimModule:PlayDisableAnimation();
end

function UIStarCopyPanel:RefreshPage(doSelect)
    local _copyMapDatas = GameCenter.CopyMapSystem:FindCopyDatasByType(CopyMapTypeEnum.StarCopy);
    if _copyMapDatas == nil then
        return;
    end
    local _copyCount = #_copyMapDatas;
    if _copyCount <= 0 then
        return;
    end
    local _selectIcon = nil;
    local _allStarCount = 0;
    for i = 1, 5 do
        if i <= _copyCount then
            self.ChildCopys[i]:Refresh(_copyMapDatas[i]);
            _allStarCount = _allStarCount + _copyMapDatas[i].CurStar;
            if _copyMapDatas[i].CurStar <= 0 and _selectIcon == nil then
                _selectIcon = self.ChildCopys[i];
            end
        end
    end

    local _getState = GameCenter.CopyMapSystem.StarCopyAwardState;
    if _getState ~= nil then
        local _starAwardCount = #self.StarAwardCfg;
        local _getStateCount = #_getState;
        for i = 1, 4 do
            if i <= _starAwardCount  then
                local _state = 0;
                if i <= _getStateCount then
                    if _getState[i] == true then
                        _state = 2; --已领取
                    elseif _allStarCount >= self.StarAwardCfg[i][1] then
                        _state = 1; --可领取
                    else
                        _state = 0; --未达成
                    end
                end
                self.StartAwardItems[i]:Refresh(self.StarAwardCfg[i], _state);
            end
        end
    end

    self.SweepPowerEnough = false;
    local _lp = GameCenter.GameSceneSystem:GetLocalPlayer();
    if _lp ~= nil then
        local _levelCfg = DataConfig.DataCharacters[_lp.Level];
        if _levelCfg ~= nil then
            self.SweepNeedPower.text = tostring(_levelCfg.StarCopyNeedFightPower);
            if _levelCfg.StarCopyNeedFightPower <= _lp.FightPower then
                self.SweepPowerEnough = true;
            end
        end
        self.MyPower.text = tostring(_lp.FightPower);
    end

    if doSelect then
        if _selectIcon == nil then
            self:SetSelectCopy(self.ChildCopys[1]);
        else
            self:SetSelectCopy(_selectIcon);
        end
    end
end

--选择副本
function UIStarCopyPanel:SetSelectCopy(icon)
    for i = 1, 5 do
        self.ChildCopys[i]:SetSelect(icon == self.ChildCopys[i]);
    end
    self.SelectCopyCfg = icon.CopyCfg;

    local _awardItems = Utils.SplitStrByTableS(self.SelectCopyCfg.ParticipationAward);
    local _awardItemCount = #_awardItems
    for i = 1, 3 do
        if i <= _awardItemCount then
            self.AwardItems[i].RootGO:SetActive(true);
            self.AwardItems[i]:InItWithCfgid(_awardItems[i][1], _awardItems[i][2], _awardItems[i][3] == 1, false);
        else
            self.AwardItems[i].RootGO:SetActive(false);
        end
    end
end

--扫荡按钮点击
function UIStarCopyPanel:OnSweepBtnClick() 
    if self.SelectCopyCfg == nil then
        return;
    end

    if self.SweepPowerEnough ~= true then
        --扫荡战力不满足
        GameCenter.MsgPromptSystem:ShowPrompt("您的战力不足，不能进行扫荡！");
        return;
    end

    local _copyData = GameCenter.CopyMapSystem:FindCopyData(self.SelectCopyCfg.Id);
    if _copyData ~= nil and _copyData.CanFreeSweep == true then
        --可以免费扫荡，直接扫荡
        GameCenter.CopyMapSystem:ReqSweepCopyMap(self.SelectCopyCfg.Id);
    else
        --不能免费扫荡，打开扫荡界面
        GameCenter.PushFixEvent(UIEventDefine.UICopySweepForm_OPEN, self.SelectCopyCfg);
    end
end

--挑战按钮点击
function UIStarCopyPanel:OnEnterBtnClick()
    if self.SelectCopyCfg == nil then
        return;
    end
    local _copyData = GameCenter.CopyMapSystem:FindCopyData(self.SelectCopyCfg.Id);
    if _copyData ~= nil and _copyData.CurStar > 0 and _copyData.CurStar < 3 and self.AgainEnterCost ~= nil and self.AgainEnterCost[1] ~= nil then
        local _text = UIUtils.CSFormat("再次挑战需要消耗物品[00FF00][{0}]x{1}[-]，是否继续？", self.AgainEnterCost[1], self.AgainEnterCost[2]);
        GameCenter.MsgPromptSystem:ShowMsgBox(_text, function (code)
            if (code == MsgBoxResultCode.Button2) then
                GameCenter.CopyMapSystem:ReqSingleEnterCopyMap(self.SelectCopyCfg.Id);
            end
        end);
    else
        GameCenter.CopyMapSystem:ReqSingleEnterCopyMap(self.SelectCopyCfg.Id);
    end
end

return UIStarCopyPanel;