--文件是自动生成,请勿手动修改.来自数据文件:timelimitgift
local M = {
   [1] = {60, 1, 18204, 18205, 18206},
   [2] = {66, 2, 18207, 18208, 18206},
   [3] = {120, 3, 18209, 18210, 18206},
   [4] = {180, 4, 18211, 18212, 18206},
   [5] = {214, 5, 18213, 18214, 18215},
   [6] = {360, 6, 18216, 18217, 18206},
   [7] = {520, 7, 18218, 18219, 18215},
   [8] = {600, 8, 18220, 18221, 18206},
   [9] = {666, 9, 18222, 18223, 18206},
   [10] = {777, 10, 18224, 18225, 18206},
   [11] = {888, 11, 18226, 18227, 18228},
   [12] = {1111, 12, 18229, 18230, 18231},
   [13] = {1212, 13, 18232, 18233, 18231},
   [14] = {1314, 14, 18234, 18235, 18236},
}
local _namesByNum = {
   Gold = 1,
   Id = 2,
}
local _namesByString = {
   Info = 3,
   Name = 4,
   Title = 5,
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
