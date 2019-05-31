--文件是自动生成,请勿手动修改.来自数据文件:sign_reward
local M = {
   [0] = {19856, 0},
   [1] = {19856, 1},
   [2] = {19856, 2},
   [3] = {19856, 3},
   [4] = {19856, 4},
   [5] = {19856, 5},
   [6] = {19856, 6},
   [7] = {19856, 7},
   [8] = {19856, 8},
   [9] = {19856, 9},
   [10] = {19856, 10},
   [11] = {19856, 11},
   [12] = {19856, 12},
}
local _namesByNum = {
   Month = 2,
}
local _namesByString = {
   Award = 1,
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
