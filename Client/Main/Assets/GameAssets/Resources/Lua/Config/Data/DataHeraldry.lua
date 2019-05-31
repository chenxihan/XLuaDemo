--文件是自动生成,请勿手动修改.来自数据文件:heraldry
local M = {
   [1] = {35034, 42987, 42986, 42985, 0, 2592000, 9, 726, 1, 54001, 11675, 8, 2592000, 42984, 1},
   [2] = {35034, 42987, 42986, 42985, 0, 2592000, 9, 726, 2, 54002, 11675, 8, 6600, 42984, 1},
   [3] = {42983, 42987, 42986, 42985, 0, 604800, 9, 725, 3, 54003, 42982, 8, 604800, 42984, 2},
}
local _namesByNum = {
   Effect = 5,
   EffectiveTime = 6,
   Gender = 7,
   Icon = 8,
   Id = 9,
   ItemId = 10,
   Part = 12,
   ProbationTime = 13,
   Type = 15,
}
local _namesByString = {
   Attribute = 1,
   AttributeDes = 2,
   Buff = 3,
   Des = 4,
   Name = 11,
   RenewPrice = 14,
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
