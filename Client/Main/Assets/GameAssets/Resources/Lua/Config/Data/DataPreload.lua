--文件是自动生成,请勿手动修改.来自数据文件:Preload
local M = {
   [1] = {1, 36214, 5},
   [2] = {2, 36215, 5},
   [3] = {3, 36216, 6},
   [4] = {4, 36217, 6},
   [5] = {5, 36218, 4},
   [6] = {6, 36219, 4},
   [7] = {7, 36220, 8},
   [8] = {8, 36221, 5},
   [9] = {9, 36222, 9},
   [10] = {10, 36223, 9},
   [11] = {11, 36224, 9},
}
local _namesByNum = {
   Id = 1,
   Type = 3,
}
local _namesByString = {
   Path = 2,
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
