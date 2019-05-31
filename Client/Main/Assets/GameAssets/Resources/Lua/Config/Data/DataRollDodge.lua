--文件是自动生成,请勿手动修改.来自数据文件:RollDodge
local M = {
   [1] = {5000, 400, 1, 700, 2000},
   [2] = {5000, 400, 2, 710, 2000},
   [3] = {5000, 400, 3, 720, 2000},
   [4] = {5000, 400, 4, 730, 2000},
   [5] = {5000, 400, 5, 740, 2000},
   [6] = {5000, 400, 6, 750, 2000},
   [7] = {5000, 400, 7, 760, 2000},
   [8] = {5000, 400, 8, 770, 2000},
   [9] = {5000, 400, 9, 780, 2000},
   [10] = {5000, 400, 10, 800, 2000},
}
local _namesByNum = {
   CdTime = 1,
   ExecuteTime = 2,
   Level = 3,
   MaxDis = 4,
   SuperArmorTime = 5,
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
