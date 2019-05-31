--文件是自动生成,请勿手动修改.来自数据文件:pet_addattribute
local M = {
   [1000] = {11873, 1000, 10},
   [1001] = {33889, 1001, 30},
   [1002] = {11681, 1002, 50},
   [1003] = {33890, 1003, 70},
   [1004] = {33891, 1004, 100},
   [1005] = {33892, 1005, 120},
   [1006] = {33893, 1006, 150},
   [1007] = {33894, 1007, 170},
   [1008] = {11878, 1008, 200},
}
local _namesByNum = {
   Id = 2,
   Level = 3,
}
local _namesByString = {
   AddAttribute = 1,
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
