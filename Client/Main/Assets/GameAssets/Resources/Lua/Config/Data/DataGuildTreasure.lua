--文件是自动生成,请勿手动修改.来自数据文件:guild_treasure
local M = {
   [1] = {1, 1, 1, 15904},
   [2] = {2, 5, 2, 15905},
   [6] = {6, 10, 6, 15906},
   [11] = {11, 60, 11, 15907},
}
local _namesByNum = {
   Id = 1,
   Rankmax = 2,
   Rankmix = 3,
}
local _namesByString = {
   Reward = 4,
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
