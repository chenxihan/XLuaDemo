--文件是自动生成,请勿手动修改.来自数据文件:KingFightSeasonAward
local M = {
   [1] = {19261, 1, 0, 1, 1},
   [2] = {19263, 2, 0, 4, 2},
   [3] = {19265, 3, 0, 16, 5},
   [4] = {19267, 4, 0, 32, 17},
   [101] = {19269, 101, 30, 0, 0},
   [102] = {19271, 102, 29, 0, 0},
   [103] = {19273, 103, 28, 0, 0},
   [104] = {19275, 104, 27, 0, 0},
   [105] = {19277, 105, 26, 0, 0},
   [106] = {19279, 106, 25, 0, 0},
   [107] = {19281, 107, 24, 0, 0},
   [108] = {19283, 108, 23, 0, 0},
   [109] = {19285, 109, 22, 0, 0},
   [110] = {19287, 110, 21, 0, 0},
   [111] = {19289, 111, 20, 0, 0},
   [112] = {19290, 112, 19, 0, 0},
   [113] = {19291, 113, 18, 0, 0},
   [114] = {19292, 114, 17, 0, 0},
   [115] = {19293, 115, 16, 0, 0},
   [116] = {19294, 116, 15, 0, 0},
   [117] = {19295, 117, 14, 0, 0},
   [118] = {19296, 118, 13, 0, 0},
   [119] = {19297, 119, 12, 0, 0},
   [120] = {19298, 120, 11, 0, 0},
   [121] = {19299, 121, 10, 0, 0},
   [122] = {19300, 122, 9, 0, 0},
   [123] = {19301, 123, 8, 0, 0},
   [124] = {19302, 124, 7, 0, 0},
   [125] = {19303, 125, 6, 0, 0},
   [126] = {19304, 126, 5, 0, 0},
   [127] = {19305, 127, 4, 0, 0},
   [128] = {19306, 128, 3, 0, 0},
   [129] = {19307, 129, 2, 0, 0},
   [130] = {19308, 130, 1, 0, 0},
}
local _namesByNum = {
   Feats = 2,
   KingLevel = 3,
   RankMax = 4,
   RankMin = 5,
}
local _namesByString = {
   Award = 1,
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
