--文件是自动生成,请勿手动修改.来自数据文件:diamondinvest
local M = {
   [1] = {1, 680, 1280, 1880},
   [2] = {2, 136, 256, 376},
   [3] = {3, 204, 384, 564},
   [4] = {4, 272, 512, 752},
   [5] = {5, 340, 640, 940},
   [6] = {6, 408, 768, 1128},
   [7] = {7, 476, 896, 1316},
   [8] = {8, 544, 1024, 1504},
   [9] = {9, 612, 1152, 1692},
   [10] = {10, 612, 1152, 1692},
   [11] = {11, 612, 1152, 1692},
   [12] = {12, 612, 1152, 1692},
   [13] = {13, 612, 1152, 1692},
   [14] = {14, 680, 1280, 1880},
}
local _namesByNum = {
   Day = 1,
   Level1 = 2,
   Level2 = 3,
   Level3 = 4,
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
