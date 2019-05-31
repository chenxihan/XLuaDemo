--作者： cy
--日期： 2019-04-26
--文件： UILianQiForgeStrengthForm.lua
--模块： UILianQiForgeStrengthForm
--描述： 炼器功能二级子面板：装备强化。上级面板为：锻造面板（UILianQiForgeForm）
------------------------------------------------

local UILianQiForgeStrengthForm = {
    RoleSkin = nil,                     --角色的skin
    EquipIconsRootTrs = nil,            --左侧所有装备的Icon等
    FightLabel = nil,                   --战力
    EquipTextLabel = nil,               --右侧，最顶部的文字。装备名字+99
    RightEquipItemTrs = nil,            --右侧装备Icon
    ProgressBar = nil,                  --右侧进度条
    ProgressText = nil,                 --右侧进度条数字
    AttributeTrs = nil,                 --右侧属性面板
    OldAttrTrs = nil,                   --右侧属性：当前等级
    NewAttrTrs = nil,                   --右侧属性：下一等级
    ItemCostTrs = nil,                  --道具消耗
    AllAttributePanel = nil,            --所有属性面板
    AllAttributeBtn = nil,              --显示所有属性按钮
    CloseAllAttributeBtn = nil,         --关闭所有属性面板按钮
    OneKeyStrengthBtn = nil,            --一键强化按钮
    StrengthBtn = nil,                  --强化按钮
    EquipItemByPosDic = Dictionary:New(),       --字典。key = 部位，value = UIEquipmentItem
    StrengthInfoByPosDic = Dictionary:New(),    --字典。key = 部位，value = 强化信息（等级，进度）
    CurSelectGo = nil,                  --当前选中的左侧装备
    CurSelectPos = 0,                   --当前选中的部位
    StartProgressAnim = false,          --是否开启进度条动画
    LevelUpCount = 0,                   --升级到下一个等级，进度条所需要走满的次数。 有可能从1级50%升级到9级70%，那么该值为9 - 1 = 8
    TargetProgress = 0,                 --升级到下一个等级，进度条到达的目标进度。 有可能从1级50%升级到9级70%，那么该值为70
    ProgressBarAddNum = 1,              --update()中，进度条涨的速度
    CurLevelCurProgress = 0,            --当前等级的当前熟练度
    CurLevelMaxProgress = 0,            --当前等级的最大熟练度
    IsDisplayCrit = false,
    ShowCrit = false,
    DisplayCritTimer = 0,
    DisplayCritSpan = 0,
    DisableCritTime= 0,
    CritIndex = 1,
    CritValueLab = nil,
    CritRate = nil,
}

function UILianQiForgeStrengthForm:OnRegisterEvents()
    self:RegisterEvent(UIEventDefine.UILianQiForgeStrengthForm_OPEN,self.OnOpen)
    self:RegisterEvent(UIEventDefine.UILianQiForgeStrengthForm_CLOSE,self.OnClose)
    self:RegisterEvent(LogicEventDefine.EID_EVENT_REFRESH_ALLINFO,self.RefreshAllInfo)
    self:RegisterEvent(LogicEventDefine.EID_EVENT_CHANGE_EQUIPMAXSTRENGTHLV,self.ChangeEquipMaxStrengthLv)
end

function UILianQiForgeStrengthForm:OnOpen(obj, sender)
    self.CSForm:Show(sender)
end

function UILianQiForgeStrengthForm:OnClose(obj,sender)
    self.CSForm:Hide()
end

function UILianQiForgeStrengthForm:ChangeEquipMaxStrengthLv(obj, sender)
    --obj = 装备部位
    self:RefreshLeftEquipInfos()
    local _curPosNewStrengthInfo = GameCenter.LianQiForgeSystem.StrengthPosLevelDic[obj]
    local _curPosStrengthInfo = {level = _curPosNewStrengthInfo.level, exp = _curPosNewStrengthInfo.exp}
    if self.StrengthInfoByPosDic:ContainsKey(obj) then
        self.StrengthInfoByPosDic[obj] = _curPosStrengthInfo
    end
    self:RefreshRightInfos(obj, _curPosStrengthInfo)
end

function UILianQiForgeStrengthForm:RefreshAllInfo(obj, sender)
    if obj.info.type == self.CurSelectPos then
        local _oldLv = self.StrengthInfoByPosDic[self.CurSelectPos].level
        local _newLv = GameCenter.LianQiForgeSystem.StrengthPosLevelDic[self.CurSelectPos].level
        self.LevelUpCount = _newLv - _oldLv
        self.TargetProgress = GameCenter.LianQiForgeSystem.StrengthPosLevelDic[self.CurSelectPos].exp
        local _strengthCount = Utils.GetTableLens(obj.CritRate)
        if obj.CritRate and _strengthCount > 0 then
            local _critCount = 0
            self.CritRate = List:New()
            for k,v in pairs(obj.CritRate) do
                if v > 1 then
                    self.CritRate:Add(v)
                    _critCount = _critCount + 1
                end
            end
            if _critCount > 0 then
                self.CritIndex = 1
                local _totalExp = 0
                local _maxExp = DataConfig.DataEquipIntenMain[self:GetCfgID(self.CurSelectPos, _oldLv)].ProficiencyMax
                local _expSpan = _maxExp - self.StrengthInfoByPosDic[self.CurSelectPos].exp
                _totalExp = _totalExp + _expSpan
                for i = _oldLv + 1, _newLv - 1 do
                    local _cfgMaxExp = DataConfig.DataEquipIntenMain[self:GetCfgID(self.CurSelectPos, i)].ProficiencyMax
                    _totalExp = _totalExp + _cfgMaxExp
                end
                _totalExp = _totalExp + self.TargetProgress
                self.DisplayCritSpan = _totalExp // _critCount
                self.DisableCritTime = _critCount == 1 and self.DisplayCritSpan or self.DisplayCritSpan * 0.85
                Debug.LogError("CritIndex = ", self.CritIndex, "CritCount = ", _critCount, "CritRate[CritIndex] = ", self.CritRate[self.CritIndex])
                self.CritValueLab.text = tostring(self.CritRate[self.CritIndex])
                self.CritValueLab.gameObject:SetActive(true)
                self.IsDisplayCrit = true
                self.ShowCrit = true
            end
        end
        self.StartProgressAnim = true
    end
