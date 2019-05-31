--作者： cy
--日期： 2019-05-09
--文件： UILianQiGemJadeForm.lua
--模块： UILianQiGemJadeForm
--描述： 炼器功能二级子面板：仙玉镶嵌。上级面板为：宝石面板（UILianQiGemForm）
------------------------------------------------

local UILianQiGemJadeForm = {
    EquipItemTrs = nil,
    AllJadeInfosTrs = nil,
    AllAttrInfosTrs = nil,
    CanGetAttrLab = nil,
    AttrCloneGo = nil,
    AttrCloneRoot = nil,
    AttrCloneRootGrid = nil,
    CurPos = 0,
}

function UILianQiGemJadeForm:OnRegisterEvents()
    self:RegisterEvent(UIEventDefine.UILianQiGemJadeForm_OPEN,self.OnOpen)
    self:RegisterEvent(UIEventDefine.UILianQiGemJadeForm_CLOSE,self.OnClose)
    self:RegisterEvent(LogicEventDefine.EID_EVENT_REFRESHRIGHTINFOS,self.RefreshRightInfos)
    self:RegisterEvent(LogicEventDefine.EID_EVENT_JADEINLAYINFO,self.RefreshJadeInlayInfo)
    self:RegisterEvent(LogicEventDefine.EID_EVENT_JADE_HOLEOPENSTATE, self.RefreshJadeOpenState)
end

function UILianQiGemJadeForm:OnOpen(obj, sender)
    if obj then
        self.CurPos = obj
    end
    self.CSForm:Show(sender)
end

function UILianQiGemJadeForm:OnClose(obj,sender)
    self.CSForm:Hide()
end

function UILianQiGemJadeForm:RegUICallback()
end

function UILianQiGemJadeForm:OnFirstShow()
    self:FindAllComponents()
    self:RegUICallback()
end

function UILianQiGemJadeForm:OnShowBefore()
    
end

function UILianQiGemJadeForm:OnShowAfter()
    self:RefreshRightInfos(self.CurPos)
end

function UILianQiGemJadeForm:OnHideBefore()
    
end

function UILianQiGemJadeForm:OnClickEquipItem(go)
    local _pos = UIEventListener.Get(go).parameter
    local _equipItem = UnityUtils.RequireComponent(go.transform, "Funcell.GameUI.Form.UIEquipmentItem")
    if _equipItem.Equipment ~= nil then
        GameCenter.ItemTipsMgr:ShowTips(_equipItem.Equipment, go, ItemTipsLocation.EquipDisplay)
    end
end

function UILianQiGemJadeForm:OnClickJade(go)
    local _equip = GameCenter.EquipmentSystem:GetPlayerDressEquip(self.CurPos)
    local _jadeID = UIEventListener.Get(go).parameter
    local _nameStrList = Utils.SplitStr(go.name, "_")
    local _curSelectIndex = tonumber(_nameStrList[2])
    if _jadeID > 0 then
        if not _equip then
            GameCenter.MsgPromptSystem:ShowPrompt(DataConfig.DataMessageString.Get("LIANQI_FORGE_STRENGTHNEEDEQUIP"))
            do return end
        end
        --当前位置有仙玉
        local _haveHigherLvJade = false
        local _curInlayJadeLv = GameCenter.LianQiGemSystem:GetJadeLevelByItemID(_jadeID)
        if GameCenter.LianQiGemSystem.JadeInlayCfgByPosDic:ContainsKey(self.CurPos) then
            local _canInlayJadeIDList = GameCenter.LianQiGemSystem.JadeInlayCfgByPosDic[self.CurPos].CanInlayJadeIDList
            if _canInlayJadeIDList then
                for i=1, #_canInlayJadeIDList do
                    if GameCenter.LianQiGemSystem:GetJadeLevelByItemID(_canInlayJadeIDList[i]) > _curInlayJadeLv then
                        local _haveCount = GameCenter.ItemContianerSystem:GetItemCountFromCfgId(_canInlayJadeIDList[i])
                        if _haveCount > 0 then
                            _haveHigherLvJade = true
                        end
                    end
                end
            end
        end
        if _haveHigherLvJade then
            --有更高级的宝石，打开替换界面
            GameCenter.PushFixEvent(UIEventDefine.UILianQiGemReplaceForm_OPEN, {2, self.CurPos, _curSelectIndex})
        else
            --没有更高级的宝石，打开升级界面
            GameCenter.PushFixEvent(UIEventDefine.UILianQiGemUpgradeForm_OPEN, {2, self.CurPos, _curSelectIndex})
        end
    elseif _jadeID == 0 then
        if not _equip then
            GameCenter.MsgPromptSystem:ShowPrompt(DataConfig.DataMessageString.Get("LIANQI_FORGE_STRENGTHNEEDEQUIP"))
            do return end
        end
        --当前位置没仙玉
        GameCenter.PushFixEvent(UIEventDefine.UILianQiGemReplaceForm_OPEN, {2, self.CurPos, _curSelectIndex})
    elseif _jadeID < 0 then
        GameCenter.MsgPromptSystem:ShowPrompt(DataConfig.DataMessageString.Get("LIANQI_GEM_NOTUNLOCK"))
    end
