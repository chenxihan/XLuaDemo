--文件是自动生成,请勿手动修改.来自数据文件:kuafu_guild_Battle
local M = {
   [1] = {100, 17844, 1, 33841, 1000, 33842, 33843},
   [2] = {90, 17844, 2, 33844, 900, 33845, 33846},
   [3] = {80, 17844, 3, 33847, 800, 33848, 33849},
   [4] = {70, 17844, 4, 33850, 700, 33851, 33852},
   [5] = {60, 17844, 5, 33853, 600, 33854, 33855},
   [6] = {50, 17844, 6, 33856, 500, 33857, 33858},
   [7] = {40, 17844, 7, 33859, 400, 33860, 33861},
   [8] = {30, 17844, 8, 33862, 300, 33863, 33864},
   [9] = {20, 17844, 9, 33865, 200, 33866, 33867},
   [10] = {10, 17844, 10, 33868, 100, 33869, 33870},
   [11] = {9, 17844, 11, 33871, 90, 33872, 33873},
   [12] = {8, 17844, 12, 33874, 80, 33875, 33876},
   [13] = {7, 17844, 13, 33877, 70, 33878, 33879},
   [14] = {6, 17844, 14, 33880, 60, 33881, 33882},
   [15] = {5, 17844, 15, 33883, 50, 33884, 33885},
   [16] = {4, 17844, 16, 33886, 40, 33887, 33888},
}
local _namesByNum = {
   FailIntegral = 1,
   Id = 3,
   VictoryIntegral = 5,
}
local _namesByString = {
   FailReward = 2,
   MonthReward = 4,
   VictoryReward = 6,
   WeekReward = 7,
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
