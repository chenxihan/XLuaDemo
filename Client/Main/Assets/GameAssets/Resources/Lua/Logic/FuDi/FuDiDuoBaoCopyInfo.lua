
------------------------------------------------
--作者： 王圣
--日期： 2019-05-18
--文件： FuDiDuoBaoCopyInfo.lua
--模块： FuDiDuoBaoCopyInfo
--描述： 福地夺宝副本Info
------------------------------------------------
--引用
local FuDiDuoBaoDamage = require "Logic.FuDi.FuDiDuoBaoDamage"
local FuDiDuoBaoCopyInfo = {
    --波数
    Degree = 0,
    MaxCount = 0,
    --剩余怪物数量
    ReMain = 0,
    --我的排名
    MyRank = 0,
    --我的伤害
    MyDamage = 0,
    DamageList = List:New(),
}
function FuDiDuoBaoCopyInfo:New()
    local _m = Utils.DeepCopy(self)
    return _m
end

function FuDiDuoBaoCopyInfo:SetData(msg)
    self.Degree = msg.degree
    self.ReMain = msg.monsterRemain
    self.MaxCount = msg.maxDegree
end
function FuDiDuoBaoCopyInfo:SetDamage(msg)
    for i = 1,#msg.rank do
        local data = nil
        if i>#self.DamageList then
            data = FuDiDuoBaoDamage:New()
            self.DamageList:Add(data)
        else
            data = self.DamageList[i]
        end
        data.Rank = msg.rank[i].top
        data.Damage = msg.rank[i].harm
        data.Name = msg.rank[i].name
    end
    self.MyRank = msg.myRank
    self.MyDamage = msg.myHarm
end
return FuDiDuoBaoCopyInfo