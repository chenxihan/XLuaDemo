--作者： cy
--日期： 2019-05-09
--文件： UILianQiGemRefineForm.lua
--模块： UILianQiGemRefineForm
--描述： 炼器功能二级子面板：宝石精炼。上级面板为：宝石面板（UILianQiGemForm）
------------------------------------------------

local UILianQiGemRefineForm = {
    EquipItemTrs = nil,
    AllGemsTrs = nil,
    ProgressBar = nil,
    ProgressBarLabel = nil,
    GemAttrInfoTrs = nil,
    GemAttrInfoCloneGo = nil,
    GemAttrInfoCloneRoot = nil,
    GemAttrInfoCloneRootGrid = nil,
    ItemsTrs = nil,
    ItemCloneGo = nil,
    ItemCloneRoot = nil,
    ItemCloneRootGrid = nil,
    QuickRefineBtn = nil,
    AutoRefineBtn = nil,
    CostItemNumDic = Dictionary:New(),          --精炼所需道具的数量字典。例：key = ItemID, value = 数量
    CurPos = 0,
    CurSelectCostItemGo = nil,
}

function UILianQiGemRefineForm:OnRegisterEvents()
    self:RegisterEvent(UIEventDefine.UILianQiGemRefineForm_OPEN, self.OnOpen)
    self:RegisterEvent(UIEventDefine.UILianQiGemRefineForm_CLOSE, self.OnClose)
    self:RegisterEvent(LogicEventDefine.EID_EVENT_REFRESHRIGHTINFOS, self.RefreshRightInfos)
    self:RegisterEvent(LogicEventDefine.EID_EVENT_GEMREFINEINFO, self.RefreshRefineInfo)
end

function UILianQiGemRefineForm:OnOpen(obj, sender)
    if obj then
        self.CurPos = obj
    end
    self.CSForm:Show(sender)
end

function UILianQiGemRefineForm:OnClose(obj,sender)
    self.CSForm:Hide()
end

function UILianQiGemRefineForm:RegUICallback()
    UIUtils.AddBtnEvent(self.QuickRefineBtn, self.QuickRefineBtnOnClick, self)
    UIUtils.AddBtnEvent(self.AutoRefineBtn, self.AutoRefineBtnOnClick, self)
end

function UILianQiGemRefineForm:OnFirstShow()
    self:FindAllComponents()
    self:RegUICallback()
end

function UILianQiGemRefineForm:OnShowBefore()
    
end

function UILianQiGemRefineForm:OnShowAfter()
    self:RefreshRightInfos(self.CurPos)
end

function UILianQiGemRefineForm:OnHideBefore()
    
end

function UILianQiGemRefineForm:QuickRefineBtnOnClick()
    local _equip = GameCenter.EquipmentSystem:GetPlayerDressEquip(self.CurPos)
    if not _equip then
        GameCenter.MsgPromptSystem:ShowPrompt(DataConfig.DataMessageString.Get("LIANQI_FORGE_STRENGTHNEEDEQUIP"))
        do return end
    end
    if not GameCenter.LianQiGemSystem:IsPosHaveGem(self.CurPos) then
        GameCenter.MsgPromptSystem:ShowPrompt(DataConfig.DataMessageString.Get("LIANQI_GEM_NEEDINLAYGEM"))
        do return end
    end
    local _refineInfo = GameCenter.LianQiGemSystem.GemRefineInfoByPosDic[self.CurPos]
    if _refineInfo.Level == GameCenter.LianQiGemSystem.GemRefineMaxLevel then
        GameCenter.MsgPromptSystem:ShowPrompt(DataConfig.DataMessageString.Get("LIANQI_GEM_MAXREFINELEVEL"))
        do return end
    end

    local _itemID = UIEventListener.Get(self.CurSelectCostItemGo).parameter
    local _itemCfg = DataConfig.DataItem[_itemID]
    if _itemID and _itemCfg then
        local _haveNum = GameCenter.ItemContianerSystem:GetItemCountFromCfgId(_itemID)
        if _haveNum > 0 then
            GameCenter.LianQiGemSystem:ReqQuickRefineGem(self.CurPos, _itemID)
        else
            --string.format( "%s不足", _itemCfg.Name)
            GameCenter.MsgPromptSystem:ShowPrompt(UIUtils.CSFormat(DataConfig.DataMessageString.Get("MATERIAL_NOT_ENOUGH"), _itemCfg.Name))
        end
    end
end

