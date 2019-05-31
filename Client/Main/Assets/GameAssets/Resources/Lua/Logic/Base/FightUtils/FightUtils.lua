------------------------------------------------
--作者： 何健
--日期： 2019-05-13
--文件： FightUtils.lua
--模块： FightUtils
--描述： 战斗力计算通用工具
------------------------------------------------

local FightUtils = {}
function FightUtils.GetPropetryPower(table)
    local _power = 0
    for k, v in pairs(table) do
        local _param = 0.0
        local _item = DataConfig.DataAttributeAdd[k]
        if _item ~= nil then
            _param = _item.Variable
        end
        _power = _power + v * (_param / 10000)
    end
    return _power
end
return FightUtils