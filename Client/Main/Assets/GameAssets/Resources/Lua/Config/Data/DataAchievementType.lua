--文件是自动生成,请勿手动修改.来自数据文件:achievementType
local M = {
   [0] = {748, 4952, 0},
   [1] = {748, 20823, 1},
   [2] = {734, 20824, 2},
   [3] = {1122, 20825, 3},
   [4] = {1162, 20826, 4},
   [5] = {890, 20827, 5},
   [6] = {886, 20828, 6},
}
local _namesByNum = {
   Icon = 1,
   Type = 3,
}
local _namesByString = {
   Name = 2,
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
