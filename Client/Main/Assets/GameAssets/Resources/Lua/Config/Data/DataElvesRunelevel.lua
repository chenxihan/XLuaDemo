--文件是自动生成,请勿手动修改.来自数据文件:elves_runelevel
local M = {
   [2] = {18198, 2, 1},
   [3] = {18198, 3, 1},
   [4] = {18199, 4, 2},
   [5] = {18199, 5, 2},
   [6] = {18200, 6, 3},
   [7] = {18200, 7, 3},
   [8] = {18201, 8, 4},
   [9] = {18202, 9, 5},
   [10] = {18203, 10, 6},
}
local _namesByNum = {
   ID = 2,
   Num = 3,
}
local _namesByString = {
   AddAttribute = 1,
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
