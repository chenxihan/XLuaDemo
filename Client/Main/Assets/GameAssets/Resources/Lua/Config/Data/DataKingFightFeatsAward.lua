--文件是自动生成,请勿手动修改.来自数据文件:KingFightFeatsAward
local M = {
   [500] = {33828, 500},
   [1000] = {33829, 1000},
   [1500] = {33830, 1500},
   [2000] = {33831, 2000},
   [2500] = {33832, 2500},
   [3000] = {33833, 3000},
   [4000] = {33834, 4000},
   [5000] = {33835, 5000},
   [6000] = {33836, 6000},
   [7000] = {33837, 7000},
   [8000] = {33838, 8000},
   [9000] = {33839, 9000},
   [10000] = {33840, 10000},
}
local _namesByNum = {
   Feats = 2,
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
