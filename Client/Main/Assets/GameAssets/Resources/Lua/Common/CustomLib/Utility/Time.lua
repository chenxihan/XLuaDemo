------------------------------------------------
--作者： 杨全福
--日期： 2019-05-8
--文件： Time.lua
--模块： Time
--描述： 时间相关函数
------------------------------------------------
--local socket = require "socket";
local TimeUtils = CS.Funcell.Core.Base.TimeUtils;

--程序启动到现在的时间
local lRealtimeSinceStartup = 0.0;
--当前帧消耗的时间
local lDeltaTime = 0.0;
local lIsInit = false;

local Time = {};

--只在main.lua初始化的时候调用，其他地方不允许调用
function Time.Start(startTime)
    if lIsInit ~= false then
        return;
    end
    lRealtimeSinceStartup = startTime;
    lIsInit = true;
end

--只在main.lua update的时候调用，其他地方不允许调用
function Time.SetDeltaTime(deltaTime)
    lRealtimeSinceStartup = lRealtimeSinceStartup + deltaTime;
    lDeltaTime = deltaTime;
end

--获取程序启动到现在的时间
function Time.GetRealtimeSinceStartup()
    return lRealtimeSinceStartup;
end

--获取单帧消耗的时间
function Time.GetDeltaTime()
    return lDeltaTime;
end

--引用CS中TimeUtils类的函数StampToDateTime,把秒转换为以1970-1-1为基础的日期
function Time.StampToDateTime(timeStamp,format)
    return TimeUtils.StampToDateTime(timeStamp,format);
end
--引用CS中TimeUtils类的函数SplitTime,把秒数据切割为天,时,分,秒
function Time.SplitTime(timeData)
    local d,h,m,s = TimeUtils.SplitTime(timeData);
    return d,h,m,s;
end
--引用CS中TimeUtils类的函数FormatTimeHHMMSS,格式化时间,小时分钟秒
function Time.FormatTimeHHMMSS(seconds)
    return TimeUtils.FormatTimeHHMMSS(seconds)
end

-- 时间格式化 返回时分秒
function Time.FormatTimeHMS(interval, useChinese)
    if not interval and not useChinese then
        return os.date("%X")
    elseif interval and not useChinese then
        return os.date("%X", interval + 57600)
    elseif not interval and useChinese then
        return os.date("%H时%M分%S秒")
    elseif interval and useChinese then
        return os.date("%H时%M分%S秒", interval + 57600)
    end
end

return Time;