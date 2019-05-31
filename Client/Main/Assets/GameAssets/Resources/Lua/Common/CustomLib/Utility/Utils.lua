------------------------------------------------
--作者： gzg
--日期： 2019-03-25
--文件： Utils.lua
--模块： Utils
--描述： 定义一些公共功能函数
------------------------------------------------

local Vector3 = require("Common.CustomLib.Utility.Vector3")
local Vector4 = require("Common.CustomLib.Utility.Vector4")
local Quaternion = require("Common.CustomLib.Utility.Quaternion")
local Color = require("Common.CustomLib.Utility.Color")
local UIUtility = CS.Funcell.Plugins.Common.UIUtility

local Utils = {}

local L_Rad2Deg = math.Rad2Deg;
local L_Deg2Rad = math.Deg2Rad;
local L_Clamp = math.Clamp;
local L_Acos = math.acos;
local L_Asin = math.asin;
local L_Sqrt = math.sqrt;
local L_Max = math.max;
local L_Min = math.min;
local L_Sin = math.sin;
local L_HalfDegToRad = 0.5 * L_Deg2Rad
local L_OverSqrt2 = 0.7071067811865475244008443621048490
local L_DeanfengLevel = 370

--获取巅峰等级
function Utils.GetDfLevel(level)
    if level > L_DeanfengLevel then
        return level - L_DeanfengLevel, true
    end
    return level, false
end

-- 移除require的lua脚本
function Utils.RemoveRequiredByName(preName)
    for key, _ in pairs(package.preload) do
        if string.find(tostring(key), preName) == 1 then
            package.preload[key] = nil
        end
    end
    for key, _ in pairs(package.loaded) do
        if string.find(tostring(key), preName) == 1 then
            package.loaded[key] = nil
        end
    end
end

-- obj通常传self, data通常为table
function Utils.Handler(func, obj, data, isNotPrintErr)
    if not func then
        if not isNotPrintErr then
            Debug.LogError("function is empty")
        end
        return nil
    end
    return function (...)
        if data then
            return func(obj, data, ...)
        else
            return func(obj, ...)
        end
    end
end

-- 取得table的数据长度
function Utils.GetTableLens(tab)
    local _count = 0
    if type(tab) == "table" then
        for _, _ in pairs(tab) do
            _count = _count + 1
        end
    end
    return _count
end



-- 深度拷贝数据
function Utils.DeepCopy(object)
    local _lookup_table = {}

    local function _copy(obj)
        --如果不是table,那么直接返回
        if type(obj) ~= "table" then
            return obj
        elseif _lookup_table[obj] then
            --如果已经复制过来,那么就返回.
            return _lookup_table[obj]
        end
        --创建一个新的table,复制过去.
        local _new_table = {}
        _lookup_table[obj] = _new_table
        for index, value in pairs(obj) do
            _new_table[_copy(index)] = _copy(value)
        end
        local ret = setmetatable(_new_table, getmetatable(obj));
        --当一个表复制完毕后,才会调用方法_OnCopyAfter_,用于处理某些需要特殊处理的table
        if ret._OnCopyAfter_ then ret:_OnCopyAfter_() end
        return ret;
    end
    return _copy(object)
end

--通过枚举获得字符串或者具体值
function Utils.GetEnumNumberAndString(str)
    local _num = {}
    local b = Utils.SplitStr(str,':')
    _num[1] = b[1]
    _num[2] = tonumber(b[2])
    return _num
end

--通过枚举获得number
function Utils.GetEnumNumber(str)
    return Utils.GetEnumNumberAndString(str)[2]
end

--通过枚举获得string
function Utils.GetEnumString(str)
    return Utils.GetEnumNumberAndString(str)[1]
end

-- 切割字符串(sep为nil时，根据空格拆分)
function Utils.SplitStr(str, sep)
    if sep == nil then
        sep = "%s"
    end
    local _ret = List:New()
    for v in string.gmatch(str, "([^" .. sep .. "]+)") do
        _ret:Add(v)
    end
    return _ret
end

-- 切割字符串
function Utils.SplitStrByTable(str, sepTable)
    local _ret = List:New()
    if type(sepTable) ~= "table" then
        Debug.LogError("sepTable is not a table")
        return _ret
    end

    local _ret = Utils.SplitStr(str, sepTable[1])

    if #sepTable > 1 then
        for i=2, #sepTable do
            local _temp = List:New()
            for j=1, #_ret do
                local _temp2 = Utils.SplitStr(_ret[j], sepTable[i])
                for k=1, #_temp2 do
                    _temp:Add(_temp2[k])
                end
            end
            _ret = _temp
        end
    end
    return _ret
