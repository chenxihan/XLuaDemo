------------------------------------------------
--作者： dhq
--日期： 2019-05-23
--文件： HouseData.lua
--模块： HouseData
--描述： 仙居的数据类
------------------------------------------------
local FightUtils = require "Logic.Base.FightUtils.FightUtils"
local UpgradeData = require "Logic.Marry.HouseData.UpgradeData"

local HouseData = {}

function HouseData:New(cfg, attrCfg)
    local _m = Utils.DeepCopy(self)
    local _cfg = cfg
    local _attrCfg = attrCfg
    --阶数
    _m.Degree = _cfg.Quality
    --等级
    _m.Level = _cfg.Level
    if _cfg.Type ~= nil then
        if _cfg.Type == GameCenter.MarrySystem.HouseDataTypeEnum.Upgrade then
            --升级的数据
            _m.UpgradeData = UpgradeData:New(_cfg, _attrCfg)
        elseif _cfg.Type == GameCenter.MarrySystem.HouseDataTypeEnum.Overfulfil then
            --_m.OverfulfilData = OverfulfilData:New(_cfg, _attrCfg)
            _m.OverfulfilData = UpgradeData:New(_cfg, _attrCfg)
        else
            --_m.PreviewData = PreviewData:New(_cfg, _attrCfg)
            _m.PreviewData = UpgradeData:New(_cfg, _attrCfg)
        end
    end
    return _m
end

return HouseData