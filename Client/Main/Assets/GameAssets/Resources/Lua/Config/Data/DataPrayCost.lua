--文件是自动生成,请勿手动修改.来自数据文件:PrayCost
local M = {
   [1] = {1, 14854, 14827},
   [2] = {2, 14827, 19419},
   [3] = {3, 19419, 19420},
   [4] = {4, 19420, 19421},
   [5] = {5, 19421, 19422},
   [6] = {6, 19422, 19423},
   [7] = {7, 19423, 19424},
   [8] = {8, 19424, 19425},
   [9] = {9, 19425, 19426},
   [10] = {10, 19426, 19427},
   [11] = {11, 19427, 19428},
   [12] = {12, 19428, 19429},
   [13] = {13, 19429, 19430},
   [14] = {14, 19430, 19431},
   [15] = {15, 19431, 19432},
   [16] = {16, 19432, 19433},
   [17] = {17, 19433, 19434},
   [18] = {18, 19434, 19435},
   [19] = {19, 19435, 19436},
   [20] = {20, 19436, 19437},
   [21] = {21, 19437, 19438},
   [22] = {22, 19438, 19439},
   [23] = {23, 19439, 19440},
   [24] = {24, 19440, 19441},
   [25] = {25, 19441, 19442},
   [26] = {26, 19442, 19443},
   [27] = {27, 19443, 19444},
   [28] = {28, 19444, 19445},
   [29] = {29, 19445, 19446},
   [30] = {30, 19446, 19447},
}
local _namesByNum = {
   Num = 1,
}
local _namesByString = {
   PrayExpCost = 2,
   PrayMoneyCost = 3,
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
