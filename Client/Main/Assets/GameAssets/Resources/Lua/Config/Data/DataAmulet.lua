--文件是自动生成,请勿手动修改.来自数据文件:amulet
local M = {
   [101] = {22054, 22055, 8177, 22056, 22057, 101, 22058, 1},
   [201] = {22059, 22055, 8182, 22060, 22061, 201, 22062, 1},
   [301] = {22063, 22055, 8187, 22064, 22065, 301, 22066, 1},
   [401] = {22067, 22055, 5797, 22068, 22069, 401, 22070, 1},
   [501] = {22071, 22055, 18574, 22072, 22073, 501, 22074, 1},
   [601] = {22075, 22055, 8305, 22056, 22065, 601, 22076, 1},
   [701] = {22077, 22055, 22078, 22060, 22069, 701, 22079, 1},
   [801] = {22080, 22055, 8318, 22064, 22073, 801, 22081, 1},
   [901] = {22082, 22055, 5806, 22068, 22065, 901, 22083, 1},
   [1001] = {22084, 22055, 8329, 22072, 22069, 1001, 22066, 1},
   [1101] = {22085, 22055, 22086, 22064, 22073, 1101, 22087, 1},
   [1201] = {22088, 22055, 8339, 22068, 22065, 1201, 22089, 1},
   [1301] = {22090, 22055, 22091, 22072, 22069, 1301, 22092, 1},
}
local _namesByNum = {
   Id = 6,
}
local _namesByString = {
   AbilityDes = 1,
   ActiveSkill = 2,
   Condition = 3,
   Des = 4,
   Icon = 5,
   Name = 7,
   OpenCondition = 8,
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
