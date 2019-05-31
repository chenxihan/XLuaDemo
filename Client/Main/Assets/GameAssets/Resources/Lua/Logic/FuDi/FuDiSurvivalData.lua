
------------------------------------------------
--作者： 王圣
--日期： 2019-05-13
--文件： FuDiSurvivalData.lua
--模块： FuDiSurvivalData
--描述： 福地Boss数据
------------------------------------------------
--引用
local FuDiSurvivalData = {
    MonsterType = 0,
    Count = 0,
}

function FuDiSurvivalData:New(msg)
    local _m = Utils.DeepCopy(self)
    _m.MonsterType = msg.type
    _m.Count = msg.num
    return _m
end

function FuDiSurvivalData:SetData(msg)
    self.MonsterType = msg.type
    self.Count = msg.num
end
return FuDiSurvivalData