end

--切割字符串多维数组切割按字符串反着查找的，string里面是数字。方便使用。如果要返回字符串别用这个
function Utils.SplitStrByTableS(str, sep)
    --设置默认值
    sep = sep or {';', '_'}
	if type(sep) ~= "table" then
		Debug.LogError("sepTable is not a table")
		return {}
	end
	if #sep == 0 then
		return {}
	end
    local _ret = {};
    if #sep == 1 then
        _ret[1] = Utils.SplitStr(str, sep[1])
        return _ret
    end
    local i = 0;
    local _insert = table.insert;
	for v in string.gmatch(str, "([^" .. sep[1] .. "]+)") do
		local curstr = v	
		local retchild = {};
		for o = 1, #sep do
			local curtable = Utils.SplitStr(curstr, sep[o])
			curstr = curtable[1]
            for g = #curtable,1,-1 do
                local strnum = tonumber(curtable[g]) and tonumber(curtable[g]) or -1
                if strnum ~= -1 then         
                    _insert(retchild, 1, strnum)
                end
            end
		end
		i = i + 1;
		_ret[i] = retchild;
	end
	return _ret;
end

--根据定义切割字符串，此函数为递归函数。index最好不传
function Utils.SplitStrBySeps(str, sep, index)
    sep = sep or {';', '_'}
	if type(sep) ~= "table" then
		Debug.LogError("sepTable is not a table")
		return str
    end
    
    index = index or 1;
    local _sepCount = #sep;
    if index > _sepCount then
        return str;
    end
    local _strTable = Utils.SplitStr(str, sep[index]);
    if (index + 1)  > _sepCount then
        return _strTable;
    end

    local _result = {}
    for i = 1, #_strTable do
        _result[i] = Utils.SplitStrBySeps(_strTable[i], sep, index + 1);
    end
    return _result;
end

--将字符串里面所有都替换为rep,   pattern是要替换的字符串
function Utils.ReplaceString(str,pattern,rep)
    local _strg = string.gmatch(str, pattern)
    for v in _strg do
        str = string.gsub(str,v,rep)
    end
    return str
end

--获取时分秒eg(09:20:30)
function Utils.GetHMS(count)
    return os.date("%X", count + 57600);
end

function Utils.SafeAsin(sinValue)
	return L_Asin(L_Clamp(sinValue, -1, 1))
end

function Utils.SafeAcos(cosValue)
	return L_Acos(L_Clamp(cosValue, -1, 1))
end

--[求距离]vector2、vector3、vector4
function Utils.Distance(va, vb)
    return (va - vb):Magnitude()
end

--v2或v3固定最大长度内
function Utils.ClampMagnitude(v ,maxLength)
	if v:SqrMagnitude() > (maxLength * maxLength) then
        v:Normalize()
        v:Mul(maxLength)
    end
    return v
end

--[点乘]vector2、vector3、vector4、Quaternion
function Utils.Dot(lhs, rhs)
    --Vector4,Quaternion
    if lhs.w then
        return lhs.x * rhs.x + lhs.y * rhs.y + lhs.z * rhs.z + lhs.w * rhs.w
    --vector3
    elseif lhs.z then
        return lhs.x * rhs.x + lhs.y * rhs.y + lhs.z * rhs.z;
    --vector2
    else
        return lhs.x * rhs.x + lhs.y * rhs.y;
    end
end

--v3的叉乘
function Utils.Cross(lhs, rhs)
	local _x = lhs.y * rhs.z - lhs.z * rhs.y
	local _y = lhs.z * rhs.x - lhs.x * rhs.z
	local _z = lhs.x * rhs.y - lhs.y * rhs.x
	return Vector3(_x,_y,_z)
end

--求两v2或两v3或两Quaternion之间的角度
function Utils.Angle(lhs, rhs)
    --Quaternion
    if lhs.w then
        local _dot = Utils.Dot(lhs, rhs)
        if _dot < 0 then
            _dot = -_dot
        end
        return L_Acos(L_Min(_dot, 1)) * 2 * L_Rad2Deg
    --Vector2 or Vector3
    else
        return Utils.SafeAcos(Utils.Dot(lhs:Normalize(), rhs:Normalize())) * L_Rad2Deg;
    end
end

local function QuaternionLerp(from, to, t)
    local _q = Quaternion()
    if Utils.Dot(from, to) < 0 then
        _q.x = from.x + t * (-to.x -from.x)
        _q.y = from.y + t * (-to.y -from.y)
        _q.z = from.z + t * (-to.z -from.z)
        _q.w = from.w + t * (-to.w -from.w)
    else
        _q.x = from.x + (to.x - from.x) * t
        _q.y = from.y + (to.y - from.y) * t
        _q.z = from.z + (to.z - from.z) * t
        _q.w = from.w + (to.w - from.w) * t
    end
    _q:Normalize()
    return _q
