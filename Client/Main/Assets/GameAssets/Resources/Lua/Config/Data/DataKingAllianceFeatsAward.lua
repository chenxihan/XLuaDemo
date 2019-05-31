--文件是自动生成,请勿手动修改.来自数据文件:kingAllianceFeatsAward
local M = {
   [1000] = {43000, 1000},
   [2000] = {42999, 2000},
   [3000] = {42998, 3000},
   [4000] = {42997, 4000},
   [5000] = {42996, 5000},
   [6000] = {42995, 6000},
   [8000] = {42994, 8000},
   [10000] = {42993, 10000},
   [12000] = {42992, 12000},
   [14000] = {42991, 14000},
   [16000] = {42990, 16000},
   [18000] = {42989, 18000},
   [20000] = {42988, 20000},
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
