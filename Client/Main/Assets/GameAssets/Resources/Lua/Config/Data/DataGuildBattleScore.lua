--文件是自动生成,请勿手动修改.来自数据文件:guild_battle_score
local M = {
   [100] = {100, 60001, 243, 243, 12624},
   [300] = {300, 60002, 245, 246, 12624},
   [500] = {500, 60003, 247, 247, 12624},
   [800] = {800, 60004, 249, 249, 12624},
   [1000] = {1000, 60001, 252, 252, 12624},
}
local _namesByNum = {
   Id = 1,
   Item = 2,
   LockPic = 3,
   OpenPic = 4,
}
local _namesByString = {
   ShowItem = 5,
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