end

function UILianQiGemJadeForm:FindAllComponents()
    self.EquipItemTrs = UIUtils.FindTrans(self.Trans, "UIEquipmentItem")
    self.AllJadeInfosTrs = UIUtils.FindTrans(self.Trans, "AllJadeInfos")
    self.AllAttrInfosTrs = UIUtils.FindTrans(self.Trans, "AllAttrInfos")
    self.CanGetAttrLab = UIUtils.FindLabel(self.Trans, "CanGetAttr")
    self.AttrCloneGo = UIUtils.FindGo(self.AllAttrInfosTrs, "AttrClone")
    self.AttrCloneRoot = UIUtils.FindTrans(self.AllAttrInfosTrs, "AttributeGrid")
    self.AttrCloneRootGrid = self.AttrCloneRoot:GetComponent("UIGrid")

    self:RefreshRightInfos(self.CurPos)
end

function UILianQiGemJadeForm:RefreshJadeOpenState(obj, sender)
    self:SetJadeInfos()
end

function UILianQiGemJadeForm:RefreshJadeInlayInfo(obj, sender)
    if #obj >= 3 then
        local _pos = obj[1]
        if _pos == self.CurPos then
            local _index = obj[2]
            local _newJadeID = obj[3]
            local _jadeItemCfg = DataConfig.DataItem[_newJadeID]
            --GetChild索引从0开始
            local _holeTrs = self.AllJadeInfosTrs:GetChild(_index - 1)
            if _holeTrs then
                local _plusTrs = _holeTrs:Find("Plus")
                _plusTrs.gameObject:SetActive(false)
                local _jadeIconTrs = _holeTrs:Find("JadeIcon")
                local _uiIconBase = UnityUtils.RequireComponent(_jadeIconTrs,"Funcell.GameUI.Form.UIIconBase")
                local _jadeNameLab = UIUtils.FindLabel(_holeTrs, "JadeName")
                if _jadeItemCfg then
                    _jadeIconTrs.gameObject:SetActive(true)
                    _uiIconBase:UpdateIcon(_jadeItemCfg.Icon)
                    _jadeNameLab.text = _jadeItemCfg.Name
                    _jadeNameLab.gameObject:SetActive(true)
                else
                    _jadeIconTrs.gameObject:SetActive(false)
                    _jadeNameLab.gameObject:SetActive(false)
                end
            end
            self:SetAllAttrs()
        end
    end
    for i=1,GameCenter.LianQiGemSystem.MaxHoleNum do
        local _holeTrs = self.AllJadeInfosTrs:GetChild(i - 1)
        _holeTrs:Find("RedPoint").gameObject:SetActive(GameCenter.LianQiGemSystem:IsJadeHoleHaveRedPoint(self.CurPos, i))
    end
