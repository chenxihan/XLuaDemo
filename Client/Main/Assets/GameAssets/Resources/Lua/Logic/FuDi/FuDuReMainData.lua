
------------------------------------------------
--作者： 王圣
--日期： 2019-05-13
--文件： FuDuReMainData.lua
--模块： FuDuReMainData
--描述： 福地剩余boss数据
------------------------------------------------
--引用
local FuDiSurvivalData = require "Logic.FuDi.FuDiSurvivalData"
local FuDuReMainData = {
    GuildId = 0,
    GuildName = 0,
    SurvivalList = List:New()
}

function FuDuReMainData:New(msg)
    local _m = Utils.DeepCopy(self)
    _m.GuildId = msg.guildId
    _m.GuildName = msg.name
    if msg.survival ~= nil then
        for i = 1,#msg.survival do
            local sv = FuDiSurvivalData:New(msg.survival[i])
            _m.SurvivalList:Add(sv)
        end
    end
    return _m
end

function FuDuReMainData:SetData(msg)
    self.GuildId = msg.guildId
    self.GuildName = msg.name
    if msg.survival ~= nil then
        for i = 1,#msg.survival do
            if i<=#self.SurvivalList then
                self.SurvivalList[i]:SetData(msg.survival[i])
            end
        end
    end
end
return FuDuReMainData