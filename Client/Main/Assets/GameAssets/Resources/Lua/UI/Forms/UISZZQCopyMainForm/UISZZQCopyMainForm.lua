------------------------------------------------
--作者： yangqf
--日期： 2019-5-7
--文件： UISZZQCopyMainForm.lua
--模块： UISZZQCopyMainForm
--描述： 圣战之启副本主界面
------------------------------------------------
local UIItem = require "UI.Components.UIItem";

--//模块定义
local UISZZQCopyMainForm = {
    --右上角trans
    RightTopTrans = nil,        --transform
    --离开按钮
    LeaveBtn = nil,             --button
    --商店按钮
    ShopBtn = nil,              --button

    --倒计时
    TimeLabel = nil,
    --阵营图标
    CampIcons = nil,
    --阵营人数
    CampNums = nil,
    --阵营分数
    CampScores = nil,

    --自己的分数
    SelfScore = nil,
    --自己的排名
    SelfRank = nil,
    --需要的分数
    NeedScore = nil,

    --grid
    ItemGrid = nil,
    --物品列表
    AwardItems = nil,

    --积分排名按钮
    ScoreRankBtn = nil,
    --排名奖励按钮
    RankAwardBtn = nil,
    --奖励已经全部领取标志
    NotAward = nil,

    --阵营图标ID
    CampIconIds = {},
    --上次更新剩余时间的秒数
    FrontUpdateTime = -1,
    --缓存的奖励配置，由于lua遍历无序，所以需要一个有序的配置
    CacheAwardTable = nil,
}

--继承Form函数
function UISZZQCopyMainForm:OnRegisterEvents()
    self:RegisterEvent(UIEventDefine.UISZZQCopyMainForm_OPEN, self.OnOpen,self);
    self:RegisterEvent(UIEventDefine.UISZZQCopyMainForm_CLOSE, self.OnClose,self);
    self:RegisterEvent(LogicEventDefine.EID_EVENT_ON_MAINMENU_OPEN, self.OnMainMenuOpen,self);
    self:RegisterEvent(LogicEventDefine.EID_EVENT_ON_MAINMENU_CLOSE, self.OnMainMenuClose,self);
end

function UISZZQCopyMainForm:OnFirstShow()

    --设置特殊的阵营Icon，用于展示到头顶
    local _compCfg = DataConfig.DataGlobal[1314];
    if _compCfg ~= nil then
        self.CampIconIds = {};
        local _compIcons = Utils.SplitStrByTableS(_compCfg.Params);
        for i = 1, #_compIcons do
            self.CampIconIds[_compIcons[i][1]] = _compIcons[i][2];
        end
    end

    self.RightTopTrans = UIUtils.FindTrans(self.Trans, "RightTop");
    self.LeaveBtn = UIUtils.FindBtn(self.Trans, "RightTop/Leave");
    self.ShopBtn = UIUtils.FindBtn(self.Trans, "RightTop/Shop");
    UIUtils.AddBtnEvent(self.LeaveBtn, self.OnLeaveBtnClick, self);
    UIUtils.AddBtnEvent(self.ShopBtn, self.OnShopBtnClick, self);
    self.CSForm.UIRegion = UIFormRegion.MainRegion;
    self.CSForm:AddAlphaPosAnimation(self.RightTopTrans, 0, 1, 0, 130, 0.5, false, false);

    self.TimeLabel = UIUtils.FindLabel(self.Trans, "Left/Back/Title/Time");
    self.CampIcons = {};
    self.CampNums = {};
    self.CampScores = {};
    for i = 1, 3 do
        self.CampIcons[i] = UnityUtils.RequireComponent(UIUtils.FindTrans(self.Trans, string.format("Left/Back/Back/%d", i)), "Funcell.GameUI.Form.UIIcon");
        self.CampIcons[i]:UpdateIcon(self.CampIconIds[i]);
        self.CampNums[i] = UIUtils.FindLabel(self.Trans, string.format("Left/Back/Back/%d/Num", i));
        self.CampScores[i] = UIUtils.FindLabel(self.Trans, string.format("Left/Back/Back/%d/Score", i));
    end
    
    self.SelfScore = UIUtils.FindLabel(self.Trans, "Left/Back/Back/SelfScore");
    self.SelfRank = UIUtils.FindLabel(self.Trans, "Left/Back/Back/SelfRank");
    self.NeedScore = UIUtils.FindLabel(self.Trans, "Left/Back/Back/ItemTitle");

    self.ItemGrid = UIUtils.FindGrid(self.Trans, "Left/Back/Back/Grid");
    self.AwardItems = {};
    for i = 1, 4 do
        self.AwardItems[i] = UIItem:New(UIUtils.FindTrans(self.Trans, string.format("Left/Back/Back/Grid/%d", i)));
    end

    self.ScoreRankBtn = UIUtils.FindBtn(self.Trans, "Left/Back/Back/ScoreRank");
    self.RankAwardBtn = UIUtils.FindBtn(self.Trans, "Left/Back/Back/RankAward");
    UIUtils.AddBtnEvent(self.ScoreRankBtn, self.OnScoreRankBtnClick, self);
    UIUtils.AddBtnEvent(self.RankAwardBtn, self.OnRankAwardBtnClick, self);
    self.NotAward = UIUtils.FindGo(self.Trans, "Left/Back/Back/NotAward");

    self.CacheAwardTable = List:New();
    --注意此遍历不是按照表顺序遍历的
    for k,v in pairs(DataConfig.DataSZZQScoreAward) do
        self.CacheAwardTable:Add(v);
    end
    self.CacheAwardTable:Sort(function(a,b)
        return a.Score < b.Score;
    end);
end

function UISZZQCopyMainForm:OnShowAfter()
   self.CSForm:PlayShowAnimation(self.RightTopTrans);
   self.FrontUpdateTime = -1;