end

--[插值] v2、v3、v4、Quaternion、Color
function Utils.Lerp(from, to, t)
    t = L_Clamp(t, 0, 1)
    return Utils.UnclampedLerp(from, to, t)
end

--[非区间插值] v2、v3、v4、Quaternion、Color
function Utils.UnclampedLerp(from, to, t)
    --Color
    if from.r then
        return Color(from.r + (to.r - from.r) * t, from.g + (to.g - from.g) * t, from.b + (to.b - from.b) * t, from.a + (to.a - from.a) * t);
    --v4,Quaternion
    elseif from.w then
        if from.SetIdentity then
            return QuaternionLerp(from, to, t);
        else
            return Vector4(from.x + (to.x - from.x) * t, from.y + (to.y - from.y) * t, from.z + (to.z - from.z) * t, from.w + (to.w - from.w) * t);
        end
    --Vector3
    elseif from.z then
        return Vector3(from.x + (to.x - from.x) * t, from.y + (to.y - from.y) * t, from.z + (to.z - from.z) * t);
    --Vector2
    else
        return Vector2(from.x + (to.x - from.x) * t, from.y + (to.y - from.y) * t);
    end
end

--Vector3、Vector4移向
function Utils.MoveTowards(current, target, maxDistanceDelta)
	local _delta = target - current
    local _sqrDelta = _delta:SqrMagnitude()
	local _sqrDistance = maxDistanceDelta * maxDistanceDelta

    if _sqrDelta > _sqrDistance then
		local magnitude = L_Sqrt(_sqrDelta)

		if magnitude > 1e-6 then
			_delta:Mul(maxDistanceDelta / magnitude)
			_delta:Add(current)
			return _delta
		else
			return current:Clone()
		end
    end
    return target:Clone()
end

--Vector3、Vector4投影
function Utils.Project(vector, onNormal)
    if vector.w then
        local _s = Utils.Dot(vector, onNormal) / Utils.Dot(onNormal, onNormal)
	    return onNormal * _s
    else
	    local num = onNormal:SqrMagnitude()
        if num < 1.175494e-38 then
            return Vector3(0,0,0)
	    end
	    local num2 = Utils.Dot(vector, onNormal)
	    local _v = onNormal:Clone()
	    _v:Mul(num2/num)
        return _v
    end
end

--Vector3投影到地面
function Utils.ProjectOnPlane(vector, planeNormal)
	local _v3 = Utils.Project(vector, planeNormal)
	_v3:Mul(-1)
	_v3:Add(vector)
	return _v3
end

--Vector3反射
function Utils.Reflect(inDirection, inNormal)
	local _num = -2 * Utils.Dot(inNormal, inDirection)
	inNormal = inNormal * _num
	inNormal:Add(inDirection)
	return inNormal
end

--绕轴的夹角
function Utils.AngleAroundAxis (from, to, axis)
	from = from - Utils.Project(from, axis)
	to = to - Utils.Project(to, axis)
	local _angle = Utils.Angle (from, to)
	return _angle * (Utils.Dot (axis, Utils.Cross (from, to)) < 0 and -1 or 1)
end

--[角轴] 绕axis轴旋转angle，创建一个Quaternion
function Utils.AngleAxis(angle, axis)
	local _normAxis = axis:Normalize()
    angle = angle * L_HalfDegToRad
    local _s = L_Sin(angle)

    local w = math.cos(angle)
    local _x = _normAxis.x * _s
    local _y = _normAxis.y * _s
    local _z = _normAxis.z * _s
	return Quaternion(_x,_y,_z,w)
end

local function OrthoNormalVector(vec)
	local res = Vector3()
	if math.abs(vec.z) > L_OverSqrt2 then
		local _a = vec.y * vec.y + vec.z * vec.z
		local _k = 1 / L_Sqrt (_a)
		res.x = 0
		res.y = -vec.z * _k
		res.z = vec.y * _k
	else
		local _a = vec.x * vec.x + vec.y * vec.y
		local _k = 1 / L_Sqrt (_a)
		res.x = -vec.y * _k
		res.y = vec.x * _k
		res.z = 0
	end
	return res
end

