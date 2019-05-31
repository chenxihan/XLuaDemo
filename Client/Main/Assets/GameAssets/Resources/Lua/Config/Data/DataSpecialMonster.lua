--文件是自动生成,请勿手动修改.来自数据文件:special_monster
local M = {
}
local _namesByNum = {
   Camp = 1,
   HeadIcon = 4,
   ID = 5,
   Mapsid = 6,
   ModelRotat = 7,
   Monsterid = 8,
   Power = 10,
   Size = 11,
}
local _namesByString = {
   Describe = 2,
   Drop = 3,
   Pos = 9,
   Time = 12,
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
