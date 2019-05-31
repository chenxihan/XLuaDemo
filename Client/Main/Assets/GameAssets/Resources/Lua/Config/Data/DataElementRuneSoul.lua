--文件是自动生成,请勿手动修改.来自数据文件:elementRuneSoul
local M = {
   [1] = {50, 14338, 1767, 1, 17440, 17441, 17442, 17443, 1},
   [2] = {50, 14346, 1768, 2, 17440, 17444, 17445, 17446, 1},
   [3] = {100, 14351, 1769, 3, 17440, 17447, 17448, 4733, 1},
   [4] = {200, 14415, 1770, 4, 17449, 17450, 17451, 17452, 1},
}
local _namesByNum = {
   AddAtt = 1,
   Icon = 3,
   Id = 4,
}
local _namesByString = {
   Attribute = 2,
   Level = 5,
   Name = 6,
   NeedItem = 7,
   RuneType = 8,
   SpecialAtt = 9,
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
