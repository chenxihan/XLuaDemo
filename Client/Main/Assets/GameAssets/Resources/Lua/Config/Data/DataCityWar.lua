--文件是自动生成,请勿手动修改.来自数据文件:CityWar
local M = {
   [1] = {64503, 1, 4971, 20714, 0},
   [2] = {64500, 2, 20716, 20774, 1},
   [3] = {64501, 3, 20775, 20774, 1},
   [4] = {64502, 4, 20776, 20774, 1},
}
local _namesByNum = {
   CloneID = 1,
   Id = 2,
   Type = 5,
}
local _namesByString = {
   Name = 3,
   ResTex = 4,
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
