--作者： cy
--日期： 2019-05-09
--文件： UILianQiGemForm.lua
--模块： UILianQiGemForm
--描述： 炼器功能一级分页：宝石面板
------------------------------------------------

local UILianQiGemForm = {
    UIListMenu = nil,--列表
    Form = LianQiGemSubEnum.Begin, --分页类型
    LeftEquipItemClone = nil,
    LeftCloneRoot = nil,
    CurSelectPos = 0,
    CurSelectSubForm = LianQiGemSubEnum.Inlay,      --当前分页
    CurSelectGo = nil,
    EquipItemByPosDic = Dictionary:New()
}

local NGUITools = CS.NGUITools

function UILianQiGemForm:OnRegisterEvents()
    self:RegisterEvent(UIEventDefine.UILianQiGemForm_OPEN, self.OnOpen)
    self:RegisterEvent(UIEventDefine.UILianQiGemForm_CLOSE, self.OnClose)
    self:RegisterEvent(LogicEventDefine.EID_EVENT_GEMINLAYINFO, self.RefreshGemInlayInfo)
    self:RegisterEvent(LogicEventDefine.EID_EVENT_JADEINLAYINFO, self.RefreshJadeInlayInfo)
    self:RegisterEvent(LogicEventDefine.EID_EVENT_GEMREFINEINFO, self.RefreshRefineInfo)
end

function UILianQiGemForm:OnOpen(obj, sender)
    self.CSForm:Show(sender)
    if obj and obj <= LianQiGemSubEnum.Count then
        self.Form = obj
    end
    self.UIListMenu:SetSelectById(self.Form)
end

function UILianQiGemForm:OnClose(obj,sender)
    self.CSForm:Hide()
end

function UILianQiGemForm:RegUICallback()
    
end

function UILianQiGemForm:OnFirstShow()
    self:FindAllComponents()
    self:RegUICallback()
end

function UILianQiGemForm:OnHideBefore()

end

function UILianQiGemForm:OnClickCloseBtn()
    self:OnClose(nil, nil)
end

function UILianQiGemForm:RefreshGemInlayInfo(obj, sender)
    if #obj >= 3 then
        local _pos = obj[1]
        local _index = obj[2]
        local _newGemID = obj[3]
        local _newGemItemCfg = DataConfig.DataItem[_newGemID]
        if self.CurSelectSubForm == LianQiGemSubEnum.Inlay then
            if self.EquipItemByPosDic:ContainsKey(_pos) then
                local _go = self.EquipItemByPosDic[_pos]
                local _stonesRoot = _go.transform:Find("Stones")
                --GetChild索引从0开始
                local _stoneTrs = _stonesRoot:GetChild(_index - 1)
                local _stoneSpr = UIUtils.FindSpr(_stoneTrs, "Icon")
                local _uiIconBase = UnityUtils.RequireComponent(_stoneSpr.transform,"Funcell.GameUI.Form.UIIconBase")
                if _newGemItemCfg then
                    _stoneSpr.gameObject:SetActive(true)
                    _uiIconBase:UpdateIcon(_newGemItemCfg.Icon)
                else
                    _stoneSpr.gameObject:SetActive(false)
                end
                --_go.transform:Find("RedPoint").gameObject:SetActive(GameCenter.LianQiGemSystem:IsGemPosHaveRedPoint(_pos))
            end
        end
    end
    for i=0, UnityUtils.GetObjct2Int(EquipmentType.Count) - 1 do
        local _go = self.LeftCloneRoot:GetChild(i).gameObject
        if _go then
            _go.transform:Find("RedPoint").gameObject:SetActive(GameCenter.LianQiGemSystem:IsGemPosHaveRedPoint(i))
        end
    end
end

