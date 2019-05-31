--文件是自动生成,请勿手动修改.来自数据文件:AutoUseMedicine
local M = {
   [1] = {1, 49, 1, 205001, 1100},
   [2] = {2, 149, 50, 205002, 1101},
   [3] = {3, 179, 150, 205003, 1102},
   [4] = {4, 219, 180, 205004, 1103},
   [5] = {5, 299, 220, 205005, 1104},
   [6] = {6, 999, 300, 205006, 1105},
   [7] = {7, 0, 0, 0, 0},
}
local _namesByNum = {
   Id = 1,
   LevelMap = 2,
   LevelMin = 3,
   ShopId = 4,
   UseItemid = 5,
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
