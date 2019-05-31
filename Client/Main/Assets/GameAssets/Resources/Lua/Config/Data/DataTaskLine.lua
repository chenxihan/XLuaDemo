--文件是自动生成,请勿手动修改.来自数据文件:task_Line
local M = {
   [1001] = {13911, 13912, 13913, 13914, 13915, 13915, 2, 1, 13916, 0, 0, 100, 1002, 0, 1, 1, 1, 1, 13917, 1, 13918, 500802, -1, 1001, 13919, 1},
}
local _namesByNum = {
   GainConditions = 7,
   Loop = 8,
   OpenPanel = 10,
   OpenPanelParam = 11,
   PathMap = 12,
   PostTaskId = 13,
   PromptIcon = 14,
   TapeID = 20,
   TaskTalkEnd = 22,
   TaskTalkStart = 23,
   TaskID = 24,
   Type = 26,
}
local _namesByString = {
   ConditionsDescribe = 1,
   ConditionsDescribeOver = 2,
   ConditionsValue = 3,
   Endpath = 4,
   Equip = 5,
   EquipHide = 6,
   Name = 9,
   Rewards = 15,
   RewardsHide = 16,
   SetActBranch = 17,
   SetActSkill = 18,
   TapeName = 19,
   Target = 21,
   TsakDescribe = 25,
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
