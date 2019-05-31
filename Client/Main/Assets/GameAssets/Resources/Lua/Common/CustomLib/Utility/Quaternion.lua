------------------------------------------------
--作者： xihan
--日期： 2019-05-10
--文件： Quaternion.lua
--模块： Quaternion
--描述： Quaternion的运算
------------------------------------------------
local Vector3 = require("Common.CustomLib.Utility.Vector3")

local L_Rawget = rawget
local L_Rawset = rawset
local L_Setmetatable = setmetatable
local L_Getmetatable = getmetatable
local L_Math = math
local L_Sin = L_Math.sin
local L_Cos = L_Math.cos
local L_Acos = L_Math.acos
local L_Asin = L_Math.asin
local L_Sqrt = L_Math.sqrt
local L_Min = L_Math.min
local L_Max = L_Math.max
local L_Sign = L_Math.Sign
local L_Atan = L_Math.atan
local L_Clamp = L_Math.Clamp
local L_Abs = L_Math.abs
local L_Rad2Deg = L_Math.Rad2Deg
local L_HalfDegToRad = 0.5 * L_Math.Deg2Rad
local L_Forward = Vector3.forward
local L_Up = Vector3.up
local L_Next = {2, 3, 1}

local Quaternion = {}

local function New(x, y, z, w)
    return L_Setmetatable({x = x or 0, y = y or 0, z = z or 0, w = w or 0}, Quaternion)
end

local function NewByEuler(x, y, z)
    if y == nil and z == nil then
        y = x.y
        z = x.z
        x = x.x
    end

    x = x * L_HalfDegToRad
    y = y * L_HalfDegToRad
    z = z * L_HalfDegToRad

    local _sinX = L_Sin(x)
    local _cosX = L_Cos(x)
    local _sinY = L_Sin(y)
    local _cosY = L_Cos(y)
    local _sinZ = L_Sin(z)
    local _cosZ = L_Cos(z)

    local _w = _cosY * _cosX * _cosZ + _sinY * _sinX * _sinZ
    x = _cosY * _sinX * _cosZ + _sinY * _cosX * _sinZ
    y = _sinY * _cosX * _cosZ - _cosY * _sinX * _sinZ
    z = _cosY * _cosX * _sinZ - _sinY * _sinX * _cosZ
    return New(x, y, z, _w)
end

function Quaternion:Set(x, y, z, w)
    self.x = x or 0
    self.y = y or 0
    self.z = z or 0
    self.w = w or 0
end

function Quaternion:Get()
    return self.x, self.y, self.z, self.w
end

function Quaternion:Clone()
    return New(self.x, self.y, self.z, self.w)
end

function Quaternion:GetNormalize()
    return self:Clone():Normalize()
end

function Quaternion:Normalize()
    local _n = self.x * self.x + self.y * self.y + self.z * self.z + self.w * self.w

    if _n ~= 1 and _n > 0 then
        _n = 1 / L_Sqrt(_n)
        self.x = self.x * _n
        self.y = self.y * _n
        self.z = self.z * _n
        self.w = self.w * _n
    end
    return self
end

function Quaternion:SetIdentity()
    self.x = 0
    self.y = 0
    self.z = 0
    self.w = 1
end

function Quaternion:Inverse()
    local _quat = New()
    _quat.x = -self.x
    _quat.y = -self.y
    _quat.z = -self.z
    _quat.w = self.w
    return _quat
end

local function Approximately(f0, f1)
    return L_Abs(f0 - f1) < 1e-6
end

function Quaternion:ToAngleAxis()
    local _angle = 2 * L_Acos(self.w)

    if Approximately(_angle, 0) then
        return _angle * 57.29578, Vector3(1, 0, 0)
    end

    local _div = 1 / L_Sqrt(1 - L_Sqrt(self.w))
    return _angle * 57.29578, Vector3(self.x * _div, self.y * _div, self.z * _div)
end

local L_PI = L_Math.pi
local L_Half_PI = L_PI * 0.5
local L_Two_PI = 2 * L_PI
local L_NegativeFlip = -0.0001
local L_PositiveFlip = L_Two_PI - 0.0001

local function SanitizeEuler(euler)
    if euler.x < L_NegativeFlip then
        euler.x = euler.x + L_Two_PI
    elseif euler.x > L_PositiveFlip then
        euler.x = euler.x - L_Two_PI
    end

    if euler.y < L_NegativeFlip then
        euler.y = euler.y + L_Two_PI
    elseif euler.y > L_PositiveFlip then
        euler.y = euler.y - L_Two_PI
    end

    if euler.z < L_NegativeFlip then
        euler.z = euler.z + L_Two_PI
    elseif euler.z > L_PositiveFlip then
        euler.z = euler.z + L_Two_PI
    end
