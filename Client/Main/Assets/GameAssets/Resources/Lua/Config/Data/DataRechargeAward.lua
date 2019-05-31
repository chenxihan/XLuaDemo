--文件是自动生成,请勿手动修改.来自数据文件:RechargeAward
local M = {
   [1] = {0, 43089, 43088, 1, 43087, 43086, 10, 1, 43085},
   [2] = {1, 1, 43084, 2, 43083, 43082, 180, 1, 43081},
   [3] = {1, 1, 43080, 3, 43079, 43078, 300, 1, 43077},
   [4] = {1, 1, 43076, 4, 41139, 43075, 680, 1, 43074},
   [5] = {1, 1, 43073, 5, 43072, 43071, 1280, 1, 43070},
   [6] = {1, 1, 43069, 6, 43068, 43067, 2880, 1, 43066},
   [7] = {1, 43065, 43064, 7, 43063, 43062, 5000, 1, 43061},
   [8] = {1, 1, 43060, 8, 43059, 43058, 9760, 1, 43057},
   [9] = {1, 1, 43056, 9, 43055, 43054, 19800, 1, 43053},
}
local _namesByNum = {
   AwardType = 1,
   Id = 4,
   NeedRecharge = 7,
   Radio = 8,
}
local _namesByString = {
   EquipAward = 2,
   FightPower = 3,
   ItemAward = 5,
   ModleId = 6,
   RewardDes = 9,
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
