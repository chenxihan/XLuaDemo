--文件是自动生成,请勿手动修改.来自数据文件:guild_invasion
local M = {
   [1] = {1, 21227},
   [5] = {5, 21228},
   [20] = {20, 21229},
   [1000] = {1000, 21230},
}
local _namesByNum = {
   Id = 1,
}
local _namesByString = {
   Ranking = 2,
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
