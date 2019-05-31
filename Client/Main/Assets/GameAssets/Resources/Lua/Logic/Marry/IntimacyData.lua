------------------------------------------------
--作者： dhq
--日期： 2019-05-13
--文件： IntimacyData.lua
--模块： IntimacyData
--描述： 结婚亲密度奖励的数据类
------------------------------------------------
local IntimacyData =
{
    --当前亲密度
    Intimate = nil,
    --达成需要的亲密度
    IntimateAll = nil,
    --当前结婚天数
    DaysCur = nil,
    --达成条件需要的天数
    DaysAll = nil,
    --奖励
    Award = nil,
    --状态
    Status = nil,
}

function IntimacyData:New(cfg)
    local _m = Utils.DeepCopy(self)
    local _cfg = cfg
    _m.Intimate = GameCenter.MarrySystem.MarryData.IntimacyValue
    _m.IntimateAll = _cfg.Intimacy
    _m.DaysCur = GameCenter.MarrySystem.MarryData.MarryDays
    _m.DaysAll = _cfg.Time
    _m.Award = _cfg.Reward
    if _m.Intimate >= _m.IntimateAll and _m.DaysCur >= _m.DaysAll then
        _m.Status = GameCenter.MarrySystem.IntimacyState.Receiving
    else
        _m.Status = GameCenter.MarrySystem.IntimacyState.UnReceive
    end
    return _m
end

return IntimacyData