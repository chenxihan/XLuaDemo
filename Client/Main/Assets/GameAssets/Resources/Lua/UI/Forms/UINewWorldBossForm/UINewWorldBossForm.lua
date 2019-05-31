------------------------------------------------
--作者： cy
--日期： 2019-05-21
--文件： UIMySelfBossCopyForm.lua
--模块： UIMySelfBossCopyForm
--描述： 个人BOSS副本左侧界面数据
------------------------------------------------

local UIItem = require "UI.Components.UIItem"

local UINewWorldBossForm = {
    LeftTrs = nil,
    BossCloneGo = nil,
    BossCloneRoot = nil,
    BossCloneRootScrollView = nil,
    BossCloneRootGrid = nil,
    CenterTrs = nil,
    ItemCloneGo = nil,
    ItemCloneRoot = nil,
    ItemCloneRootGrid = nil,
    FollowBtn = nil,
    KillRecordBtn = nil,
    KillRecordPanelTrs = nil,
    KillRecordPanelCloseBg = nil,
    KillRecordPanelCloseBtn = nil,
    BossInfoBtn = nil,
    BossInfoPanelTrs = nil,
    BossInfoPanelCloseBg = nil,
    BossInfoPanelCloseBtn = nil,
    BottomTrs = nil,
    LayerCloneGo = nil,
    LayerCloneRoot = nil,
    LayerCloneRootScrollView = nil,
    LayerCloneRootGrid = nil,
    KillBossDescLab = nil,
    RankRewardCountLab = nil,
    EnterRewardCountLab = nil,
    GotoBtn = nil,
    CurSelectBossID = 0,
    CurSelectLayer = 0,
    RefreshTimeOffset = 0.5,            --刷新的时间间隔
    CurTime = 0,                        --用于计算时间间隔
    StartRefreshTime = false,
}

function UINewWorldBossForm:OnRegisterEvents()
	self:RegisterEvent(UIEventDefine.UINewWorldBossForm_OPEN, self.OnOpen)
	self:RegisterEvent(UIEventDefine.UINewWorldBossForm_CLOSE, self.OnClose)
	self:RegisterEvent(LogicEventDefine.EID_EVENT_NEWWORLDBOSS_REFRESHTIME, self.RefreshBossTime)
	self:RegisterEvent(LogicEventDefine.EID_EVENT_NEWWORLDBOSS_KILLRECORD, self.SetBossKillRecord)
	self:RegisterEvent(LogicEventDefine.EID_EVENT_NEWWORLDBOSS_FOLLOW, self.SetFollowBoss)
end

function UINewWorldBossForm:OnOpen(obj, sender)
    self.CSForm:Show(sender)
end

function UINewWorldBossForm:OnClose(obj, sender)
    self.CSForm:Hide()
    self.StartRefreshTime = false
end

--注册UI上面的事件，比如点击事件等
function UINewWorldBossForm:RegUICallback()
    UIUtils.AddBtnEvent(self.FollowBtn, self.OnClickFollowBtn, self)
    UIUtils.AddBtnEvent(self.KillRecordBtn, self.OnClickKillRecordBtn, self)
    UIUtils.AddBtnEvent(self.BossInfoBtn, self.OnClickBossInfoBtn, self)
    UIUtils.AddBtnEvent(self.GotoBtn, self.OnClickGotoBtn, self)
    UIUtils.AddBtnEvent(self.KillRecordPanelCloseBtn, self.CloseKillRecordPanel, self)
    UIUtils.AddBtnEvent(self.BossInfoPanelCloseBtn, self.CloseBossInfoPanel, self)
    UIEventListener.Get(self.KillRecordPanelCloseBg.gameObject).onClick = Utils.Handler(self.CloseKillRecordPanel, self)
    UIEventListener.Get(self.BossInfoPanelCloseBtn.gameObject).onClick = Utils.Handler(self.CloseBossInfoPanel, self)
end

function UINewWorldBossForm:OnFirstShow()
    self:FindAllComponents()
    self:RegUICallback()
end

function UINewWorldBossForm:OnShowBefore()
    GameCenter.BossSystem:ReqAllWorldBossInfo()
end

function UINewWorldBossForm:OnHideBefore()

end

