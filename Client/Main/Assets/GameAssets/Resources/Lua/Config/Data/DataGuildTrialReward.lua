--文件是自动生成,请勿手动修改.来自数据文件:guild_trial_reward
local M = {
   [1] = {1, 1, 1, 37659},
   [2] = {2, 5, 2, 37660},
   [3] = {3, 20, 6, 37661},
   [4] = {4, 1000, 21, 37662},
}
local _namesByNum = {
   Num = 1,
   RankingIntervalMax = 2,
   RankingIntervalMini = 3,
}
local _namesByString = {
   RewardItem = 4,
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
