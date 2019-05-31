--文件是自动生成,请勿手动修改.来自数据文件:active_reward
local M = {
   [20] = {20, 21216, 1},
   [40] = {40, 21217, 1},
   [60] = {60, 21218, 1},
   [80] = {80, 21217, 1},
   [100] = {100, 21219, 1},
}
local _namesByNum = {
   QNeedintegral = 1,
}
local _namesByString = {
   QRewardItem = 2,
   QRewardSeven = 3,
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
