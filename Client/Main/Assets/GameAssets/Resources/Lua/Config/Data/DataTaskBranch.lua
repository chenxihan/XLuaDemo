--文件是自动生成,请勿手动修改.来自数据文件:task_branch
local M = {
}
local _namesByNum = {
   BackGroupId = 1,
   BranchId = 2,
   ConditionsType = 4,
   GainConditions = 7,
   ItemID = 8,
   OpenPanel = 10,
}
local _namesByString = {
   ConditionsDescribe = 3,
   ConditionsValue = 5,
   DemandValue = 6,
   Name = 9,
   TaskReward = 11,
   TsakDescribe = 12,
   TypeName = 13,
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
