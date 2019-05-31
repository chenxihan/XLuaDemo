--作者： xc
--日期： 2019-04-18
--文件： NatureMountData.lua
--模块： NatureMountData
--描述： 坐骑数据系统子类继承NatureBaseData
------------------------------------------------
local NatureBase = require "Logic.Nature.NatureBaseData"
local SkillSetDate = require "Logic.Nature.NatureSkillSetData"
local ModelData= require "Logic.Nature.NatureBaseModelData"
local FashionData = require "Logic.Nature.NatureFashionData"
local BaseAttrData = require "Logic.Nature.NatureBaseAttrData"
local BaseItemData = require "Logic.Nature.NatureBaseItemData"
local RedPointCustomCondition = CS.Funcell.Code.Logic.RedPointCustomCondition

local NatureMountData = {
    Cfg = nil , --坐骑配置表数据
    IsMax = 0, --升级最大等级
    super = nil, --父类对象
    BaseCfg = nil, --基础属性配置表
    BaseExp = 0, --基础属性经验值，进度条
    BaseIsMax = 0, --基础属性最大等级
    BaseAttrList = List:New(), --属性列表，存储NatureBaseAttrData
    BaseStarDir = Dictionary:New(),--阶数对应的最大星数
    BaseItemList = List:New(), --可以吃的道具
}

function NatureMountData:New()
    local _obj = NatureBase:New()
    local _M = Utils.DeepCopy(self)
    _M.super = _obj
    return _M
end

--初始化技能
function NatureMountData:Initialize()
    for k, v in pairs(DataConfig.DataNatureHorse) do
        if v.Skill ~= 0 then
            local _data = SkillSetDate:New(v)
            self.super.SkillList:Add(_data)
        end
        if v.ModelID ~= 0 then
            local _data = ModelData:New(v)
            self.super.ModelList:Add(_data)
        end
        if self.BaseStarDir:ContainsKey(v.Steps) then
            if self.BaseStarDir[v.Steps] < v.Star then
                self.BaseStarDir[v.Steps] = v.Star
            end
        else
            self.BaseStarDir:Add(v.Steps,v.Star)
        end
        if self.IsMax < v.Id then
            self.IsMax = v.Id
        end
    end
    for k, v in pairs(DataConfig.DataHorseBasic) do
        if self.BaseIsMax < v.Id then
            self.BaseIsMax = v.Id
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
    for k, v in pairs(DataConfig.DataHuaxingHorse) do
        local _data = FashionData:New(v)
        self.super.FishionList:Add(_data)
    end
    self.super.FishionList:Sort(
        function(a,b)
            return tonumber(a.ModelId) < tonumber(b.ModelId)
        end
    )
    --可以吃的道具
    local _iteminfo = DataConfig.DataHorseBasic[1].UpItem
    self:AnalysisItem(_iteminfo)
    self.HitEvent = Utils.Handler(self.UpDateHit, self)
    GameCenter.RegFixEventHandle(LogicEventDefine.EVENT_ITEM_CHANGE_UPDATE, self.HitEvent)
    self.CoinEvent = Utils.Handler(self.UpDateCoin, self)
    GameCenter.RegFixEventHandle(LogicEventDefine.EVENT_COIN_CHANGE_UPDATE, self.CoinEvent)
    self.HitEquipEvent = Utils.Handler(self.UpDateEquipHit, self)
    GameCenter.RegFixEventHandle(LogicEventDefine.EVENT_BACKFORM_ITEM_UPDATE, self.HitEquipEvent)
end

--反初始化  
function NatureMountData:UnInitialize()
    self.Cfg = nil
    self.super = nil
    self.IsMax = 0
    self.BaseCfg = nil
    self.BaseExp = 0
    self.BaseIsMax = 0
    self.BaseAttrList:Clear()
    GameCenter.UnRegFixEventHandle(LogicEventDefine.EVENT_ITEM_CHANGE_UPDATE, self.HitEvent)
    GameCenter.UnRegFixEventHandle(LogicEventDefine.EVENT_COIN_CHANGE_UPDATE, self.CoinEvent)
    GameCenter.UnRegFixEventHandle(LogicEventDefine.EVENT_BACKFORM_ITEM_UPDATE, self.HitEquipEvent)
