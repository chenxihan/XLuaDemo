------------------------------------------------
--作者： xihan
--日期： 2019-05-15
--文件： Vector4.lua
--模块： Vector4
--描述： Vector4的运算
------------------------------------------------
local L_Format = string.format
local L_Sqrt = math.sqrt
local L_Setmetatable = setmetatable
local L_Rawget = rawget
local L_Type = type

local Vector4 = {}

local function New(x, y, z, w)
    return L_Setmetatable({x = x or 0, y = y or 0, z = z or 0, w = w or 0}, Vector4)
end

function Vector4:Set(x, y, z, w)
    self.x = x or 0
    self.y = y or 0
    self.z = z or 0
    self.w = w or 0
end

function Vector4:Get()
    return self.x, self.y, self.z, self.w
end

function Vector4:Clone()
    return New(self.x, self.y, self.z, self.w)
end

function Vector4:Magnitude()
    return L_Sqrt(self:SqrMagnitude())
end

function Vector4:SqrMagnitude()
    return self.x * self.x + self.y * self.y + self.z * self.z + self.w * self.w
end

function Vector4:GetNormalize()
    local _v = New(self.x, self.y, self.z, self.w)
    return _v:Normalize()
end

function Vector4:Normalize()
    local _num = self:SqrMagnitude()

    if _num == 1 then
        return self
    elseif _num > 1e-05 then
        local _n = 1 / L_Sqrt(_num)
        self:Mul(_n)
    else
        self:Set(0, 0, 0, 0)
    end
    return self
end

function Vector4:SetScale(scale)
    self.x = self.x * scale.x
    self.y = self.y * scale.y
    self.z = self.z * scale.z
    self.w = self.w * scale.w
end

function Vector4:Add(b)
    self.x = self.x + b.x
    self.y = self.y + b.y
    self.z = self.z + b.z
    self.w = self.w + b.w

    return self
end

function Vector4:Sub(b)
    self.x = self.x - b.x
    self.y = self.y - b.y
    self.z = self.z - b.z
    self.w = self.w - b.w

    return self
end

function Vector4:Mul(d)
    self.x = self.x * d
    self.y = self.y * d
    self.z = self.z * d
    self.w = self.w * d

    return self
end

function Vector4:Div(d)
    self.x = self.x / d
    self.y = self.y / d
    self.z = self.z / d
    self.w = self.w / d

    return self
end

Vector4.__add = function(va, vb)
    return New(va.x + vb.x, va.y + vb.y, va.z + vb.z, va.w + vb.w)
end

Vector4.__sub = function(va, vb)
    return New(va.x - vb.x, va.y - vb.y, va.z - vb.z, va.w - vb.w)
end

Vector4.__mul = function(va, d)
    return New(va.x * d, va.y * d, va.z * d, va.w * d)
end

Vector4.__div = function(va, d)
    return New(va.x / d, va.y / d, va.z / d, va.w / d)
end

Vector4.__unm = function(va)
    return New(-va.x, -va.y, -va.z, -va.w)
end

Vector4.__eq = function(va, vb)
    local _v = va - vb
    local _delta = _v:SqrMagnitude()
    return _delta < 1e-10
end

Vector4.__tostring = function(self)
    return L_Format("[%f,%f,%f,%f]", self.x, self.y, self.z, self.w)
end

Vector4.__index = function(t, k)
    return L_Rawget(Vector4, k)
end

local L_Metatable = {
    zero = function()
        return New(0, 0, 0, 0)
    end,
    one = function()
        return New(1, 1, 1, 1)
    end
}

L_Metatable.__index = function(t, k)
    if L_Metatable[k] then
        return L_Metatable[k]()
    end
end

L_Metatable.__call = function(t, x, y, z, w)
    if L_Type(x) == "number" or L_Type(x) == "nil" then
        return New(x, y, z, w)
    else
        return New(x.x, x.y, x.z, x.w)
    end
end

L_Setmetatable(Vector4, L_Metatable)
return Vector4
