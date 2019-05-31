--文件是自动生成,请勿手动修改.来自数据文件:guild_welfare
local M = {
   [7] = {33755, 33756, 1, 1, 685, 22892, 7, 1},
   [2] = {24215, 33757, 1, 2, 33758, 6943, 2, 1},
   [1] = {24215, 33759, 1, 3, 33760, 5811, 1, 1},
   [4] = {33761, 33762, 1, 4, 33763, 5045, 4, 1},
   [5] = {33764, 33765, 1, 5, 685, 4956, 5, 1},
   [3] = {4998, 33766, 33767, 6, 685, 4833, 3, 33768},
}
local _namesByNum = {
   Icon = 4,
   Num = 7,
}
local _namesByString = {
   ButtonName = 1,
   Describe = 2,
   Function = 3,
   Item = 5,
   Name = 6,
   RewardItem = 8,
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
