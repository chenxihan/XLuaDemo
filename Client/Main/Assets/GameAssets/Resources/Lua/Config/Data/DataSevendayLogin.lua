--文件是自动生成,请勿手动修改.来自数据文件:sevenday_login
local M = {
   [1] = {21209, 1, 1},
   [2] = {21210, 2, 1},
   [3] = {21211, 3, 1},
   [4] = {21212, 4, 1},
   [5] = {21213, 5, 1},
   [6] = {21214, 6, 1},
   [7] = {21215, 7, 1},
}
local _namesByNum = {
   Day = 2,
}
local _namesByString = {
   Award = 1,
   Equip = 3,
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
