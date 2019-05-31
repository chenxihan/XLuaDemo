--文件是自动生成,请勿手动修改.来自数据文件:marriage_zodiac
local M = {
   [1] = {20799, 1, 20800, 1},
   [2] = {20801, 2, 20802, 1},
   [3] = {20803, 3, 20804, 1},
   [4] = {20805, 4, 20806, 1},
   [5] = {20807, 5, 20808, 1},
   [6] = {20809, 6, 20810, 1},
   [7] = {20811, 7, 20812, 1},
   [8] = {20813, 8, 20814, 1},
   [9] = {20815, 9, 20816, 1},
   [10] = {20817, 10, 20818, 1},
   [11] = {20819, 11, 20820, 1},
   [12] = {20821, 12, 20822, 1},
}
local _namesByNum = {
   Level = 2,
   Radio = 4,
}
local _namesByString = {
   Att = 1,
   Name = 3,
}
local mt = {}
mt.__index = function (t,key)
    local _value = _namesByNum[key]
    if _value ~= nil then
        return t[_value]
    end
    _value = _namesByString[key]
    if _value ~= nil then
        return StringDefines[t[_value]]
    end
    if key ~= "_OnCopyAfter_" then
        Debug.LogError(string.format("不存在 key = %s", key))
    end
end
for _,v in pairs(M) do
    setmetatable(v,mt)
end
return M
