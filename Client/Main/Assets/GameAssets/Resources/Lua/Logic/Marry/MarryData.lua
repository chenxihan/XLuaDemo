------------------------------------------------
--作者： dhq
--日期： 2019-05-21
--文件： MarryData.lua
--模块： MarryData
--描述： 婚姻的数据类
------------------------------------------------
local PartnerMateInfo = require("Logic.Marry.PartnerMateInfo")
local IntimacyData = require("Logic.Marry.IntimacyData")
local TitleData = require("Logic.Marry.TitleData")
local HouseData = require("Logic.Marry.HouseData.HouseData")

local MarryData =
{
    --配偶ID（uint64）
    PartnerId = 0,
    --配偶名
    PartnerName = nil,
    --亲密度值
    IntimacyValue = 0,
    --结婚天数
    MarryDays = 0,
    --仙居阶数
    HouseDegree = 0,
    --仙居等级
    HouseLevel = 0,
    --今日剩余举办婚宴次数
    DayRemainHoldTimes = 0,
    --是否在举行婚宴
    HasWedding = nil,
    --今日剩余的祈福购买次数
    WishBuyCount = 0,
    --今日剩余的祈福次数
    WishCount = 0,
    --配偶外观信息
    PartnerMateInfo = nil,
    --配偶离线时间(0表示在线，否则表示其具体离线时间)，单位：秒s
    MateOffTime = 1,

    --配置表数据
    CostCfg = nil,
    DinnerCfg = nil,
    HouseCfg = nil,
    IntimacyCfg = nil,
    RingCfg = nil,
    TitleCfg = nil,
    --称号的数据
    TitleDataList = nil,
    --亲密度奖励的数据
    IntimacyDataList = nil,
    --仙居的数据
    HouseDataList = nil,
}

function MarryData:New()
    local _m = Utils.DeepCopy(self)
    self.PartnerMateInfo = PartnerMateInfo:New()
    self:LoadCfg()
    return _m
end

function MarryData:InitData()
    self.TitleDataList = List:New()
    self.IntimacyDataList = List:New()
    self.HouseDataList = List:New()

    --加载称号的配置，组装数据
    for _index = 1, #DataConfig.DataMarryTitle do
        local _cfg = DataConfig.DataMarryTitle[_index]
        local _data = TitleData:New(_cfg)
        self.TitleDataList:Add(_data)
    end
    self.TitleDataList:Sort(
        function(a, b)
            return a.CurPercent > b.CurPercent
        end
    )

    --加载亲密度奖励的配置，组装数据
    for _index = 1, #DataConfig.DataMarryIntimacy do
        local _cfg = DataConfig.DataMarryIntimacy[_index]
        local _data = IntimacyData:New(_cfg)
        self.IntimacyDataList:Add(_data)
    end

    --属性配置表
    local _attrCfg = DataConfig.DataAttributeAdd
    --加载仙居的配置，组装数据
    for _, _cfgItem in pairs(DataConfig.DataMarryHouse) do
        local _cfg = _cfgItem
        local _data = HouseData:New(_cfg, _attrCfg)
        self.HouseDataList:Add(_data)
    end
end

-- 加载配置表，赋值出来
function MarryData:LoadCfg()
    self.CostCfg = DataConfig.DataMarryCost
    self.DinnerCfg = DataConfig.DataMarryDinner
    self.HouseCfg = DataConfig.DataMarryHouse
    self.IntimacyCfg = DataConfig.DataMarryIntimacy
    self.RingCfg = DataConfig.DataMarryRing
    self.TitleCfg = DataConfig.DataMarryTitle
end

function MarryData:UpdateNetData(marryInfo)
    --配偶ID（uint64）
    if marryInfo.PartnerId ~= nil then
        self.PartnerId = marryInfo.PartnerId
    end
    --配偶名
    self.PartnerName = marryInfo.PartnerName
    --亲密度值
    self.IntimacyValue = marryInfo.IntimacyValue
    --结婚天数
    self.MarryDays = marryInfo.MarryDays
    --仙居阶数
    self.HouseDegree = marryInfo.HouseDegree
    --仙居等级
    self.HouseLevel = marryInfo.HouseLevel
    --今日剩余举办婚宴次数
    self.DayRemainHoldTimes = marryInfo.DayRemainHoldTimes
    --是否在举行婚宴
    self.HasWedding = marryInfo.HasWedding
    --今日剩余的祈福购买次数
    self.WishBuyCount = marryInfo.WishBuyCount
    --今日剩余的祈福次数
    self.WishCount = marryInfo.WishCount
    --配偶外观信息
    if marryInfo.PartnerMateInfo ~= nil then
        self.PartnerMateInfo = self.PartnerMateInfo:UpdateNetData(marryInfo.PartnerMateInfo)
    end
    --配偶离线时间(0表示在线，否则表示其具体离线时间)，单位：秒s
    self.MateOffTime = marryInfo.MateOffTime
    return self
end

return MarryData