end

function UILianQiGemJadeForm:RefreshRightInfos(obj, sender)
    self.CurPos = obj
    self:SetEquipItem(obj)
    self:SetJadeInfos()
    self:SetAllAttrs()
end

function UILianQiGemJadeForm:SetEquipItem(pos)
    local _equip = GameCenter.EquipmentSystem:GetPlayerDressEquip(pos)
    local _starLv = GameCenter.EquipmentSystem:OnGetStarLevel(pos)
    self.EquipItemTrs.name = string.format( "UIEquipmentItem_%d", pos)
    local _equipItem = UnityUtils.RequireComponent(self.EquipItemTrs, "Funcell.GameUI.Form.UIEquipmentItem")
    UIEventListener.Get(self.EquipItemTrs.gameObject).parameter = pos
    _equipItem.SingleClick = Utils.Handler(self.OnClickEquipItem, self)
    if _equip ~= nil then
        _equipItem:UpdateEquipment(_equip, pos, _starLv)
    else
        _equipItem:UpdateEquipment(pos, _starLv)
    end
end

function UILianQiGemJadeForm:SetJadeInfos()
    local _jadeIDList = GameCenter.LianQiGemSystem.JadeInlayInfoByPosDic[self.CurPos]
    if _jadeIDList then
        for i=1,GameCenter.LianQiGemSystem.MaxHoleNum do
            local _holeTrs = self.AllJadeInfosTrs:GetChild(i - 1)
            local _lockTrs = _holeTrs:Find("Lock")
            local _plusTrs = _holeTrs:Find("Plus")
            local _jadeIconSpr = UIUtils.FindSpr(_holeTrs, "JadeIcon")
            local _unlockConditionLab = UIUtils.FindLabel(_holeTrs, "UnlockCondition")
            local _jadeNameLab = UIUtils.FindLabel(_holeTrs, "JadeName")
    
            --if GameCenter.LianQiGemSystem:IsHoleUnlockByIndex(2, self.CurPos, i) then
            if _jadeIDList then
                UIEventListener.Get(_holeTrs.gameObject).parameter = _jadeIDList[i]
                -- >= 0，表示孔位已解锁
                if _jadeIDList[i] >= 0 then
                    _lockTrs.gameObject:SetActive(false)
                    _unlockConditionLab.gameObject:SetActive(false)
                    if _jadeIDList[i] > 0 then
                        --大于0，表示已解锁，已镶嵌仙玉
                        _jadeIconSpr.gameObject:SetActive(true)
                        _jadeNameLab.gameObject:SetActive(true)
                        _plusTrs.gameObject:SetActive(false)
                        local _uiIconBase = UnityUtils.RequireComponent(_jadeIconSpr.transform,"Funcell.GameUI.Form.UIIconBase")
                        local _itemCfg = DataConfig.DataItem[_jadeIDList[i]]
                        if _itemCfg then
                            _uiIconBase:UpdateIcon(_itemCfg.Icon)
                            _jadeNameLab.text = _itemCfg.Name
                        end
                    else
                        --等于0，表示已解锁，未镶嵌仙玉
                        _jadeIconSpr.gameObject:SetActive(false)
                        _jadeNameLab.gameObject:SetActive(false)
                        _plusTrs.gameObject:SetActive(true)
                    end
                else
                    --小于0，表示未解锁
                    _jadeIconSpr.gameObject:SetActive(false)
                    _jadeNameLab.gameObject:SetActive(false)
                    _plusTrs.gameObject:SetActive(false)
                    _lockTrs.gameObject:SetActive(true)
                    _unlockConditionLab.gameObject:SetActive(true)
                    local _conditionText = GameCenter.LianQiGemSystem:GetConditionDesc(2, self.CurPos, i)
                    _unlockConditionLab.text = _conditionText
                end
                _holeTrs:Find("RedPoint").gameObject:SetActive(GameCenter.LianQiGemSystem:IsJadeHoleHaveRedPoint(self.CurPos, i))
                UIEventListener.Get(_holeTrs.gameObject).onClick = Utils.Handler(self.OnClickJade, self)
            end
            
        end
    end