function UILianQiGemForm:RefreshRefineInfo(obj, sender)
    if obj < self.LeftCloneRoot.childCount then
        local _go = self.LeftCloneRoot:GetChild(obj).gameObject
        if _go then
            local _equip = GameCenter.EquipmentSystem:GetPlayerDressEquip(obj)
            local _nameLab = UIUtils.FindLabel(_go.transform, "EquipName")
            if _equip then
                if GameCenter.LianQiGemSystem.GemRefineInfoByPosDic:ContainsKey(obj) then
                    local _refineInfo = GameCenter.LianQiGemSystem.GemRefineInfoByPosDic[obj]
                    _nameLab.text = string.format( "%s+%d", _equip.Name, _refineInfo.Level)-- UIUtils.CSFormat("{0}+{1}", _equip.Name, _refineInfo.Level)
                else
                    _nameLab.text = string.format( "%s+%d", _equip.Name, 0)
                end
            else
                _nameLab.text = ""
            end
            self:LeftItemOnClick(_go)
        end
    end
    for i=0, UnityUtils.GetObjct2Int(EquipmentType.Count) - 1 do
        local _go = self.LeftCloneRoot:GetChild(i).gameObject
        if _go then
            _go.transform:Find("RedPoint").gameObject:SetActive(GameCenter.LianQiGemSystem:IsGemRefinePosHaveRedPoint(i))
        end
    end
end

function UILianQiGemForm:RefreshJadeInlayInfo(obj, sender)
    if #obj >= 3 then
        local _pos = obj[1]
        local _index = obj[2]
        local _newJadeID = obj[3]
        local _newJadeItemCfg = DataConfig.DataItem[_newJadeID]
        if self.CurSelectSubForm == LianQiGemSubEnum.Jade then
            if self.EquipItemByPosDic:ContainsKey(_pos) then
                local _go = self.EquipItemByPosDic[_pos]
                local _stonesRoot = _go.transform:Find("Stones")
                --GetChild索引从0开始
                local _stoneTrs = _stonesRoot:GetChild(_index - 1)
                local _stoneSpr = UIUtils.FindSpr(_stoneTrs, "Icon")
                local _uiIconBase = UnityUtils.RequireComponent(_stoneSpr.transform,"Funcell.GameUI.Form.UIIconBase")
                if _newJadeItemCfg then
                    _stoneSpr.gameObject:SetActive(true)
                    _uiIconBase:UpdateIcon(_newJadeItemCfg.Icon)
                else
                    _stoneSpr.gameObject:SetActive(false)
                end
                --_go.transform:Find("RedPoint").gameObject:SetActive(GameCenter.LianQiGemSystem:IsJadePosHaveRedPoint(_pos))
            end
        end
    end
    for i=0, UnityUtils.GetObjct2Int(EquipmentType.Count) - 1 do
        local _go = self.LeftCloneRoot:GetChild(i).gameObject
        if _go then
            _go.transform:Find("RedPoint").gameObject:SetActive(GameCenter.LianQiGemSystem:IsJadePosHaveRedPoint(i))
        end
    end
end

function UILianQiGemForm:LeftItemOnClick(go)
    if self.CurSelectGo == go then
        do return end
    else
        if self.CurSelectGo ~= nil then
            self.CurSelectGo.transform:Find("Bg").gameObject:SetActive(true)
            self.CurSelectGo.transform:Find("SelectBg").gameObject:SetActive(false)
        end
        go.transform:Find("Bg").gameObject:SetActive(false)
        go.transform:Find("SelectBg").gameObject:SetActive(true)
        self.CurSelectPos = UIEventListener.Get(go).parameter
        GameCenter.PushFixEvent(LogicEventDefine.EID_EVENT_REFRESHRIGHTINFOS, self.CurSelectPos)
        self.CurSelectGo = go
    end
end

function UILianQiGemForm:FindAllComponents()
    self.LeftEquipItemClone = UIUtils.FindTrans(self.Trans, "EquipItemClone")
    self.LeftCloneRoot = UIUtils.FindTrans(self.Trans, "LeftList")
    self.UIListMenu = UnityUtils.RequireComponent(self.Trans:Find("UIListMenu"), "Funcell.GameUI.Form.UIListMenu")
    self.UIListMenu:OnFirstShow(self.CSForm)
    self.UIListMenu:AddIcon(LianQiGemSubEnum.Inlay, DataConfig.DataMessageString.Get("LIANQI_GEM_INLAY"), FunctionStartIdCode.LianQiGemInlay)
    self.UIListMenu:AddIcon(LianQiGemSubEnum.Refine, DataConfig.DataMessageString.Get("LIANQI_GEM_REFINE"), FunctionStartIdCode.LianQiGemRefine)
    self.UIListMenu:AddIcon(LianQiGemSubEnum.Jade, DataConfig.DataMessageString.Get("LIANQI_GEM_JADEINLAY"), FunctionStartIdCode.LianQiGemJade)
    self.UIListMenu:AddSelectEvent(Utils.Handler(self.OnMenuSelect,self))
    self.UIListMenu.IsHideIconByFunc = true
    self:InitLeftList()
