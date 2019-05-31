
------------------------------------------------
--作者： _SqL_
--日期： 2019-04-29
--文件： GodBookData.lua
--模块： GodBookData
--描述： 天书数据
------------------------------------------------
local AmuletData = require "Logic.GodBook.AmuletData"

local GodBookData = {
    ID = 0,                                     -- 对应DataAmulet表的ID
    Status = false,                             -- 符咒激活状态
    TaskList = List:New(),                      -- 符咒对应的 任务列表
}

function GodBookData:New(info)
    local _m = Utils.DeepCopy(self)
    _m:Init(info)
    _m:SortData()
    return _m
end

-- 初始化
function GodBookData:Init(info)
    self.ID = info.id
    self.Status = info.status
    if info.list ~= nil then
        self.TaskList:Clear()
        for i = 1, #info.list do
            self.TaskList:Add(AmuletData:New(info.list[i]))
        end
    end
end

-- 任务列表 排序 可领取 > 进行中 > 已领取
function GodBookData:SortData()
    table.sort( self.TaskList, function(a, b)
        if a.Status == b.Status then
            return a.TargetValue < b.TargetValue
        end
        return a.Status < b.Status
    end)
end

return GodBookData