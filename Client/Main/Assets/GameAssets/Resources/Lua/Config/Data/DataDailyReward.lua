--文件是自动生成,请勿手动修改.来自数据文件:daily_reward
local M = {
   [1] = {1, 20, 21216},
   [2] = {2, 40, 21217},
   [3] = {3, 60, 21218},
   [4] = {4, 80, 21217},
   [5] = {5, 100, 21219},
}
local _namesByNum = {
   Id = 1,
   QNeedintegral = 2,
}
local _namesByString = {
   QRewardItem = 3,
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
