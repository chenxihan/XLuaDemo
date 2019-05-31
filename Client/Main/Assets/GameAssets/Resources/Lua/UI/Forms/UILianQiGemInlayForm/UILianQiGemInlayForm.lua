--作者： cy
--日期： 2019-05-09
--文件： UILianQiGemInlayForm.lua
--模块： UILianQiGemInlayForm
--描述： 炼器功能二级子面板：宝石镶嵌。上级面板为：宝石面板（UILianQiGemForm）
------------------------------------------------

local UILianQiGemInlayForm = {
    EquipItemTrs = nil,
    AllGemInfosTrs = nil,
    CurPos = 0,
}

function UILianQiGemInlayForm:OnRegisterEvents()
    self:RegisterEvent(UIEventDefine.UILianQiGemInlayForm_OPEN,self.OnOpen)
    self:RegisterEvent(UIEventDefine.UILianQiGemInlayForm_CLOSE,self.OnClose)
    self:RegisterEvent(LogicEventDefine.EID_EVENT_REFRESHRIGHTINFOS,self.RefreshRightInfos)
    self:RegisterEvent(LogicEventDefine.EID_EVENT_GEMINLAYINFO,self.RefreshGemInlayInfo)
    self:RegisterEvent(LogicEventDefine.EID_EVENT_GEM_HOLEOPENSTATE, self.RefreshGemOpenState)
end

function UILianQiGemInlayForm:OnOpen(obj, sender)
    if obj then
        self.CurPos = obj
    end
    self.CSForm:Show(sender)
end

function UILianQiGemInlayForm:OnClose(obj,sender)
    self.CSForm:Hide()
end

function UILianQiGemInlayForm:RegUICallback()
end

function UILianQiGemInlayForm:OnFirstShow()
    self:FindAllComponents()
    self:RegUICallback()
end

function UILianQiGemInlayForm:OnShowBefore()
    
end

function UILianQiGemInlayForm:OnShowAfter()
    self:RefreshRightInfos(self.CurPos)
end

function UILianQiGemInlayForm:OnHideBefore()
    
end

function UILianQiGemInlayForm:OnClickEquipItem(go)
    local _pos = UIEventListener.Get(go).parameter
    local _equipItem = UnityUtils.RequireComponent(go.transform, "Funcell.GameUI.Form.UIEquipmentItem")
    if _equipItem.Equipment ~= nil then
        GameCenter.ItemTipsMgr:ShowTips(_equipItem.Equipment, go, ItemTipsLocation.EquipDisplay)
    end
end

function UILianQiGemInlayForm:OnClickGem(go)
    local _equip = GameCenter.EquipmentSystem:GetPlayerDressEquip(self.CurPos)
    local _gemID = UIEventListener.Get(go).parameter
    local _nameStrList = Utils.SplitStr(go.name, "_")
    local _curSelectIndex = tonumber(_nameStrList[2])
    if _gemID > 0 then
        if not _equip then
            GameCenter.MsgPromptSystem:ShowPrompt(DataConfig.DataMessageString.Get("LIANQI_FORGE_STRENGTHNEEDEQUIP"))
            do return end
        end
        --当前位置有宝石
        local _haveHigherLvGem = false
        local _curInlayGemLv = GameCenter.LianQiGemSystem:GetGemLevelByItemID(_gemID)
        if GameCenter.LianQiGemSystem.GemInlayCfgByPosDic:ContainsKey(self.CurPos) then
            local _canInlayGemIDList = GameCenter.LianQiGemSystem.GemInlayCfgByPosDic[self.CurPos].CanInlayGemIDList
            if _canInlayGemIDList then
                for i=1, #_canInlayGemIDList do
                    if GameCenter.LianQiGemSystem:GetGemLevelByItemID(_canInlayGemIDList[i]) > _curInlayGemLv then
                        local _haveCount = GameCenter.ItemContianerSystem:GetItemCountFromCfgId(_canInlayGemIDList[i])
                        if _haveCount > 0 then
                            _haveHigherLvGem = true
                        end
                    end
                end
            end
        end
        if _haveHigherLvGem then
            --有更高级的宝石，打开替换界面
            GameCenter.PushFixEvent(UIEventDefine.UILianQiGemReplaceForm_OPEN, {1, self.CurPos, _curSelectIndex})
        else
            --没有更高级的宝石，打开升级界面
            GameCenter.PushFixEvent(UIEventDefine.UILianQiGemUpgradeForm_OPEN, {1, self.CurPos, _curSelectIndex})
        end
    elseif _gemID == 0 then
        if not _equip then
            GameCenter.MsgPromptSystem:ShowPrompt(DataConfig.DataMessageString.Get("LIANQI_FORGE_STRENGTHNEEDEQUIP"))
            do return end
        end
        --当前位置没宝石
        GameCenter.PushFixEvent(UIEventDefine.UILianQiGemReplaceForm_OPEN, {1, self.CurPos, _curSelectIndex})
    elseif _gemID < 0 then
        GameCenter.MsgPromptSystem:ShowPrompt(DataConfig.DataMessageString.Get("LIANQI_GEM_NOTUNLOCK"))
    end
