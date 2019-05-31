--文件是自动生成,请勿手动修改.来自数据文件:marry_cost
local M = {
   [1] = {18695, 18697, 1, 1, 1, 0, 18699, 18701, 18702, 1, 42, 1},
   [2] = {18704, 18697, 2, 2, 1, 0, 18699, 18707, 18708, 18709, 43, 2},
   [3] = {18749, 18697, 3, 3, 18750, 0, 18751, 18752, 18753, 18754, 44, 3},
}
local _namesByNum = {
   Dinner = 3,
   EffectID = 4,
   Friends = 6,
   Title = 11,
   Type = 12,
}
local _namesByString = {
   Attributes = 1,
   AttType = 2,
   Fashion = 5,
   Mold = 7,
   Name = 8,
   NeedType = 9,
   RewardItemList = 10,
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