function UILianQiGemRefineForm:AutoRefineBtnOnClick()
    --设“所有部位都没有装备” = true
    local _allPosNotHaveEquip = true
    --设“所有部位都有宝石” = false
    local _allPosNotHaveGem = true
    --设“所有部位都到达最高等级” = true
    local _allPosIsMaxLv = true
    local _gemInlayCfg = DataConfig.DataGemstoneInlay[1000 + self.CurPos]
    if _gemInlayCfg then
        local _sameCostPosList = GameCenter.LianQiGemSystem.RefineColorTypeDic[_gemInlayCfg.ColorType]
        if _sameCostPosList then
            for i=1, #_sameCostPosList do
                local _pos = _sameCostPosList[i]
                local _equip = GameCenter.EquipmentSystem:GetPlayerDressEquip(_pos)
                if _equip then
                    --当该部位有装备
                    _allPosNotHaveEquip = false
                end
                if GameCenter.LianQiGemSystem:IsPosHaveGem(_pos) then
                    --当该部位有宝石
                    _allPosNotHaveGem = false
                end
                local _refineInfo = GameCenter.LianQiGemSystem.GemRefineInfoByPosDic[_pos]
                if _refineInfo.Level < GameCenter.LianQiGemSystem.GemRefineMaxLevel then
                    --当该部位精炼等级比最大等级小
                    _allPosIsMaxLv = false
                end
            end
        end
    end
    if _allPosNotHaveEquip then
        GameCenter.MsgPromptSystem:ShowPrompt(DataConfig.DataMessageString.Get("LIANQI_FORGE_STRENGTHNEEDEQUIP"))
        do return end
    end
    if _allPosNotHaveGem then
        GameCenter.MsgPromptSystem:ShowPrompt(DataConfig.DataMessageString.Get("LIANQI_GEM_NEEDINLAYGEM"))
        do return end
    end
    if _allPosIsMaxLv then
        GameCenter.MsgPromptSystem:ShowPrompt(DataConfig.DataMessageString.Get("LIANQI_GEM_GEMREFINEALLPOSMAX"))
        do return end
    end

    local _haveItem = false
    for k,v in pairs(self.CostItemNumDic) do
        if v > 0 then _haveItem = true end
    end
    if _haveItem then
        GameCenter.LianQiGemSystem:ReqAutoRefineGem(self.CurPos)
    else
        GameCenter.MsgPromptSystem:ShowPrompt(DataConfig.DataMessageString.Get("LIANQI_GEM_NEEDITEMNOTENOUGH"))
    end
end

function UILianQiGemRefineForm:OnClickEquipItem(go)
    local _pos = UIEventListener.Get(go).parameter
    local _equipItem = UnityUtils.RequireComponent(go.transform, "Funcell.GameUI.Form.UIEquipmentItem")
    if _equipItem.Equipment ~= nil then
        GameCenter.ItemTipsMgr:ShowTips(_equipItem.Equipment, go, ItemTipsLocation.EquipDisplay)
    end
end

function UILianQiGemRefineForm:OnItemClick(go)
    local _itemID = UIEventListener.Get(go).parameter
    if go == self.CurSelectCostItemGo then
        GameCenter.ItemTipsMgr:ShowTips(_itemID, go)
    else
        if self.CurSelectCostItemGo ~= nil then
            self.CurSelectCostItemGo.transform:Find("Select").gameObject:SetActive(false)
        end
        go.transform:Find("Select").gameObject:SetActive(true)
    end
    self.CurSelectCostItemGo = go
end

function UILianQiGemRefineForm:FindAllComponents()
    self.EquipItemTrs = UIUtils.FindTrans(self.Trans, "UIEquipmentItem")
    self.AllGemsTrs = UIUtils.FindTrans(self.Trans, "Gems")
    self.ProgressBar = UIUtils.FindProgressBar(self.Trans, "Progress")
    self.ProgressBarLabel = UIUtils.FindLabel(self.Trans, "Progress/Text")
    self.GemAttrInfoTrs = UIUtils.FindTrans(self.Trans, "GemAttrInfo")
    self.GemAttrInfoCloneGo = UIUtils.FindGo(self.GemAttrInfoTrs, "GemAttrClone")
    self.GemAttrInfoCloneRoot = UIUtils.FindTrans(self.GemAttrInfoTrs, "AttributeGrid")
    self.GemAttrInfoCloneRootGrid = self.GemAttrInfoCloneRoot:GetComponent("UIGrid")
    self.ItemsTrs = UIUtils.FindTrans(self.Trans, "Items")
    self.ItemCloneGo = UIUtils.FindGo(self.ItemsTrs, "ItemClone")
    self.ItemCloneRoot = UIUtils.FindTrans(self.ItemsTrs, "ItemGrid")
    self.ItemCloneRootGrid = self.ItemCloneRoot:GetComponent("UIGrid")
    self.QuickRefineBtn = UIUtils.FindBtn(self.Trans, "QuickRefineBtn")
    self.AutoRefineBtn = UIUtils.FindBtn(self.Trans, "AutoRefineBtn")
    
    self:RefreshRightInfos(self.CurPos)
    if self.ItemCloneRoot.childCount > 0 then
        self:OnItemClick(self.ItemCloneRoot:GetChild(0).gameObject)
    end