end

--初始化服务器数据
function NatureMountData:InitWingInfo(msg)
    if msg and msg.natureInfo then
        self.Cfg = DataConfig.DataNatureHorse[msg.natureInfo.curLevel]
        self.BaseCfg = DataConfig.DataHorseBasic[msg.natureInfo.mountinfo.Level]
        self.BaseExp = msg.natureInfo.mountinfo.Exp
        self.super:UpDateSkill(msg.natureInfo.haveActiveSkill) --设置技能
        self.super:UpDateModel(msg.natureInfo.haveActiveModel) --设置模型
        self.super:UpDataFashionInfos(msg.natureInfo.outlineInfo) --设置化形
        if self.BaseCfg then
            self:AnalysisAttr(self.BaseCfg.Attribute)
        end
        if self.Cfg then
            self.super:AnalysisAttr(self.Cfg.Attribute)
            self.super:AnalysisItem(self.Cfg.UpItem)
            self.super:Parase(msg.natureType,msg.natureInfo)
        end
        self.super:UpDateLevelHit(FunctionStartIdCode.MountLevel,self.IsMax,1)
        self.super:UpDateDrugHit(FunctionStartIdCode.MountDrug,NatureEnum.Mount)
        self.super:UpDateFashionHit(FunctionStartIdCode.MountFashion)
        self:UpDateEatItem()
    end
end

--更新基础属性升级
function NatureMountData:UpDateBaseAttr(msg)
    self.super.Fight = msg.fight
    self.BaseCfg = DataConfig.DataHorseBasic[msg.info.Level]
    self.BaseExp = msg.info.Exp
    if self.BaseCfg then
        self:AnalysisAttr(self.BaseCfg.Attribute)
    end
    self:UpDateEatItem()
end

--更新技能升级
function NatureMountData:UpDateUpLevel(msg)
    if msg.activeSkill ~= 0 then
        self.super:SetSkillActive(msg.activeSkill)
    end
    self.super.Level = msg.level
    self.Cfg = DataConfig.DataNatureHorse[msg.level]
    if self.Cfg then
        self.super:AnalysisAttr(self.Cfg.Attribute)
    end
    if msg.activeModel ~= 0 then
        self.super:SetModelActive(msg.activeModel)
    end
    self.super.CurExp = msg.curexp
    self.super.Fight = msg.fight
    self.super:UpDateLevelHit(FunctionStartIdCode.MountLevel,self.IsMax,1)
end

--更新吃果子信息
function NatureMountData:UpDateGrugInfo(msg)
    self.super.Fight = msg.fight
    self.super:UpDateDrug(msg,NatureEnum.Mount)
    self.super:UpDateDrugHit(FunctionStartIdCode.MountDrug,NatureEnum.Mount)
end

--更新设置模型ID
function NatureMountData:UpDateModelId(model)
    self.super.CurModel = model
end

--更新化形升级结果
function NatureMountData:UpDateFashionInfo(msg)
    self.super:UpDataFashion(msg)
    self.super:UpDateFashionHit(FunctionStartIdCode.MountFashion)
end

--货币更新
function NatureMountData:UpDateCoin(item)
    if self.super.ItemList then --道具
        local _isHave = self.super.ItemList:Find(
            function(code)
                return code.ItemID == item
            end
        )
        if _isHave then
            self.super:UpDateLevelHit(FunctionStartIdCode.NatureMagicLevel,self.IsMax,1)
        end
    end
end

--更新装备红点
function NatureMountData:UpDateEquipHit(itemDb,sender)
    if itemDb.Type == ItemType.Equip then
        self:UpDateEatItem()
    end
end

