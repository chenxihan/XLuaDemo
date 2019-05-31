--文件是自动生成,请勿手动修改.来自数据文件:vip
local M = {
   [0] = {0, 0, 22160, 0, 685, 685, 0, 0, 685, 0, 0},
   [99] = {1, 1, 22161, 0, 22162, 22163, 99, 60, 5058, 300, 30},
   [999] = {1, 1, 22164, 1006, 1, 22165, 999, 60, 22166, 0, -1},
}
local _namesByNum = {
   CanPasswordSell = 1,
   CanSell = 2,
   Exp = 4,
   Level = 7,
   MaxPhysical = 8,
   NeedRecharge = 10,
   Time = 11,
}
local _namesByString = {
   Des = 3,
   Gift = 5,
   Icon = 6,
   Name = 9,
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
