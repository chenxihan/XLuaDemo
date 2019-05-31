--文件是自动生成,请勿手动修改.来自数据文件:marry_intimacy
local M = {
   [1] = {1314, 1, 20694, 1},
   [2] = {3344, 2, 20695, 1},
   [3] = {6666, 3, 20696, 1},
   [4] = {8888, 4, 20697, 1},
   [5] = {9999, 5, 20698, 1},
   [6] = {13140, 6, 20699, 1},
   [7] = {18888, 7, 20700, 1},
   [8] = {28888, 8, 20701, 1},
   [9] = {33440, 9, 20702, 1},
   [10] = {38888, 10, 20703, 1},
}
local _namesByNum = {
   Intimacy = 1,
   Key = 2,
   Time = 4,
}
local _namesByString = {
   Reward = 3,
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
