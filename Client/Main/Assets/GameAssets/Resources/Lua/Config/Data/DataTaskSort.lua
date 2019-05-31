--文件是自动生成,请勿手动修改.来自数据文件:TaskSort
local M = {
   [0] = {10, 30, 0},
   [1] = {40, 120, 1},
   [2] = {50, 201, 2},
   [3] = {60, 150, 3},
   [4] = {90, 180, 4},
   [5] = {100, 190, 5},
   [6] = {70, 160, 6},
   [7] = {80, 170, 7},
   [8] = {9, 8, 8},
   [9] = {110, 200, 9},
   [11] = {59, 149, 11},
   [12] = {2, 1, 12},
}
local _namesByNum = {
   FinishValue = 1,
   NotFinishValue = 2,
   TaskType = 3,
}
local _namesByString = {
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
