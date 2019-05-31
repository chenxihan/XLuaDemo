--文件是自动生成,请勿手动修改.来自数据文件:guild_fight_ranking
local M = {
   [5] = {5, 21102},
   [15] = {15, 21103},
   [50] = {50, 21104},
   [150] = {150, 21105},
   [500] = {500, 21106},
   [1000] = {1000, 21107},
   [1500] = {1500, 21108},
   [2000] = {2000, 21109},
   [3000] = {3000, 21110},
   [5000] = {5000, 21111},
}
local _namesByNum = {
   Num = 1,
}
local _namesByString = {
   RewardItem = 2,
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
