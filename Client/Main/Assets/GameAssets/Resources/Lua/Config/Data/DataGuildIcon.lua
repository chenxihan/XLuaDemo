--文件是自动生成,请勿手动修改.来自数据文件:guild_icon
local M = {
   [1] = {479, 1},
   [2] = {480, 2},
   [3] = {481, 3},
   [4] = {482, 4},
   [5] = {483, 5},
   [6] = {484, 6},
   [7] = {485, 7},
   [8] = {486, 8},
   [9] = {487, 9},
   [10] = {488, 10},
   [11] = {489, 11},
   [12] = {490, 12},
   [13] = {491, 13},
   [14] = {492, 14},
   [15] = {493, 15},
   [16] = {494, 16},
   [17] = {495, 17},
   [18] = {496, 18},
   [19] = {497, 19},
   [20] = {498, 20},
}
local _namesByNum = {
   Icon = 1,
   Num = 2,
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
