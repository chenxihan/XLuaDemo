------------------------------------------------
--作者： xihan
--日期： 2019-05-15
--文件： Ray.lua
--模块： Ray
--描述： Ray的运算
------------------------------------------------
local L_Rawget = rawget
local L_Setmetatable = setmetatable

local Ray = {}

local function New(direction, origin)
    return L_Setmetatable({direction = direction:Normalize(), origin = origin}, Ray)
end

function Vector4:Get()
    return self.origin, self.direction
end

function Ray:GetPoint(distance)
	local _dir = self.direction * distance
	_dir:Add(self.origin)
	return _dir
end

Ray.__tostring = function(self)
	return string.format("Origin:(%f,%f,%f),Dir:(%f,%f, %f)", self.origin.x, self.origin.y, self.origin.z, self.direction.x, self.direction.y, self.direction.z)
end

Ray.__index = function(t, k)
    return L_Rawget(Ray, k)
end

local L_Metatable = {}

L_Metatable.__call = function(t, direction, origin)
    if direction.direction then
        return New(direction.direction, direction.origin)
    else
        return New(direction, origin)
    end
end

L_Setmetatable(Ray, L_Metatable)
return Ray