end

function UILianQiForgeStrengthForm:RegUICallback()
    UIUtils.AddBtnEvent(self.StrengthBtn, self.OnClickStrengthBtn, self)
    UIUtils.AddBtnEvent(self.OneKeyStrengthBtn, self.OnClickOneKeyStrengthBtn, self)
    UIEventListener.Get(self.AllAttributeBtn.gameObject).onClick = Utils.Handler(self.OnClickAllAttributeBtn, self)
    UIEventListener.Get(self.CloseAllAttributeBtn.gameObject).onClick = Utils.Handler(self.OnClickCloseAllAttributeBtn, self)
    --UIUtils.AddBtnEvent(self.AllAttributeBtn, self.OnClickAllAttributeBtn, self)
    --UIUtils.AddBtnEvent(self.CloseAllAttributeBtn, self.OnClickCloseAllAttributeBtn, self)
end

function UILianQiForgeStrengthForm:OnFirstShow()
    --self.EquipItemByPosDic = Dictionary:New()
    --self.StrengthInfoByPosDic = Dictionary:New()
    self:FindAllComponents()
    self:RegUICallback()
end

function UILianQiForgeStrengthForm:OnShowBefore()
    
end

function UILianQiForgeStrengthForm:OnShowAfter()
    self:RefreshLeftEquipInfos()
    self:RefreshPlayerSkin()
    self:RefreshFightInfo()

    if self.EquipItemByPosDic ~= nil then
        self:OnClickEquipItem(self.EquipItemByPosDic[0].gameObject)
    end
end

function UILianQiForgeStrengthForm:OnHideBefore()
    self.CurSelectGo = nil
    self.CurSelectPos = 0
    self.StartProgressAnim = false
    self.LevelUpCount = 0
    self.TargetProgress = 0
    self.IsDisplayCrit = false
    self.DisplayCritTimer = 0
    self.DisplayCritSpan = 0
    self.DisableCritTime= 0
    self.CritIndex = 1
    self.CritRate = nil
    self.ShowCrit = false
end

function UILianQiForgeStrengthForm:FindAllComponents()
    self.RoleSkin = UIUtils.RequireUIRoleSkinCompoent(UIUtils.FindTrans(self.Trans,"Left/UIRoleSkinCompoent"))
    self.EquipIconsRootTrs = UIUtils.FindTrans(self.Trans, "Left/EquipIcons")
    self.FightLabel = UIUtils.FindLabel(self.Trans, "Left/Fight")
    self.EquipTextLabel = UIUtils.FindLabel(self.Trans, "Right/EquipText")
    self.RightEquipItemTrs = UIUtils.FindTrans(self.Trans, "Right/UIEquipmentItem")
    self.ProgressBar = UIUtils.FindProgressBar(self.Trans, "Right/Progress")
    self.ProgressText = UIUtils.FindLabel(self.Trans, "Right/Progress/Text")
    self.AttributeTrs = UIUtils.FindTrans(self.Trans, "Right/Attribute")
    self.OldAttrTrs = UIUtils.FindTrans(self.Trans, "Right/Attribute/Old")
    self.NewAttrTrs = UIUtils.FindTrans(self.Trans, "Right/Attribute/New")
    self.ItemCostTrs = UIUtils.FindTrans(self.Trans, "Right/ItemCost")
    self.AllAttributePanel = UIUtils.FindTrans(self.Trans, "Left/AllAttributePanel")
    self.CloseAllAttributeBtn = UIUtils.FindTrans(self.AllAttributePanel, "Bg")
    self.AllAttributeBtn = UIUtils.FindTrans(self.Trans, "Left/AllAttributeBtn")
    self.OneKeyStrengthBtn = UIUtils.FindBtn(self.Trans, "Right/OneKeyStrengthBtn")
    self.StrengthBtn = UIUtils.FindBtn(self.Trans, "Right/StrengthBtn")
    self.CritValueLab = UIUtils.FindLabel(self.Trans, "Right/CritValue")
    --self.CSForm:AddAlphaAnimation(self.CritValueLab.transform)
    if self.RoleSkin ~= nil then
        self.RoleSkin:OnFirstShow(self.CSForm, FSkinTypeCode.Player)
    end
    self:InitEquipIcons()
    self:InitStrengthDic()
end

function UILianQiForgeStrengthForm:OnClickCloseAllAttributeBtn()
    self.AllAttributePanel.gameObject:SetActive(false)
end

