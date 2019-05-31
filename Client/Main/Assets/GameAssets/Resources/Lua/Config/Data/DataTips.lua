--文件是自动生成,请勿手动修改.来自数据文件:Tips
local M = {
   [1] = {1, 19120},
   [2] = {2, 19121},
   [3] = {3, 19122},
   [4] = {4, 19123},
   [5] = {5, 19124},
   [6] = {6, 19125},
   [7] = {7, 19126},
   [8] = {8, 19127},
   [9] = {9, 19128},
   [10] = {10, 19129},
   [11] = {11, 19130},
   [12] = {12, 19131},
   [13] = {13, 19132},
}
local _namesByNum = {
   Id = 1,
}
local _namesByString = {
   Tips = 2,
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
