--文件是自动生成,请勿手动修改.来自数据文件:guild_fight_reward
local M = {
   [1] = {1, 18755, 1, 1, 17037, 14},
   [2] = {1, 18756, 2, 2, 18757, 13},
   [3] = {2, 1, 3, 1, 18757, 12},
   [4] = {2, 1, 4, 2, 3930, 0},
   [5] = {3, 1, 5, 1, 3930, 0},
   [6] = {3, 1, 6, 2, 9749, 0},
   [7] = {10, 18758, 7, 1, 17037, 0},
   [8] = {10, 18759, 8, 2, 18757, 0},
}
local _namesByNum = {
   Area = 1,
   Num = 3,
   Outcome = 4,
   RewardTitle = 6,
}
local _namesByString = {
   Auction = 2,
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
