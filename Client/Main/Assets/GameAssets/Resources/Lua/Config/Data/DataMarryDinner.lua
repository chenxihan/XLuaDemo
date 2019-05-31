--文件是自动生成,请勿手动修改.来自数据文件:marry_dinner
local M = {
   [1] = {111, 1, 42218, 42955},
   [2] = {111, 2, 42219, 42954},
   [3] = {111, 3, 42220, 42953},
}
local _namesByNum = {
   CloneId = 1,
   Level = 2,
}
local _namesByString = {
   Name = 3,
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
