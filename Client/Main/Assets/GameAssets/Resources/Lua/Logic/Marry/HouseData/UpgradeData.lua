------------------------------------------------
--作者： dhq
--日期： 2019-05-27
--文件： UpgradeData.lua
--模块： UpgradeData
--描述： 仙居升级的数据类
------------------------------------------------
local FightUtils = require "Logic.Base.FightUtils.FightUtils"

local UpgradeData = {}

function UpgradeData:New(cfg, attrCfg)
    if cfg == nil or attrCfg == nil then
        return nil
    end
    local _cfg = cfg
    local _attrCfg = attrCfg
    local _m = Utils.DeepCopy(self)
    _m.ID = _cfg.Id
    --当前阶数
    _m.Degree = _cfg.Quality
    --当前等级
    _m.Level = _cfg.Level
    --名字
    _m.Name = _cfg.Name
    --加成的属性
    _m.Attributes = _cfg.Attributes
    --升级需要消耗的物品
    _m.UpNeedItem = _cfg.UpNeedItem
    --升级需要的经验
    _m.UpExp = _cfg.UpExp
    --战斗力计算的字典
    local _fightPowerDict = Dictionary:New()
    --属性名字和值
    _m.AttrDict = Dictionary:New()
    local _attrs = Utils.SplitStr(_m.Attributes, ';')
    for i = 1, #_attrs do
        local _strs = Utils.SplitStr(_attrs[i], '_')
        if #_strs >= 1 then
            --属性
            local _prop = tonumber(_strs[1])
            --属性的值
            local _num = tonumber(_strs[2])
            _fightPowerDict:Add(_prop, _num)
            --属性的名字
            if _prop == 0 then
                _prop = 5
            end
            local _attrName = _attrCfg[tonumber(_prop)].Name
            _m.AttrDict:Add(_attrName, _num)
        end
    end
    --属性的战斗力
    _m.FightPower = FightUtils.GetPropetryPower(_fightPowerDict)
    return _m
end

return UpgradeData