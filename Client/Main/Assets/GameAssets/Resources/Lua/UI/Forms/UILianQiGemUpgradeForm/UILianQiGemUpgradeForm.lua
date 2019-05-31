--作者： cy
--日期： 2019-05-09
--文件： UILianQiGemUpgradeForm.lua
--模块： UILianQiGemUpgradeForm
--描述： 炼器功能二级子面板：宝石镶嵌 的附属面板：宝石升级界面
------------------------------------------------
local NGUITools = CS.NGUITools

local UILianQiGemUpgradeForm = {
    CloseBtn = nil,
    NowGemTrs = nil,
    NextGemTrs = nil,
    MyNowHaveGemItemTrs = nil,
    UpgradeBtn = nil,
    UpgradeBtnLab = nil,
    UpgradeNeedMoneyType = ItemTypeCode.Gold,
    UpgradeNeedMoney = 0,
    CurPos = 0,
    CurIndex = 1,
    Type = 1,                           --打开本界面的上级界面，1：宝石，2：仙玉
}

function UILianQiGemUpgradeForm:OnRegisterEvents()
    self:RegisterEvent(UIEventDefine.UILianQiGemUpgradeForm_OPEN,self.OnOpen)
    self:RegisterEvent(UIEventDefine.UILianQiGemUpgradeForm_CLOSE,self.OnClose)
end

function UILianQiGemUpgradeForm:OnOpen(obj, sender)
    if obj then
        self.Type = obj[1]
        self.CurPos = obj[2]
        self.CurIndex = obj[3]
    end
    self.CSForm:Show(sender)
end

function UILianQiGemUpgradeForm:OnClose(obj,sender)
    self.CSForm:Hide()
end

function UILianQiGemUpgradeForm:RegUICallback()
    UIUtils.AddBtnEvent(self.CloseBtn, self.OnClose, self)
    UIUtils.AddBtnEvent(self.UpgradeBtn, self.UpgradeBtnOnClick, self)
end

function UILianQiGemUpgradeForm:OnFirstShow()
    self:FindAllComponents()
    self:RegUICallback()
end

function UILianQiGemUpgradeForm:OnShowBefore()
    
end

function UILianQiGemUpgradeForm:OnShowAfter()
    self:InitAllInfos()
end

function UILianQiGemUpgradeForm:OnHideBefore()
    
end

function UILianQiGemUpgradeForm:FindAllComponents()
    self.CloseBtn = UIUtils.FindBtn(self.Trans, "closeButton")
    self.NowGemTrs = UIUtils.FindTrans(self.Trans, "NowGem")
    self.NextGemTrs = UIUtils.FindTrans(self.Trans, "NextGem")
    self.MyNowHaveGemItemTrs = UIUtils.FindTrans(self.Trans, "MyNowHaveGemItem")
    self.UpgradeBtn = UIUtils.FindBtn(self.Trans, "UpgradeBtn")
    self.UpgradeBtnLab = UIUtils.FindLabel(self.Trans, "UpgradeBtn/Label")

    self:InitAllInfos()
end

function UILianQiGemUpgradeForm:CloseBtnOnClick()
    self:OnClose(nil)
end

function UILianQiGemUpgradeForm:UpgradeBtnOnClick()
    if self.UpgradeNeedMoney > 0 then
        local _haveMoney = GameCenter.ItemContianerSystem:GetEconomyWithType(self.UpgradeNeedMoneyType)
        if _haveMoney >= self.UpgradeNeedMoney then
            GameCenter.LianQiGemSystem:ReqUpGradeGem(self.Type, self.CurPos, self.CurIndex)
        else
            local _itemID = UnityUtils.GetObjct2Int(self.UpgradeNeedMoneyType)
            local _itemCfg = DataConfig.DataItem[_itemID]
            if _itemCfg then
                --string.format( "%s不足", _itemCfg.Name)
                GameCenter.MsgPromptSystem:ShowPrompt(UIUtils.CSFormat(DataConfig.DataMessageString.Get("MATERIAL_NOT_ENOUGH"), _itemCfg.Name))
            end
        end
    else
        GameCenter.LianQiGemSystem:ReqUpGradeGem(self.Type, self.CurPos, self.CurIndex)
    end
    self:OnClose()
end