end

function UILianQiGemInlayForm:FindAllComponents()
    self.EquipItemTrs = UIUtils.FindTrans(self.Trans, "UIEquipmentItem")
    self.AllGemInfosTrs = UIUtils.FindTrans(self.Trans, "AllGemInfos")

    self:RefreshRightInfos(self.CurPos)
end

function UILianQiGemInlayForm:RefreshGemOpenState(obj, sender)
    self:SetGemInfos()
end

function UILianQiGemInlayForm:RefreshGemInlayInfo(obj, sender)
    if #obj >= 3 then
        local _pos = obj[1]
        if _pos == self.CurPos then
            local _index = obj[2]
            local _newGemID = obj[3]
            local _gemItemCfg = DataConfig.DataItem[_newGemID]
            --GetChild索引从0开始
            local _holeTrs = self.AllGemInfosTrs:GetChild(_index - 1)
            if _holeTrs then
                local _plusTrs = _holeTrs:Find("Plus")
                _plusTrs.gameObject:SetActive(false)
                local _gemTrs = _holeTrs:Find("Gem")
                _gemTrs.gameObject:SetActive(true)
                local _gemIconSpr = UIUtils.FindSpr(_gemTrs, "GemIcon")
                local _uiIconBase = UnityUtils.RequireComponent(_gemIconSpr.transform,"Funcell.GameUI.Form.UIIconBase")
                local _gemInfoTrs = _gemTrs:Find("GemInfo")
                if _gemItemCfg then
                    _gemIconSpr.gameObject:SetActive(true)
                    _uiIconBase:UpdateIcon(_gemItemCfg.Icon)
                    self:SetGemNameAndAttrs(_gemInfoTrs, _gemItemCfg)
                else
                    _gemIconSpr.gameObject:SetActive(false)
                end
                UIEventListener.Get(_holeTrs.gameObject).parameter = _newGemID
                _holeTrs:Find("RedPoint").gameObject:SetActive(GameCenter.LianQiGemSystem:IsGemHoleHaveRedPoint(self.CurPos, _index))
            end
        end
    end
    for i=1,GameCenter.LianQiGemSystem.MaxHoleNum do
        local _holeTrs = self.AllGemInfosTrs:GetChild(i - 1)
        _holeTrs:Find("RedPoint").gameObject:SetActive(GameCenter.LianQiGemSystem:IsGemHoleHaveRedPoint(self.CurPos, i))
    end
end

function UILianQiGemInlayForm:RefreshRightInfos(obj, sender)
    self.CurPos = obj
    self:SetEquipItem(obj)
    self:SetGemInfos()
end

function UILianQiGemInlayForm:SetEquipItem(pos)
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

