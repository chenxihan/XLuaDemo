--文件是自动生成,请勿手动修改.来自数据文件:kuafu_Alchemy
local M = {
   [1] = {150, 1, 100, 114},
   [2] = {150, 2, 100, 112},
   [3] = {150, 3, 100, 110},
   [4] = {150, 4, 100, 108},
   [5] = {150, 5, 100, 106},
   [6] = {150, 6, 100, 104},
   [7] = {150, 7, 100, 102},
   [8] = {150, 8, 100, 100},
}
local _namesByNum = {
   DoubleProfit = 1,
   Id = 2,
   OrdinaryProfit = 3,
   PlunderProfit = 4,
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
