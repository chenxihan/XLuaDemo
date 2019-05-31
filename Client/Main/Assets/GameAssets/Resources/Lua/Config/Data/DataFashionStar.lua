--文件是自动生成,请勿手动修改.来自数据文件:FashionStar
local M = {
   [1] = {19535, 5, 5, 1, 1, 1, 19536, 0, 5002, 16225, 19537, 1, 1, 500},
   [2] = {19538, 60, 6, 2, 1, 2, 19539, 0, 5002, 16225, 19540, 10, 5, 400},
   [3] = {19541, 140, 7, 2, 1, 3, 19542, 0, 5002, 16225, 19540, 20, 10, 300},
   [4] = {19543, 296, 8, 3, 1, 4, 19544, 1, 5002, 16225, 19545, 37, 23, 200},
   [5] = {19546, 696, 8, 3, 1, 5, 19547, 1, 5002, 16225, 19545, 87, 56, 200},
   [6] = {19548, 900, 9, 4, 2, 6, 19549, 1, 5002, 16225, 19550, 100, 62, 200},
   [7] = {19551, 2200, 20, 8, 2, 7, 19552, 1, 5002, 16225, 19550, 110, 68, 100},
   [8] = {19553, 2662, 22, 10, 3, 8, 19554, 1, 5002, 16225, 19550, 121, 75, 50},
   [9] = {19555, 2926, 22, 10, 3, 9, 19556, 1, 5002, 16225, 19557, 133, 82, 40},
   [10] = {16242, 3504, 24, 12, 3, 10, 19558, 1, 5002, 16225, 19557, 146, 90, 30},
}
local _namesByNum = {
   BlessnumLimit = 2,
   BlessnumMax = 3,
   BlessnumMin = 4,
   GenderClass = 5,
   Layer = 6,
   Notice = 8,
   PanelShowId = 9,
   UpNumMax = 12,
   UpNumMin = 13,
   UpProbability = 14,
}
local _namesByString = {
   AddAttribute = 1,
   Name = 7,
   QNameColor = 10,
   UpItem = 11,
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
