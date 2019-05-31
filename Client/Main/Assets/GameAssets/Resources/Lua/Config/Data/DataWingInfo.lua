--文件是自动生成,请勿手动修改.来自数据文件:wing_info
local M = {
   [19] = {42981, 19},
   [72] = {42980, 72},
   [73] = {42979, 73},
   [76] = {42978, 76},
   [80] = {42977, 80},
   [81] = {42976, 81},
   [115] = {42975, 115},
   [95] = {42974, 95},
   [120] = {42973, 120},
   [121] = {42972, 121},
   [126] = {42971, 126},
   [42] = {42970, 42},
   [136] = {42969, 136},
   [137] = {42968, 137},
}
local _namesByNum = {
   Id = 2,
}
local _namesByString = {
   ConditionInfo = 1,
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
