--作者： cy
--日期： 2019-05-20
--文件： UILianQiGemAllAttrForm.lua
--模块： UILianQiGemAllAttrForm
--描述： 在UIPlayerBaseForm中的一个子面板，用于显示所有宝石属性
------------------------------------------------

local UILianQiGemAllAttrForm = {
    AnimModule = nil,
    GetLevelInfoTrs = nil,
    CurLevelLab = nil,
    NextLevelInfoTrs = nil,
    CloseBtn = nil,
}

--注册事件函数, 提供给CS端调用.
function UILianQiGemAllAttrForm:OnRegisterEvents()
    self:RegisterEvent(UIEventDefine.UILianQiGemAllAttrForm_OPEN,self.OnOpen)
    self:RegisterEvent(UIEventDefine.UILianQiGemAllAttrForm_CLOSE,self.OnClose)
end

function UILianQiGemAllAttrForm:OnOpen(obj, sender)
    self.CSForm:Show(sender)
end

function UILianQiGemAllAttrForm:OnClose(obj,sender)
    self.CSForm:Hide()
end

--Load函数, 提供给CS端调用.
function UILianQiGemAllAttrForm:OnLoad()
    
end

--第一只显示函数, 提供给CS端调用.
function UILianQiGemAllAttrForm:OnFirstShow()
	self:FindAllComponents();
	self:RegUICallback();
end

--显示之前的操作, 提供给CS端调用.
function UILianQiGemAllAttrForm:OnShowBefore()
    
end

--显示后的操作, 提供给CS端调用.
function UILianQiGemAllAttrForm:OnShowAfter()
    
end

--隐藏之前的操作, 提供给CS端调用.
function UILianQiGemAllAttrForm:OnHideBefore()
    
end

--隐藏之后的操作, 提供给CS端调用.
function UILianQiGemAllAttrForm:OnHideAfter()
    
end

--卸载事件的操作, 提供给CS端调用.
function UILianQiGemAllAttrForm:OnUnRegisterEvents()
    
end

--UnLoad的操作, 提供给CS端调用.
function UILianQiGemAllAttrForm:OnUnload()
    
end

--窗体卸载的操作, 提供给CS端调用.
function UILianQiGemAllAttrForm:OnFormDestroy()
    
end

--查找所有组件
function UILianQiGemAllAttrForm:FindAllComponents()
    local _myTrans = self.Trans;
    self.CloseBtn = UIUtils.FindBtn(_myTrans, "closeButton")
    self.GetLevelInfoTrs = UIUtils.FindTrans(_myTrans, "GetLevelInfo")
    self.CurLevelLab = UIUtils.FindLabel(_myTrans, "CurLevel")
    self.NextLevelInfoTrs = UIUtils.FindTrans(_myTrans, "NextLevelInfo")
    --创建动画模块
    self.AnimModule = UIAnimationModule(self.Trans)
    --添加一个动画
    self.AnimModule:AddAlphaAnimation()
    
    self:SetAllInfo()
end

--绑定UI组件的回调函数
function UILianQiGemAllAttrForm:RegUICallback()
    UIUtils.AddBtnEvent(self.CloseBtn, self.Close, self)
end

function UILianQiGemAllAttrForm:Close()
    self:OnClose()
end

function UILianQiGemAllAttrForm:SetAllInfo()
    table.sort( DataConfig.DataGemGrade, function(a, b) return a.Id < b.Id end )
    --表从1开始，可以用#取长度
    local _gemTotalLv = GameCenter.LianQiGemSystem:GetGemTotalLevel()
    local _curCfg, _nextCfg = self:GetCurAndNextCfg(_gemTotalLv)
    self:SetAttrInfo(self.GetLevelInfoTrs, _curCfg)
    self.CurLevelLab.text = tostring(_gemTotalLv)
    self:SetAttrInfo(self.NextLevelInfoTrs, _nextCfg)
end