function UINewWorldBossForm:SetFollowBoss(obj, sender)
    local _followSelect = self.FollowBtn.transform:Find("selected").gameObject
    local _bossInfo = GameCenter.BossSystem.WorldBossInfoDic[self.CurSelectBossID]
    if _bossInfo then
        _followSelect:SetActive(_bossInfo.IsFollow)
    else
        _followSelect:SetActive(false)
    end
end

function UINewWorldBossForm:SetBossKillRecord(obj, sender)
    if obj then
        if obj.bossId == self.CurSelectBossID then
            if obj.killedRecordList and #obj.killedRecordList > 0 then
                self.KillRecordPanelTrs:Find("NoRecordTips").gameObject:SetActive(false)
                local _recordCloneGo = UIUtils.FindGo(self.KillRecordPanelTrs, "RecordClone")
                local _recordCloneRoot = UIUtils.FindTrans(self.KillRecordPanelTrs, "RecordRoot")
                local _recordCloneRootGrid = _recordCloneRoot:GetComponent("UIGrid")
                local _recordCloneRootScrollView = _recordCloneRoot:GetComponent("UIScrollView")
                for i=1, #obj.killedRecordList do
                    local _go
                    if i - 1 < _recordCloneRoot.childCount then
                        _go = _recordCloneRoot:GetChild(i - 1).gameObject
                    else
                        _go = UnityUtils.Clone(_recordCloneGo, _recordCloneRoot)
                    end
                    local _timeLab = UIUtils.FindLabel(_go.transform, "Time")
                    local _nameLab = UIUtils.FindLabel(_go.transform, "Name")
                    local _timeStr = Time.StampToDateTime(obj.killedRecordList[i].killTime, "HH:mm:ss")
                    --local d, h, m, s = Time.SplitTime(obj.killedRecordList[i].killTime)
                    _timeLab.txt = _timeStr
                    local _killerName = obj.killedRecordList[i].killer
                    _nameLab.text = UIUtils.CSFormat(DataConfig.DataMessageString.Get("NEWWORLDBOSS_COLOREDKILLINFO"), _killerName)
                    _go:SetActive(true)
                end
                for i=#obj.killedRecordList, _recordCloneRoot.childCount - 1 do
                    _recordCloneRoot:GetChild(i - 1).gameObject:SetActive(false)
                end
                _recordCloneRootGrid.repositionNow = true
                _recordCloneRootScrollView:ResetPosition()
            else
                self.KillRecordPanelTrs:Find("NoRecordTips").gameObject:SetActive(true)
            end
        else
            self.KillRecordPanelTrs:Find("NoRecordTips").gameObject:SetActive(true)
        end
    end
end

function UINewWorldBossForm:SetBossInfo()
    local _attrCloneGo = UIUtils.FindGo(self.BossInfoPanelTrs, "AttrClone")
    local _attrCloneRoot = UIUtils.FindTrans(self.BossInfoPanelTrs, "AttrRoot")
    local _attrCloneRootGrid = _attrCloneRoot:GetComponent("UIGrid")
    local _attrsDic = Dictionary:New()
    local _monsterCfg = DataConfig.DataMonster[self.CurSelectBossID]
    local _attrs = Utils.SplitStrByTableS(_monsterCfg.AttributeValue, {";", "_"})
    for i=1, 4 do
        if not _attrsDic:ContainsKey(_attrs[i][1]) then
            _attrsDic:Add(_attrs[i][1], _attrs[i][2])
        end
    end
    if not _attrsDic:ContainsKey(2) then
        _attrsDic:Add(2, _monsterCfg.MaxHp)
    end
    local _count = 0
    _attrsDic:Foreach(function(key, value)
        local _go
        if _count < _attrCloneRoot.childCount then
            _go = _attrCloneRoot:GetChild(_count).gameObject
        else
            _go = UnityUtils.Clone(_attrCloneGo, _attrCloneRoot)
        end
        local _attrCfg = DataConfig.DataAttributeAdd[key]
        if _attrCfg then
            local _nameLab = UIUtils.FindLabel(_go.transform, "AttrName")
            local _valueLab = UIUtils.FindLabel(_go.transform, "AttrValue")
            _nameLab.text = _attrCfg.Name
            local _valueStr = tostring(value)
            if _attrCfg.ShowPercent == 1 then
                _valueStr = string.format( "%s%%", tostring(math.FormatNumber(value/100)))
            end
            _valueLab.text = _valueStr
        end
        _go:SetActive(true)
        _count = _count + 1
    end)
    for i=_count, _attrCloneRoot.childCount - 1 do
        _attrCloneRoot:GetChild(i).gameObject:SetActive(false)
    end
    _attrCloneRootGrid.repositionNow = true
