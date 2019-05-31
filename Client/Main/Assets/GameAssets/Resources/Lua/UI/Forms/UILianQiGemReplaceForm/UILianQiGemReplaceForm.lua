--作者： cy
--日期： 2019-05-09
--文件： UILianQiGemReplaceForm.lua
--模块： UILianQiGemReplaceForm
--描述： 炼器功能二级子面板：宝石镶嵌 的附属面板：宝石替换界面
------------------------------------------------

local UILianQiGemReplaceForm = {
    CloseBtn = nil,                     --关闭按钮
    GemCloneGo = nil,                   --宝石克隆gameobject
    GemCloneRootGo = nil,               --宝石克隆根节点gameobject
    GemCloneRootScrollView = nil,       --根节点的ScrollView组件
    GemCloneRootGrid = nil,             --根节点的Grid组件
    NoItemGo = nil,
    CurPos = 0,
    CurIndex = 1,
    Type = 1,                           --打开本界面的上级界面，1：宝石，2：仙玉
}

function UILianQiGemReplaceForm:OnRegisterEvents()
    self:RegisterEvent(UIEventDefine.UILianQiGemReplaceForm_OPEN,self.OnOpen)
    self:RegisterEvent(UIEventDefine.UILianQiGemReplaceForm_CLOSE,self.OnClose)
end

function UILianQiGemReplaceForm:OnOpen(obj, sender)
    if obj then
        self.Type = obj[1]
        self.CurPos = obj[2]
        self.CurIndex = obj[3]
    end
    self.CSForm:Show(sender)
end

function UILianQiGemReplaceForm:OnClose(obj,sender)
    self.CSForm:Hide()
end

function UILianQiGemReplaceForm:RegUICallback()
    UIUtils.AddBtnEvent(self.CloseBtn, self.CloseBtnOnClick, self)
end

function UILianQiGemReplaceForm:OnFirstShow()
    self:FindAllComponents()
    self:RegUICallback()
end

function UILianQiGemReplaceForm:OnShowBefore()
    
end

function UILianQiGemReplaceForm:OnShowAfter()
    self:InitGemList()
end

function UILianQiGemReplaceForm:OnHideBefore()
    
end

function UILianQiGemReplaceForm:CloseBtnOnClick()
    self:OnClose(nil)
end

function UILianQiGemReplaceForm:FindAllComponents()
    self.CloseBtn = UIUtils.FindBtn(self.Trans, "closeButton")
    self.GemCloneGo = UIUtils.FindGo(self.Trans, "GemClone")
    self.GemCloneRootGo = UIUtils.FindGo(self.Trans, "GemList")
    self.GemCloneRootScrollView = self.GemCloneRootGo:GetComponent("UIScrollView")
    self.GemCloneRootGrid = self.GemCloneRootGo:GetComponent("UIGrid")
    self.NoItemGo = UIUtils.FindGo(self.Trans, "NoItem")

    self:InitGemList()
end

function UILianQiGemReplaceForm:InitGemList()
    local _canInlayIDList
    if self.Type == 1 then
        _canInlayIDList = GameCenter.LianQiGemSystem.GemInlayCfgByPosDic[self.CurPos].CanInlayGemIDList
    elseif self.Type == 2 then
        _canInlayIDList = GameCenter.LianQiGemSystem.JadeInlayCfgByPosDic[self.CurPos].CanInlayJadeIDList
    end
    local _haveItemCount = 0
    if _canInlayIDList then
        for i=#_canInlayIDList, 1, -1 do
            local _haveCount = GameCenter.ItemContianerSystem:GetItemCountFromCfgId(_canInlayIDList[i])
            local _itemCfg = DataConfig.DataItem[_canInlayIDList[i]]
            if _haveCount > 0 then
                local _go
                if _haveItemCount < self.GemCloneRootGo.transform.childCount then
                    _go = self.GemCloneRootGo.transform:GetChild(_haveItemCount).gameObject
                else
                    _go = UnityUtils.Clone(self.GemCloneGo, self.GemCloneRootGo.transform)-- NGUITools.AddChild(self.GemCloneRootGo, self.GemCloneGo)
                end
                local _uiItem = UIUtils.RequireUIItem(_go.transform:Find("Item"))
                if _uiItem then
                    _uiItem:InitializationWithIdAndNum(_canInlayIDList[i], _haveCount, false, false)
                end
                local _nameLab = UIUtils.FindLabel(_go.transform, "NameLabel")
                _nameLab.text = _itemCfg.Name
                local _attrs = Utils.SplitStrByTableS(_itemCfg.EffectNum, {";", "_"})
                if _attrs[1] and _attrs[1][1] == 1 then
                    local _attr1Cfg = DataConfig.DataAttributeAdd[_attrs[1][2]]
                    local _txt = _attr1Cfg.ShowPercent == 0 and tostring(_attrs[1][3]) or string.format( "%d%%", _attrs[1][3]//100)-- UIUtils.CSFormat("{0}%", _attrs[1][3]/100)
                    local _attr1Lab = UIUtils.FindLabel(_go.transform, "Attr1")
                    _attr1Lab.text = string.format( "%s+%s", _attr1Cfg.Name, _txt)-- UIUtils.CSFormat("{0}+{1}", _attr1Cfg.Name, _txt)
                end
                if _attrs[2] and _attrs[2][1] == 1 then
                    local _attr2Cfg = DataConfig.DataAttributeAdd[_attrs[2][2]]
                    local _txt = _attr2Cfg.ShowPercent == 0 and tostring(_attrs[2][3]) or string.format( "%d%%", _attrs[2][3]//100)-- UIUtils.CSFormat("{0}%", _attrs[2][3]/100)
                    local _attr2Lab = UIUtils.FindLabel(_go.transform, "Attr2")
                    _attr2Lab.text = string.format( "%s+%s", _attr2Cfg.Name, _txt)-- UIUtils.CSFormat("{0}+{1}", _attr2Cfg.Name, _txt)
                end
                _go:SetActive(true)
                UIEventListener.Get(_go).parameter = _canInlayIDList[i]
                UIEventListener.Get(_go).onClick = Utils.Handler(self.GemItemOnClick, self)
                _haveItemCount = _haveItemCount + 1
            end
        end
    end
    for i = _haveItemCount, self.GemCloneRootGo.transform.childCount - 1 do
        self.GemCloneRootGo.transform:GetChild(i).gameObject:SetActive(false)
    end
    self.GemCloneRootGrid.repositionNow = true
    self.NoItemGo:SetActive(_haveItemCount == 0)
end

function UILianQiGemReplaceForm:GemItemOnClick(go)
    local _itemID = UIEventListener.Get(go).parameter
    GameCenter.LianQiGemSystem:ReqInlay(self.Type, self.CurPos, self.CurIndex, _itemID)
    self:OnClose()
end

return UILianQiGemReplaceForm