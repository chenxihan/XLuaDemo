--文件是自动生成,请勿手动修改.来自数据文件:state_package
local M = {
   [1001] = {0, 10, 6, 1, 499, 1001, 1, 21091, 0, 15904, 30, 1},
   [1002] = {0, 10, 18, 1, 499, 1002, 2, 21092, 0, 21093, 30, 1},
   [1003] = {0, 20, 200, 1, 499, 1003, 3, 21094, 1, 21095, 20, 2},
   [1004] = {0, 5, 500, 1, 499, 1004, 4, 21096, 0, 21097, 30, 3},
   [2001] = {0, 10, 6, 2, 499, 2001, 1, 21091, 0, 21098, 30, 1},
   [2002] = {0, 10, 18, 2, 499, 2002, 2, 21092, 0, 21099, 30, 1},
   [2003] = {0, 20, 200, 2, 499, 2003, 3, 21094, 1, 21100, 20, 2},
   [2004] = {0, 5, 500, 2, 499, 2004, 4, 21096, 0, 21101, 30, 3},
}
local _namesByNum = {
   BgPic = 1,
   CdTime = 2,
   Cost = 3,
   Group = 4,
   Icon = 5,
   Id = 6,
   Level = 7,
   Nature = 9,
   ShowTime = 11,
   Type = 12,
}
local _namesByString = {
   Name = 8,
   Reward = 10,
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
