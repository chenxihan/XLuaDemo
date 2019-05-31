------------------------------------------------
--作者： xihan
--日期： 2019-05-14
--文件： Color.lua
--模块： Color
--描述： Color的运算
------------------------------------------------
local Color = {}

--新建一个Color r、g、b、a的取值范围[0,1]
local function New(r, g, b, a)
    return setmetatable({r = r or 0, g = g or 0, b = b or 0, a = a or 1}, Color)
end

function Color:Set(r, g, b, a)
    self.r = r
    self.g = g
    self.b = b
    self.a = a or 1
end

function Color:Get()
    return self.r, self.g, self.b, self.a
end

function Color:Clone()
    return New(self.r, self.g, self.b, self.a)
end

function Color:Equals(other)
    return self.r == other.r and self.g == other.g and self.b == other.b and self.a == other.a
end

local function RGBToHSVHelper(offset, dominantcolor, colorone, colortwo)
    local _v = dominantcolor

    if _v ~= 0 then
        local _num = 0

        if colorone > colortwo then
            _num = colortwo
        else
            _num = colorone
        end
        local _num2 = _v - _num
        local _h = 0
        local _s = 0
        if _num2 ~= 0 then
            _s = _num2 / _v
            _h = offset + (colorone - colortwo) / _num2
        else
            _s = 0
            _h = offset + (colorone - colortwo)
        end

        _h = _h / 6
        if _h < 0 then
            _h = _h + 1
        end
        return _h, _s, _v
    end

    return 0, 0, _v
end

--RGB转HSV
function Color:RGBToHSV()
    if self.b > self.g and self.b > self.r then
        return RGBToHSVHelper(4, self.b, self.r, self.g)
    elseif self.g > self.r then
        return RGBToHSVHelper(2, self.g, self.b, self.r)
    else
        return RGBToHSVHelper(0, self.r, self.g, self.b)
    end
end

--灰度
function Color:GetGrayScale()
    return 0.299 * self.r + 0.587 * self.g + 0.114 * self.b
end

--伽马转线性,获取一个新的Color
function Color:GetGamma()
    return New(
        math.LinearToGammaSpaceExact(self.r),
        math.LinearToGammaSpaceExact(self.g),
        math.LinearToGammaSpaceExact(self.b),
        self.a
    )
end

--伽马转线性
function Color:Gamma()
    self.r = math.LinearToGammaSpaceExact(self.r)
    self.g = math.LinearToGammaSpaceExact(self.g)
    self.b = math.LinearToGammaSpaceExact(self.b)
    return self
end

--线性转伽马,获取一个新的Color
function Color:GetLinear()
    return New(
        math.GammaToLinearSpaceExact(self.r),
        math.GammaToLinearSpaceExact(self.g),
        math.GammaToLinearSpaceExact(self.b),
        self.a
    )
end

--线性转伽马
function Color:Linear()
    self.r = math.GammaToLinearSpaceExact(self.r)
    self.g = math.GammaToLinearSpaceExact(self.g)
    self.b = math.GammaToLinearSpaceExact(self.b)
    return self
end

--返回最大颜色组件值
function Color:MaxColorComponent()
    return math.max(math.max(self.r, self.g), self.b)
end

Color.__add = function(a, b)
    return New(a.r + b.r, a.g + b.g, a.b + b.b, a.a + b.a)
end

Color.__sub = function(a, b)
    return New(a.r - b.r, a.g - b.g, a.b - b.b, a.a - b.a)
end

Color.__mul = function(a, b)
    if type(b) == "number" then
        return New(a.r * b, a.g * b, a.b * b, a.a * b)
    elseif getmetatable(b) == Color then
        return New(a.r * b.r, a.g * b.g, a.b * b.b, a.a * b.a)
    end
end

Color.__div = function(a, d)
    return New(a.r / d, a.g / d, a.b / d, a.a / d)
end

Color.__eq = function(a, b)
    return a.r == b.r and a.g == b.g and a.b == b.b and a.a == b.a
end

Color.__tostring = function(self)
    return string.format("RGBA[%f,%f,%f,%f]", self.r, self.g, self.b, self.a)
end

local L_Metatable = {
    black = function()
        return New(0, 0, 0, 1)
    end,
    blue = function()
        return New(0, 0, 1, 1)
    end,
    clear = function()
        return New(0, 0, 0, 0)
    end,
    cyan = function()
        return New(0, 1, 1, 1)
    end,
    gray = function()
        return New(0.5, 0.5, 0.5, 1)
    end,
    green = function()
        return New(0, 1, 0, 1)
    end,
    magenta = function()
        return New(1, 0, 1, 1)
    end,
    red = function()
        return New(1, 0, 0, 1)
    end,
    white = function()
        return New(1, 1, 1, 1)
    end,
    yellow = function()
        return New(1, 0.92, 0.016, 1)
    end
}

L_Metatable.__index = function(t, k)
    if L_Metatable[k] then
        return L_Metatable[k]()
    end
end

L_Metatable.__call = function(t, r, g, b, a)
    if type(r) == "number" or type(r) == "nil" then
        return New(r, g, b, a)
    else
        return New(r.r, r.g, r.b, r.a)
    end
end

Color.__index = function(t, k)
    return rawget(Color, k)
end

setmetatable(Color, L_Metatable)
return Color
