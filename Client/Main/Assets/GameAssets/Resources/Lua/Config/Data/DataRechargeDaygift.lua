--文件是自动生成,请勿手动修改.来自数据文件:recharge_daygift
local M = {
   [1] = {37675, 10, 1, 80049, 2, 1, 1, 37676, 1},
   [3] = {37677, 30, 3, 80050, 2, 3, 1, 37678, 2},
   [8] = {37679, 80, 8, 80051, 2, 8, 1, 37680, 3},
}
local _namesByNum = {
   Gold = 2,
   Id = 3,
   ItemAward = 4,
   Level = 5,
   NeedRecharge = 6,
   Radio = 7,
   Vip = 9,
}
local _namesByString = {
   DesAward = 1,
   Rewards = 8,
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
