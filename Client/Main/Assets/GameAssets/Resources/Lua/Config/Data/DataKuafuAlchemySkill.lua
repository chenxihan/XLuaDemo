--文件是自动生成,请勿手动修改.来自数据文件:kuafu_Alchemy_skill
local M = {
   [79031] = {80089, 79031, 1},
   [79032] = {80090, 79032, 1},
   [79033] = {80091, 79033, 1},
   [79034] = {80092, 79034, 1},
   [79035] = {80085, 79035, 2},
   [79036] = {80086, 79036, 2},
   [79037] = {80087, 79037, 2},
   [79038] = {80088, 79038, 2},
}
local _namesByNum = {
   BUFF = 1,
   SkillId = 2,
   Type = 3,
}
local _namesByString = {
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
