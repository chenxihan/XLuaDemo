
------------------------------------------------
--作者： _SqL_
--日期： 2019-04-29
--文件： AmuletData.lua
--模块： AmuletData
--描述： 符咒数据
------------------------------------------------
local AmuletData = {
    ID = 0,                         -- 对应DataAmuletCondition表的ID
    Progress = 0,                   -- 任务完成进度
    Status = 0,                     -- 状态 1可领取 2不可领取 3已领取
    TargetValue = 0,                -- 任务目标值
}

function AmuletData:New(info)
    local _m = Utils.DeepCopy(self)
    _m.ID = info.id
    _m:RefreshData(info)
    _m:SetTargetValue()
    return _m
end

-- 刷新数据
function AmuletData:RefreshData(info)
    if info.Status == AmuletTaskStatusEnum.RECEIVED then
        self.Status = AmuletTaskStatusEnum.RECEIVED
        self.Progress = self.TargetValue
    else
        self.Status = info.status
        self.Progress = info.progress
    end
end

-- 设置任务目标值
function AmuletData:SetTargetValue()
    local _strs = Utils.SplitStr(DataConfig.DataAmuletCondition[self.ID].Accomplishments,";")
    for i = 1, #_strs do
        local _s = Utils.SplitStr(_strs[i],"_")
        local _value = tonumber(_s[#_s])
        if _value then
            self.TargetValue = self.TargetValue + _value
        end
    end
end

return AmuletData