--作者： xc
--日期： 2019-04-28
--文件： NatureWeaponData.lua
--模块： NatureWeaponData
--描述： 神器数据系统子类继承NatureBaseData
------------------------------------------------
local NatureBase = require "Logic.Nature.NatureBaseData"
local SkillSetDate = require "Logic.Nature.NatureSkillSetData"
local ModelData= require "Logic.Nature.NatureBaseModelData"
local FashionData = require "Logic.Nature.NatureFashionData"
local BaseItemData = require "Logic.Nature.NatureBaseItemData"
local RedPointCustomCondition = CS.Funcell.Code.Logic.RedPointCustomCondition

local NatureWeaponData = {
    Cfg = nil , --阵法配置表数据
    IsMax = 0, --阵法最大等级
    super = nil, --父类对象
    BreakItem = List:New() --突破道具
}

function NatureWeaponData:New()
    local _obj = NatureBase:New()
    local _M = Utils.DeepCopy(self)
    _M.super = _obj
    return _M
end

--解析突破道具
function NatureWeaponData:AnalysisBreakItem(str)
    self.BreakItem:Clear()
    if str then
        local _cs = {';','_'}
        local _attr = Utils.SplitStrByTableS(str,_cs)
        for i=1,#_attr do        
            local _data = BaseItemData:New(_attr[i][1],_attr[i][2])
            self.BreakItem:Add(_data)
        end
    end
end

--初始化技能
function NatureWeaponData:Initialize()
    for k, v in pairs(DataConfig.DataNatureWeapon) do
        if v.Skill ~= 0 then
            local _data = SkillSetDate:New(v)
            self.super.SkillList:Add(_data)
        end
        if v.ModelID ~= 0 then
            local _data = ModelData:New(v)
            self.super.ModelList:Add(_data)
        end
        if self.IsMax < v.Id then
            self.IsMax = v.Id
        end
    end
    self.super.SkillList:Sort(
        function(a,b)
            if a.SkillInfo and b.SkillInfo then
                return tonumber(a.SkillInfo.Id) < tonumber(b.SkillInfo.Id)
            end
            return true
        end
    )
    self.super.ModelList:Sort(
        function(a,b)
            return tonumber(a.Stage) < tonumber(b.Stage)
        end
    )
    --初始化化形数据
    for k, v in pairs(DataConfig.DataHuaxingWeapon) do
        local _data = FashionData:New(v)
        self.super.FishionList:Add(_data)
    end
    self.super.FishionList:Sort(
        function(a,b)
            return tonumber(a.ModelId) < tonumber(b.ModelId)
        end
    )
    self.HitEvent = Utils.Handler(self.UpDateHit, self)
    GameCenter.RegFixEventHandle(LogicEventDefine.EVENT_ITEM_CHANGE_UPDATE, self.HitEvent)
    self.CoinEvent = Utils.Handler(self.UpDateCoin, self)
    GameCenter.RegFixEventHandle(LogicEventDefine.EVENT_COIN_CHANGE_UPDATE, self.CoinEvent)
end

--反初始化  
function NatureWeaponData:UnInitialize()
    self.Cfg = nil
    self.super = nil
    self.IsMax = 0
    GameCenter.UnRegFixEventHandle(LogicEventDefine.EVENT_ITEM_CHANGE_UPDATE, self.HitEvent)
    GameCenter.UnRegFixEventHandle(LogicEventDefine.EVENT_COIN_CHANGE_UPDATE, self.CoinEvent)
end

--初始化服务器数据
function NatureWeaponData:InitWingInfo(msg)
    if msg and msg.natureInfo then
        self.Cfg = DataConfig.DataNatureWeapon[msg.natureInfo.curLevel]
        self.super:UpDateSkill(msg.natureInfo.haveActiveSkill) --设置技能
        self.super:UpDateModel(msg.natureInfo.haveActiveModel) --设置模型
        self.super:UpDataFashionInfos(msg.natureInfo.outlineInfo) --设置化形
        if self.Cfg then
            self.super:AnalysisAttr(self.Cfg.Att)
            self:UpDateMsgWeaponInfo(msg.WeaponsInfo)
            self.super:AnalysisItemAndNum(self.Cfg.ActiveCost) --设置升级道具
            self:AnalysisBreakItem(self.Cfg.LevelUpCost) --设置突破道具
            self.super:Parase(msg.natureType,msg.natureInfo)
        end
        self:UpDateLevelOrBreakHit(FunctionStartIdCode.NatureWeaponLevel,true)
        self:UpDateLevelOrBreakHit(FunctionStartIdCode.NatureWeaponBreak,false)
        self.super:UpDateFashionHit(FunctionStartIdCode.NatureWeaponFashion)
    end
end