end

function UISZZQCopyMainForm:OnHideBefore()
end

--更新
function UISZZQCopyMainForm:Update(dt)
end

--开启事件
function UISZZQCopyMainForm:OnOpen(obj, sender)
    self.CSForm:Show(sender);
    self:RefreshPageInfo(obj);
end

--关闭事件
function UISZZQCopyMainForm:OnClose(obj, sender)
    self.CSForm:Hide();
end

--刷新界面
function UISZZQCopyMainForm:RefreshPageInfo(msg)
    if msg == nil then
        return;
    end

    local _campCount = #msg.campInfo;
    for i = 1, _campCount do
        local _msgInfo = msg.campInfo[i];
        local _index = _msgInfo.camp;
        if _index > 0 and _index <= 3 then
            self.CampNums[_index].text = DataConfig.DataMessageString.Get("C_SZZQ_PEOPLENUM", _msgInfo.count);
            self.CampScores[_index].text = DataConfig.DataMessageString.Get("C_SZZQ_TIMEMIN", _msgInfo.points);
        end
    end
    self.SelfScore.text = DataConfig.DataMessageString.Get("C_SZZQ_TIMEMIN", msg.selfScore);
    self.SelfRank.text = DataConfig.DataMessageString.Get("C_SZZQ_RANK", msg.selfRank);

    local _scoreCfg = nil;
    local _maxScore = nil;
    local _awardCount = #self.CacheAwardTable;
    for i = 1, _awardCount do
        if  msg.selfScore < self.CacheAwardTable[i].Score then
            _scoreCfg = self.CacheAwardTable[i];
            break;
        end
        _maxScore = self.CacheAwardTable[i].Score;
    end

    if _scoreCfg ~= nil then
        self.NotAward:SetActive(false);
        self.ItemGrid.gameObject:SetActive(true);
        self.NeedScore.text = DataConfig.DataMessageString.Get("C_SZZQ_SCOREAWARD", _scoreCfg.Score);
        --解析经验奖励
        local _levelCfg = DataConfig.DataCharacters[GameCenter.GameSceneSystem:GetLocalPlayerLevel()];
        if _levelCfg ~= nil then
            local _itemParams = Utils.SplitStr(_levelCfg.SZZQEXPAward, ';');
            if  _scoreCfg.UesExpIndex >= 0 and _scoreCfg.UesExpIndex < #_itemParams then
                self.AwardItems[1].RootGO:SetActive(true);
                self.AwardItems[1].RootGO:SetActive(true);
                self.AwardItems[1]:InItWithCfgid(UnityUtils.GetObjct2Int(ItemTypeCode.Exp), tonumber(_itemParams[_scoreCfg.UesExpIndex + 1]), false, false);
            end
        end
        --解析物品奖励
        local _itemTable = Utils.SplitStrByTableS(_scoreCfg.Award);
        local _itemCount = #_itemTable;
        for i = 2, 4 do
            local _itemIndex = i - 1;
            if _itemIndex <= _itemCount then
                self.AwardItems[i].RootGO:SetActive(true);
                self.AwardItems[i]:InItWithCfgid(_itemTable[_itemIndex][1], _itemTable[_itemIndex][2], false, false);
            else
                self.AwardItems[i].RootGO:SetActive(false);
            end
        end
        self.ItemGrid:Reposition();
    else
        self.NotAward:SetActive(true);
        self.ItemGrid.gameObject:SetActive(false);
        self.NeedScore.text = DataConfig.DataMessageString.Get("C_SZZQ_SCOREAWARD", _maxScore);
    end
end

--更新
function UISZZQCopyMainForm:Update(dt)
    if GameCenter.MapLogicSystem.ActiveLogic ~= nil and GameCenter.MapLogicSystem.ActiveLogic.RemainTime ~= nil then
        local _remianTime = math.floor(GameCenter.MapLogicSystem.ActiveLogic.RemainTime);
        if _remianTime ~= self.FrontUpdateTime then
            self.FrontUpdateTime = _remianTime;
            local _min = _remianTime // 60;
            local _sec = _remianTime - (_min * 60);
            self.TimeLabel.text =  DataConfig.DataMessageString.Get("C_SZZQ_TIME", _min, _sec);
        end
    end
end

--主界面菜单打开处理
function UISZZQCopyMainForm:OnMainMenuOpen(obj, sender)
    self.CSForm:PlayHideAnimation(self.RightTopTrans);
end

--主界面菜单关闭处理
function UISZZQCopyMainForm:OnMainMenuClose(obj, sender)
    self.CSForm:PlayShowAnimation(self.RightTopTrans);
end

--离开按钮点击
function UISZZQCopyMainForm:OnLeaveBtnClick()
    GameCenter.MapLogicSystem:SendLeaveMapMsg(true);
end

--积分排名按钮点击
function UISZZQCopyMainForm:OnScoreRankBtnClick()
    if GameCenter.MapLogicSystem.ActiveLogic ~= nil and GameCenter.MapLogicSystem.ActiveLogic.CurCopyMapDataID ~= nil then
        GameCenter.Network.Send("MSG_copyMap.ReqCloneFightInfo", {modelId = GameCenter.MapLogicSystem.ActiveLogic.CurCopyMapDataID})
    end
end

--排名奖励按钮点击
function UISZZQCopyMainForm:OnRankAwardBtnClick()
    GameCenter.PushFixEvent(UIEventDefine.UISZZQAwardForm_OPEN);
end

--商店按钮点击
function UISZZQCopyMainForm:OnShopBtnClick()
    GameCenter.MainFunctionSystem:DoFunctionCallBack(FunctionStartIdCode.Mall, nil);
end

return UISZZQCopyMainForm;