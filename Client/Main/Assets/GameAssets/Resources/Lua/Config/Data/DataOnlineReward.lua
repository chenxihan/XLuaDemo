--文件是自动生成,请勿手动修改.来自数据文件:online_reward
local M = {
   [180] = {80013, 180, 41721},
   [600] = {50040, 600, 41723},
   [1200] = {50034, 1200, 41725},
   [2400] = {50035, 2400, 41727},
   [3600] = {50075, 3600, 41729},
}
local _namesByNum = {
   QDefaultItem = 1,
   QOnlinetime = 2,
}
local _namesByString = {
   QRewardItem = 3,
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