end

function UILianQiGemRefineForm:RefreshRefineInfo(obj, sender)
    if obj == self.CurPos then
        self:SetProgess()
        self:SetAllAttrs()
        -- if self.ItemCloneRoot.childCount > 0 then
        --     local _clickGo = self.ItemCloneRoot:GetChild(0).gameObject
        --     if self.CurSelectCostItemGo ~= _clickGo then
        --         self:OnItemClick(_clickGo)
        --     end
        -- end
    end
    self:SetItemCost()
    self:SetBtnRedPoint()
end

function UILianQiGemRefineForm:RefreshRightInfos(obj, sender)
    self.CurPos = obj
    self:SetEquipItem(obj)
    self:SetGemInfos()
    self:SetProgess()
    self:SetAllAttrs()
    self:SetItemCost()
    self:SetBtnRedPoint()
    -- if self.ItemCloneRoot.childCount > 0 then
    --     self:OnItemClick(self.ItemCloneRoot:GetChild(0).gameObject)
    -- end
end

function UILianQiGemRefineForm:SetEquipItem(pos)
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

function UILianQiGemRefineForm:SetGemInfos()
    local _gemIDList = GameCenter.LianQiGemSystem.GemInlayInfoByPosDic[self.CurPos]
    if _gemIDList then
        for i=1,GameCenter.LianQiGemSystem.MaxHoleNum do
            local _holeTrs = self.AllGemsTrs:GetChild(i - 1)
            local _lockTrs = _holeTrs:Find("Lock")
            local _gemIconSpr = UIUtils.FindSpr(_holeTrs, "GemIcon")
            --if GameCenter.LianQiGemSystem:IsHoleUnlockByIndex(1, self.CurPos, i) then
            if _gemIDList then
                --UIEventListener.Get(_holeTrs.gameObject).parameter = _gemIDList[i]
                -- >=0，表示孔位已解锁
                if _gemIDList[i] >= 0 then
                    if _gemIDList[i] > 0 then
                        --大于0，表示已镶嵌宝石
                        _lockTrs.gameObject:SetActive(false)
                        _gemIconSpr.gameObject:SetActive(true)
                        local _uiIconBase = UnityUtils.RequireComponent(_gemIconSpr.transform,"Funcell.GameUI.Form.UIIconBase")
                        local _gemItemCfg = DataConfig.DataItem[_gemIDList[i]]
                        _uiIconBase:UpdateIcon(_gemItemCfg.Icon)
                    else
                        --等于0，表示未镶嵌宝石
                        _lockTrs.gameObject:SetActive(true)
                        _gemIconSpr.gameObject:SetActive(false)
                    end
                else
                    _lockTrs.gameObject:SetActive(true)
                    _gemIconSpr.gameObject:SetActive(false)
                end
            end
        end
    end
end

function UILianQiGemRefineForm:SetProgess()
    local _refineInfo = GameCenter.LianQiGemSystem.GemRefineInfoByPosDic[self.CurPos]
    if _refineInfo then
        if _refineInfo.Level + 1 <= GameCenter.LianQiGemSystem.GemRefineMaxLevel then
            local _refineCfgID = self:GetRefineCfgID(self.CurPos, _refineInfo.Level + 1)
            local _refineCfg = DataConfig.DataGemRefining[_refineInfo.Level + 1]
            local _maxExp = _refineCfg.Exp
            self.ProgressBar.value = _refineInfo.Exp/_maxExp
            self.ProgressBarLabel.text = string.format( "%d/%d", _refineInfo.Exp, _maxExp)
        else
            self.ProgressBar.value = 1
            self.ProgressBarLabel.text = "MAX"
        end
    end
end

