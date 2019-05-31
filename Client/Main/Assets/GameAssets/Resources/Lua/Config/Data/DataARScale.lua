--文件是自动生成,请勿手动修改.来自数据文件:ARScale
local M = {
   [101] = {40, 101, 20780, 5},
   [102] = {40, 102, 17595, 4},
   [103] = {30, 103, 17610, 4},
   [104] = {45, 104, 17599, 6},
   [105] = {60, 105, 17614, 7},
   [106] = {50, 106, 20781, 7},
   [107] = {50, 107, 17624, 7},
   [108] = {50, 108, 20782, 10},
   [109] = {70, 109, 17633, 10},
   [110] = {70, 110, 17628, 10},
   [111] = {35, 111, 17606, 4},
}
local _namesByNum = {
   Arcamera = 1,
   Id = 2,
   Shadowcamera = 4,
}
local _namesByString = {
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
