--文件是自动生成,请勿手动修改.来自数据文件:Equip_fuse
local M = {
   [1] = {1000, 4000, 5917, 50, 36849, 1, 36849, 36850, 1, 1, 1, 36851, 2500},
   [2] = {700, 3500, 36854, 40, 36855, 50, 36855, 36856, 2, 50, 1, 36857, 1500},
   [3] = {500, 3300, 36858, 30, 36860, 70, 36860, 36861, 3, 70, 3, 36862, 500},
   [4] = {300, 3000, 36864, 20, 36865, 90, 36865, 36866, 4, 90, 5, 36868, 500},
}
local _namesByNum = {
   BasicProbability = 1,
   BestProbability = 2,
   CultureProbability = 4,
   EquipLevel = 6,
   Id = 9,
   Level = 10,
   OrdnanceLevel = 11,
   PerfectProbability = 13,
}
local _namesByString = {
   Consume = 3,
   Equip = 5,
   FailBest = 7,
   FailOrdinary = 8,
   PerfectEquip = 12,
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
