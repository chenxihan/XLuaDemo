--文件是自动生成,请勿手动修改.来自数据文件:wing_up
local M = {
   [1] = {22117, 5, 5, 1, 5032, 22118, 1, 0, 22119, 1, 1, 500, 0},
   [2] = {22120, 60, 6, 2, 1, 1, 2, 0, 22121, 10, 5, 400, 0},
   [3] = {22122, 140, 7, 2, 8177, 22123, 3, 0, 22121, 20, 10, 300, 0},
   [4] = {22124, 296, 8, 3, 1, 1, 4, 0, 22125, 37, 23, 200, 0},
   [5] = {22126, 696, 8, 3, 22127, 22128, 5, 0, 22125, 87, 56, 200, 0},
   [6] = {22129, 900, 9, 4, 1, 1, 6, 0, 22130, 100, 62, 200, 0},
   [7] = {22131, 2200, 20, 8, 5809, 22132, 7, 0, 22130, 110, 68, 100, 0},
   [8] = {22133, 2662, 22, 10, 1, 1, 8, 0, 22130, 121, 75, 50, 0},
   [9] = {22134, 2926, 22, 10, 8182, 22135, 9, 0, 22136, 133, 82, 40, 0},
   [10] = {22137, 3504, 24, 12, 1, 1, 10, 0, 22136, 146, 90, 30, 0},
}
local _namesByNum = {
   BlessnumLimit = 2,
   BlessnumMax = 3,
   BlessnumMin = 4,
   Id = 7,
   Notice = 8,
   UpNumMax = 10,
   UpNumMin = 11,
   UpProbability = 12,
   UpRoleLevel = 13,
}
local _namesByString = {
   Attr = 1,
   Condition = 5,
   ConditionInfo = 6,
   UpItemInfo = 9,
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