--更新技能升级
function NatureWeaponData:UpDateUpLevel(msg)
    if msg.activeSkill ~= 0 then
        self.super:SetSkillActive(msg.activeSkill)
    end
    self.super.Level = msg.level
    self.Cfg = DataConfig.DataNatureWeapon[msg.level]
    if self.Cfg then
        self.super:AnalysisAttr(self.Cfg.Att)
        self:UpDateMsgWeaponInfo(msg.WeaponsInfo)
    end
    if msg.activeModel ~= 0 then
        self.super:SetModelActive(msg.activeModel)
    end
    self.super.CurExp = msg.curexp
    self.super.Fight = msg.fight
    self:UpDateLevelOrBreakHit(FunctionStartIdCode.NatureWeaponLevel,true)
    self:UpDateLevelOrBreakHit(FunctionStartIdCode.NatureWeaponBreak,false)
end

--更新设置模型ID
function NatureWeaponData:UpDateModelId(model)
    self.super.CurModel = model
end

--更新化形升级结果
function NatureWeaponData:UpDateFashionInfo(msg)
    self.super:UpDataFashion(msg)
    self.super:UpDateFashionHit(FunctionStartIdCode.NatureWeaponFashion)
end

--货币更新
function NatureWeaponData:UpDateCoin(item)
    if self.super.ItemList then --道具
        local _isHave = self.super.ItemList:Find(
            function(code)
                return code.ItemID == item
            end
        ) 
        if _isHave then
            self:UpDateLevelOrBreakHit(FunctionStartIdCode.NatureWeaponLevel,true)
        end
    end    
    if self.BreakItem then --道具突破
        local _isHave = self.BreakItem:Find(
            function(code)
                return code.ItemID == item
            end
        )
        if _isHave then
            self:UpDateLevelOrBreakHit(FunctionStartIdCode.NatureWeaponBreak,true)
        end
    end
end

--道具来了，红点更新
function NatureWeaponData:UpDateHit(item,sender)
    if self.super.ItemList then --道具
        local _isHave = self.super.ItemList:Find(
            function(code)
                return code.ItemID == item
            end
        ) 
        if _isHave then
            self:UpDateLevelOrBreakHit(FunctionStartIdCode.NatureWeaponLevel,true)
        end
    end
    if self.BreakItem then --道具突破
        local _isHave = self.BreakItem:Find(
            function(code)
                return code.ItemID == item
            end
        )
        if _isHave then
            self:UpDateLevelOrBreakHit(FunctionStartIdCode.NatureWeaponBreak,true)
        end
    end
    if self.super.FishionList then --化形
        local _isHave = self.super.FishionList:Find(
            function(code)
                return code.Item == item
            end
        ) 
        if _isHave then
            self.super:UpDateFashionHit(FunctionStartIdCode.NatureWeaponFashion)
        end
    end
end

--功能函数！！！！！！！！！！！！！！！

--是否满级了
function NatureWeaponData:IsMaxLevel()
    return self.IsMax <= self.super.Level
end

--获取模型相机大小
function NatureWeaponData:Get3DUICamerSize(modelid)
    local _info = DataConfig.DataHuaxingWeapon[modelid]
    if _info then
        return _info.CameraSize
    end
    return 1
end

--更新服务器过来的属性数据
function NatureWeaponData:UpDateMsgWeaponInfo(weaponsInfo)
    if weaponsInfo then
        for i=1,#weaponsInfo do
            local _info = self.super.AttrList:Find(
                function(code)
                    return code.AttrID == weaponsInfo[i].id
                end
            )
            if _info then
                _info.Attr = weaponsInfo[i].value
            end
        end
    end
end

--得到属性值是否可以突破
function NatureWeaponData:GetAttrIsBreak()
    if self.super.AttrList then
        for i=1,#self.super.AttrList do
            if self.super.AttrList[i].Attr <  self.super.AttrList[i].AddAttr then
                return false
            end
        end
        return true
    end
    return false
end

--更新等级红点
function NatureWeaponData:UpDateLevelOrBreakHit(functionid,islevel)
    local _isReach = false
    local _ismax = self.super.Level >= self.IsMax
    local _itemlist = islevel and self.super.ItemList or self.BreakItem
    local _count = #_itemlist
    if not _ismax then
        for i = 1,_count do
            if GameCenter.ItemContianerSystem:GetItemCountFromCfgId(_itemlist[i].ItemID) >= _itemlist[i].ItemExp  then
                _isReach = true
            else
                _isReach = false
                break
            end
        end
    end
    if islevel then
       _isReach = _isReach and not self:GetAttrIsBreak()
    end
    if _isReach then
        GameCenter.RedPointSystem:AddFuncCondition(functionid, NatureSubEnum.Begin, RedPointCustomCondition(true))
    else
        GameCenter.RedPointSystem:RemoveFuncCondition(functionid, NatureSubEnum.Begin)
    end
end

return NatureWeaponData