function UILianQiForgeStrengthForm:OnClickAllAttributeBtn()
    self.AllAttributePanel.gameObject:SetActive(true)
    local _totalLv = GameCenter.LianQiForgeSystem:GetTotalStrengthLv()
    local _curLvLab = UIUtils.FindLabel(self.AllAttributePanel, "CurLevel")
    _curLvLab.text = tostring(_totalLv)
    local _curCfg, _nextCfg = self:GetCurAndNextCfg(_totalLv)
    --当前已获得属性
    local _getLevelInfoTrs = UIUtils.FindTrans(self.AllAttributePanel, "GetLevelInfo")
    local _getTotalLvLab = UIUtils.FindLabel(_getLevelInfoTrs, "TotalLevel")
    if _curCfg.Id == 0 then
        _getLevelInfoTrs.gameObject:SetActive(false)
    else
        _getLevelInfoTrs.gameObject:SetActive(true)
        _getTotalLvLab.text = tostring(_curCfg.Level)
        local _getAttrs = Utils.SplitStrByTableS(_curCfg.Value, {';','_'})
        self:SetAllAttrText(true, 1, _getAttrs[1])
        self:SetAllAttrText(true, 2, _getAttrs[2])
        self:SetAllAttrText(true, 3, _getAttrs[3])
        self:SetAllAttrText(true, 4, _getAttrs[4])
    end
    local _nextLevelInfoTrs = UIUtils.FindTrans(self.AllAttributePanel, "NextLevelInfo")
    local _nextTotalLvLab = UIUtils.FindLabel(_nextLevelInfoTrs, "TotalLevel")
    if _nextCfg.Id == -1 then
        _nextLevelInfoTrs.gameObject:SetActive(false)
    else
        _nextLevelInfoTrs.gameObject:SetActive(true)
        _nextTotalLvLab.text = tostring(_nextCfg.Level)
        local _nextAttrs = Utils.SplitStrByTableS(_nextCfg.Value, {';', '_'})
        self:SetAllAttrText(false, 1, _nextAttrs[1])
        self:SetAllAttrText(false, 2, _nextAttrs[2])
        self:SetAllAttrText(false, 3, _nextAttrs[3])
        self:SetAllAttrText(false, 4, _nextAttrs[4])
    end
end

function UILianQiForgeStrengthForm:GetCurAndNextCfg(totalLv)
    --该表id从1开始，因此可以用“#”取长度
    local _cfgLength = #DataConfig.DataEquipIntenClass
    for k,v in pairs(DataConfig.DataEquipIntenClass) do
        --和前n-1个数据作对比（因为要和“当前条目”和“下一条目”的等级作对比）
        if k - 1 < _cfgLength then
            if totalLv >= v.Level and totalLv < DataConfig.DataEquipIntenClass[k + 1].Level then
                return v, DataConfig.DataEquipIntenClass[k + 1]
            end
        else
            --如果到了最后一条数据还没return
            local _cfg = Utils.DeepCopy(v)
            --Id == -1表示已达最高级
            _cfg.Id = -1
            return v, _cfg
        end
    end
    --默认数据
    local _cfg = Utils.DeepCopy(DataConfig.DataEquipIntenClass[1])
    --Id == 0表示未获得
    _cfg.Id = 0
    return _cfg, DataConfig.DataEquipIntenClass[1] --, Utils.DeepCopy(DataConfig.DataEquipIntenClass[1])
end

function UILianQiForgeStrengthForm:SetAllAttrText(isCurrent, index, attr)
    if isCurrent then
        local _getAttrLab = UIUtils.FindLabel(self.AllAttributePanel, string.format("GetLevelInfo/Attr%d", index))
        local _getAttrNameLab = UIUtils.FindLabel(self.AllAttributePanel, string.format("GetLevelInfo/Attr%d/Txt", index))
        if attr then
            _getAttrLab.gameObject:SetActive(true)
            local _attrCfg = DataConfig.DataAttributeAdd[attr[1]]
            local _txt = _attrCfg.ShowPercent == 0 and tostring(attr[2]) or string.format( "%s%%", tostring(math.FormatNumber(attr[2]/100)))
            _getAttrLab.text = _txt
            if _attrCfg then
                _getAttrNameLab.text = string.format("%s%s", _attrCfg.Name, ":")
            end
        else
            _getAttrLab.gameObject:SetActive(false)
        end
    else
        local _nextAttrLab = UIUtils.FindLabel(self.AllAttributePanel, string.format("NextLevelInfo/Attr%d", index))
        local _nextAttrNameLab = UIUtils.FindLabel(self.AllAttributePanel, string.format("NextLevelInfo/Attr%d/Txt", index))
        if attr then
            _nextAttrLab.gameObject:SetActive(true)
            local _attrCfg = DataConfig.DataAttributeAdd[attr[1]]
            local _txt = _attrCfg.ShowPercent == 0 and tostring(attr[2]) or string.format("%s%%", tostring(math.FormatNumber(attr[2]/100)))
            _nextAttrLab.text = _txt
            if _attrCfg then
                _nextAttrNameLab.text = string.format("%s%s", _attrCfg.Name, ":")
            end
        else
            _nextAttrLab.gameObject:SetActive(false)
        end
    end
end