function UILianQiGemRefineForm:SetAllAttrs()
    local _gemIDList = GameCenter.LianQiGemSystem.GemInlayInfoByPosDic[self.CurPos]
    local _refineInfo = GameCenter.LianQiGemSystem.GemRefineInfoByPosDic[self.CurPos]
    if _gemIDList and _refineInfo then
        local _baseGemAttrDic = Dictionary:New()
        for i = 1, #_gemIDList do
            if _gemIDList[i] and _gemIDList[i] > 0 then
                local _itemCfg = DataConfig.DataItem[_gemIDList[i]]
                local _attrs = Utils.SplitStrByTableS(_itemCfg.EffectNum, {";", "_"})
                for j = 1, #_attrs do
                    --第一个参数为1表示增加的属性
                    if _attrs[j][1] == 1 then
                        if _baseGemAttrDic:ContainsKey(_attrs[j][2]) then
                            _baseGemAttrDic[_attrs[j][2]] = _baseGemAttrDic[_attrs[j][2]] + _attrs[j][3]
                        else
                            _baseGemAttrDic:Add(_attrs[j][2], _attrs[j][3])
                        end
                    end
                end
            end
        end
        --当前等级增加的属性
        local _curRefineLvAttrDic = Dictionary:New()
        local _refineCfgID = self:GetRefineCfgID(self.CurPos, _refineInfo.Level)
        local _refineCfg = DataConfig.DataGemRefining[_refineCfgID]
        if _refineCfg then
            local _attrs = Utils.SplitStrByTableS(_refineCfg.Attribute, {";", "_"})
            for j = 1, #_attrs do
                if not _curRefineLvAttrDic:ContainsKey(_attrs[j][1]) then
                    _curRefineLvAttrDic:Add(_attrs[j][1], _attrs[j][2])
                end
            end
        end
        --下级增加的属性
        local _addAttrsDic = Dictionary:New()
        local _refineCfgID = 0
        if _refineInfo.Level + 1 <= GameCenter.LianQiGemSystem.GemRefineMaxLevel then
            _refineCfgID = self:GetRefineCfgID(self.CurPos, _refineInfo.Level + 1)
        else
            _refineCfgID = self:GetRefineCfgID(self.CurPos, GameCenter.LianQiGemSystem.GemRefineMaxLevel)
        end
        local _refineCfg = DataConfig.DataGemRefining[_refineCfgID]
        if _refineCfg then
            local _attrs = Utils.SplitStrByTableS(_refineCfg.Attribute, {";", "_"})
            for j = 1, #_attrs do
                if not _baseGemAttrDic:ContainsKey(_attrs[j][1]) then
                    _baseGemAttrDic:Add(_attrs[j][1], 0)
                end
                if not _curRefineLvAttrDic:ContainsKey(_attrs[j][1]) then
                    _curRefineLvAttrDic:Add(_attrs[j][1], 0)
                end
                if (not _addAttrsDic:ContainsKey(_attrs[j][1])) and (_curRefineLvAttrDic:ContainsKey(_attrs[j][1])) then
                    _addAttrsDic:Add(_attrs[j][1], _attrs[j][2] - _curRefineLvAttrDic[_attrs[j][1]])
                end
            end
        end

        local _keyList = List:New()
        local _addPer = 0
        for k,v in pairs(_curRefineLvAttrDic) do
            local _attrCfg = DataConfig.DataAttributeAdd[k]
            if _attrCfg and _attrCfg.ShowPercent == 1 then
                _addPer = v/10000
            end
            _keyList:Add(k)
        end
        _keyList:Sort(function(a, b) return a < b end)
        local _count = 0
        for v,k in pairs(_keyList) do
            local _go
            if _count < self.GemAttrInfoCloneRoot.childCount then
                _go = self.GemAttrInfoCloneRoot:GetChild(_count).gameObject
            else
                _go = UnityUtils.Clone(self.GemAttrInfoCloneGo, self.GemAttrInfoCloneRoot)
            end
            local _nameLab = UIUtils.FindLabel(_go.transform, "Name")
            local _totalNumLab = UIUtils.FindLabel(_go.transform, "TotalNum")
            local _addLab = UIUtils.FindLabel(_go.transform, "Add")
            local _attrCfg = DataConfig.DataAttributeAdd[k]
            if _attrCfg then
                _nameLab.text = _attrCfg.Name
                local _txt = ""
                if _attrCfg.ShowPercent == 0 then
                    _txt = tostring(math.floor( (_baseGemAttrDic[k]) + _curRefineLvAttrDic[k] ))
                    --_txt = tostring(math.floor( (_baseGemAttrDic[k] * (1 + _addPer)) + _curRefineLvAttrDic[k] ))
                else
                    _txt = string.format("%d%%", math.FormatNumber((_baseGemAttrDic[k] + _curRefineLvAttrDic[k]) / 100))
                end
                _totalNumLab.text = _txt
                if _refineInfo.Level == GameCenter.LianQiGemSystem.GemRefineMaxLevel then
                    _addLab.text = "MAX"
                else
                    local _addTxt = _attrCfg.ShowPercent == 0 and tostring(_addAttrsDic[k]) or string.format( "%d%%", math.FormatNumber(_addAttrsDic[k]/100))
                    _addLab.text = _addTxt
                end
            end
            -- if _addAttrsDic:ContainsKey(k) then
                
            -- else
            --     local _equip = GameCenter.EquipmentSystem:GetPlayerDressEquip(self.CurPos)
            --     if _equip then
            --         _addLab.text = "MAX"
            --     else
            --         _addLab.text = "MAX"
            --     end
            -- end
            _count = _count + 1
            _go:SetActive(true)
        end
        for i = _count + 1, self.GemAttrInfoCloneRoot.childCount do
            self.GemAttrInfoCloneRoot:GetChild(i - 1).gameObject:SetActive(false)
        end
        self.GemAttrInfoCloneRootGrid.repositionNow = true
    end
