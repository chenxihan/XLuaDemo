--文件是自动生成,请勿手动修改.来自数据文件:help
local M = {
   [61000] = {33596, 61000},
   [62000] = {33597, 62000},
   [63000] = {33598, 63000},
   [104000] = {33599, 104000},
   [65000] = {33600, 65000},
   [66000] = {33601, 66000},
   [67000] = {33602, 67000},
   [112000] = {33603, 112000},
   [1] = {33604, 1},
   [1046000] = {33605, 1046000},
   [109100] = {33606, 109100},
   [2264200] = {33607, 2264200},
   [2264300] = {33608, 2264300},
   [2264400] = {33609, 2264400},
   [1057000] = {33610, 1057000},
   [1183000] = {33611, 1183000},
   [1183001] = {33612, 1183001},
   [1181000] = {33613, 1181000},
   [1049000] = {33614, 1049000},
   [1049100] = {33615, 1049100},
}
local _namesByNum = {
   Id = 2,
}
local _namesByString = {
   Content = 1,
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
