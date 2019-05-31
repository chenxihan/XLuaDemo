--文件是自动生成,请勿手动修改.来自数据文件:task_battlefield
local M = {
}
local _namesByNum = {
   Calculate = 1,
   Camp = 2,
   CanPathfinding = 3,
   GoalMap = 7,
   GroupID = 8,
   Id = 9,
   LevelMax = 10,
   LevelMin = 11,
   OpenUI = 15,
   TaskType = 22,
}
local _namesByString = {
   Describe = 4,
   FillStarcost = 5,
   Goal = 6,
   Map = 12,
   Name = 13,
   Num = 14,
   Rewards1 = 16,
   Rewards2 = 17,
   Rewards3 = 18,
   Rewards4 = 19,
   Rewards5 = 20,
   Star = 21,
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
