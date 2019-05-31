--文件是自动生成,请勿手动修改.来自数据文件:courage
local M = {
   [1] = {5, 0, 20133, 962, 1, 0, 1051000, 0, 10, 0, 0, 0, 20136},
   [2] = {21, 0, 20138, 963, 2, 10000, 1055000, 0, 0, 0, 0, 0, 4721},
   [3] = {22, 0, 20142, 974, 3, 30000, 1056000, 0, 0, 0, 0, 0, 4930},
}
local _namesByNum = {
   CloneType = 1,
   Deal = 2,
   Icon = 4,
   Id = 5,
   Max = 6,
   OpenUi = 7,
   OpenUiParam = 8,
   Param1 = 9,
   Param2 = 10,
   Param3 = 11,
   Param4 = 12,
}
local _namesByString = {
   Desc = 3,
   Title = 13,
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
