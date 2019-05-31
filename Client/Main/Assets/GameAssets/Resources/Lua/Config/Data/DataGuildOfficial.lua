--文件是自动生成,请勿手动修改.来自数据文件:guild_official
local M = {
   [0] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 11244, 1000, 0, 0},
   [1] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 1, 1, 11248, 1000, 0, 0},
   [2] = {1, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 1, 0, 2, 1, 20777, 3, 0, 0},
   [3] = {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 1, 1, 3, 1, 20778, 3, 1, 1},
   [4] = {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 4, 1, 20779, 1, 1, 1},
}
local _namesByNum = {
   CanAgree = 1,
   CanAlter = 2,
   CanAutoClean = 3,
   CanCall = 4,
   CanDestory = 5,
   CanHan = 6,
   CanInvite = 7,
   CanKick = 8,
   CanSetOfficial = 9,
   CanUp = 10,
   CityMatch = 11,
   DistributionItme = 12,
   GuildFighting = 13,
   KuafuMatch = 14,
   Level = 15,
   ModifyOfficeAccording = 16,
   Num = 18,
   ResearchSkill = 19,
   Voice = 20,
}
local _namesByString = {
   Name = 17,
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
