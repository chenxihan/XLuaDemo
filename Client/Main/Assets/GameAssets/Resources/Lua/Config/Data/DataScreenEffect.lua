--文件是自动生成,请勿手动修改.来自数据文件:ScreenEffect
local M = {
   [1] = {1, 1, 15},
   [2] = {2, 1, 16},
   [3] = {3, 1, 17},
   [4] = {4, 1, 75},
}
local _namesByNum = {
   Id = 1,
   Pos = 2,
   Res = 3,
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
