--文件是自动生成,请勿手动修改.来自数据文件:guild_fight_personal
local M = {
   [1] = {10, 1, 1, 1, 37627},
   [2] = {10, 2, 5, 2, 37628},
   [3] = {10, 3, 20, 6, 37629},
   [4] = {10, 4, 1000, 21, 37630},
   [5] = {1, 5, 1, 1, 37627},
   [6] = {1, 6, 5, 2, 37628},
   [7] = {1, 7, 20, 6, 37629},
   [8] = {1, 8, 1000, 21, 37630},
   [9] = {2, 9, 1, 1, 37631},
   [10] = {2, 10, 5, 2, 37632},
   [11] = {2, 11, 20, 6, 37633},
   [12] = {2, 12, 1000, 21, 37634},
   [13] = {3, 13, 1, 1, 37635},
   [14] = {3, 14, 5, 2, 37636},
   [15] = {3, 15, 20, 6, 37637},
   [16] = {3, 16, 1000, 21, 37638},
}
local _namesByNum = {
   Area = 1,
   Num = 2,
   RankingIntervalMax = 3,
   RankingIntervalMini = 4,
}
local _namesByString = {
   RewardItem = 5,
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
