--文件是自动生成,请勿手动修改.来自数据文件:bossGodRuinsMonster
local M = {
   [67001] = {5160, 67001, 17554},
   [67002] = {5160, 67002, 17555},
   [67003] = {5160, 67003, 17556},
   [67004] = {5160, 67004, 17557},
   [67005] = {5160, 67005, 17558},
   [67006] = {5160, 67006, 17559},
   [67007] = {5160, 67007, 17560},
   [67008] = {5160, 67008, 17561},
   [67017] = {5161, 67017, 17554},
   [67018] = {5161, 67018, 17555},
   [67019] = {5161, 67019, 17556},
   [67020] = {5161, 67020, 17557},
   [67021] = {5161, 67021, 17558},
   [67022] = {5161, 67022, 17559},
   [67023] = {5161, 67023, 17560},
   [67024] = {5161, 67024, 17561},
   [67033] = {5162, 67033, 17554},
   [67034] = {5162, 67034, 17555},
   [67035] = {5162, 67035, 17556},
   [67036] = {5162, 67036, 17557},
   [67037] = {5162, 67037, 17558},
   [67038] = {5162, 67038, 17559},
   [67039] = {5162, 67039, 17560},
   [67040] = {5162, 67040, 17561},
}
local _namesByNum = {
   CloneID = 1,
   Id = 2,
}
local _namesByString = {
   Pos = 3,
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
