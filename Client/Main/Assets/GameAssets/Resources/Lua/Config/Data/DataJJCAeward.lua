--文件是自动生成,请勿手动修改.来自数据文件:JJCAeward
local M = {
   [1] = {1, 4674, 15643},
   [2] = {2, 14789, 43012},
   [3] = {3, 13078, 15624},
   [4] = {4, 43011, 43010},
   [5] = {5, 43009, 15604},
   [6] = {6, 43008, 43007},
   [7] = {7, 43006, 15585},
   [8] = {8, 43005, 43004},
   [9] = {9, 43003, 15565},
   [10] = {10, 43002, 43001},
}
local _namesByNum = {
   Id = 1,
}
local _namesByString = {
   Rank = 2,
   Reward = 3,
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
