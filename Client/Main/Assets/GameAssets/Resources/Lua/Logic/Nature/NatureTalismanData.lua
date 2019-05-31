--作者： xc
--日期： 2019-04-25
--文件： NatureTalismanData.lua
--模块： NatureTalismanData
--描述： 法器数据系统子类继承NatureBaseData
------------------------------------------------
local NatureBase = require "Logic.Nature.NatureBaseData"
local SkillSetDate = require "Logic.Nature.NatureSkillSetData"
local ModelData= require "Logic.Nature.NatureBaseModelData"
local FashionData = require "Logic.Nature.NatureFashionData"
local RedPointCustomCondition = CS.Funcell.Code.Logic.RedPointCustomCondition

local NatureTalismanData = {
    Cfg = nil , --法器配置表数据
    IsMax = 0, --法器最大等级
    super = nil, --父类对象
}

function NatureTalismanData:New()
    local _obj = NatureBase:New()
    local _M = Utils.DeepCopy(self)
    _M.super = _obj
    return _M
end

--初始化技能
function NatureTalismanData:Initialize()
    for k, v in pairs(DataConfig.DataNatureTalisman) do
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
    for k, v in pairs(DataConfig.DataHuaxingTalisman) do
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
function NatureTalismanData:UnInitialize()
    self.Cfg = nil
    self.super = nil
    self.IsMax = 0
    GameCenter.UnRegFixEventHandle(LogicEventDefine.EVENT_ITEM_CHANGE_UPDATE, self.HitEvent)
    GameCenter.UnRegFixEventHandle(LogicEventDefine.EVENT_COIN_CHANGE_UPDATE, self.CoinEvent)
end

--初始化服务器数据
function NatureTalismanData:InitWingInfo(msg)
    if msg and msg.natureInfo then
        self.Cfg = DataConfig.DataNatureTalisman[msg.natureInfo.curLevel]
        self.super:UpDateSkill(msg.natureInfo.haveActiveSkill) --设置技能
        self.super:UpDateModel(msg.natureInfo.haveActiveModel) --设置模型
        self.super:UpDataFashionInfos(msg.natureInfo.outlineInfo) --设置化形
        if self.Cfg then
            self.super:AnalysisAttr(self.Cfg.Attribute)
            self.super:AnalysisItem(self.Cfg.UpItem)
            self.super:Parase(msg.natureType,msg.natureInfo)
        end
        self.super:UpDateLevelHit(FunctionStartIdCode.NatureTalismanLevel,self.IsMax,1)
        self.super:UpDateDrugHit(FunctionStartIdCode.NatureTalismanDrug,NatureEnum.Talisman)
        self.super:UpDateFashionHit(FunctionStartIdCode.NatureTalismanFashion)
    end
end

--更新技能升级
function NatureTalismanData:UpDateUpLevel(msg)
    if msg.activeSkill ~= 0 then
        self.super:SetSkillActive(msg.activeSkill)
    end
    self.super.Level = msg.level
    self.Cfg = DataConfig.DataNatureTalisman[msg.level]
    if self.Cfg then
        self.super:AnalysisAttr(self.Cfg.Attribute)
    end
    if msg.activeModel ~= 0 then
        self.super:SetModelActive(msg.activeModel)
    end
    self.super.CurExp = msg.curexp
    self.super.Fight = msg.fight
    self.super:UpDateLevelHit(FunctionStartIdCode.NatureTalismanLevel,self.IsMax,1)
end

--更新吃果子信息
function NatureTalismanData:UpDateGrugInfo(msg)
    self.super.Fight = msg.fight
    self.super:UpDateDrug(msg,NatureEnum.Talisman)
    self.super:UpDateDrugHit(FunctionStartIdCode.NatureTalismanDrug,NatureEnum.Talisman)
end

--更新设置模型ID
function NatureTalismanData:UpDateModelId(model)
    self.super.CurModel = model
end

--更新化形升级结果
function NatureTalismanData:UpDateFashionInfo(msg)
    self.super:UpDataFashion(msg)
    self.super:UpDateFashionHit(FunctionStartIdCode.NatureTalismanFashion)
end

--货币更新
function NatureTalismanData:UpDateCoin(item)
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

--道具来了，红点更新
function NatureTalismanData:UpDateHit(item,sender)
    if self.super.ItemList then --道具
        local _isHave = self.super.ItemList:Find(
            function(code)
                return code.ItemID == item
            end
        ) 
        if _isHave then
            self.super:UpDateLevelHit(FunctionStartIdCode.NatureTalismanLevel,self.IsMax,1)
        end
    end
    if self.super.DrugList then --吃药
        local _isHave = self.super.DrugList:Find(
            function(code)
                return code.ItemId == item
            end
        ) 
        if _isHave then
            self.super:UpDateDrugHit(FunctionStartIdCode.NatureTalismanDrug,NatureEnum.Talisman)
        end
    end
    if self.super.FishionList then --化形
        local _isHave = self.super.FishionList:Find(
            function(code)
                return code.Item == item
            end
        ) 
        if _isHave then
            self.super:UpDateFashionHit(FunctionStartIdCode.NatureTalismanFashion)
        end
    end
end

--功能函数！！！！！！！！！！！！！！！

--法器是否满级了
function NatureTalismanData:IsMaxLevel()
    return self.IsMax <= self.super.Level
end

--获取模型相机大小
function NatureTalismanData:Get3DUICamerSize(modelid)
    local _info = DataConfig.DataHuaxingTalisman[modelid]
    if _info then
        return _info.CameraSize
    end
    return 1
end

return NatureTalismanData