local function Vector3Slerp(from, to, t)
	local _omega, _sinom, _scale0, _scale1

	if t <= 0 then
		return from:Clone()
	elseif t >= 1 then
		return to:Clone()
	end

	local _v2 	= to:Clone()
	local _v1 	= from:Clone()
	local _len2 	= to:Magnitude()
	local _len1 	= from:Magnitude()
	_v2:Div(_len2)
	_v1:Div(_len1)

	local _len 	= (_len2 - _len1) * t + _len1
	local _cosom = Utils.Dot(_v1, _v2)

	if _cosom > 1 - 1e-6 then
		_scale0 = 1 - t
		_scale1 = t
	elseif _cosom < -1 + 1e-6 then
		local axis = OrthoNormalVector(from)
		local q = Utils.AngleAxis(180.0 * t, axis)
		local v = q:MulVec3(from)
		v:Mul(_len)
		return v
	else
		_omega 	= L_Acos(_cosom)
		_sinom 	= L_Sin(_omega)
		_scale0 	= L_Sin((1 - t) * _omega) / _sinom
		_scale1 	= L_Sin(t * _omega) / _sinom
	end

	_v1:Mul(_scale0)
	_v2:Mul(_scale1)
	_v2:Add(_v1)
	_v2:Mul(_len)
	return _v2
end

local function UnclampedSlerp(from, to, t)
	local _cosAngle = Utils.Dot(from, to)

    if _cosAngle < 0 then
        _cosAngle = -_cosAngle
        to = Quaternion(-to.x, -to.y, -to.z, -to.w)
    end

    local _t1, _t2
    if _cosAngle < 0.95 then
	    local angle 	= L_Acos(_cosAngle)
		local sinAngle 	= L_Sin(angle)
        local invSinAngle = 1 / sinAngle
        _t1 = L_Sin((1 - t) * angle) * invSinAngle
        _t2 = L_Sin(t * angle) * invSinAngle
		return Quaternion(from.x * _t1 + to.x * _t2, from.y * _t1 + to.y * _t2, from.z * _t1 + to.z * _t2, from.w * _t1 + to.w * _t2)
    else
		return Utils.Lerp(from, to, t)
    end
end

function Utils.Slerp(from, to, t)
    t = L_Clamp(t, 0, 1)
    --Quaternion
    if from.w then
        return UnclampedSlerp(from, to, t)
    --vector3
    else
        return Vector3Slerp(from, to, t)
    end
end
--Quaternion转向
local function QuaternionRotateTowards(from, to, maxDegreesDelta)
	local _angle = Utils.Angle(from, to)

	if _angle == 0 then
		return to
	end

	local _t = L_Min(1, maxDegreesDelta / _angle)
	return UnclampedSlerp(from, to, _t)
end

local function ClampedMove(lhs, rhs, clampedDelta)
	local _delta = rhs - lhs

	if _delta > 0 then
		return lhs + L_Min(_delta, clampedDelta)
	else
		return lhs - L_Min(-_delta, clampedDelta)
	end
end

--Vector3转向
local function Vector3RotateTowards(current, target, maxRadiansDelta, maxMagnitudeDelta)
	local _len1 = current:Magnitude()
	local _len2 = target:Magnitude()

	if _len1 > 1e-6 and _len2 > 1e-6 then
		local _from = current / _len1
		local _to = target / _len2
		local _cosom = Utils.Dot(_from, _to)

		if _cosom > 1 - 1e-6 then
			return Utils.MoveTowards (current, target, maxMagnitudeDelta)
		elseif _cosom < -1 + 1e-6 then
			local _axis = OrthoNormalVector(_from)
			local _q = Utils.AngleAxis(maxRadiansDelta * L_Rad2Deg, _axis)
			local rotated = _q:MulVec3(_from)
			local _delta = ClampedMove(_len1, _len2, maxMagnitudeDelta)
			rotated:Mul(_delta)
			return rotated
		else
			local _angle = L_Acos(_cosom)
			local _axis = Utils.Cross(_from, _to)
			_axis:Normalize ()
			local _q = Utils.AngleAxis(L_Min(maxRadiansDelta, _angle) * L_Rad2Deg, _axis)
			local rotated = _q:MulVec3(_from)
			local _delta = ClampedMove(_len1, _len2, maxMagnitudeDelta)
			rotated:Mul(_delta)
			return rotated
		end
	end

	return Utils.MoveTowards(current, target, maxMagnitudeDelta)
end

--转向
function Utils.RotateTowards(from, to, Delta, maxMagnitudeDelta)
    --Quaternion
    if from.w then
        return QuaternionRotateTowards(from, to, Delta)
    --vector3
    else
        return Vector3RotateTowards(from, to, Delta, maxMagnitudeDelta)
    end
end