--道具来了，红点更新
function NatureMountData:UpDateHit(item,sender)
    if self.super.ItemList then --道具
        local _isHave = self.super.ItemList:Find(
            function(code)
                return code.ItemID == item
            end
        )
        if _isHave then
            self.super:UpDateLevelHit(FunctionStartIdCode.MountLevel,self.IsMax,1)
        end
    end
    if self.super.DrugList then --吃药
        local _isHave = self.super.DrugList:Find(
            function(code)
                return code.ItemId == item
            end
        ) 
        if _isHave then
            self.super:UpDateDrugHit(FunctionStartIdCode.MountDrug,NatureEnum.Mount)
        end
    end
    if self.super.FishionList then --化形
        local _isHave = self.super.FishionList:Find(
            function(code)
                return code.Item == item
            end
        )
        if _isHave then
            self.super:UpDateFashionHit(FunctionStartIdCode.MountFashion)
        end
    end
    if self.BaseItemList then
        local _isHave = self.BaseItemList:Find(
            function(code)
                return code.ItemID == item
            end
        )
        if _isHave then
            self:UpDateEatItem()
        end
    end
end

--功能函数！！！！！！！！！！！！！！！

--吃道具红点检测
function NatureMountData:UpDateEatItem()
    if not self.BaseCfg then
        return;
    end
    local _isReach = false
    local _ismax = self.BaseCfg.Id >= self.BaseIsMax
    local _count = #self.BaseItemList
    for i = 1,_count do
        if GameCenter.ItemContianerSystem:GetItemCountFromCfgId(self.BaseItemList[i].ItemID) >= 1 and not _ismax then
            _isReach = true
            GameCenter.RedPointSystem:AddFuncCondition(FunctionStartIdCode.MountEatEquip, NatureSubEnum.Begin, RedPointCustomCondition(true))
            break
        end
    end
    if not _isReach then
        local _list = GameCenter.EquipmentSystem:GetEquipCanEat()
        if _list.Count > 0 then 
            GameCenter.RedPointSystem:AddFuncCondition(FunctionStartIdCode.MountEatEquip, NatureSubEnum.Begin, RedPointCustomCondition(true))
        else
            GameCenter.RedPointSystem:RemoveFuncCondition(FunctionStartIdCode.MountEatEquip, NatureSubEnum.Begin)
        end
    end
end

--得到当前阶段中最大星数
function NatureMountData:GetCurMaxStar()
    if self.BaseStarDir:ContainsKey(self.Cfg.Steps) then
        return self.BaseStarDir[self.Cfg.Steps]
    end
    return 0
end

function NatureMountData:AnalysisAttr(str)
    self.BaseAttrList:Clear()
    if str then
        local _cs = {';','_'}
        local _attr = Utils.SplitStrByTableS(str,_cs)
        for i=1,#_attr do        
            local _data = BaseAttrData:New(_attr[i][1],_attr[i][2],_attr[i][3])
            self.BaseAttrList:Add(_data)
        end
    end
end

--得到道具经验
function NatureMountData:GetItemExp(itemid)
    local _isHave = self.BaseItemList:Find(
        function(code)
            return code.ItemID == itemid
        end
    )
    if _isHave then
        return _isHave.ItemExp
    end
    return 0
end

--可以吃的道具
function NatureMountData:AnalysisItem(str)
    self.BaseItemList:Clear()
    if str then
        local _attr = Utils.SplitStr(str,'_')
        for i=1,#_attr do
            local _itemid = tonumber(_attr[i])
            local _itemInfo = DataConfig.DataItem[_itemid]
            if _itemInfo then
                local _value = Utils.SplitStr(_itemInfo.EffectNum,'_')
                if _value[2] then
                    local _data = BaseItemData:New(_itemid,tonumber(_value[2]))
                    self.BaseItemList:Add(_data)
                end
            end
        end
    end
end

--是否满级了
function NatureMountData:IsMaxLevel()
    return self.IsMax <= self.super.Level
end

--基础是否满级了
function NatureMountData:IsBaseMaxLevel()
    return self.BaseIsMax <= self.BaseCfg.Id
end

--获取模型相机大小
function NatureMountData:Get3DUICamerSize(modelid)
    local _info = DataConfig.DataHuaxingHorse[modelid]
    if _info then
        return _info.CameraSize
    end
    return 1
end

return NatureMountData