function UILianQiForgeStrengthForm:OnClickStrengthBtn()
    local _equip = GameCenter.EquipmentSystem:GetPlayerDressEquip(self.CurSelectPos)
    local _strenthInfo = self.StrengthInfoByPosDic[self.CurSelectPos]
    if _equip == nil then
        GameCenter.MsgPromptSystem:ShowPrompt(DataConfig.DataMessageString.Get("LIANQI_FORGE_STRENGTHNEEDEQUIP"))
    else
        --部位的最高强化等级
        local _posIntenMaxLv = GameCenter.LianQiForgeSystem.StrengthMaxLevel
        --部位的最高强化等级对应的DataEquipIntenMain表
        local _posIntenMaxCfg = DataConfig.DataEquipIntenMain[self:GetCfgID(self.CurSelectPos, _posIntenMaxLv)]
        --当前装备的最高强化等级
        local _equipIntenMaxLv = _equip.ItemInfo.LevelMax
        --当前装备最高强化等级对应的DataEquipIntenMain表
        local _equipIntenMaxCfg = DataConfig.DataEquipIntenMain[self:GetCfgID(self.CurSelectPos, _equipIntenMaxLv)]
        if _strenthInfo.level < _equipIntenMaxLv then
            local _cfgID = self:GetCfgID(self.CurSelectPos, _strenthInfo.level)
            local _cfg = DataConfig.DataEquipIntenMain[_cfgID]
            local _haveMoney = GameCenter.ItemContianerSystem:GetItemCountFromCfgId(_cfg.StoneId)
            local _needMoney = _cfg.StoneNum
            if _haveMoney < _needMoney then
                GameCenter.MsgPromptSystem:ShowPrompt(DataConfig.DataMessageString.Get("MoneyNotEnough"))
                do return end
            end
            GameCenter.LianQiForgeSystem:ReqEquipStrengthUpLevel(self.CurSelectPos, false)
        elseif _strenthInfo.level == _equipIntenMaxLv then
            --如果和当前装备最大等级相等，比较经验值
            if _equipIntenMaxCfg ~= nil and _strenthInfo.exp >= _equipIntenMaxCfg.ProficiencyMax then
                --如果比当前装备最大强化等级的最大经验还高，给提示
                GameCenter.MsgPromptSystem:ShowPrompt(DataConfig.DataMessageString.Get("LIANQI_FORGE_MAXEQUIPSTRENGTHLV"))
            else
                --如果比当前装备最大强化等级的最大经验小，发消息
                local _cfgID = self:GetCfgID(self.CurSelectPos, _strenthInfo.level)
                local _cfg = DataConfig.DataEquipIntenMain[_cfgID]
                local _haveMoney = GameCenter.ItemContianerSystem:GetItemCountFromCfgId(_cfg.StoneId)
                local _needMoney = _cfg.StoneNum
                if _haveMoney < _needMoney then
                    GameCenter.MsgPromptSystem:ShowPrompt(DataConfig.DataMessageString.Get("MoneyNotEnough"))
                    do return end
                end
                GameCenter.LianQiForgeSystem:ReqEquipStrengthUpLevel(self.CurSelectPos, false)
            end
        else
            if _strenthInfo.level < _posIntenMaxLv then
                --提示“已达装备最高强化等级”
                GameCenter.MsgPromptSystem:ShowPrompt(DataConfig.DataMessageString.Get("LIANQI_FORGE_MAXEQUIPSTRENGTHLV"))
            else
                --提示“已达部位最高强化等级”
                GameCenter.MsgPromptSystem:ShowPrompt(DataConfig.DataMessageString.Get("LIANQI_FORGE_MAXPOSSTRENGTHLV"))
            end
        end
    end
end

function UILianQiForgeStrengthForm:OnClickOneKeyStrengthBtn()
    local _equip = GameCenter.EquipmentSystem:GetPlayerDressEquip(self.CurSelectPos)
    local _strenthInfo = self.StrengthInfoByPosDic[self.CurSelectPos]
    if _equip == nil then
        GameCenter.MsgPromptSystem:ShowPrompt(DataConfig.DataMessageString.Get("LIANQI_FORGE_STRENGTHNEEDEQUIP"))
    else
        --部位的最高强化等级
        local _posIntenMaxLv = GameCenter.LianQiForgeSystem.StrengthMaxLevel
        --部位的最高强化等级对应的DataEquipIntenMain表
        local _posIntenMaxCfg = DataConfig.DataEquipIntenMain[self:GetCfgID(self.CurSelectPos, _posIntenMaxLv)]
        --当前装备的最高强化等级
        local _equipIntenMaxLv = _equip.ItemInfo.LevelMax
        --当前装备最高强化等级对应的DataEquipIntenMain表
        local _equipIntenMaxCfg = DataConfig.DataEquipIntenMain[self:GetCfgID(self.CurSelectPos, _equipIntenMaxLv)]
        if _strenthInfo.level < _equipIntenMaxLv then
            local _cfgID = self:GetCfgID(self.CurSelectPos, _strenthInfo.level)
            local _cfg = DataConfig.DataEquipIntenMain[_cfgID]
            local _haveMoney = GameCenter.ItemContianerSystem:GetItemCountFromCfgId(_cfg.StoneId)
            local _needMoney = _cfg.StoneNum
            if _haveMoney < _needMoney then
                GameCenter.MsgPromptSystem:ShowPrompt(DataConfig.DataMessageString.Get("MoneyNotEnough"))
                do return end
            end
            GameCenter.LianQiForgeSystem:ReqEquipStrengthUpLevel(self.CurSelectPos, true)
        elseif _strenthInfo.level == _equipIntenMaxLv then
            --如果和当前装备最大等级相等，比较经验值
            if _equipIntenMaxCfg ~= nil and _strenthInfo.exp >= _equipIntenMaxCfg.ProficiencyMax then
                --如果比当前装备最大强化等级的最大经验还高，给提示
                GameCenter.MsgPromptSystem:ShowPrompt(DataConfig.DataMessageString.Get("LIANQI_FORGE_MAXEQUIPSTRENGTHLV"))
            else
                --如果比当前装备最大强化等级的最大经验小，发消息
                local _cfgID = self:GetCfgID(self.CurSelectPos, _strenthInfo.level)
                local _cfg = DataConfig.DataEquipIntenMain[_cfgID]
                local _haveMoney = GameCenter.ItemContianerSystem:GetItemCountFromCfgId(_cfg.StoneId)
                local _needMoney = _cfg.StoneNum
                if _haveMoney < _needMoney then
                    GameCenter.MsgPromptSystem:ShowPrompt(DataConfig.DataMessageString.Get("MoneyNotEnough"))
                    do return end
                end
                GameCenter.LianQiForgeSystem:ReqEquipStrengthUpLevel(self.CurSelectPos, true)
            end
        else
            if _strenthInfo.level < _posIntenMaxLv then
                --提示“已达装备最高强化等级”
                GameCenter.MsgPromptSystem:ShowPrompt(DataConfig.DataMessageString.Get("LIANQI_FORGE_MAXEQUIPSTRENGTHLV"))
            else
                --提示“已达部位最高强化等级”
                GameCenter.MsgPromptSystem:ShowPrompt(DataConfig.DataMessageString.Get("LIANQI_FORGE_MAXPOSSTRENGTHLV"))
            end
        end
    end
