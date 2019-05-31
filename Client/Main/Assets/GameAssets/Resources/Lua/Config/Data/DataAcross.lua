--文件是自动生成,请勿手动修改.来自数据文件:across
local M = {
   [1] = {1, 2, 100},
   [2] = {2, 4, 200},
   [3] = {3, 8, 300},
   [4] = {4, 16, 400},
   [5] = {5, 32, 500},
}
local _namesByNum = {
   Id = 1,
   ServerNum = 2,
   WorldLevel = 3,
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