function UILianQiGemUpgradeForm:InitAllInfos()
    local _inlayIDList
    local _maxLv = 0
    if self.Type == 1 then
        _inlayIDList = GameCenter.LianQiGemSystem.GemInlayInfoByPosDic[self.CurPos]
        _maxLv = GameCenter.LianQiGemSystem.GemMaxLevel
    elseif self.Type == 2 then
        _inlayIDList = GameCenter.LianQiGemSystem.JadeInlayInfoByPosDic[self.CurPos]
        _maxLv = GameCenter.LianQiGemSystem.JadeMaxLevel
    end
    if _inlayIDList and _inlayIDList[self.CurIndex] then
        local _curInlayID = _inlayIDList[self.CurIndex]
        local _curInlayItemCfg = DataConfig.DataItem[_curInlayID]
        local _curInlayLv = GameCenter.LianQiGemSystem:GetJadeLevelByItemID(_curInlayID)
        if _curInlayLv + 1 <= _maxLv then
            local _nextInlayID = _curInlayID + 1
            local _nextInlayItemCfg = DataConfig.DataItem[_nextInlayID]
            if _curInlayItemCfg then
                self:SetGemInfo(self.NowGemTrs, _curInlayItemCfg)
            end
            if _nextInlayItemCfg then
                self:SetGemInfo(self.NextGemTrs, _nextInlayItemCfg)
            end
        else
            if _curInlayItemCfg then
                self:SetGemInfo(self.NowGemTrs, _curInlayItemCfg)
                self:SetGemInfo(self.NextGemTrs, _curInlayItemCfg)
            end
        end
        local _uiItem = UIUtils.RequireUIItem(self.MyNowHaveGemItemTrs)
        local _haveNum = GameCenter.ItemContianerSystem:GetItemCountFromCfgId(_curInlayID)
        if _uiItem then
            _uiItem:InitializationWithIdAndNum(_curInlayID, _haveNum, false, false)
            _uiItem:OnSetNum(tostring(_haveNum))
            _uiItem:OnSetNumColor(_haveNum > 0 and Color.green or Color.red)
        end
        if _curInlayItemCfg.HechenTarget and _curInlayItemCfg.HechenTarget ~= "" then
            NGUITools:SetButtonGrayAndNotOnClick(self.UpgradeBtn.transform, false)
            local _targetList = Utils.SplitStr(_curInlayItemCfg.HechenTarget, "_")
            if _targetList[2] then
                local _conbineNeedNum = tonumber(_targetList[2])
                local _conbineNeedMoney = (_conbineNeedNum - (_haveNum + 1)) * _curInlayItemCfg.ItemPrice
                if _conbineNeedMoney > 0 then
                    self.UpgradeNeedMoney = _conbineNeedMoney
                    local _itemID = UnityUtils.GetObjct2Int(self.UpgradeNeedMoneyType)
                    local _itemCfg = DataConfig.DataItem[_itemID]
                    if _itemCfg then
                        self.UpgradeBtnLab.text = UIUtils.CSFormat(DataConfig.DataMessageString.Get("LIANQI_GEM_01UPGRADE"), _conbineNeedMoney, _itemCfg.Name)
                    end
                else
                    self.UpgradeNeedMoney = 0
                    self.UpgradeBtnLab.text = DataConfig.DataMessageString.Get("LIANQI_GEM_UPGRADENOW")
                end
            end
        else
            self.UpgradeBtnLab.text = DataConfig.DataMessageString.Get("LIANQI_GEM_MAXGEMLEVEL")
            NGUITools.SetButtonGrayAndNotOnClick(self.UpgradeBtn.transform, true)
        end
    end
end

function UILianQiGemUpgradeForm:SetGemInfo(trans, itemCfg)
    local _uiItem = UIUtils.RequireUIItem(trans:Find("Item"))
    if _uiItem then
        _uiItem:InitializationWithIdAndNum(itemCfg.Id, 1, false, false)
    end
    local _nameLab = UIUtils.FindLabel(trans, "NameLabel")
    _nameLab.text = itemCfg.Name
    local _attrs = Utils.SplitStrByTableS(itemCfg.EffectNum, {";", "_"})
    if _attrs[1] and _attrs[1][1] == 1 then
        local _attr1Cfg = DataConfig.DataAttributeAdd[_attrs[1][2]]
        local _txt = _attr1Cfg.ShowPercent == 0 and tostring(_attrs[1][3]) or string.format( "%d%%", _attrs[1][3]//100)-- UIUtils.CSFormat("{0}%", _attrs[1][3]/100)
        local _attr1Lab = UIUtils.FindLabel(trans, "Attr1")
        _attr1Lab.text = string.format( "%s+%s", _attr1Cfg.Name, _txt)-- UIUtils.CSFormat("{0}+{1}", _attr1Cfg.Name, _txt)
    end
    if _attrs[2] and _attrs[2][1] == 1 then
        local _attr2Cfg = DataConfig.DataAttributeAdd[_attrs[2][2]]
        local _txt = _attr2Cfg.ShowPercent == 0 and tostring(_attrs[2][3]) or string.format( "%d%%", _attrs[2][3]//100)-- UIUtils.CSFormat("{0}%", _attrs[2][3]/100)
        local _attr2Lab = UIUtils.FindLabel(trans, "Attr2")
        _attr2Lab.text = string.format( "%s+%s", _attr2Cfg.Name, _txt)-- UIUtils.CSFormat("{0}+{1}", _attr2Cfg.Name, _txt)
    end
end

return UILianQiGemUpgradeForm