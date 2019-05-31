--文件是自动生成,请勿手动修改.来自数据文件:marriage_dinner
local M = {
   [1] = {10000, 36858, 5000, 839, 20, 1, 42218, 1, 1},
   [2] = {20000, 9834, 10000, 840, 20, 2, 42219, 1, 1},
   [3] = {30000, 19422, 15000, 841, 20, 3, 42220, 1, 1},
}
local _namesByNum = {
   Charm = 1,
   GiftMoney = 3,
   Icon = 4,
   JoinCount = 5,
   Level = 6,
   Radio = 8,
}
local _namesByString = {
   CostValue = 2,
   Name = 7,
   Reward = 9,
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
