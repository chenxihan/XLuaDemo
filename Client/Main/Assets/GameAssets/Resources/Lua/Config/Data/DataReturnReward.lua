--文件是自动生成,请勿手动修改.来自数据文件:returnReward
local M = {
   [1] = {7, 19416, 19417, 1, 19418},
}
local _namesByNum = {
   Day = 1,
   ID = 4,
}
local _namesByString = {
   Des1 = 2,
   Des2 = 3,
   QRewardItem = 5,
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
