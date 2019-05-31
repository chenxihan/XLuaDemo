--文件是自动生成,请勿手动修改.来自数据文件:elves_advanced
local M = {
   [1] = {16223, 5, 5, 1, 52, 42, 20, 1, 1, 16224, 0, 55, 16225, 50029, 1, 0, 10000},
   [2] = {16226, 60, 6, 2, 59, 49, 40, 2, 2, 16227, 0, 56, 16225, 50029, 10, 5, 400},
   [3] = {16228, 140, 7, 2, 58, 48, 40, 2, 3, 16229, 0, 57, 16225, 50029, 20, 10, 300},
   [4] = {16230, 296, 8, 3, 61, 51, 60, 3, 4, 16231, 0, 58, 16225, 50029, 37, 23, 200},
   [5] = {16232, 696, 8, 3, 57, 47, 60, 3, 5, 16233, 0, 59, 16225, 50029, 87, 56, 200},
   [6] = {16234, 900, 9, 4, 56, 46, 80, 4, 6, 16235, 1, 60, 16225, 50029, 100, 62, 200},
   [7] = {16236, 2200, 20, 8, 53, 43, 80, 4, 7, 16237, 1, 61, 16225, 50029, 110, 68, 100},
   [8] = {16238, 2662, 22, 10, 54, 44, 80, 4, 8, 16239, 1, 62, 16225, 50029, 121, 75, 50},
   [9] = {16240, 2926, 22, 10, 55, 45, 100, 5, 9, 16241, 1, 63, 16225, 50029, 133, 82, 40},
   [10] = {16242, 3504, 24, 12, 60, 50, 100, 5, 10, 16243, 1, 64, 16225, 50029, 146, 90, 30},
}
local _namesByNum = {
   BlessnumLimit = 2,
   BlessnumMax = 3,
   BlessnumMin = 4,
   CatchSelfRes = 5,
   CatchVfxRes = 6,
   GoldNum = 7,
   ItemNum = 8,
   Layer = 9,
   Notice = 11,
   PanelShowId = 12,
   UpItem = 14,
   UpNumMax = 15,
   UpNumMin = 16,
   UpProbability = 17,
}
local _namesByString = {
   AddAttribute = 1,
   Name = 10,
   QNameColor = 13,
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
