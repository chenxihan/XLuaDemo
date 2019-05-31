--文件是自动生成,请勿手动修改.来自数据文件:GroundBuff
local M = {
   [1] = {3000, 1, 5000, 5, 0, 1, 100, 39},
   [2] = {3000, 1, 5001, 0, 0, 2, 100, 40},
   [3] = {3000, 1, 5002, 0, 0, 3, 100, 41},
   [4] = {1000, 30, 5004, 8, -1, 4, 8000, 62},
   [5] = {3000, 1, 5005, 2, 0, 5, 100, 39},
   [6] = {3000, 1, 5006, 2, 0, 6, 100, 40},
   [7] = {3000, 1, 5007, 2, 0, 7, 100, 41},
   [8] = {3000, 9999, 80056, 8, -1, 8, 15000, 103},
}
local _namesByNum = {
   ActiveStep = 1,
   ActiveTimes = 2,
   BuffId = 3,
   DisValue = 4,
   GroupNo = 5,
   Id = 6,
   LogicBodySize = 7,
   Res = 8,
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