end

function UILianQiForgeStrengthForm:OnClickEquipItem(go)
    local _pos = UIEventListener.Get(go).parameter
    local _equipItem = UnityUtils.RequireComponent(go.transform, "Funcell.GameUI.Form.UIEquipmentItem")
    if self.CurSelectGo == go then
        -- if _equipItem.Equipment ~= nil then
        --     GameCenter.ItemTipsMgr:ShowTips(_equipItem.Equipment, go, ItemTipsLocation.EquipDisplay)
        -- end
        do return end
    else
        self.LevelUpCount = 0
        self.TargetProgress = 0
        self.IsDisplayCrit = false
        self.DisplayCritTimer = 0
        self.DisplayCritSpan = 0
        self.DisableCritTime= 0
        self.CritIndex = 1
        self.ShowCrit = false
        self.CritValueLab.gameObject:SetActive(false)
        --local levelInfo = { level = result.infos[i].level, exp = result.infos[i].exp }
        --如果在播动画的过程中被打断，那么需要刷新,上次选中部位的左侧强化等级信息
        if self.StartProgressAnim then
            local _lastPosNewStrengthInfo = GameCenter.LianQiForgeSystem.StrengthPosLevelDic[self.CurSelectPos]
            local _lastPosStrengthInfo = {level = _lastPosNewStrengthInfo.level, exp = _lastPosNewStrengthInfo.exp} --GameCenter.LianQiForgeSystem.StrengthPosLevelDic[self.CurSelectPos]
            if self.StrengthInfoByPosDic:ContainsKey(self.CurSelectPos) then
                self.StrengthInfoByPosDic[self.CurSelectPos] = _lastPosStrengthInfo
            end
            self:SetLeftStrengthLvByPos(self.CurSelectPos, _lastPosStrengthInfo)
            self.StartProgressAnim = false
        end
        local _curPosNewStrengthInfo = GameCenter.LianQiForgeSystem.StrengthPosLevelDic[_pos]
        local _curPosStrengthInfo = {level = _curPosNewStrengthInfo.level, exp = _curPosNewStrengthInfo.exp}
        if self.StrengthInfoByPosDic:ContainsKey(_pos) then
            self.StrengthInfoByPosDic[_pos] = _curPosStrengthInfo
        end
        self:RefreshRightInfos(_pos, _curPosStrengthInfo)
        if self.EquipItemByPosDic[self.CurSelectPos] then
            self.EquipItemByPosDic[self.CurSelectPos]:OnSelectItem(false)
        end
        if self.EquipItemByPosDic[_pos] then
            self.EquipItemByPosDic[_pos]:OnSelectItem(true)
        end
    end
    self.CurSelectPos = _pos
    self.CurSelectGo = go
    self.CurLevelCurProgress = GameCenter.LianQiForgeSystem.StrengthPosLevelDic[_pos].exp
    local _cfgID = self:GetCfgID(_pos, GameCenter.LianQiForgeSystem.StrengthPosLevelDic[_pos].level)
    self.CurLevelMaxProgress = DataConfig.DataEquipIntenMain[_cfgID].ProficiencyMax
    self.ProgressBarAddNum = self.CurLevelMaxProgress / 20
end

function UILianQiForgeStrengthForm:RightEquipItemOnClick(go)
    local _equipItem = UnityUtils.RequireComponent(go.transform, "Funcell.GameUI.Form.UIEquipmentItem")
    if _equipItem.Equipment ~= nil then
        GameCenter.ItemTipsMgr:ShowTips(_equipItem.Equipment, go, ItemTipsLocation.EquipDisplay)
    end
end


