------------------------------------------------
--作者： xihan
--日期： 2019-05-06
--文件： Vector2.lua
--模块： Vector2
--描述： Vector2的运算
------------------------------------------------
local L_Sqrt = math.sqrt
local L_Setmetatable = setmetatable
local L_Rawget = rawget
local L_Acos = math.acos
local L_Clamp = math.Clamp
local L_Format = string.format

local Vector2 = {}

local function New(x, y)
    return L_Setmetatable({x = x or 0, y = y or 0}, Vector2)
end

function Vector2:Set(x, y)
    self.x = x or 0
    self.y = y or 0
end

function Vector2:Get()
    return self.x, self.y
end

function Vector2:Clone()
    return New(self.x, self.y)
end

function Vector2:Magnitude()
    return L_Sqrt(self.x * self.x + self.y * self.y)
end

function Vector2:SqrMagnitude()
    return self.x * self.x + self.y * self.y
end

function Vector2:GetNormalize()
    local _v = self:Clone()
    return _v:Normalize()
end

function Vector2:Normalize()
    local _num = self:Magnitude()
    if _num == 1 then
        return self
    elseif _num > 1e-05 then
        self:Div(_num)
    else
        self:Set(0, 0)
    end
    return self
end

function Vector2:Div(d)
    self.x = self.x / d
    self.y = self.y / d
    return self
end

function Vector2:Mul(d)
    self.x = self.x * d
    self.y = self.y * d
    return self
end

function Vector2:Add(b)
    self.x = self.x + b.x
    self.y = self.y + b.y
    return self
end

function Vector2:Sub(b)
    self.x = self.x - b.x
    self.y = self.y - b.y
    return
end

Vector2.__add = function(va, vb)
    return New(va.x + vb.x, va.y + vb.y)
end

Vector2.__sub = function(va, vb)
    return New(va.x - vb.x, va.y - vb.y)
end

Vector2.__mul = function(va, d)
    return New(va.x * d, va.y * d)
end

Vector2.__div = function(va, d)
    return New(va.x / d, va.y / d)
end

Vector2.__unm = function(va)
    return New(-va.x, -va.y)
end

Vector2.__eq = function(va, vb)
    return (va - vb):SqrMagnitude() < 1e-10
end

Vector2.__tostring = function(self)
    return L_Format("[%s,%s]", self.x, self.y)
end

Vector2.__index = function(t, k)
    return L_Rawget(Vector2, k)
end

local L_Metatable = {
    up = function()
        return New(0, 1)
    end,
    down = function()
        return New(0, -1)
    end,
    right = function()
        return New(1, 0)
    end,
    left = function()
        return New(-1, 0)
    end,
    zero = function()
        return New(0, 0)
    end,
    one = function()
        return New(1, 1)
    end
}

L_Metatable.__index = function(t, k)
    if L_Metatable[k] then
        return L_Metatable[k]()
    end
end

L_Metatable.__call = function(t, x, y)
    local _typeX = type(x)
    if _typeX == "number" or _typeX == "nil" then
        return New(x, y)
    else
        return New(x.x, x.y)
    end
end

L_Setmetatable(Vector2, L_Metatable)
return Vector2
