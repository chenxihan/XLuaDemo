--文件是自动生成,请勿手动修改.来自数据文件:recharge_daily_total
local M = {
   [1] = {42226, 1, 1, 60, 1},
   [2] = {42227, 1, 2, 300, 1},
   [3] = {42228, 1, 3, 680, 1},
   [4] = {42229, 1, 4, 300, 2},
   [5] = {42230, 2, 5, 300, 2},
   [6] = {42231, 3, 6, 300, 2},
}
local _namesByNum = {
   Day = 2,
   ID = 3,
   Money = 4,
   Position = 5,
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
