--文件是自动生成,请勿手动修改.来自数据文件:kaifu_thousand_people_up
local M = {
   [1] = {17647, 1, 17648, 30, 17649},
   [2] = {17650, 2, 17651, 20, 17652},
   [3] = {17653, 3, 17654, 10, 17655},
   [4] = {17656, 4, 17657, 10, 17658},
   [5] = {17659, 5, 17660, 5, 17661},
   [6] = {17662, 6, 17663, 3, 17664},
}
local _namesByNum = {
   ID = 2,
   Num = 4,
}
local _namesByString = {
   ConditionsValue = 1,
   Name = 3,
   Reward = 5,
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