end

function UILianQiGemForm:InitLeftList()
    for i=0, UnityUtils.GetObjct2Int(EquipmentType.Count) - 1 do
        local _go = UnityUtils.Clone(self.LeftEquipItemClone.gameObject, self.LeftCloneRoot)-- NGUITools.AddChild(self.LeftCloneRoot.gameObject, self.LeftEquipItemClone.gameObject).gameObject
        local _equip = GameCenter.EquipmentSystem:GetPlayerDressEquip(i)
        local _starLv = GameCenter.EquipmentSystem:OnGetStarLevel(i)
        local _equipItem = UnityUtils.RequireComponent(_go.transform:Find("UIEquipmentItem"), "Funcell.GameUI.Form.UIEquipmentItem")
        _equipItem.transform.name = string.format( "UIEquipmentItem_%d", i)
        _equipItem.SingleClick = nil
        if _equip ~= nil then
            _equipItem:UpdateEquipment(_equip, i, _starLv)
            _go.transform:Find("Equiped").gameObject:SetActive(true)
        else
            _equipItem:UpdateEquipment(i, _starLv)
            _go.transform:Find("Equiped").gameObject:SetActive(false)
        end
        local _nameLab = UIUtils.FindLabel(_go.transform, "EquipName")
        _nameLab.text = _equip and _equip.Name or ""
        _go:SetActive(true)
        if not self.EquipItemByPosDic:ContainsKey(i) then
            self.EquipItemByPosDic:Add(i, _go)
        else
            self.EquipItemByPosDic[i] = _go
        end
        UIEventListener.Get(_go).parameter = i
        UIEventListener.Get(_go).onClick = Utils.Handler(self.LeftItemOnClick, self)
    end
    self.LeftCloneRoot:GetComponent("UIGrid").repositionNow = true
    self.LeftCloneRoot:GetComponent("UIScrollView"):ResetPosition()
end

function UILianQiGemForm:OnMenuSelect(id, open)
    self.Form = id
    if open then
        self:OpenSubForm(id)
    else
        self:CloseSubForm(id)
    end
end

function UILianQiGemForm:OpenSubForm(id)
    if id == LianQiGemSubEnum.Inlay then
        --宝石镶嵌
        if self.LeftCloneRoot.childCount > 0 then
            local _go = self.LeftCloneRoot:GetChild(0).gameObject
            self:LeftItemOnClick(_go)
        end
        self:SetGemInlayList()
        self.CurSelectSubForm = LianQiGemSubEnum.Inlay
        GameCenter.PushFixEvent(UIEventDefine.UILianQiGemInlayForm_OPEN, self.CurSelectPos, self.CSForm)
        self.LeftCloneRoot:GetComponent("UIScrollView"):ResetPosition()
    elseif id == LianQiGemSubEnum.Refine then
        --宝石精炼
        if self.LeftCloneRoot.childCount > 0 then
            local _go = self.LeftCloneRoot:GetChild(0).gameObject
            self:LeftItemOnClick(_go)
        end
        self:SetGemRefineList()
        self.CurSelectSubForm = LianQiGemSubEnum.Refine
        GameCenter.PushFixEvent(UIEventDefine.UILianQiGemRefineForm_OPEN, self.CurSelectPos, self.CSForm)
        self.LeftCloneRoot:GetComponent("UIScrollView"):ResetPosition()
    elseif id == LianQiGemSubEnum.Jade then
        --仙玉镶嵌
        if self.LeftCloneRoot.childCount > 0 then
            local _go = self.LeftCloneRoot:GetChild(0).gameObject
            self:LeftItemOnClick(_go)
        end
        self:SetGemJadeList()
        self.CurSelectSubForm = LianQiGemSubEnum.Jade
        GameCenter.PushFixEvent(UIEventDefine.UILianQiGemJadeForm_OPEN, self.CurSelectPos, self.CSForm)
        self.LeftCloneRoot:GetComponent("UIScrollView"):ResetPosition()
    end
