--文件是自动生成,请勿手动修改.来自数据文件:marriage
local M = {
   [0] = {2067, -1, 0, 0, 16244, 19300, 0, 0},
   [1] = {16245, -1, 0, 1, 16246, 27100, 0, 0},
   [2] = {16247, 1, 900001, 2, 16248, 38000, 0, 900001},
   [3] = {16249, 2, 0, 3, 16250, 53200, 1, 0},
   [4] = {16251, 3, 0, 4, 16252, 74400, 1, 900002},
   [5] = {16253, 4, 0, 5, 16254, 104200, 1, 0},
   [6] = {16255, -1, 0, 6, 16256, 146000, 1, 0},
   [7] = {16257, -1, 0, 7, 16258, 204400, 1, 0},
   [8] = {16259, -1, 0, 8, 16260, 286100, 1, 0},
   [9] = {16261, -1, 0, 9, 16262, 400600, 1, 0},
   [10] = {16263, -1, 0, 10, 16264, 560900, 1, 0},
   [11] = {16265, -1, 0, 11, 16266, 785200, 1, 0},
   [12] = {16267, -1, 0, 12, 16268, 0, 1, 0},
}
local _namesByNum = {
   AttType = 2,
   BuffId = 3,
   Level = 4,
   NeedValue = 6,
   Radio = 7,
   SkillId = 8,
}
local _namesByString = {
   Attr = 1,
   Name = 5,
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
