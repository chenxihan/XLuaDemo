
------------------------------------------------
--作者： 王圣
--日期： 2019-05-18
--文件： FuDiDuoBaoDamage.lua
--模块： FuDiDuoBaoDamage
--描述： 福地夺宝副本伤害数据
------------------------------------------------
--引用
local FuDiDuoBaoDamage = {
    Rank = 0,
    Damage = 0,
    Name = nil,
}

function FuDiDuoBaoDamage:New()
    local _m = Utils.DeepCopy(self)
    return _m
end
return FuDiDuoBaoDamage