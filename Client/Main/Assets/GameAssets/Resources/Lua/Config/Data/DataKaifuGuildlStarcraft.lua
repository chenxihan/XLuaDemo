--文件是自动生成,请勿手动修改.来自数据文件:kaifu_guildl_Starcraft
local M = {
   [1] = {1, 22187, 1, 22188},
   [2] = {2, 22189, 2, 22190},
   [3] = {3, 22191, 3, 22192},
}
local _namesByNum = {
   ID = 1,
   Position = 3,
}
local _namesByString = {
   Name = 2,
   Reward = 4,
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