function UILianQiForgeStrengthForm:InitEquipIcons()
    for i=0, UnityUtils.GetObjct2Int(EquipmentType.Count) - 1 do
        local _str = string.format("UIEquipmentItem_%d", i)
        local _equipItem = UnityUtils.RequireComponent(self.EquipIconsRootTrs:Find(_str), "Funcell.GameUI.Form.UIEquipmentItem")
        UIEventListener.Get(_equipItem.gameObject).parameter = i
        _equipItem.SingleClick = Utils.Handler(self.OnClickEquipItem, self)
        self.EquipItemByPosDic:Add(i, _equipItem)
    end
end

function UILianQiForgeStrengthForm:InitStrengthDic()
    for i=0, UnityUtils.GetObjct2Int(EquipmentType.Count) - 1 do
        local _strengthInfo = GameCenter.LianQiForgeSystem.StrengthPosLevelDic[i]
        if _strengthInfo then
            self.StrengthInfoByPosDic:Add(i, {level = _strengthInfo.level, exp = _strengthInfo.exp})
        end
    end
end

function UILianQiForgeStrengthForm:RefreshLeftEquipInfos()
    self:RefreshLeftEquipIcons()
    self:RefreshLeftEquipStrengthLv()
end

function UILianQiForgeStrengthForm:RefreshLeftEquipIcons()
    for i=0, UnityUtils.GetObjct2Int(EquipmentType.Count) - 1 do
        if self.EquipItemByPosDic:ContainsKey(i) then
            local _equip = GameCenter.EquipmentSystem:GetPlayerDressEquip(i)
            local _starLv = GameCenter.EquipmentSystem:OnGetStarLevel(i)
            if _equip ~= nil then
                self.EquipItemByPosDic[i]:UpdateEquipment(_equip, i, _starLv)
            else
                self.EquipItemByPosDic[i]:UpdateEquipment(i, _starLv)
            end
        end
    end
end

function UILianQiForgeStrengthForm:RefreshLeftEquipStrengthLv()
    for i=0, UnityUtils.GetObjct2Int(EquipmentType.Count) - 1 do
        if self.EquipItemByPosDic:ContainsKey(i) then
            local _strengthInfo = GameCenter.LianQiForgeSystem.StrengthPosLevelDic[i]
            self:SetLeftStrengthLvByPos(i, _strengthInfo)
        end
    end
end

function UILianQiForgeStrengthForm:SetLeftStrengthLvByPos(pos, strenthInfo)
    local _strengthLvLab = UIUtils.FindLabel(self.EquipItemByPosDic[pos].transform, "StrengthLv")
    --local _strengthInfo = self.StrengthInfoByPosDic:Get(pos)
    -- if self.StrengthInfoByPosDic:ContainsKey(pos) then
    --     self.StrengthInfoByPosDic[pos] = {level = _strengthInfo.level, exp = _strengthInfo.exp}
    -- else
    --     self.StrengthInfoByPosDic:Add(pos, {level = _strengthInfo.level, exp = _strengthInfo.exp})
    -- end
    local _equip = GameCenter.EquipmentSystem:GetPlayerDressEquip(pos)
    if _equip ~= nil and strenthInfo.level > _equip.ItemInfo.LevelMax then
        _strengthLvLab.text = string.format("+%d", _equip.ItemInfo.LevelMax)
    else
        _strengthLvLab.text = string.format("+%d", strenthInfo.level)
    end
end

function UILianQiForgeStrengthForm:RefreshPlayerSkin()
    self.RoleSkin:SetEquip(FSkinPartCode.Body, RoleVEquipTool.GetLPBodyModel())
    self.RoleSkin:SetEquip(FSkinPartCode.Weapon, RoleVEquipTool.GetLPWeaponModel())
    self.RoleSkin:SetEquip(FSkinPartCode.Wing, RoleVEquipTool.GetLPWingModel())
    self.RoleSkin:SetEquip(FSkinPartCode.StrengthenVfx, RoleVEquipTool.GetLPStrengthenVfx())
    self.RoleSkin:SetLocalScale( 150.0 );
end

function UILianQiForgeStrengthForm:RefreshFightInfo()
    self.FightLabel.text = tostring(GameCenter.GameSceneSystem:GetLocalPlayer().FightPower)
end