end

function UINewWorldBossForm:RefreshBossTime(obj, sender)
    if self.LayerCloneRoot.childCount > 0 then
        self:OnClickBottomLayer(self.LayerCloneRoot:GetChild(0).gameObject)
        self.StartRefreshTime = true
    end
    self:SetRemainCount()
end

function UINewWorldBossForm:CloseKillRecordPanel()
    self.KillRecordPanelTrs.gameObject:SetActive(false)
end

function UINewWorldBossForm:CloseBossInfoPanel()
    self.BossInfoPanelTrs.gameObject:SetActive(false)
end

function UINewWorldBossForm:OnClickFollowBtn()
    if GameCenter.BossSystem.WorldBossInfoDic:ContainsKey(self.CurSelectBossID) then
        local _isFollow = GameCenter.BossSystem.WorldBossInfoDic[self.CurSelectBossID].IsFollow
        GameCenter.BossSystem:ReqFollowBoss(self.CurSelectBossID, not _isFollow)
    end
end

function UINewWorldBossForm:OnClickKillRecordBtn()
    GameCenter.BossSystem:ReqBossKilledInfo(self.CurSelectBossID)
    self.KillRecordPanelTrs.gameObject:SetActive(true)
end

function UINewWorldBossForm:OnClickBossInfoBtn()
    self.BossInfoPanelTrs.gameObject:SetActive(true)
    self:SetBossInfo()
end

function UINewWorldBossForm:OnClickGotoBtn()
    local _bossCfg = DataConfig.DataBossnewWorld[self.CurSelectBossID]
    if _bossCfg then
        GameCenter.BossSystem.CurSelectBossID = self.CurSelectBossID
        Debug.LogError("MapID = ", _bossCfg.CloneMap)
        GameCenter.CopyMapSystem:ReqSingleEnterCopyMap(_bossCfg.CloneMap)
    end
end

function UINewWorldBossForm:OnClickBottomLayer(go)
    go.transform:GetComponent("UIToggle"):Set(true)
    local _layer = UIEventListener.Get(go).parameter
    self:SetLeftBossList(_layer)
    self.CurSelectLayer = _layer
end

function UINewWorldBossForm:OnClickLeftBoss(go)
    local _bossID = UIEventListener.Get(go).parameter
    local _bossCfg = DataConfig.DataBossnewWorld[_bossID]
    go.transform:GetComponent("UIToggle"):Set(true)
    if _bossCfg then
        local _rewardItemList = Utils.SplitStr(_bossCfg.Drop, ";")
        for i=1, #_rewardItemList do
            local _itemID = tonumber(_rewardItemList[i])
            local _go
            if i - 1 < self.ItemCloneRoot.childCount then
                _go = self.ItemCloneRoot:GetChild(i - 1).gameObject
            else
                _go = UnityUtils.Clone(self.ItemCloneGo, self.ItemCloneRoot)
            end
            local _item = UIUtils.RequireUIItem(_go.transform)
            if _item then
                _item:InitializationWithIdAndNum(_itemID, 0, false, false)
            end
            _go:SetActive(true)
        end
        for i=#_rewardItemList, self.ItemCloneRoot.childCount - 1 do
            self.ItemCloneRoot:GetChild(i).gameObject:SetActive(false)
        end
        self.ItemCloneRootGrid.repositionNow = true
        local _followSelect = self.FollowBtn.transform:Find("selected").gameObject
        local _bossInfo = GameCenter.BossSystem.WorldBossInfoDic[_bossID]
        if _bossInfo then
            _followSelect:SetActive(_bossInfo.IsFollow)
        else
            _followSelect:SetActive(false)
        end
    end
    self.CurSelectBossID = _bossID
end

