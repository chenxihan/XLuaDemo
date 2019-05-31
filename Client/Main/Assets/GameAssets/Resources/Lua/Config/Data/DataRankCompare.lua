--文件是自动生成,请勿手动修改.来自数据文件:Rank_compare
local M = {
   [1] = {1, 5366, 0, 3210000, 1},
   [2] = {2, 5696, 0, 3200000, 2},
   [3] = {3, 21143, 0, 0, 3},
   [4] = {4, 43051, 0, 0, 4},
   [5] = {5, 3263, 0, 0, 5},
   [6] = {6, 17061, 0, 0, 6},
   [7] = {7, 24318, 0, 0, 7},
   [8] = {8, 24094, 0, 0, 8},
   [9] = {9, 4808, 0, 0, 9},
   [10] = {10, 16893, 0, 0, 10},
   [11] = {11, 21198, 0, 0, 11},
}
local _namesByNum = {
   Id = 1,
   Pic = 3,
   Promote = 4,
   Sort = 5,
}
local _namesByString = {
   Name = 2,
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
