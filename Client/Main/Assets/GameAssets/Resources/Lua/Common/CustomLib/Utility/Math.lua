------------------------------------------------
--作者： xihan
--日期： 2019-05-06
--文件： Math.lua
--模块： 无
--描述： 数学
------------------------------------------------

---------------------[lua自带的]-----------------
-- math.maxinteger 最大值 9223372036854775807
-- math.mininteger 最小值 -9223372036854775808
-- math.huge 无穷大	inf
-- math.tointeger 转整数
-- math.pi	圆周率	math.pi	3.1415926535898
-- math.abs	取绝对值	math.abs(-2012)	2012
-- math.ceil	向上取整	math.ceil(9.1)	10
-- math.floor	向下取整	math.floor(9.9)	9
-- math.max	取参数最大值	math.max(2,4,6,8)	8
-- math.min	取参数最小值	math.min(2,4,6,8)	2
-- math.sqrt	开平方	math.sqrt(65536)	256.0
-- math.modf	取整数和小数部分	math.modf(20.12)	20   0.12
-- math.randomseed	设随机数种子	math.randomseed(os.time())
-- math.random	取随机数	math.random(5,90)	5~90
-- math.rad	角度转弧度	math.rad(180)	3.1415926535898
-- math.deg	弧度转角度	math.deg(math.pi)	180.0
-- math.exp	e的x次方	math.exp(4)	54.598150033144
-- math.log	计算x的自然对数	math.log(54.598150033144)	4.0
-- math.sin	正弦	math.sin(math.rad(30))	0.5
-- math.cos	余弦	math.cos(math.rad(60))	0.5
-- math.tan	正切	math.tan(math.rad(45))	1.0
-- math.asin	反正弦	math.deg(math.asin(0.5))	30.0
-- math.acos	反余弦	math.deg(math.acos(0.5))	60.0
-- math.atan	反正切	math.deg(math.atan(1))	45.0
-- math.type 获取类型是integer还是float
-- math.fmod 取模 math.fmod(65535,2)	1
------------------------------------------------

local L_Floor = math.floor
local L_Abs = math.abs

--角度转弧度
math.Deg2Rad = math.pi / 180
--弧度转角度
math.Rad2Deg = 180 / math.pi
--机械极小值
math.Epsilon = 1.401298e-45

--value的p次幂
function math.Pow(value, p)
	return value^p;
end

--大约（小数第一位四舍五入）
function math.Round(num)
	return L_Floor(num + 0.5)
end

--函数返回一个数字的符号, 指示数字是正数,负数还是零
function math.Sign(num)
	if num > 0 then
		num = 1
	elseif num < 0 then
		num = -1
	else
		num = 0
	end
	return num
end

--限制value的值在min和max之间, 如果value小于min,返回min，如果value大于于max,返回max
function math.Clamp(num, min, max)
	if num < min then
		num = min
	elseif num > max then
		num = max
	end
	return num
end

local Clamp = math.Clamp

--线性插值
function math.Lerp(from, to, t)
	return from + (to - from) * Clamp(t, 0, 1)
end

--非限制线性插值
function math.LerpUnclamped(a, b, t)
    return a + (b - a) * t;
end

--重复
function math.Repeat(t, length)
	return t - (L_Floor(t / length) * length)
end

--插值角度
function math.LerpAngle(a, b, t)
	local _num = math.Repeat(b - a, 360)

	if _num > 180 then
		_num = _num - 360
	end
	return a + _num * Clamp(t, 0, 1)
end

--移向
function math.MoveTowards(current, target, maxDelta)
	if L_Abs(target - current) <= maxDelta then
		return target
	end
	return current + math.Sign(target - current) * maxDelta
end

--增量角
function math.DeltaAngle(current, target)
	local _num = math.Repeat(target - current, 360)

	if _num > 180 then
		_num = _num - 360
	end
	return _num
end

--移动角
function math.MoveTowardsAngle(current, target, maxDelta)
	target = current + math.DeltaAngle(current, target)
	return math.MoveTowards(current, target, maxDelta)
end

