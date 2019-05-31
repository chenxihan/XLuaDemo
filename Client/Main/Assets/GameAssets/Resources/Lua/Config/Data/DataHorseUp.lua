--文件是自动生成,请勿手动修改.来自数据文件:horse_up
local M = {
   [0] = {92, 5, 5, 1, 10000, 250, 0, 0, 2, 0, 175, 3, 0, 4, 1, 1, 500},
   [1] = {5, 5, 5, 1, 10000, 250, 0, 1, 2, 0, 175, 3, 0, 4, 1, 1, 500},
   [2] = {6, 60, 6, 2, 10000, 200, 0, 2, 7, 0, 176, 3, 0, 8, 10, 5, 400},
   [3] = {9, 140, 7, 2, 10000, 200, 0, 3, 10, 0, 178, 3, 0, 8, 20, 10, 300},
   [4] = {11, 296, 8, 3, 10000, 250, 0, 4, 12, 0, 182, 3, 0, 13, 37, 23, 200},
   [5] = {14, 696, 8, 3, 10000, 200, 0, 5, 15, 1, 180, 3, 0, 13, 87, 56, 200},
   [6] = {16, 900, 9, 4, 10000, 400, 0, 6, 17, 1, 181, 3, 0, 18, 100, 62, 200},
   [7] = {19, 2200, 20, 8, 10000, 350, 0, 7, 20, 1, 177, 3, 0, 18, 110, 68, 100},
   [8] = {21, 2662, 22, 10, 10000, 300, 0, 8, 22, 1, 174, 3, 0, 18, 121, 75, 50},
   [9] = {23, 2926, 22, 10, 10000, 300, 0, 9, 24, 1, 179, 3, 0, 25, 133, 82, 40},
   [10] = {26, 3504, 24, 12, 10000, 300, 0, 10, 27, 1, 179, 3, 0, 25, 146, 90, 30},
}
local _namesByNum = {
   BlessnumLimit = 2,
   BlessnumMax = 3,
   BlessnumMin = 4,
   CameraDis = 5,
   CameraSize = 6,
   CanFly = 7,
   Layer = 8,
   Notice = 10,
   PanelHeadId = 11,
   UpFigureLevel = 13,
   UpNumMax = 15,
   UpNumMin = 16,
   UpProbability = 17,
}
local _namesByString = {
   Attr = 1,
   Name = 9,
   QNameColor = 12,
   UpItemInfo = 14,
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
