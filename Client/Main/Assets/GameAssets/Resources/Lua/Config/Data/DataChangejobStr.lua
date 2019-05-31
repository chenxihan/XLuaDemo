--文件是自动生成,请勿手动修改.来自数据文件:changejobStr
local M = {
   [186] = {186, 37649},
   [187] = {187, 37650},
   [188] = {188, 37651},
   [189] = {189, 37652},
   [190] = {190, 37653},
   [191] = {191, 37654},
}
local _namesByNum = {
   ID = 1,
}
local _namesByString = {
   Language = 2,
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
