------------------------------------------------
--作者： xihan
--日期： 2019-05-07
--文件： Vector3.lua
--模块： Vector3
--描述： Vector3的运算
------------------------------------------------
local L_Format = string.format
local L_Sqrt = math.sqrt
local L_Setmetatable = setmetatable
local L_Rawget = rawget

local Vector3 = {}

local function New(x, y, z)
    return L_Setmetatable({x = x or 0, y = y or 0, z = z or 0}, Vector3)
end

function Vector3:Set(x, y, z)
    self.x = x or 0
    self.y = y or 0
    self.z = z or 0
end

function Vector3:Get()
    return self.x, self.y, self.z
end

function Vector3:Clone()
    return New(self.x, self.y, self.z)
end

function Vector3:Magnitude()
    return L_Sqrt(self.x * self.x + self.y * self.y + self.z * self.z)
end

function Vector3:SqrMagnitude()
    return self.x * self.x + self.y * self.y + self.z * self.z
end

function Vector3:GetNormalize()
    return self:Clone():Normalize()
end

function Vector3:Normalize()
    local L_Num = self:Magnitude()
    if L_Num > 1e-5 then
        self:Div(L_Num)
    else
        self.x = 0
        self.y = 0
        self.z = 0
    end
    return self
end

function Vector3:MulQuat(quat)
    local _num = quat.x * 2
    local _num2 = quat.y * 2
    local _num3 = quat.z * 2
    local _num4 = quat.x * _num
    local _num5 = quat.y * _num2
    local _num6 = quat.z * _num3
    local _num7 = quat.x * _num2
    local _num8 = quat.x * _num3
    local _num9 = quat.y * _num3
    local _num10 = quat.w * _num
    local _num11 = quat.w * _num2
    local _num12 = quat.w * _num3

    local _x = (((1 - (_num5 + _num6)) * self.x) + ((_num7 - _num12) * self.y)) + ((_num8 + _num11) * self.z)
    local _y = (((_num7 + _num12) * self.x) + ((1 - (_num4 + _num6)) * self.y)) + ((_num9 - _num10) * self.z)
    local _z = (((_num8 - _num11) * self.x) + ((_num9 + _num10) * self.y)) + ((1 - (_num4 + _num5)) * self.z)

    self:Set(_x, _y, _z)
    return self
end

function Vector3:Add(vb)
    self.x = self.x + vb.x
    self.y = self.y + vb.y
    self.z = self.z + vb.z

    return self
end

function Vector3:Sub(vb)
    self.x = self.x - vb.x
    self.y = self.y - vb.y
    self.z = self.z - vb.z

    return self
end

function Vector3:Mul(q)
    if type(q) == "number" then
        self.x = self.x * q
        self.y = self.y * q
        self.z = self.z * q
    else
        self:MulQuat(q)
    end

    return self
end

function Vector3:Div(d)
    self.x = self.x / d
    self.y = self.y / d
    self.z = self.z / d

    return self
end

function Vector3:Equals(vb)
    return (self - vb):SqrMagnitude() < 1e-10
end

Vector3.__add = function(va, vb)
    return New(va.x + vb.x, va.y + vb.y, va.z + vb.z)
end

Vector3.__sub = function(va, vb)
    return New(va.x - vb.x, va.y - vb.y, va.z - vb.z)
end

Vector3.__mul = function(va, d)
    if type(d) == "number" then
        return New(va.x * d, va.y * d, va.z * d)
    else
        local _vec = va:Clone()
        _vec:MulQuat(d)
        return _vec
    end
end

Vector3.__div = function(va, d)
    return New(va.x / d, va.y / d, va.z / d)
end

Vector3.__unm = function(va)
    return New(-va.x, -va.y, -va.z)
end

Vector3.__eq = function(a, b)
    return (a - b):SqrMagnitude() < 1e-10
end

Vector3.__tostring = function(self)
    return L_Format("[%s,%s,%s]", self.x, self.y, self.z)
end

Vector3.__index = function(t, k)
    return L_Rawget(Vector3, k)
end

local L_Metatable = {
    up = function()
        return New(0, 1, 0)
    end,
    down = function()
        return New(0, -1, 0)
    end,
    right = function()
        return New(1, 0, 0)
    end,
    left = function()
        return New(-1, 0, 0)
    end,
    forward = function()
        return New(0, 0, 1)
    end,
    back = function()
        return New(0, 0, -1)
    end,
    zero = function()
        return New(0, 0, 0)
    end,
    one = function()
        return New(1, 1, 1)
    end
}

L_Metatable.__index = function(t, k)
    if L_Metatable[k] then
        return L_Metatable[k]()
    end
end
L_Metatable.__call = function(t, x, y, z)
    if type(x) == "number" or type(x) == "nil" then
        return New(x, y, z)
    else
        return New(x.x, x.y, x.z)
    end
end

L_Setmetatable(Vector3, L_Metatable)
return Vector3
