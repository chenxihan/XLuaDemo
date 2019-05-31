--文件是自动生成,请勿手动修改.来自数据文件:daily
local M = {
   [17] = {10, 0, 1, 0, 6886, 5336, 685, 42598, 1, 685, 876, 17, 1, 0, 20, 42599, 685, 50, 685, 6873, 1, 1222000, 6889, 5, 0, 0, 6890, 1, 0, 0, 685, 6892, 6983, 2, 1},
   [18] = {10, 0, 1, 0, 6886, 5336, 4674, 42600, 1, 685, 876, 18, 1, 0, 20, 42601, 685, 50, 685, 6873, 1, 1221000, 6889, 5, 0, 0, 6890, 1, 0, 0, 685, 6892, 6983, 2, 1},
   [19] = {10, 0, 1, 0, 6886, 5336, 685, 42602, 1, 685, 876, 19, 1, 0, 20, 4983, 685, 50, 685, 6873, 1, 1223000, 6889, 5, 0, 0, 6890, 1, 0, 0, 685, 6892, 1, 2, 1},
   [20] = {5, 1, 1, 0, 7017, 42603, 685, 7018, 3, 685, 876, 20, 1, 0, 5, 42604, 685, 50, 685, 6873, 1, 2470000, 7020, 5, 0, 0, 42605, 1, 0, 0, 685, 6877, 7022, 1, 1},
   [21] = {5, 1, 1, 0, 7017, 42603, 685, 7018, 3, 685, 876, 21, 1, 0, 5, 5087, 685, 50, 685, 6873, 1, 2460000, 7020, 5, 0, 0, 42605, 1, 0, 0, 685, 6877, 42606, 1, 1},
}
local _namesByNum = {
   ActiveValue = 1,
   AddOnMenu = 2,
   Canshow = 3,
   CloneID = 4,
   Fbtype = 9,
   Icon = 11,
   Id = 12,
   IfGono = 13,
   IfPush = 14,
   MaxValue = 15,
   OpenLevel = 18,
   OpenType = 21,
   OpenUI = 22,
   PushAdvance = 24,
   PushType = 25,
   Refresh = 26,
   Sort = 28,
   Sweep = 29,
   SweepLevel = 30,
   Times = 34,
   Type = 35,
}
local _namesByString = {
   Condition = 5,
   Conditiondes = 6,
   DelayDays = 7,
   Description = 8,
   FoundTeam = 10,
   Name = 16,
   NpcID = 17,
   OpenTime = 19,
   OpenTimeDes = 20,
   Production = 23,
   Reward = 27,
   Task = 31,
   Team = 32,
   Time = 33,
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