--Vector3平滑阻尼
function Utils.SmoothDamp(current, target, currentVelocity, smoothTime)
	local _maxSpeed = math.huge
	local _deltaTime = Time.GetDeltaTime()
    smoothTime = math.max(0.0001, smoothTime)
    local _num = 2 / smoothTime
    local _num2 = _num * _deltaTime
    local _num3 = 1 / (1 + _num2 + 0.48 * _num2 * _num2 + 0.235 * _num2 * _num2 * _num2)
    local _vectorClone = target:Clone()
    local _maxLength = _maxSpeed * smoothTime
	local _vector = current - target
    Utils.ClampMagnitude(_vector, _maxLength)
    target = current - _vector
    local _vecTemp = (currentVelocity + (_vector * _num)) * _deltaTime
    currentVelocity = (currentVelocity - (_vecTemp * _num)) * _num3
    local _vecResult = target + (_vector + _vecTemp) * _num3

    if Utils.Dot(_vectorClone - current, _vecResult - _vectorClone) > 0 then
        _vecResult = _vectorClone
        currentVelocity:Set(0,0,0)
    end

    return _vecResult, currentVelocity
end

--[缩放]vector3、vector4
function Utils.Scale(lhs, rhs)
    if lhs.w then
        return Vector4(lhs.x * rhs.x, lhs.y * rhs.y, lhs.z * rhs.z, lhs.w * rhs.w)
    else
        return Vector3(lhs.x * rhs.x, lhs.y * rhs.y, lhs.z * rhs.z)

    end
end

--[求小值]vector2、vector3、vector4
function Utils.Min(lhs, rhs)
    if lhs.w then
        return Vector4(L_Min(lhs.x, rhs.x), L_Min(lhs.y, rhs.y), L_Min(lhs.z, rhs.z), L_Min(lhs.w, rhs.w))
    elseif lhs.z then
        return Vector3(L_Min(lhs.x, rhs.x), L_Min(lhs.y, rhs.y), L_Min(lhs.z, rhs.z))
    else
        return Vector2(L_Min(lhs.x, rhs.x), L_Min(lhs.y, rhs.y))
    end
end

--[求大值]vector2、vector3、vector4
function Utils.Max(lhs, rhs)
    if lhs.w then
        return Vector4(L_Max(lhs.x, rhs.x), L_Max(lhs.y, rhs.y), L_Max(lhs.z, rhs.z), L_Max(lhs.w, rhs.w))
    elseif lhs.z then
        return Vector3(L_Max(lhs.x, rhs.x), L_Max(lhs.y, rhs.y), L_Max(lhs.z, rhs.z))
    else
        return Vector2(L_Max(lhs.x, rhs.x), L_Max(lhs.y, rhs.y))
    end
end

--HSV转RGB
function Utils.HSVToRGB(H, S, V, hdr)
  local _white = Color(1,1,1,1)

  if S == 0 then
    _white.r = V
    _white.g = V
    _white.b = V
    return _white
  end

  if V == 0 then
    _white.r = 0
    _white.g = 0
    _white.b = 0
    return _white
  end

  _white.r = 0
  _white.g = 0
  _white.b = 0;
  local _num = S
  local _num2 = V
  local _f = H * 6;
  local _num4 = math.floor(_f)
  local _num5 = _f - _num4
  local _num6 = _num2 * (1 - _num)
  local _num7 = _num2 * (1 - (_num * _num5))
  local _num8 = _num2 * (1 - (_num * (1 - _num5)))
  local _num9 = _num4

  local _flag = _num9 + 1

  if _flag == 0 then
    _white.r = _num2
    _white.g = _num6
    _white.b = _num7
  elseif _flag == 1 then
    _white.r = _num2
    _white.g = _num8
    _white.b = _num6
  elseif _flag == 2 then
    _white.r = _num7
    _white.g = _num2
    _white.b = _num6
  elseif _flag == 3 then
    _white.r = _num6
    _white.g = _num2
    _white.b = _num8
  elseif _flag == 4 then
    _white.r = _num6
    _white.g = _num7
    _white.b = _num2
  elseif _flag == 5 then
    _white.r = _num8
    _white.g = _num6
    _white.b = _num2
  elseif _flag == 6 then
    _white.r = _num2
    _white.g = _num6
    _white.b = _num7
  elseif _flag == 7 then
    _white.r = _num2
    _white.g = _num8
    _white.b = _num6
  end

  if not hdr then
    _white.r = L_Clamp(_white.r, 0, 1)
    _white.g = L_Clamp(_white.g, 0, 1)
    _white.b = L_Clamp(_white.b, 0, 1)
  end

  return _white
end

return Utils