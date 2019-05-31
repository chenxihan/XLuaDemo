--文件是自动生成,请勿手动修改.来自数据文件:CityWarAward
local M = {
   [0] = {33899, 33899, 33899, 0, 33899, 33899, 0, 33899, 33900, 0, 0, 0},
   [1] = {33901, 33901, 33901, 1, 33901, 33901, 0, 33901, 1, 0, 20, 100},
}
local _namesByNum = {
   Type = 4,
   WinMemberTitle = 7,
   WinOwnerTitle = 10,
   YuyueAddValue = 11,
   YuyueBaseValue = 12,
}
local _namesByString = {
   DayAward = 1,
   LoseAward = 2,
   MonthAward = 3,
   WeekAward = 5,
   WinMemberAward = 6,
   WinOwnerAward = 8,
   WinOwnerFashion = 9,
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