end

function UILianQiGemForm:CloseSubForm(id)
    if id == LianQiGemSubEnum.Inlay then
        --宝石镶嵌
        GameCenter.PushFixEvent(UIEventDefine.UILianQiGemInlayForm_CLOSE, nil, self.CSForm)
    elseif id == LianQiGemSubEnum.Refine then
        --宝石精炼
        GameCenter.PushFixEvent(UIEventDefine.UILianQiGemRefineForm_CLOSE, nil, self.CSForm)
    elseif id == LianQiGemSubEnum.Jade then
        --仙玉镶嵌
        GameCenter.PushFixEvent(UIEventDefine.UILianQiGemJadeForm_CLOSE, nil, self.CSForm)
    end
end

function UILianQiGemForm:SetGemInlayList()
    for i=0, UnityUtils.GetObjct2Int(EquipmentType.Count) - 1 do
        local _go = self.LeftCloneRoot:GetChild(i).gameObject
        if _go then
            local _equip = GameCenter.EquipmentSystem:GetPlayerDressEquip(i)
            local _starLv = GameCenter.EquipmentSystem:OnGetStarLevel(i)
            local _equipTrs = _go.transform:Find(string.format( "UIEquipmentItem_%d", i))
            local _equipItem = UnityUtils.RequireComponent(_equipTrs, "Funcell.GameUI.Form.UIEquipmentItem")
            _equipItem.SingleClick = nil
            if _equip ~= nil then
                _equipItem:UpdateEquipment(_equip, i, _starLv)
                _go.transform:Find("Equiped").gameObject:SetActive(true)
            else
                _equipItem:UpdateEquipment(i, _starLv)
                _go.transform:Find("Equiped").gameObject:SetActive(false)
            end
            local _nameLab = UIUtils.FindLabel(_go.transform, "EquipName")
            _nameLab.text = _equip and _equip.Name or ""

            local _gemInlayInfoDic = GameCenter.LianQiGemSystem.GemInlayInfoByPosDic
            local _stonesRoot = _go.transform:Find("Stones")
            local _noGems = false
            if _gemInlayInfoDic then
                if _gemInlayInfoDic:ContainsKey(i) then
                    local _gemIDList = _gemInlayInfoDic[i]
                    for j = 1, #_gemIDList do
                        local _itemCfg = DataConfig.DataItem[_gemIDList[j]]
                        local _stoneTrs = _stonesRoot:GetChild(j - 1)
                        local _stoneSpr = UIUtils.FindSpr(_stoneTrs, "Icon")
                        if j - 1 < _stonesRoot.childCount and _itemCfg then
                            _stoneSpr.gameObject:SetActive(true)
                            local _uiIconBase = UnityUtils.RequireComponent(_stoneSpr.transform,"Funcell.GameUI.Form.UIIconBase")
                            _uiIconBase:UpdateIcon(_itemCfg.Icon)
                        else
                            _stoneSpr.gameObject:SetActive(false)
                        end
                    end
                    for j = #_gemIDList + 1, _stonesRoot.childCount do
                        local _stoneTrs = _stonesRoot:GetChild(j - 1)
                        local _stoneSpr = UIUtils.FindSpr(_stoneTrs, "Icon")
                        _stoneSpr.gameObject:SetActive(false)
                    end
                else
                    _noGems = true
                end
            else
                _noGems = true
            end
            --如果一个宝石都没有
            if _noGems then
                for j = 1, _stonesRoot.childCount do
                    local _stoneTrs = _stonesRoot:GetChild(j - 1)
                    local _stoneSpr = UIUtils.FindSpr(_stoneTrs, "Icon")
                    _stoneSpr.gameObject:SetActive(false)
                end
            end
            _go.transform:Find("RedPoint").gameObject:SetActive(GameCenter.LianQiGemSystem:IsGemPosHaveRedPoint(i))
        end
    end
end