function UILianQiGemInlayForm:SetGemInfos()
    local _gemIDList = GameCenter.LianQiGemSystem.GemInlayInfoByPosDic[self.CurPos]
    --local _openHoleCount = 0
    if _gemIDList then
        for i=1,GameCenter.LianQiGemSystem.MaxHoleNum do
            local _holeTrs = self.AllGemInfosTrs:GetChild(i - 1)
            local _lockTrs = _holeTrs:Find("Lock")
            local _plusTrs = _holeTrs:Find("Plus")
            local _gemTrs = _holeTrs:Find("Gem")
            local _unlockConditionTrs = _holeTrs:Find("UnlockCondition")
            --如果当前孔位已解锁
            --if GameCenter.LianQiGemSystem:IsHoleUnlockByIndex(1, self.CurPos, i) then
            if _gemIDList[i] then
                UIEventListener.Get(_holeTrs.gameObject).parameter = _gemIDList[i]
                -- >= 0，表示孔位已解锁
                if _gemIDList[i] >= 0 then
                    _lockTrs.gameObject:SetActive(false)
                    _unlockConditionTrs.gameObject:SetActive(false)
                    --_holeTrs:Find("Plus").gameObject:SetActive(true)
                    --_openHoleCount = _openHoleCount + 1
        
                    if _gemIDList[i] > 0 then
                        --大于0，表示已解锁，已镶嵌宝石
                        _gemTrs.gameObject:SetActive(true)
                        _plusTrs.gameObject:SetActive(false)
                        local _uiIconBase = UnityUtils.RequireComponent(_gemTrs:Find("GemIcon"),"Funcell.GameUI.Form.UIIconBase")
                        local _itemCfg = DataConfig.DataItem[_gemIDList[i]]
                        if _itemCfg then
                            _uiIconBase:UpdateIcon(_itemCfg.Icon)
                            self:SetGemNameAndAttrs(_gemTrs:Find("GemInfo"), _itemCfg)
                        end
                        --UIEventListener.Get(_holeTrs.gameObject).parameter = _gemIDList[i]
                    else
                        --等于0，表示已解锁，未镶嵌宝石
                        _gemTrs.gameObject:SetActive(false)
                        _plusTrs.gameObject:SetActive(true)
                        --UIEventListener.Get(_holeTrs.gameObject).parameter = 0
                    end
                else
                    --小于0，表示未解锁
                    _lockTrs.gameObject:SetActive(true)
                    local _conditionLab = _unlockConditionTrs:GetComponent("UILabel")-- UIUtils.FindLabel(_holeTrs, "UnlockCondition")
                    _conditionLab.gameObject:SetActive(true)
                    local _conditionText = GameCenter.LianQiGemSystem:GetConditionDesc(1, self.CurPos, i)
                    _conditionLab.text = _conditionText
                    _gemTrs.gameObject:SetActive(false)
                    _plusTrs.gameObject:SetActive(false)
                    --UIEventListener.Get(_holeTrs.gameObject).onClick = nil
                end
                _holeTrs:Find("RedPoint").gameObject:SetActive(GameCenter.LianQiGemSystem:IsGemHoleHaveRedPoint(self.CurPos, i))
                UIEventListener.Get(_holeTrs.gameObject).onClick = Utils.Handler(self.OnClickGem, self)
            end
        end
    end
    -- if _gemIDList then
    --     for i = 1, _openHoleCount do
    --         local _holeTrs = self.AllGemInfosTrs:GetChild(i - 1)
    --         local _gemInfoTrs = _holeTrs:Find("Gem/GemInfo")
    --         local _plusTrs = _holeTrs:Find("Plus")
    --         if _gemIDList[i] and _gemIDList[i] > 0 then
    --             local _uiIconBase = UnityUtils.RequireComponent(_holeTrs:Find("Gem/GemIcon"),"Funcell.GameUI.Form.UIIconBase")
    --             _uiIconBase:UpdateIcon(_gemIDList[i])
    --             local _itemCfg = DataConfig.DataItem[_gemIDList[i]]
    --             _gemInfoTrs.gameObject:SetActive(true)
    --             _plusTrs.gameObject:SetActive(false)
    --             self:SetGemNameAndAttrs(_gemInfoTrs, _itemCfg)
    --             UIEventListener.Get(_holeTrs.gameObject).parameter = _gemIDList[i]
    --         else
    --             _plusTrs.gameObject:SetActive(true)
    --             UIEventListener.Get(_holeTrs.gameObject).parameter = 0
    --             _gemInfoTrs.gameObject:SetActive(false)
    --         end
    --         UIEventListener.Get(_holeTrs).onClick = Utils.Handler(self.OnClickGem, self)
    --     end
    -- end
end

function UILianQiGemInlayForm:SetGemNameAndAttrs(gemInfoTrs, itemCfg)
    local _gemNameLab = UIUtils.FindLabel(gemInfoTrs,"GemName")
    local _gemAttr1Lab = UIUtils.FindLabel(gemInfoTrs,"GemAttr1")
    local _gemAttr2Lab = UIUtils.FindLabel(gemInfoTrs,"GemAttr2")
    _gemNameLab.text = itemCfg.Name
    local _attrs = Utils.SplitStrByTableS(itemCfg.EffectNum, {";", "_"})
    if _attrs[1] then
        _gemAttr1Lab.gameObject:SetActive(true)
        --效果第一个参数为1，表示加属性
        if _attrs[1][1] == 1 then
            local _attrCfg = DataConfig.DataAttributeAdd[_attrs[1][2]]
            local _valueStr = _attrCfg.ShowPercent == 0 and tostring(_attrs[1][3]) or string.format( "%d%%", _attrs[1][3] // 100)-- UIUtils.CSFormat("{0}%", _attrs[1][3] / 100)
            _gemAttr1Lab.text = string.format( "%s+%s", _attrCfg.Name, _valueStr)-- UIUtils.CSFormat("{0}+{1}", _attrCfg.Name, _valueStr)
        else
            _gemAttr1Lab.gameObject:SetActive(false)
        end
    else
        _gemAttr1Lab.gameObject:SetActive(false)
    end
    if _attrs[2] then
        _gemAttr2Lab.gameObject:SetActive(true)
        if _attrs[2][1] == 1 then
            local _attrCfg = DataConfig.DataAttributeAdd[_attrs[2][2]]
            local _valueStr = _attrCfg.ShowPercent == 0 and tostring(_attrs[2][3]) or string.format( "%d%%", _attrs[2][3] // 100)-- UIUtils.CSFormat("{0}%", _attrs[2][3] / 100)
            _gemAttr2Lab.text = string.format( "%s+%s", _attrCfg.Name, _valueStr)-- UIUtils.CSFormat("{0}+{1}", _attrCfg.Name, _valueStr)
        else
            _gemAttr2Lab.gameObject:SetActive(false)
        end
    else
        _gemAttr2Lab.gameObject:SetActive(false)
    end
end

return UILianQiGemInlayForm