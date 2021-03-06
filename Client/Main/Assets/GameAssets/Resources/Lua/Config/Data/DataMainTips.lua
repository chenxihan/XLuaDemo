--文件是自动生成,请勿手动修改.来自数据文件:main_tips
local M = {
   [1] = {0, 37352, 37353, 1, 0, 37354, 5366, 37355, 37356, 0, 37355, 0},
   [2] = {0, 37357, 37358, 2, 30, 37359, 4964, 37360, 1, 0, 37357, 0},
   [3] = {0, 37361, 37362, 3, 0, 37363, 4818, 37364, 37365, 0, 37364, 0},
   [4] = {0, 37366, 37358, 4, 50, 37367, 4964, 37368, 1, 0, 37366, 0},
   [5] = {0, 37369, 37370, 5, 0, 37371, 5696, 37372, 37373, 0, 37372, 0},
   [6] = {0, 37374, 37358, 6, 70, 1, 4964, 37375, 1, 0, 37374, 1},
   [7] = {0, 37376, 37377, 7, 0, 1, 37378, 37379, 37380, 0, 37379, 1},
   [8] = {0, 37381, 37382, 8, 0, 1, 37383, 37384, 37385, 0, 37386, 1},
   [9] = {0, 37387, 37388, 9, 0, 1, 4853, 37389, 37390, 0, 37389, 1},
   [10] = {0, 37391, 37392, 10, 110, 1, 4964, 37393, 1, 0, 37391, 1},
   [11] = {0, 37394, 37395, 11, 0, 1, 4861, 37397, 37398, 0, 37397, 1},
   [12] = {0, 37399, 37400, 12, 130, 1, 23960, 37401, 1, 0, 37401, 1},
   [13] = {0, 37402, 37362, 13, 0, 1, 11255, 37403, 37404, 0, 37403, 1},
   [14] = {0, 37405, 37406, 14, 150, 1, 4993, 37407, 1, 0, 37407, 1},
   [15] = {0, 37408, 37358, 15, 160, 1, 4964, 37409, 1, 0, 37408, 1},
   [16] = {0, 37410, 37411, 16, 0, 1, 4843, 37412, 37413, 0, 37412, 1},
   [17] = {0, 37405, 37406, 17, 220, 1, 4993, 37414, 1, 0, 37414, 1},
   [18] = {0, 37415, 37416, 18, 0, 1, 4871, 37417, 37418, 0, 37417, 1},
   [19] = {0, 37419, 37395, 19, 0, 1, 4859, 37420, 37421, 0, 37420, 1},
   [20] = {0, 37422, 37395, 20, 250, 1, 37423, 37424, 1, 0, 37425, 1},
   [21] = {0, 37426, 37382, 21, 260, 1, 4920, 37427, 1, 0, 37427, 1},
   [22] = {0, 37405, 37406, 22, 280, 1, 4993, 37428, 1, 0, 37428, 1},
   [23] = {0, 37430, 37416, 23, 0, 1, 37431, 37432, 37433, 0, 37432, 1},
   [24] = {0, 37434, 37388, 24, 320, 1, 37435, 37436, 1, 0, 37436, 1},
   [25] = {0, 37437, 37406, 25, 350, 1, 37438, 37439, 1, 0, 37439, 1},
   [26] = {0, 37440, 37406, 26, 370, 1, 5075, 37441, 1, 0, 37441, 1},
}
local _namesByNum = {
   Day = 1,
   Id = 4,
   Level = 5,
   Time = 10,
   Type = 12,
}
local _namesByString = {
   Explain = 2,
   Icon = 3,
   ModelRes = 6,
   Name = 7,
   Need = 8,
   Task = 9,
   Title = 11,
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
