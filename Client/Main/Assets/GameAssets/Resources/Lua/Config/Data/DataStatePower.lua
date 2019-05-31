--文件是自动生成,请勿手动修改.来自数据文件:state_power
local M = {
   [1] = {0, 0, 1005, 1, 20903, 1, 42221, 16631, 0, 2592},
   [2] = {0, 1, 1006, 2, 20906, 2, 42222, 16634, 0, 2593},
   [3] = {1, 1, 1008, 3, 20912, 3, 42223, 16637, 0, 2595},
   [4] = {1, 2, 1009, 4, 20916, 4, 42224, 16631, 0, 42225},
}
local _namesByNum = {
   Convey = 1,
   DailyExpfb = 2,
   ExpBuff = 3,
   Id = 4,
   Pic = 6,
   Skill = 9,
}
local _namesByString = {
   Name = 5,
   PowerList = 7,
   Reward = 8,
   Value = 10,
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
