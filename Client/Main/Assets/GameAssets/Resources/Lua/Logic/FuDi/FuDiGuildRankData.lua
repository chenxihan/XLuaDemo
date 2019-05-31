
------------------------------------------------
--作者： 王圣
--日期： 2019-05-10
--文件： FuDiRankData.lua
--模块： FuDiRankData
--描述： 福地排行榜数据
------------------------------------------------
--引用
local PersonData = require "Logic.FuDi.FuDiPersonRankData"
local FuDiGuildRankData = {
    GuildId = 0,
    MyRank = -1,
    GuildName = nil,
    PersonList = List:New()
}

function FuDiGuildRankData:New(msg)
    local _m = Utils.DeepCopy(self)
    _m.GuildId = msg.guildId
    if msg.myRank == nil then
        _m.MyRank = -1
    else
        _m.MyRank = msg.myRank
    end
    _m.GuildName = msg.name
    for i = 1,#msg.menberRank do
        local rankInfo = PersonData:New(msg.menberRank[i])
        _m.PersonList:Add(rankInfo)
    end
    return _m
end
return FuDiGuildRankData