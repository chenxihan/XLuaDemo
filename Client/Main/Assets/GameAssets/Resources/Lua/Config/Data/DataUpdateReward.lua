--文件是自动生成,请勿手动修改.来自数据文件:update_reward
local M = {
   [1] = {0, 1, 41138, 41139},
}
local _namesByNum = {
   NeedUpdate = 1,
   Num = 2,
}
local _namesByString = {
   UpdateInfo = 3,
   UpdateReward = 4,
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
