--文件是自动生成,请勿手动修改.来自数据文件:daily_notice
local M = {
   [1] = {1, 6872, 33824, 1, 0, 0, 1},
   [2] = {2, 6880, 33825, 4, 1, 5, 1},
   [3] = {3, 6883, 33826, 2, 1, 0, 0},
   [4] = {4, 6020, 33827, 3, 1, 0, 0},
}
local _namesByNum = {
   ID = 1,
   Number = 4,
   Reveal = 5,
   TimeCorrect = 6,
   Type = 7,
}
local _namesByString = {
   Name = 2,
   News = 3,
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
