
------------------------------------------------
--作者： 王圣
--日期： 2019-05-13
--文件： FuDiPreviewData.lua
--模块： FuDiPreviewData
--描述： 福地预览数据
------------------------------------------------
--引用
local FuDuReMainData = require "Logic.FuDi.FuDuReMainData"
local FuDiPreviewData = {
    --本日宗派积分
    CurScore = 0,
    ReceivedList = List:New(),
    ReMainList = List:New(),
}

function FuDiPreviewData:New(msg)
    local _m = Utils.DeepCopy(self)
    _m.CurScore = msg.score
    _m.ReceivedList:Clear()
    if msg.rewards ~= nil then
        for i = 1, #msg.rewards do
            _m.ReceivedList:Add(msg.rewards[i])
        end
    end
    if msg.remain ~= nil then
        for i = 1,#msg.remain do
            local reMain = FuDuReMainData:New(msg.remain[i])
            _m.ReMainList:Add(reMain)
        end
    end
    return _m
end

function FuDiPreviewData:SetData(msg)
    self.CurScore = msg.score
    self.ReceivedList:Clear()
    if msg.rewards ~= nil then
        for i = 1,#msg.rewards do
            self.ReceivedList:Add(msg.rewards[i])
        end
    end
    if msg.remain then
        for i = 1,#msg.remain do
            if i<= #self.ReMainList then
                self.ReMainList[i]:SetData(msg.remain[i])
            end
        end
    end
end
return FuDiPreviewData