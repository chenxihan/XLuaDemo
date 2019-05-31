--文件是自动生成,请勿手动修改.来自数据文件:guild_bonfire
local M = {
   [1] = {1, 33912},
   [50] = {50, 33913},
   [100] = {100, 33914},
   [150] = {150, 33915},
   [200] = {200, 33916},
   [250] = {250, 33917},
   [300] = {300, 33918},
   [350] = {350, 33919},
   [400] = {400, 33920},
   [450] = {450, 33921},
   [500] = {500, 33922},
}
local _namesByNum = {
   Level = 1,
}
local _namesByString = {
   Reward = 2,
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