end

function Quaternion:ToEulerAngles()
    local _x = self.x
    local _y = self.y
    local _z = self.z
    local _w = self.w

    local _check = 2 * (_y * _z - _w * _x)

    if _check < 0.999 then
        if _check > -0.999 then
            local _v =
                Vector3(
                -L_Asin(_check),
                L_Atan(2 * (_x * _z + _w * _y), 1 - 2 * (_x * _x + _y * _y)),
                L_Atan(2 * (_x * _y + _w * _z), 1 - 2 * (_x * _x + _z * _z))
            )
            SanitizeEuler(_v)
            _v:Mul(L_Rad2Deg)
            return _v
        else
            local _v = Vector3(L_Half_PI, L_Atan(2 * (_x * _y - _w * _z), 1 - 2 * (_y * _y + _z * _z)), 0)
            SanitizeEuler(_v)
            _v:Mul(L_Rad2Deg)
            return _v
        end
    else
        local _v = Vector3(-L_Half_PI, L_Atan(-2 * (_x * _y - _w * _z), 1 - 2 * (_y * _y + _z * _z)), 0)
        SanitizeEuler(_v)
        _v:Mul(L_Rad2Deg)
        return _v
    end
end

function Quaternion:Forward()
    return self:MulVec3(Vector3.forward)
end

function Quaternion:MulVec3(point)
    local _vec = Vector3()

    local _num = self.x * 2
    local _num2 = self.y * 2
    local _num3 = self.z * 2
    local _num4 = self.x * _num
    local _num5 = self.y * _num2
    local _num6 = self.z * _num3
    local _num7 = self.x * _num2
    local _num8 = self.x * _num3
    local _num9 = self.y * _num3
    local _num10 = self.w * _num
    local _num11 = self.w * _num2
    local _num12 = self.w * _num3

    _vec.x = (((1 - (_num5 + _num6)) * point.x) + ((_num7 - _num12) * point.y)) + ((_num8 + _num11) * point.z)
    _vec.y = (((_num7 + _num12) * point.x) + ((1 - (_num4 + _num6)) * point.y)) + ((_num9 - _num10) * point.z)
    _vec.z = (((_num8 - _num11) * point.x) + ((_num9 + _num10) * point.y)) + ((1 - (_num4 + _num5)) * point.z)
    return _vec
end

local function MatrixToQuaternion(rot, quat)
    local _trace = rot[1][1] + rot[2][2] + rot[3][3]

    if _trace > 0 then
        local _s = L_Sqrt(_trace + 1)
        quat.w = 0.5 * _s
        _s = 0.5 / _s
        quat.x = (rot[3][2] - rot[2][3]) * _s
        quat.y = (rot[1][3] - rot[3][1]) * _s
        quat.z = (rot[2][1] - rot[1][2]) * _s
         --]]
        quat:Normalize()
    else
        local _i = 1
        local _q = {0, 0, 0}

        if rot[2][2] > rot[1][1] then
            _i = 2
        end

        if rot[3][3] > rot[_i][_i] then
            _i = 3
        end

        local _j = L_Next[_i]
        local _k = L_Next[_j]

        local _t = rot[_i][_i] - rot[_j][_j] - rot[_k][_k] + 1
        local _s = 0.5 / L_Sqrt(_t)
        _q[_i] = _s * _t
        local _w = (rot[_k][_j] - rot[_j][_k]) * _s
        _q[_j] = (rot[_j][_i] + rot[_i][_j]) * _s
        _q[_k] = (rot[_k][_i] + rot[_i][_k]) * _s

        quat:Set(_q[1], _q[2], _q[3], _w)
        quat:Normalize()
    end
end

--创建一个从formDirection到toDirection的Quaternion实例
function Quaternion:GetFromToRotation(from, to)
    local _q = self:Clone()
    _q:FromToRotation(from, to)
    return _q
