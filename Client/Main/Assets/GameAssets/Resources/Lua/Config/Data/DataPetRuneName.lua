--文件是自动生成,请勿手动修改.来自数据文件:PetRuneName
local M = {
   [1] = {1, 33902, 33903},
   [2] = {2, 33904, 33905},
   [3] = {3, 22094, 33906},
   [4] = {4, 33907, 33908},
   [5] = {5, 22098, 33909},
   [6] = {6, 33910, 33911},
}
local _namesByNum = {
   Id = 1,
}
local _namesByString = {
   Name = 2,
   TexRes = 3,
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