function UILianQiGemForm:SetGemRefineList()
    self:SetGemInlayList()
    for i=0, UnityUtils.GetObjct2Int(EquipmentType.Count) - 1 do
        local _go = self.LeftCloneRoot:GetChild(i).gameObject
        if _go then
            local _equip = GameCenter.EquipmentSystem:GetPlayerDressEquip(i)
            local _nameLab = UIUtils.FindLabel(_go.transform, "EquipName")
            if _equip then
                if GameCenter.LianQiGemSystem.GemRefineInfoByPosDic:ContainsKey(i) then
                    local _refineInfo = GameCenter.LianQiGemSystem.GemRefineInfoByPosDic[i]
                    _nameLab.text = string.format( "%s+%d", _equip.Name, _refineInfo.Level)-- UIUtils.CSFormat("{0}+{1}", _equip.Name, _refineInfo.Level)
                else
                    _nameLab.text = string.format( "%s+%d", _equip.Name, 0)
                end
            else
                _nameLab.text = ""
            end
            _go.transform:Find("RedPoint").gameObject:SetActive(GameCenter.LianQiGemSystem:IsGemRefinePosHaveRedPoint(i))
        end
    end
end

function UILianQiGemForm:SetGemJadeList()
    for i=0, UnityUtils.GetObjct2Int(EquipmentType.Count) - 1 do
        local _go = self.LeftCloneRoot:GetChild(i).gameObject
        if _go then
            local _equip = GameCenter.EquipmentSystem:GetPlayerDressEquip(i)
            local _starLv = GameCenter.EquipmentSystem:OnGetStarLevel(i)
            local _equipTrs = _go.transform:Find(string.format( "UIEquipmentItem_%d", i))
            local _equipItem = UnityUtils.RequireComponent(_equipTrs, "Funcell.GameUI.Form.UIEquipmentItem")
            _equipItem.SingleClick = nil
            if _equip ~= nil then
                _equipItem:UpdateEquipment(_equip, i, _starLv)
                _go.transform:Find("Equiped").gameObject:SetActive(true)
            else
                _equipItem:UpdateEquipment(i, _starLv)
                _go.transform:Find("Equiped").gameObject:SetActive(false)
            end
            local _nameLab = UIUtils.FindLabel(_go.transform, "EquipName")
            _nameLab.text = _equip and _equip.Name or ""
            
            local _jadeInlayInfoDic = GameCenter.LianQiGemSystem.JadeInlayInfoByPosDic
            local _stonesRoot = _go.transform:Find("Stones")
            local _noGems = false
            if _jadeInlayInfoDic then
                if _jadeInlayInfoDic:ContainsKey(i) then
                    local _gemIDList = _jadeInlayInfoDic[i]
                    for j = 1, #_gemIDList do
                        local _itemCfg = DataConfig.DataItem[_gemIDList[j]]
                        local _stoneTrs = _stonesRoot:GetChild(j - 1)
                        local _stoneSpr = UIUtils.FindSpr(_stoneTrs, "Icon")
                        if j - 1 < _stonesRoot.childCount and _itemCfg then
                            _stoneSpr.gameObject:SetActive(true)
                            local _uiIconBase = UnityUtils.RequireComponent(_stoneSpr.transform,"Funcell.GameUI.Form.UIIconBase")
                            _uiIconBase:UpdateIcon(_itemCfg.Icon)
                        else
                            _stoneSpr.gameObject:SetActive(false)
                        end
                    end
                    for j = #_gemIDList + 1, _stonesRoot.childCount do
                        local _stoneTrs = _stonesRoot:GetChild(j - 1)
                        local _stoneSpr = UIUtils.FindSpr(_stoneTrs, "Icon")
                        _stoneSpr.gameObject:SetActive(false)
                    end
                else
                    _noGems = true
                end
            else
                _noGems = true
            end
            --如果一个仙玉都没有
            if _noGems then
                for j = 1, _stonesRoot.childCount do
                    local _stoneTrs = _stonesRoot:GetChild(j - 1)
                    local _stoneSpr = UIUtils.FindSpr(_stoneTrs, "Icon")
                    _stoneSpr.gameObject:SetActive(false)
                end
            end
            _go.transform:Find("RedPoint").gameObject:SetActive(GameCenter.LianQiGemSystem:IsJadePosHaveRedPoint(i))
        end
    end
end

return UILianQiGemForm