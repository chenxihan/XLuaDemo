--文件是自动生成,请勿手动修改.来自数据文件:ActivityPrompt
local M = {
   [1] = {2, 17453, 1, 54400, 3},
   [2] = {1, 17454, 2, 54400, 3},
   [3] = {0, 17455, 3, 0, 1},
   [4] = {0, 17456, 4, 0, 2},
   [5] = {2, 17457, 5, 54600, 4},
   [6] = {1, 17458, 6, 54600, 4},
   [7] = {0, 17459, 7, 0, 5},
   [8] = {3, 17460, 8, 2030000, 0},
   [9] = {5, 17461, 9, 2034000, 0},
   [10] = {6, 17461, 10, 2034000, 0},
   [11] = {7, 17461, 11, 2034000, 0},
   [12] = {7000, 17462, 12, 1062000, 0},
   [13] = {10000, 17463, 13, 1052000, 0},
   [14] = {10001, 17464, 14, 1053000, 0},
   [15] = {1, 17465, 15, 2030000, 0},
   [16] = {-999, 17466, 16, 1054000, 0},
   [17] = {-998, 17467, 17, 1054000, 0},
   [18] = {-997, 17468, 18, 1055000, 0},
   [19] = {-996, 17469, 19, 1055000, 0},
   [20] = {-995, 17470, 20, 1056000, 0},
   [21] = {-994, 17471, 21, 1056000, 0},
   [22] = {-993, 17472, 22, 2030000, 0},
   [23] = {-992, 17473, 23, 2030000, 0},
   [24] = {-991, 17474, 24, 1057000, 0},
   [25] = {-990, 17475, 25, 1057000, 0},
   [26] = {-989, 17476, 26, 1183000, 0},
   [27] = {-988, 17477, 27, 1183100, 0},
}
local _namesByNum = {
   DataId = 1,
   Id = 3,
   OpenPanel = 4,
   Type = 5,
}
local _namesByString = {
   Desc = 2,
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