function UILianQiGemAllAttrForm:SetAttrInfo(trans, cfg)
    if cfg.Id == 0 or cfg.Id == -1 then
        trans.gameObject:SetActive(false)
        do return end
    end
    local _leveLab = UIUtils.FindLabel(trans, "TotalLevel")
    _leveLab.text = tostring(cfg.Leve)
    local _attrs = Utils.SplitStrByTableS(cfg.AddAttr, {";", "_"})
    if _attrs[1] then
        local _attrNameLab = UIUtils.FindLabel(trans, "Attr1/Txt")
        local _attrValueLab = UIUtils.FindLabel(trans, "Attr1")
        local _attrCfg = DataConfig.DataAttributeAdd[_attrs[1][1]]
        if _attrCfg then
            _attrNameLab.text = _attrCfg.Name
            local _valueTxt = _attrCfg.ShowPercent == 0 and tostring(_attrs[1][2]) or ((math.FormatNumber(_attrs[1][2]/100)) .. "%")
            _attrValueLab.text = _valueTxt
        end
    end
    if _attrs[2] then
        local _attrNameLab = UIUtils.FindLabel(trans, "Attr2/Txt")
        local _attrValueLab = UIUtils.FindLabel(trans, "Attr2")
        local _attrCfg = DataConfig.DataAttributeAdd[_attrs[2][1]]
        if _attrCfg then
            _attrNameLab.text = _attrCfg.Name
            local _valueTxt = _attrCfg.ShowPercent == 0 and tostring(_attrs[2][2]) or ((math.FormatNumber(_attrs[2][2]/100)) .. "%")
            _attrValueLab.text = _valueTxt
        end
    end
    if _attrs[3] then
        local _attrNameLab = UIUtils.FindLabel(trans, "Attr3/Txt")
        local _attrValueLab = UIUtils.FindLabel(trans, "Attr3")
        local _attrCfg = DataConfig.DataAttributeAdd[_attrs[3][1]]
        if _attrCfg then
            _attrNameLab.text = _attrCfg.Name
            local _valueTxt = _attrCfg.ShowPercent == 0 and tostring(_attrs[3][2]) or ((math.FormatNumber(_attrs[3][2]/100)) .. "%")
            _attrValueLab.text = _valueTxt
        end
    end
    if _attrs[4] then
        local _attrNameLab = UIUtils.FindLabel(trans, "Attr4/Txt")
        local _attrValueLab = UIUtils.FindLabel(trans, "Attr4")
        local _attrCfg = DataConfig.DataAttributeAdd[_attrs[4][1]]
        if _attrCfg then
            _attrNameLab.text = _attrCfg.Name
            local _valueTxt = _attrCfg.ShowPercent == 0 and tostring(_attrs[4][2]) or ((math.FormatNumber(_attrs[4][2]/100)) .. "%")
            _attrValueLab.text = _valueTxt
        end
    end
end

function UILianQiGemAllAttrForm:GetCurAndNextCfg(totalLv)
    --该表id从1开始，因此可以用“#”取长度
    local _cfgLength = #DataConfig.DataGemGrade
    for k,v in pairs(DataConfig.DataGemGrade) do
        --和前n-1个数据作对比（因为要和“当前条目”和“下一条目”的等级作对比）
        if k - 1 < _cfgLength then
            if totalLv >= v.Leve and totalLv < DataConfig.DataGemGrade[k + 1].Leve then
                return v, DataConfig.DataGemGrade[k + 1]
            end
        else
            --如果到了最后一条数据还没return
            local _cfg = Utils.DeepCopy(v)
            --Id = -1 表示已达最大值
            _cfg.Id = -1
            return v, _cfg
        end
    end
    --默认数据
    local _cfg = Utils.DeepCopy(DataConfig.DataGemGrade[1])
    _cfg.Id = 0
    return _cfg, DataConfig.DataGemGrade[1] --, Utils.DeepCopy(DataConfig.DataGemGrade[1])
end

return UILianQiGemAllAttrForm;