function UINewWorldBossForm:FindAllComponents()
    self.LeftTrs = UIUtils.FindTrans(self.Trans, "Left")
    self.BossCloneGo = UIUtils.FindGo(self.LeftTrs, "BossClone")
    self.BossCloneRoot = UIUtils.FindTrans(self.LeftTrs, "BossRoot")
    self.BossCloneRootGrid = self.BossCloneRoot:GetComponent("UIGrid")
    self.BossCloneRootScrollView = self.BossCloneRoot:GetComponent("UIScrollView")
    self.CenterTrs = UIUtils.FindTrans(self.Trans, "Center")
    self.ItemCloneGo = UIUtils.FindGo(self.CenterTrs, "ItemClone")
    self.ItemCloneRoot = UIUtils.FindTrans(self.CenterTrs, "ItemRoot")
    self.ItemCloneRootGrid = self.ItemCloneRoot:GetComponent("UIGrid")
    self.FollowBtn = UIUtils.FindBtn(self.CenterTrs, "Follow")
    self.KillRecordBtn = UIUtils.FindBtn(self.CenterTrs, "KillRecordBtn")
    self.KillRecordPanelTrs = UIUtils.FindTrans(self.CenterTrs, "KillRecordPanel")
    self.KillRecordPanelCloseBg = UIUtils.FindTrans(self.KillRecordPanelTrs, "CloseBg")
    self.KillRecordPanelCloseBtn = UIUtils.FindBtn(self.KillRecordPanelTrs, "CloseButton")
    self.BossInfoBtn = UIUtils.FindBtn(self.CenterTrs, "BossInfoBtn")
    self.BossInfoPanelTrs = UIUtils.FindTrans(self.CenterTrs, "BossInfoPanel")
    self.BossInfoPanelCloseBg = UIUtils.FindTrans(self.BossInfoPanelTrs, "CloseBg")
    self.BossInfoPanelCloseBtn = UIUtils.FindBtn(self.BossInfoPanelTrs, "CloseButton")
    self.BottomTrs = UIUtils.FindTrans(self.Trans, "Bottom")
    self.LayerCloneGo = UIUtils.FindGo(self.BottomTrs, "LayerClone")
    self.LayerCloneRoot = UIUtils.FindTrans(self.BottomTrs, "LayerRoot")
    self.LayerCloneRootGrid = self.LayerCloneRoot:GetComponent("UIGrid")
    self.LayerCloneRootScrollView = self.LayerCloneRoot:GetComponent("UIScrollView")
    self.KillBossDescLab = UIUtils.FindLabel(self.BottomTrs, "Desc/Label")
    self.RankRewardCountLab = UIUtils.FindLabel(self.BottomTrs, "RankRewardCount/Label")
    self.EnterRewardCountLab = UIUtils.FindLabel(self.BottomTrs, "EnterRewardCount/Label")
    self.GotoBtn = UIUtils.FindBtn(self.BottomTrs, "GoBtn")

    self:SetBottomLayerList()
end

function UINewWorldBossForm:SetBottomLayerList()
    GameCenter.BossSystem.LayerBossIDDic:Foreach(function(key, value)
        local _go
        if key < self.LayerCloneRoot.childCount then
            _go = self.LayerCloneRoot:GetChild(key).gameObject
        else
            _go = UnityUtils.Clone(self.LayerCloneGo, self.LayerCloneRoot)
        end
        local _layerName = UIUtils.FindLabel(_go.transform, "Name")
        local _infiniteStr = DataConfig.DataMessageString.Get("NEWWORLDBOSS_INFINITELAYER")
        local _layerNumStr = DataConfig.DataMessageString.Get("NEWWORLDBOSS_LAYERNUM")
        _layerName.text = key == 0 and _infiniteStr or UIUtils.CSFormat(_layerNumStr, key)
        UIEventListener.Get(_go).parameter = key
        UIEventListener.Get(_go).onClick = Utils.Handler(self.OnClickBottomLayer, self)
        _go:SetActive(true)
    end)
    self.LayerCloneRootGrid.repositionNow = true
    self.LayerCloneRootScrollView:ResetPosition()
    self:SetRemainCount()
end

function UINewWorldBossForm:SetRemainCount()
    local _totalRankCount = GameCenter.BossSystem.WorldBossRankRewardMaxCount
    local _usedRankCount = GameCenter.BossSystem.WorldBossRankRewardCount
    self.RankRewardCountLab.text = string.format( "%d/%d", _totalRankCount - _usedRankCount, _totalRankCount)
    local _totalEnterCount = GameCenter.BossSystem.WorldBossEnterRewardMaxCount
    local _usedEnterCount = GameCenter.BossSystem.WorldBossEnterRewardCount
    self.EnterRewardCountLab.text = string.format( "%d/%d", _totalEnterCount - _usedEnterCount, _totalEnterCount)
