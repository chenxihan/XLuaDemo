
------------------------------------------------
--作者： _SqL_
--日期： 2019-05-16
--文件： RealmTaskData.lua
--模块： RealmTaskData
--描述： 境界任务数据
------------------------------------------------
local RealmTaskData = {
    ID = 0,
    Progress = 0,                           -- 任务进度
    TargetValue = 0,                        -- 任务目标值
    TaskName = nil,                         -- 任务名字
    RewardIconShow = nil,                   -- 奖励展示
    Status = nil,                           -- 领取状态
    Sort = nil,                             -- 排序使用
}

function RealmTaskData:New(info)
    local _m = Utils.DeepCopy(self)
    _m:RefreshData(info)
    return _m
end

-- 刷新数据
function RealmTaskData:RefreshData(info)
    self.ID = info.id
    self.Progress = info.progress
    self.Status = info.status
    local _stateCfg = DataConfig.DataState[info.id]
    if _stateCfg then
        local _strs = Utils.SplitStr(_stateCfg.Condition,"_")
        self.TargetValue = tonumber(_strs[#_strs])
        self.TaskName = UIUtils.CSFormat(_stateCfg.Des,self.TargetValue)
    else
        Debug.LogError("DataState not contains key = ", info.id)
    end
    if self.Status then
        self.Sort = 3
    else
        if self.Progress >= self.TargetValue then
            self.Progress = self.TargetValue
            self.Sort = 1
        else
            self.Sort = 2
        end
    end
end

return RealmTaskData