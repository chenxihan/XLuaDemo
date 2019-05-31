--文件是自动生成,请勿手动修改.来自数据文件:world_question_reward
local M = {
   [1] = {1, 1, 1, 3255},
   [2] = {2, 2, 2, 3256},
   [3] = {3, 5, 3, 3257},
   [4] = {4, 10, 6, 3258},
   [5] = {5, 50, 11, 3259},
   [6] = {6, 100, 51, 3260},
   [7] = {7, 1000, 101, 3261},
}
local _namesByNum = {
   Id = 1,
   LevelMax = 2,
   LevelMin = 3,
}
local _namesByString = {
   Reward = 4,
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