end
--从from到to的四元数
function Quaternion:FromToRotation(from, to)
    from = from:Normalize()
    to = to:Normalize()

    local _e = Utils.Dot(from, to)

    if _e > 1 - 1e-6 then
        self:Set(0, 0, 0, 1)
    elseif _e < -1 + 1e-6 then
        local _left = {0, from.z, from.y}
        local _mag = _left[2] * _left[2] + _left[3] * _left[3] --+ left[1] * left[1] = 0

        if _mag < 1e-6 then
            _left[1] = -from.z
            _left[2] = 0
            _left[3] = from.x
            _mag = _left[1] * _left[1] + _left[3] * _left[3]
        end

        local _invlen = 1 / L_Sqrt(_mag)
        _left[1] = _left[1] * _invlen
        _left[2] = _left[2] * _invlen
        _left[3] = _left[3] * _invlen

        local _up = {0, 0, 0}
        _up[1] = _left[2] * from.z - _left[3] * from.y
        _up[2] = _left[3] * from.x - _left[1] * from.z
        _up[3] = _left[1] * from.y - _left[2] * from.x

        local _fxx = -from.x * from.x
        local _fyy = -from.y * from.y
        local _fzz = -from.z * from.z

        local _fxy = -from.x * from.y
        local _fxz = -from.x * from.z
        local _fyz = -from.y * from.z

        local _uxx = _up[1] * _up[1]
        local _uyy = _up[2] * _up[2]
        local _uzz = _up[3] * _up[3]
        local _uxy = _up[1] * _up[2]
        local _uxz = _up[1] * _up[3]
        local _uyz = _up[2] * _up[3]

        local _lxx = -_left[1] * _left[1]
        local _lyy = -_left[2] * _left[2]
        local _lzz = -_left[3] * _left[3]
        local _lxy = -_left[1] * _left[2]
        local _lxz = -_left[1] * _left[3]
        local _lyz = -_left[2] * _left[3]

        local _rot = {
            {_fxx + _uxx + _lxx, _fxy + _uxy + _lxy, _fxz + _uxz + _lxz},
            {_fxy + _uxy + _lxy, _fyy + _uyy + _lyy, _fyz + _uyz + _lyz},
            {_fxz + _uxz + _lxz, _fyz + _uyz + _lyz, _fzz + _uzz + _lzz}
        }

        MatrixToQuaternion(_rot, self)
    else
        local _v = Utils.Cross(from, to)
        local _h = (1 - _e) / Utils.Dot(_v, _v)

        local _hx = _h * _v.x
        local _hz = _h * _v.z
        local _hxy = _hx * _v.y
        local _hxz = _hx * _v.z
        local _hyz = _hz * _v.y

        local _rot = {
            {_e + _hx * _v.x, _hxy - _v.z, _hxz + _v.y},
            {_hxy + _v.z, _e + _h * _v.y * _v.y, _hyz - _v.x},
            {_hxz - _v.y, _hyz + _v.x, _e + _hz * _v.z}
        }
        MatrixToQuaternion(_rot, self)
    end
end

Quaternion.__mul =
    function(lhs, rhs)
    if Quaternion == L_Getmetatable(rhs) then
        return New(
            (((lhs.w * rhs.x) + (lhs.x * rhs.w)) + (lhs.y * rhs.z)) - (lhs.z * rhs.y),
            (((lhs.w * rhs.y) + (lhs.y * rhs.w)) + (lhs.z * rhs.x)) - (lhs.x * rhs.z),
            (((lhs.w * rhs.z) + (lhs.z * rhs.w)) + (lhs.x * rhs.y)) - (lhs.y * rhs.x),
            (((lhs.w * rhs.w) - (lhs.x * rhs.x)) - (lhs.y * rhs.y)) - (lhs.z * rhs.z)
        )
    elseif Vector3 == L_Getmetatable(rhs) then
        return lhs:MulVec3(rhs)
    end
end

Quaternion.__unm = function(q)
    return New(-q.x, -q.y, -q.z, -q.w)
end

Quaternion.__eq = function(lhs, rhs)
    return Utils.Dot(lhs, rhs) > 0.999999
end

Quaternion.__tostring = function(self)
    return "[" .. self.x .. "," .. self.y .. "," .. self.z .. "," .. self.w .. "]"
end

Quaternion.__index = function(t, k)
    return L_Rawget(Quaternion, k)
end

local L_Metatable = {
    identity = function()
        return New(0, 0, 0, 1)
    end
}

L_Metatable.__index = function(t, k)
    if L_Metatable[k] then
        return L_Metatable[k]()
    end
end

L_Metatable.__call = function(t, x, y, z, w)
    if type(x) == "number" or type(x) == "nil" then
        return New(x, y, z, w)
    else
        if x.w then
            return New(x.x, x.y, x.z, x.w)
        else
            return NewByEuler(x.x, x.y, x.z)
        end
    end
end

L_Setmetatable(Quaternion, L_Metatable)
return Quaternion