--根据强化信息，更新右侧各种属性、等级、进度条等内容
function UILianQiForgeStrengthForm:RefreshRightInfos(pos, strengthInfo)
    local _strengthInfo = {type = pos, level = strengthInfo.level, exp = strengthInfo.exp}
    local _equip = GameCenter.EquipmentSystem:GetPlayerDressEquip(_strengthInfo.type)
    local _starLv = GameCenter.EquipmentSystem:OnGetStarLevel(_strengthInfo.type)
    --如果当前部位强化等级 > 当前装备所能容纳的强化上限。做相应处理
    if _equip ~= nil and _strengthInfo.level > _equip.ItemInfo.LevelMax then
        _strengthInfo.level = _equip.ItemInfo.LevelMax
        local _cfgID = self:GetCfgID(_strengthInfo.type, _strengthInfo.level)
        local _cfg = DataConfig.DataEquipIntenMain[_cfgID]
        _strengthInfo.exp = _cfg.ProficiencyMax
    end
    --装备信息
    self.EquipTextLabel.text = _equip ~= nil and string.format( "%s+%s", _equip.Name, _strengthInfo.level) or ""
    local _equipItem = UnityUtils.RequireComponent(self.RightEquipItemTrs, "Funcell.GameUI.Form.UIEquipmentItem")
    _equipItem.transform.name = string.format( "UIEquipmentItem_%d", pos)
    --右侧的装备icon，禁用点击事件
    _equipItem.SingleClick = Utils.Handler(self.RightEquipItemOnClick, self)
    if _equip ~= nil then
        _equipItem:UpdateEquipment(_equip, _strengthInfo.type, _starLv)
    else
        _equipItem:UpdateEquipment(_strengthInfo.type, _starLv)
    end
    --进度条
    local _cfgID = self:GetCfgID(_strengthInfo.type, _strengthInfo.level)
    local _cfg = DataConfig.DataEquipIntenMain[_cfgID]
    local _max = _cfg.ProficiencyMax
    self:RefreshProgressInfo(_strengthInfo.exp, _max)
    --属性
    self:SetAttributeInfo(_strengthInfo.type, _strengthInfo.level)
    local _item = UIUtils.RequireUIItem(self.ItemCostTrs)
    if _item then
        _item:InitializationWithIdAndNum(_cfg.StoneId, _cfg.StoneNum, false, true)
    end
    --按钮红点
    local _moneyIsEnough = GameCenter.LianQiForgeSystem:IsMoneyEnoughByPos(pos)
    self.StrengthBtn.transform:Find("RedPoint").gameObject:SetActive(_moneyIsEnough)
    self.OneKeyStrengthBtn.transform:Find("RedPoint").gameObject:SetActive(_moneyIsEnough)
    --_item数量颜色
    local _haveMoney = GameCenter.ItemContianerSystem:GetItemCountFromCfgId(_cfg.StoneId)
    local _needMoney = _cfg.StoneNum
    _item:OnSetNumColor(_haveMoney >= _needMoney and Color.green or Color.red)
end

function UILianQiForgeStrengthForm:GetCfgID(pos, level)
    return (pos + 100) * 1000 + level
end

function UILianQiForgeStrengthForm:RefreshProgressInfo(cur, max)
    self.ProgressBar.value = cur / max
    if cur <= max then
        self.ProgressText.text = string.format( "%d/%d", math.modf( cur ), math.modf( max ))
    else
        self.ProgressText.text = UIUtils.CSFormat(DataConfig.DataMessageString.Get("LIANQI_FORGE_STRENGTHOVERFLOW"), math.modf( cur - max ))
    end
end

function UILianQiForgeStrengthForm:SetAttributeInfo(pos, level)
    local _curLvCfgID = self:GetCfgID(pos, level)
    local _curLvCfg = DataConfig.DataEquipIntenMain[_curLvCfgID]
    self:SetAttrText(_curLvCfg, true)

    if level + 1 <= GameCenter.LianQiForgeSystem.StrengthMaxLevel then
        local _nextLvCfgID = self:GetCfgID(pos, level + 1)
        local _nextLvCfg = DataConfig.DataEquipIntenMain[_nextLvCfgID]
        self:SetAttrText(_nextLvCfg, false)
    else
        self:SetAttrText(_curLvCfg, false)
    end
end