end

function UINewWorldBossForm:SetLeftBossList(layer)
    local _bossIDList = GameCenter.BossSystem.LayerBossIDDic[layer]
    local _maxLv = 0
    local _clickGameObj = nil
    if _bossIDList then
        local _lpLevel = GameCenter.GameSceneSystem:GetLocalPlayer().Level
        for i=1, #_bossIDList do
            local _bossCfg = DataConfig.DataBossnewWorld[_bossIDList[i]]
            local _monsterCfg = DataConfig.DataMonster[_bossIDList[i]]
            local _go
            if i - 1 < self.BossCloneRoot.childCount then
                _go = self.BossCloneRoot:GetChild(i - 1).gameObject
            else
                _go = UnityUtils.Clone(self.BossCloneGo, self.BossCloneRoot)
            end
            local _stageLab = UIUtils.FindLabel(_go.transform, "Stage")
            local _nameLab = UIUtils.FindLabel(_go.transform, "Name")
            local _levelLab = UIUtils.FindLabel(_go.transform, "Level")
            local _timeLab = UIUtils.FindLabel(_go.transform, "Time")
            if _bossCfg and _monsterCfg then
                _stageLab.text = UIUtils.CSFormat(DataConfig.DataMessageString.Get("NEWWORLDBOSS_STAGE"), _bossCfg.DropEquipShow)
                -- string.format( "%d阶", _bossCfg.DropEquipShow)
                local name = _monsterCfg.Name
                local lv = _monsterCfg.Level
                if lv <= _lpLevel then
                    if lv > _maxLv then
                        _clickGameObj = _go
                        _maxLv = lv
                    end
                end
                _nameLab.text = string.format( "%s", name)
                _levelLab.text = string.format( "Lv.%d", lv)
            end
            self:SetRefreshTime(_timeLab, _bossIDList[i])
            UIEventListener.Get(_go).parameter = _bossIDList[i]
            UIEventListener.Get(_go).onClick = Utils.Handler(self.OnClickLeftBoss, self)
            _go:SetActive(true)
        end
        for i=#_bossIDList, self.BossCloneRoot.childCount - 1 do
            self.BossCloneRoot:GetChild(i).gameObject:SetActive(false)
        end
        self.BossCloneRootGrid.repositionNow = true
        self.BossCloneRootScrollView:ResetPosition()
    end
    if _clickGameObj then
        self:OnClickLeftBoss(_clickGameObj)
    else
        if self.BossCloneRoot.childCount > 0 then
            self:OnClickLeftBoss(self.BossCloneRoot:GetChild(0).gameObject)
        end
    end
end

function UINewWorldBossForm:SetRefreshTime(timeLab, bossID)
    if GameCenter.BossSystem.WorldBossInfoDic:ContainsKey(bossID) then
        local _refreshTime = GameCenter.BossSystem.WorldBossInfoDic[bossID].RefreshTime
        if _refreshTime then
            if _refreshTime <= 0 then
                timeLab.text = DataConfig.DataMessageString.Get("NEWWORLDBOSS_ALIVE")
                timeLab.color = Color.green
            else
                local d, h, m, s = Time.SplitTime(math.floor( _refreshTime ))
                -- local _secound = math.FormatNumber(_refreshTime % 60)
                -- local _minute = math.FormatNumber((_refreshTime // 60) % 60)
                -- local _hour = math.FormatNumber((_refreshTime // 3600) % 60)
                timeLab.text = string.format( "%02d:%02d:%02d", h, m, s)
                timeLab.color = Color.red
            end
        end
    end
end

function UINewWorldBossForm:RefreshLeftListTime()
    for i=0, self.BossCloneRoot.childCount - 1 do
        local _go = self.BossCloneRoot:GetChild(i).gameObject
        if _go.activeSelf then
            local _bossID = UIEventListener.Get(_go).parameter
            local _timeLab = UIUtils.FindLabel(_go.transform, "Time")
            self:SetRefreshTime(_timeLab, _bossID)
        end
    end
end

function UINewWorldBossForm:Update(dt)
    if self.StartRefreshTime then
        if self.CurTime > self.RefreshTimeOffset then
            self:RefreshLeftListTime()
            self.CurTime = 0
        else
            self.CurTime = self.CurTime + dt
        end
    end
end

return UINewWorldBossForm