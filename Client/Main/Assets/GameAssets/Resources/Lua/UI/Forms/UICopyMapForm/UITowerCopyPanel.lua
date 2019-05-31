------------------------------------------------
--作者： yangqf
--日期： 2019-04-28
--文件： UITowerCopyPanel.lua
--模块： UITowerCopyPanel
--描述： 爬塔副本分页
------------------------------------------------
local TowerCopyIcon = require "UI.Forms.UICopyMapForm.UITowerCopyIcon"
local UIItem = require "UI.Components.UIItem";

--//模块定义
local UITowerCopyPanel = {
    --当前transform
    Trans = nil,
    --父
    Parent = nil,
    --动画模块
    AnimModule = nil,

    --章节名字Label
    NameLabel = nil,
    --关卡图标
    LevelIcons = nil,
    --需要战力
    NeedFightLabel = nil,
    --我的战力
    MyFightLabel = nil,
    --排行按钮
    RankBtn = nil,
    --本层掉落grid
    CurDropGrid = nil,
    --本层掉落items
    CurDropItems = nil,
    --本章掉落grid
    CurBigDropGrid = nil,
    --本章掉落items
    CurBigDropItems = nil,
    --进入按钮
    EnterBtn = nil,
}

function UITowerCopyPanel:OnFirstShow(trans, parent, rootForm)
    self.Trans = trans;
    self.Parent = parent;
    self.RootForm = rootForm;
    
    self.AnimModule = UIAnimationModule(self.Trans);
    self.AnimModule:AddAlphaAnimation();

    self.NameLabel = UIUtils.FindLabel(self.Trans, "Top/Name");
    self.LevelIcons = {};
    for i = 1, 10 do
        self.LevelIcons[i] = TowerCopyIcon:New(UIUtils.FindTrans(self.Trans, "Top/" .. i));
    end
    self.NeedFightLabel = UIUtils.FindLabel(self.Trans, "NeedPower/Value");
    self.MyFightLabel = UIUtils.FindLabel(self.Trans, "MyPower/Value");
    self.RankBtn = UIUtils.FindBtn(self.Trans, "RankBtn");
    UIUtils.AddBtnEvent(self.RankBtn, self.OnRankBtnClick, self);
    self.CurDropGrid = UIUtils.FindGrid(self.Trans, "Down/Item0");
    self.CurDropItems = {};
    for i = 1, 3 do
        self.CurDropItems[i] = UIItem:New(UIUtils.FindTrans(self.Trans, string.format("Down/Item0/%d", i)));
    end
    self.CurBigDropGrid = UIUtils.FindGrid(self.Trans, "Down/Item1");
    self.CurBigDropItems = {};
    for i = 1, 4 do
        self.CurBigDropItems[i] = UIItem:New(UIUtils.FindTrans(self.Trans, string.format("Down/Item1/%d", i)));
    end
    self.EnterBtn = UIUtils.FindBtn(self.Trans, "Down/EnterBtn");
    UIUtils.AddBtnEvent(self.EnterBtn, self.OnEnterBtnClick, self);

    self.Trans.gameObject:SetActive(false);
    return self
end

--打开
function UITowerCopyPanel:Show()
    GameCenter.CopyMapSystem:ReqOpenChallengePanel();
    self.AnimModule:PlayEnableAnimation();
    self:RefreshPage();
end

--关闭
function UITowerCopyPanel:Hide()
    self.AnimModule:PlayDisableAnimation();
end

--排行按钮点击
function UITowerCopyPanel:OnRankBtnClick()
end

--挑战按钮点击
function UITowerCopyPanel:OnEnterBtnClick()
    local _towerData = GameCenter.CopyMapSystem:FindCopyDataByType(CopyMapTypeEnum.TowerCopy);
    if _towerData == nil then
        return;
    end
    GameCenter.CopyMapSystem:ReqSingleEnterCopyMap(_towerData.CopyID);
end

--刷新界面
function UITowerCopyPanel:RefreshPage()
    local _lp = GameCenter.GameSceneSystem:GetLocalPlayer();
    if _lp == nil then
        return;
    end

    local _towerData = GameCenter.CopyMapSystem:FindCopyDataByType(CopyMapTypeEnum.TowerCopy);
    if _towerData == nil then
        return;
    end
    if _towerData.CurLevel < 1 then
        _towerData.CurLevel = 1;
    end
    local _curCfg = DataConfig.DataChallengeReward[_towerData.CurLevel];
    if _curCfg == nil then
        return;
    end

    local _startLevel = (_towerData.CurLevel - 1) // 10 * 10 + 1;
    local _resIndex = 1;
    for i = _startLevel, _startLevel + 9 do
        local _cfg = DataConfig.DataChallengeReward[i];
        self.LevelIcons[_resIndex]:Refresh(_cfg, _towerData.CurLevel);
        _resIndex = _resIndex + 1;
    end

    self.NameLabel.text = _curCfg.Name;
    self.NeedFightLabel.text = tostring(_curCfg.NeedFightPower);
    self.MyFightLabel.text = tostring(_lp.FightPower);

    local _curItems = Utils.SplitStrByTableS(_curCfg.SuccessReward);
    for i = 1, 3 do
        if i <= #_curItems then
            self.CurDropItems[i].RootGO:SetActive(true);
            self.CurDropItems[i]:InItWithCfgid(_curItems[i][1], _curItems[i][2], false, false);
        else
            self.CurDropItems[i].RootGO:SetActive(false);
        end
    end
    self.CurDropGrid:Reposition();

    local _bigLevelCfg = DataConfig.DataChallengeReward[_startLevel + 9];
    if _bigLevelCfg ~= nil then
        _curItems = Utils.SplitStrByTableS(_bigLevelCfg.FirstReward);
        for i = 1, 4 do
            if i <= #_curItems then
                self.CurBigDropItems[i].RootGO:SetActive(true);
                self.CurBigDropItems[i]:InItWithCfgid(_curItems[i][1], _curItems[i][2], false, false);
            else
                self.CurBigDropItems[i].RootGO:SetActive(false);
            end
        end
        self.CurBigDropGrid:Reposition();
    end
end

return UITowerCopyPanel