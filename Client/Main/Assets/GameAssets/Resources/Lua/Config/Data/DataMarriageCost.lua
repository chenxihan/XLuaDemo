--文件是自动生成,请勿手动修改.来自数据文件:marriage_cost
local M = {
   [1] = {1, 1, 1, 200, 18699, 18701, 33895, 1, 1},
   [2] = {2, 2, 1, 200, 18699, 18707, 33896, 33897, 2},
   [3] = {3, 3, 18750, 200, 18751, 18752, 33898, 33897, 3},
}
local _namesByNum = {
   Dinner = 1,
   EffectID = 2,
   Friends = 4,
   Type = 9,
}
local _namesByString = {
   Fashion = 3,
   Mold = 5,
   Name = 6,
   NeedType = 7,
   RewardItemList = 8,
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
