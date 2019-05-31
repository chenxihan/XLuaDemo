--文件是自动生成,请勿手动修改.来自数据文件:guild_donate
local M = {
   [1] = {5917, 42967, 1, 42966, 42965},
   [2] = {14854, 42964, 2, 42963, 42962},
   [3] = {14827, 42961, 3, 42960, 42959},
   [4] = {19422, 42958, 4, 42957, 42956},
}
local _namesByNum = {
   Id = 3,
}
local _namesByString = {
   CoinType = 1,
   GuildGet = 2,
   OwnGet = 4,
   TechnologyGet = 5,
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
