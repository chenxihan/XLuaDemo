
------------------------------------------------
--作者： 王圣
--日期： 2019-05-15
--文件： FuDiBossShowData.lua
--模块： FuDiBossShowData
--描述： 福地boss展示数据
------------------------------------------------
--引用
local FuDiBossData = require "Logic.FuDi.FuDiBossData"
local FuDiBossShowData = {
    Score = 0,
    BossDataDic = Dictionary:New(),
}

function FuDiBossShowData:New(msg)
    local _m = Utils.DeepCopy(self)
    for k,v in pairs(DataConfig.DataGuildBattleBoss) do
        local list = nil
        local data = FuDiBossData:New(v)
        if _m.BossDataDic:ContainsKey(v.Group) then
            list = _m.BossDataDic[v.Group]
            list:Add(data)
        else
            list = List:New()
            list:Add(data)
            _m.BossDataDic:Add(v.Group,list)
        end
    end
    return _m
end

function FuDiBossShowData:SetData(msg)
    if msg.resurgenceTime ~= nil then
        for i = 1,#msg.resurgenceTime do
            local data = self:GetBossData(msg.resurgenceTime[i])
        end
    end
    for k,v in pairs(self.BossDataDic) do
        for i = 1,#v do
            if msg.attentionList ~=nil then
                for m = 1,#msg.attentionList do
                    if msg.attentionList[m] == v[i].Id then
                        v[i].IsAttention = true
                        break
                    else 
                        v[i].IsAttention = false
                    end
                end
            end
        end
    end
end
function FuDiBossShowData:GetBossData(data)
    local bossData = nil
    for k,v in pairs(self.BossDataDic) do
        for i = 1,#v do
            if v[i].Id == data.monsterModelId then
                bossData = v[i]
                bossData:SetData(data)
                return bossData
            end
        end
    end
    return bossData
end
function FuDiBossShowData:GetBossById(id)
    local bossData = nil
    for k,v in pairs(self.BossDataDic) do
        for i = 1,#v do
            if v[i].Id == id then
                bossData = v[i]
                return bossData
            end
        end
    end
    return bossData
end
--获取Boss数据by key  sort
function FuDiBossShowData:GetBossDataByType(key,sort)
    local data = nil
    if self.BossDataDic:ContainsKey(key) then
        local list = self.BossDataDic[key]
        if list ~= nil then
            for i  =1,#list do
                if list[i].Sort == sort then
                    data = list[i]
                    return data
                end
            end
        end
    end
    return data
end

function FuDiBossShowData:GetBossListByKey(key)
    local list = nil
    if self.BossDataDic:ContainsKey(key) then
        list = self.BossDataDic[key]
    end
    return list
end
return FuDiBossShowData