--文件是自动生成,请勿手动修改.来自数据文件:SZZQScoreAward
local M = {
   [500] = {37663, 500, 0},
   [1200] = {37664, 1200, 1},
   [1700] = {37665, 1700, 2},
   [2300] = {37666, 2300, 3},
   [3000] = {37667, 3000, 4},
}
local _namesByNum = {
   Score = 2,
   UesExpIndex = 3,
}
local _namesByString = {
   Award = 1,
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
