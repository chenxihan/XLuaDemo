
------------------------------------------------
--作者： 王圣
--日期： 2019-05-10
--文件： FuDiPersonRankData.lua
--模块： FuDiPersonRankData
--描述： 福地个人排行榜数据
------------------------------------------------
--引用
local FuDiPersonRankData = {
    --排名
    Rank = 0,
    --境界
    Vip = 0,
    --等级
    Level = 0,
    --战斗力
    FightPoint = 0,
    --名字
    Name = nil,
}

function FuDiPersonRankData:New(msg)
    local _m = Utils.DeepCopy(self)
    _m.Rank = msg.rank
    _m.Vip = msg.realm
    _m.Level = msg.level
    _m.FightPoint = msg.fight
    _m.Name = msg.name
    return _m
end
return FuDiPersonRankData