end

function UILianQiGemJadeForm:SetAllAttrs()
    local _jadeIDList = GameCenter.LianQiGemSystem.JadeInlayInfoByPosDic[self.CurPos]
    if _jadeIDList then
        local _attrsDic = Dictionary:New()
        for i = 1, #_jadeIDList do
            if _jadeIDList[i] and _jadeIDList[i] > 0 then
                local _itemCfg = DataConfig.DataItem[_jadeIDList[i]]
                local _attrs = Utils.SplitStrByTableS(_itemCfg.EffectNum, {";", "_"})
                for j = 1, #_attrs do
                    --第一个参数为1表示增加的属性
                    if _attrs[j][1] == 1 then
                        if _attrsDic:ContainsKey(_attrs[j][2]) then
                            _attrsDic[_attrs[j][2]] = _attrsDic[_attrs[j][2]] + _attrs[j][3]
                        else
                            _attrsDic:Add(_attrs[j][2], _attrs[j][3])
                        end
                    end
                end
            end
        end
        --local _attrNameList = List:New()
        local _count = 0
        for k,v in pairs(_attrsDic) do
            local _attrCfg = DataConfig.DataAttributeAdd[k]
            if _attrCfg then
                local _go
                if _count < self.AttrCloneRoot.childCount then
                    _go = self.AttrCloneRoot:GetChild(_count).gameObject
                else
                    _go = UnityUtils.Clone(self.AttrCloneGo, self.AttrCloneRoot)
                end
                local _nameLab = UIUtils.FindLabel(_go.transform, "Name")
                local _attrNum = UIUtils.FindLabel(_go.transform, "TotalAttrNum")
                _nameLab.text = _attrCfg.Name
                _attrNum.text = tostring(v)
                _go:SetActive(true)
                --_attrNameList:Add(_attrCfg.Name)
                _count = _count + 1
            end
        end
        self.AttrCloneRootGrid.repositionNow = true
        local _canGetAttrList = List:New()
        if GameCenter.LianQiGemSystem.JadeInlayCfgByPosDic:ContainsKey(self.CurPos) then
            local _canInlayJadeList = GameCenter.LianQiGemSystem.JadeInlayCfgByPosDic[self.CurPos].CanInlayJadeIDList
            for i = 1, #_canInlayJadeList do
                local _itemCfg = DataConfig.DataItem[_canInlayJadeList[i]]
                if _itemCfg then
                    local _attrs = Utils.SplitStrByTableS(_itemCfg.EffectNum, {";", "_"})
                    for j = 1, #_attrs do
                        --第一个参数为1表示增加的属性
                        if _attrs[j][1] == 1 then
                            if not _canGetAttrList:Contains(_attrs[j][2]) then
                                _canGetAttrList:Add(_attrs[j][2])
                            end
                        end
                    end
                end
            end
        end
        _canGetAttrList:Sort(
            function (a, b)
                return a < b
            end
        )
        local _txt = ""
        for i = 1,#_canGetAttrList do
            if i ~= #_canGetAttrList then
                local _attrCfg = DataConfig.DataAttributeAdd[_canGetAttrList[i]]
                if _attrCfg then
                    _txt = _txt .. string.format( "%s,", _attrCfg.Name)
                end
            else
                local _attrCfg = DataConfig.DataAttributeAdd[_canGetAttrList[i]]
                if _attrCfg then
                    _txt = _txt .. _attrCfg.Name
                end
            end
        end
        self.CanGetAttrLab.text = _txt
    end
end

return UILianQiGemJadeForm