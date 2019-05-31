
------------------------------------------------
--作者： _SqL_
--日期： 2019-04-22
--文件： DailyActivityData.lua
--模块： DailyActivityData
--描述： 日常数据
------------------------------------------------

local DailyActivityData = {
    -- 活动ID
    ID = 0,
    -- 活动开启
    Open = false,
    -- 活动关闭
    Hide = false,
    -- 当前活跃值
    CurrActive =0,
    -- 当前完成次数
    Count = 0,
    -- 可获取的最大活跃度
    TotalActive =0,
    -- 可参加活动的总次数   
    TotalCount =0,
    -- 活动是否完成
    Complete = false,
    -- 奖励列表
    RewardList = List:New()
}

function DailyActivityData:New(id)
    local _M = Utils.DeepCopy(self)
    local _cfg = DataConfig.DataDaily[id]
    if _cfg ~= nil then
        _M.ID = id
        _M.TotalActive = _cfg.MaxValue
        _M.TotalCount = _cfg.Times
        _M.RewardList = Utils.SplitStr(_cfg.Reward, ";")
    end
    return _M
end

return DailyActivityData