--设置属性的text。cfg = 配置表（DataEquipIntenMain）， isOld = true表示左侧的当前等级text，isOld = false表示右侧的下一等级text
function UILianQiForgeStrengthForm:SetAttrText(cfg, isOld)
    if isOld then
        local _oldLvLab = UIUtils.FindLabel(self.OldAttrTrs, "Level")
        _oldLvLab.text = tostring(cfg.Level)
        local _oldAttr1Lab = UIUtils.FindLabel(self.OldAttrTrs, "Attr1")
        local _oldAttr1NameLab = UIUtils.FindLabel(self.OldAttrTrs, "Attr1/Txt")
        local _oldAttr2Lab = UIUtils.FindLabel(self.OldAttrTrs, "Attr2")
        local _oldAttr2NameLab = UIUtils.FindLabel(self.OldAttrTrs, "Attr2/Txt")
        local _attr1 = Utils.SplitStrByTableS(cfg.Value, {';','_'})
        if _attr1[1] then
            _oldAttr1Lab.gameObject:SetActive(true)
            local _attrCfg = DataConfig.DataAttributeAdd[_attr1[1][1]]
            local _txt = _attrCfg.ShowPercent == 0 and tostring(_attr1[1][2]) or string.format( "%s%%", tostring(math.FormatNumber(_attr1[1][2]/100)))-- string.format( "%d%%", _attr1[1][2]//100)
            _oldAttr1Lab.text = _txt
            if _attrCfg ~= nil then
                _oldAttr1NameLab.text = _attrCfg.Name .. ":"
            end
        else
            _oldAttr1Lab.gameObject:SetActive(false)
        end
        if _attr1[2] then
            _oldAttr2Lab.gameObject:SetActive(true)
            local _attrCfg = DataConfig.DataAttributeAdd[_attr1[2][1]]
            local _txt = _attrCfg.ShowPercent == 0 and tostring(_attr1[2][2]) or string.format( "%s%%", tostring(math.FormatNumber(_attr1[2][2]/100)))-- string.format( "%d%%", _attr1[2][2]//100)
            _oldAttr2Lab.text = _txt
            if _attrCfg ~= nil then
                _oldAttr2NameLab.text = _attrCfg.Name .. ":"
            end
        else
            _oldAttr2Lab.gameObject:SetActive(false)
        end
    else
        local _newLvLab = UIUtils.FindLabel(self.NewAttrTrs, "Level")
        _newLvLab.text = tostring(cfg.Level)
        local _newAttr1Lab = UIUtils.FindLabel(self.NewAttrTrs, "Attr1")
        local _newAttr1NameLab = UIUtils.FindLabel(self.NewAttrTrs, "Attr1/Txt")
        local _newAttr2Lab = UIUtils.FindLabel(self.NewAttrTrs, "Attr2")
        local _newAttr2NameLab = UIUtils.FindLabel(self.NewAttrTrs, "Attr2/Txt")
        local _attr2 = Utils.SplitStrByTableS(cfg.Value, {';','_'})
        if _attr2[1] then
            _newAttr1Lab.gameObject:SetActive(true)
            local _attrCfg = DataConfig.DataAttributeAdd[_attr2[1][1]]
            local _txt = _attrCfg.ShowPercent == 0 and tostring(_attr2[1][2]) or string.format( "%s%%", tostring(math.FormatNumber(_attr2[1][2]/100)))-- string.format( "%d%%", _attr2[1][2]//100)
            _newAttr1Lab.text = _txt
            if _attrCfg ~= nil then
                _newAttr1NameLab.text = _attrCfg.Name .. ":"
            end
        else
            _newAttr1Lab.gameObject:SetActive(false)
        end
        if _attr2[2] then
            _newAttr2Lab.gameObject:SetActive(true)
            local _attrCfg = DataConfig.DataAttributeAdd[_attr2[2][1]]
            local _txt = _attrCfg.ShowPercent == 0 and tostring(_attr2[2][2]) or string.format( "%s%%", tostring(math.FormatNumber(_attr2[2][2]/100)))-- string.format( "%d%%", _attr2[2][2]//100)
            _newAttr2Lab.text = _txt
            if _attrCfg ~= nil then
                _newAttr2NameLab.text = _attrCfg.Name .. ":"
            end
        else
           _newAttr2Lab.gameObject:SetActive(false)
        end
    end
end

function UILianQiForgeStrengthForm:Update()
    if self.StartProgressAnim then
        if self.LevelUpCount > 0 then
            self.CurLevelCurProgress = self.CurLevelCurProgress + self.ProgressBarAddNum
            self:RefreshProgressInfo(self.CurLevelCurProgress, self.CurLevelMaxProgress)
            if self.CurLevelCurProgress >= self.CurLevelMaxProgress then
                self.LevelUpCount = self.LevelUpCount - 1
                if self.StrengthInfoByPosDic:ContainsKey(self.CurSelectPos) then
                    local _curStrengthInfo = self.StrengthInfoByPosDic[self.CurSelectPos]
                    _curStrengthInfo.level = _curStrengthInfo.level + 1
                    self.CurLevelCurProgress = 0
                    _curStrengthInfo.exp = 0
                    local _cfgID = self:GetCfgID(self.CurSelectPos, _curStrengthInfo.level)
                    self.CurLevelMaxProgress = DataConfig.DataEquipIntenMain[_cfgID].ProficiencyMax
                    self:UpgradeLevel()
                end
            end
        else
            if self.CurLevelCurProgress < self.TargetProgress then
                self.CurLevelCurProgress = self.CurLevelCurProgress + self.ProgressBarAddNum
                self.CurLevelCurProgress = self.CurLevelCurProgress > self.TargetProgress and self.TargetProgress or self.CurLevelCurProgress
                self:RefreshProgressInfo(self.CurLevelCurProgress, self.CurLevelMaxProgress)
            else
                self:RefreshProgressInfo(self.TargetProgress, self.CurLevelMaxProgress)
                if self.StrengthInfoByPosDic:ContainsKey(self.CurSelectPos) then
                    self.StrengthInfoByPosDic[self.CurSelectPos].exp = self.TargetProgress
                end
                self:RefreshRightInfos(self.CurSelectPos, self.StrengthInfoByPosDic[self.CurSelectPos])
                self.DisplayCritTimer = 0
                self.DisplayCritSpan = 0
                self.DisableCritTime= 0
                self.CritIndex = 1
                self.CritValueLab.gameObject:SetActive(false)
                self.StartProgressAnim = false
            end
        end
        
        if self.ShowCrit then
            self.DisplayCritTimer = self.DisplayCritTimer + self.ProgressBarAddNum
            if self.IsDisplayCrit then
                if self.DisplayCritTimer >= self.DisableCritTime then
                    self.CritValueLab.gameObject:SetActive(false)
                    self.IsDisplayCrit = false
                    self.CritIndex = self.CritIndex + 1
                end
            else
                if self.DisplayCritTimer >= self.DisplayCritSpan then
                    if self.CritRate[self.CritIndex] then
                        self.CritValueLab.text = tostring(self.CritRate[self.CritIndex])
                        self.CritValueLab.gameObject:SetActive(true)
                        self.IsDisplayCrit = true
                        self.DisplayCritTimer = 0
                        self.CritIndex = 1
                        if not self.StartProgressAnim then
                            self.CritValueLab.gameObject:SetActive(false)
                        end
                    end
                end
            end
        end
    end
end

function UILianQiForgeStrengthForm:UpgradeLevel()
    --TODO:播左侧升级特效
    GameCenter.MsgPromptSystem:ShowPrompt("强化等级提升！")
    local _strengthInfo = self.StrengthInfoByPosDic[self.CurSelectPos]
    self:SetLeftStrengthLvByPos(self.CurSelectPos, _strengthInfo)
    --内部会自己刷新进度条
    self:RefreshRightInfos(self.CurSelectPos, self.StrengthInfoByPosDic[self.CurSelectPos])
end

return UILianQiForgeStrengthForm