--近似
function math.Approximately(a, b)
	return L_Abs(b - a) < math.max(1e-6 * math.max(L_Abs(a), L_Abs(b)), 1.121039e-44)
end

--反插值
function math.InverseLerp(from, to, value)
	if from < to then
		if value < from then
			return 0
		end
		if value > to then
			return 1
		end

		value = value - from
		value = value/(to - from)
		return value
	end
	if from <= to then
		return 0
	end
	if value < to then
		return 1
	end
	if value > from then
        return 0
	end
	return 1.0 - ((value - to) / (from - to))
end

--乒乓
function math.PingPong(t, length)
    t = math.Repeat(t, length * 2)
    return length - L_Abs(t - length)
end

--获取随机数
function math.Random(n, m)
	math.randomseed(os.time())
	local _range = m - n
	return math.random() * _range + n
end

--是否是非数字值
function math.IsNan(number)
	return not (number == number)
end

--伽玛函数
function math.Gamma(value, absmax, gamma)
	local _flag = false
    if value < 0 then
        _flag = true
    end
    local _num = L_Abs(value)
    if _num > absmax then
        return (not _flag) and _num or -_num
    end
    local _num2 = (_num / absmax )^ gamma * absmax
    return (not _flag) and _num2 or -_num2
end

--平滑阻尼
function math.SmoothDamp(current, target, currentVelocity, smoothTime, maxSpeed, deltaTime)
	maxSpeed = maxSpeed or math.huge
	deltaTime = deltaTime or Time.deltaTime
    smoothTime = math.max(0.0001, smoothTime)
    local _num = 2 / smoothTime
    local _num2 = _num * deltaTime
    local _num3 = 1 / (1 + _num2 + 0.48 * _num2 * _num2 + 0.235 * _num2 * _num2 * _num2)
    local _num4 = current - target
    local _num5 = target
    local max = maxSpeed * smoothTime
    _num4 = Clamp(_num4, -max, max)
    target = current - _num4
    local _num7 = (currentVelocity + (_num * _num4)) * deltaTime
    currentVelocity = (currentVelocity - _num * _num7) * _num3
    local _num8 = target + (_num4 + _num7) * _num3
    if (_num5 > current) == (_num8 > _num5)  then
        _num8 = _num5
        currentVelocity = (_num8 - _num5) / deltaTime
    end
    return _num8,currentVelocity
end

--平滑阻尼角度
function math.SmoothDampAngle(current, target, currentVelocity, smoothTime, maxSpeed, deltaTime)
	deltaTime = deltaTime or Time.deltaTime
	maxSpeed = maxSpeed or math.huge
	target = current + math.DeltaAngle(current, target)
    return math.SmoothDamp(current, target, currentVelocity, smoothTime, maxSpeed, deltaTime)
end

--平滑插值
function math.SmoothStep(from, to, t)
    t = Clamp(t, 0, 1)
    t = -2 * t * t * t + 3 * t * t
    return to * t + from * (1 - t)
end

--水平角
function math.HorizontalAngle(dir)
	return math.deg(math.atan(dir.x, dir.z))
end

--伽马转线性
function math.GammaToLinearSpaceExact(value)
    if value <= 0.04045 then
        return value / 12.92;
    elseif value < 1.0 then
        return math.Pow((value + 0.055)/1.055, 2.4);
    else
        return math.Pow(value, 2.2);
    end
end

--线性转伽马
function math.LinearToGammaSpaceExact(value)
    if value <= 0.0 then
         return 0.0;
    elseif value <= 0.0031308 then
        return 12.92 * value;
    elseif value < 1.0 then
        return 1.055 * math.Pow(value, 0.4166667) - 0.055;
    else
       return math.Pow(value, 0.45454545);
    end
end

--将数字转为整数或者小数。如72.0返回72；  72.5返回72.5	支持负数
function math.FormatNumber(value)
    local t1, t2 = math.modf(value)
	if t2 == 0 then
		--小数部分如果等于0，则返回整数部分
        return t1
	else
		--小数部分如果大于0，则直接返回
        return value
    end
end