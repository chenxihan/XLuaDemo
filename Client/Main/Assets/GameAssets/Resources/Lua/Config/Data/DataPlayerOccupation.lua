--文件是自动生成,请勿手动修改.来自数据文件:PlayerOccupation
local M = {
   [0] = {1, 22180, 18561, 0, 22181},
   [1] = {0, 22182, 18565, 1, 22183},
   [2] = {0, 22184, 8527, 2, 22185},
   [3] = {0, 22184, 8591, 3, 22185},
   [4] = {1, 22184, 8622, 4, 22185},
   [5] = {0, 22184, 22186, 5, 22185},
}
local _namesByNum = {
   AtkType = 1,
   Occ = 4,
}
local _namesByString = {
   Introduction = 2,
   Name = 3,
   Special = 5,
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
