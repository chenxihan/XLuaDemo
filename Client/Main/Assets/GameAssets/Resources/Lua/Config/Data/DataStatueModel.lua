--文件是自动生成,请勿手动修改.来自数据文件:statue_model
local M = {
   [100] = {0, 0, 100, 101, 6500, 6501, 6502, 6503, 6504, 6505, 10111, 100, 1, 136, 75},
   [101] = {0, -90, 101, 101, 6500, 6501, 6502, 6503, 6504, 6505, 10112, 100, 1, 127, 87},
   [102] = {0, -90, 102, 101, 6500, 6501, 6502, 6503, 6504, 6505, 10113, 100, 1, 127, 82},
   [103] = {0, 90, 103, 101, 6500, 6501, 6502, 6503, 6504, 6505, 10114, 100, 1, 118, 91},
   [104] = {0, 90, 104, 101, 6500, 6501, 6502, 6503, 6504, 6505, 10115, 100, 1, 118, 87},
   [105] = {0, -90, 105, 101, 6500, 6501, 6502, 6503, 6504, 6505, 10116, 100, 1, 127, 91},
   [900] = {0, 0, 900, 900, 6500, 6501, 6502, 6503, 6504, 6505, 33100, 100, 2, 154, 173},
   [901] = {0, 0, 901, 900, 6500, 6501, 6502, 6503, 6504, 6505, 33101, 100, 2, 154, 55},
   [902] = {0, 0, 902, 900, 6500, 6501, 6502, 6503, 6504, 6505, 33102, 100, 2, 147, 55},
   [903] = {0, 0, 903, 900, 6500, 6501, 6502, 6503, 6504, 6505, 33103, 100, 2, 164, 55},
   [10000] = {0, 0, 10000, 64000, 6500, 6501, 6502, 6503, 6504, 6505, 33100, 100, 3, 40, 36},
   [10001] = {0, 0, 10001, 64000, 6500, 6501, 6502, 6503, 6504, 6505, 33101, 100, 3, 45, 47},
   [10002] = {0, 0, 10002, 64000, 6500, 6501, 6502, 6503, 6504, 6505, 33102, 100, 3, 31, 32},
   [10003] = {0, 0, 10003, 64000, 6500, 6501, 6502, 6503, 6504, 6505, 33103, 100, 3, 51, 32},
}
local _namesByNum = {
   DirX = 1,
   DirY = 2,
   Id = 3,
   Mapid = 4,
   Model1 = 5,
   Model2 = 6,
   Model3 = 7,
   Model4 = 8,
   Model5 = 9,
   Model6 = 10,
   Npcid = 11,
   SizeScale = 12,
   Type = 13,
   X = 14,
   Y = 15,
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
