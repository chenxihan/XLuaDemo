--文件是自动生成,请勿手动修改.来自数据文件:diamondinvest_level
local M = {
   [1] = {680, 1, 2, 2},
   [2] = {1280, 2, 2, 2},
   [3] = {1880, 3, 2, 2},
}
local _namesByNum = {
   Diamond = 1,
   InvestLevel = 2,
   Level = 3,
   Vip = 4,
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