end

function UILianQiGemRefineForm:SetItemCost()
    local _refineInfo = GameCenter.LianQiGemSystem.GemRefineInfoByPosDic[self.CurPos]
    if _refineInfo then
        local _refineCfg
        if _refineInfo.Level + 1 <= GameCenter.LianQiGemSystem.GemRefineMaxLevel then
            local _cfgID = self:GetRefineCfgID(self.CurPos, _refineInfo.Level + 1)
            _refineCfg = DataConfig.DataGemRefining[_cfgID]
        else
            local _cfgID = self:GetRefineCfgID(self.CurPos, _refineInfo.Level)
            _refineCfg = DataConfig.DataGemRefining[_cfgID]
        end
        if _refineCfg then
            local _costItemIDs = Utils.SplitStr(_refineCfg.ItemID, "_")
            self.CostItemNumDic:Clear()
            for i = 1, #_costItemIDs do
                local _itemCfg = DataConfig.DataItem[tonumber(_costItemIDs[i])]
                if _itemCfg then
                    local _haveNum = GameCenter.ItemContianerSystem:GetItemCountFromCfgId(_itemCfg.Id)
                    self.CostItemNumDic:Add(_itemCfg.Id, _haveNum)
                    local _go
                    if i - 1 < self.ItemCloneRoot.childCount then
                        _go = self.ItemCloneRoot:GetChild(i - 1).gameObject
                    else
                        _go = UnityUtils.Clone(self.ItemCloneGo, self.ItemCloneRoot)
                    end
                    local _uiItem = UIUtils.RequireUIItem(_go.transform)
                    if _uiItem then
                        _uiItem:InitializationWithIdAndNum(_itemCfg.Id, _haveNum, false, true)
                        _uiItem:OnSetNum(tostring(_haveNum))
                        _uiItem:OnSetNumColor(_haveNum > 0 and Color.green or Color.red)
                        _uiItem.isShowTips = false
                    end
                    UIEventListener.Get(_go).parameter = _itemCfg.Id
                    UIEventListener.Get(_go).onClick = Utils.Handler(self.OnItemClick, self)
                    _go:SetActive(true)
                end
            end
            for i = #_costItemIDs + 1, self.ItemCloneRoot.childCount do
                local _go = self.ItemCloneRoot:GetChild(i - 1).gameObject
                if _go then _go:SetActive(false) end
            end
            self.ItemCloneRootGrid.repositionNow = true
        end
    end
end

function UILianQiGemRefineForm:SetBtnRedPoint()
    local _quickRedPoint = GameCenter.LianQiGemSystem:IsGemRefinePosHaveRedPoint(self.CurPos)
    self.QuickRefineBtn.transform:Find("RedPoint").gameObject:SetActive(_quickRedPoint)

    local _autoRedPoint = false
    local _gemInlayCfg = DataConfig.DataGemstoneInlay[1000 + self.CurPos]
    if _gemInlayCfg then
        local _sameCostPosList = GameCenter.LianQiGemSystem.RefineColorTypeDic[_gemInlayCfg.ColorType]
        if _sameCostPosList then
            for i=1, #_sameCostPosList do
                local _pos = _sameCostPosList[i]
                if GameCenter.LianQiGemSystem:IsGemRefinePosHaveRedPoint(_pos) then
                    _autoRedPoint = true
                    break
                end
            end
        end
    end
    self.AutoRefineBtn.transform:Find("RedPoint").gameObject:SetActive(_autoRedPoint)
end

function UILianQiGemRefineForm:GetRefineCfgID(pos, level)
    return pos * 1000 + level
end

return UILianQiGemRefineForm