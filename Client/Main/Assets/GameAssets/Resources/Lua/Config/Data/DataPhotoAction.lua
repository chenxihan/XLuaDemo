--文件是自动生成,请勿手动修改.来自数据文件:photoAction
local M = {
   [1] = {42155, 1, 42156},
   [2] = {42155, 2, 42156},
   [3] = {42155, 3, 42156},
   [4] = {42155, 4, 42156},
   [5] = {42155, 5, 42156},
   [6] = {42155, 6, 42156},
}
local _namesByNum = {
   Id = 2,
}
local _namesByString = {
   Action = 1,
   Name = 3,
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
