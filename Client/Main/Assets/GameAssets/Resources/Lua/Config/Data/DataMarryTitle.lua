--文件是自动生成,请勿手动修改.来自数据文件:marry_title
local M = {
   [0] = {2067, -1, 0, 0, 1000, 0, 0, 16, 41125},
   [1] = {16245, -1, 0, 1, 2000, 0, 0, 17, 41126},
   [2] = {16247, 1, 900001, 2, 4000, 0, 900001, 18, 41127},
   [3] = {16249, 2, 0, 3, 8000, 1, 0, 19, 41128},
   [4] = {16251, 3, 0, 4, 16000, 1, 900002, 20, 41129},
   [5] = {16253, 4, 0, 5, 32000, 1, 0, 21, 41130},
   [6] = {16255, -1, 0, 6, 64000, 1, 0, 22, 41131},
   [7] = {16257, -1, 0, 7, 128000, 1, 0, 23, 41132},
   [8] = {16259, -1, 0, 8, 256000, 1, 0, 24, 41133},
   [9] = {16261, -1, 0, 9, 512000, 1, 0, 25, 41134},
   [10] = {16263, -1, 0, 10, 1024000, 1, 0, 26, 41135},
   [11] = {16265, -1, 0, 11, 2048000, 1, 0, 27, 41136},
   [12] = {16267, -1, 0, 12, 4096000, 1, 0, 28, 41137},
}
local _namesByNum = {
   AttType = 2,
   BuffId = 3,
   Level = 4,
   NeedValue = 5,
   Radio = 6,
   SkillId = 7,
   TitleId = 8,
}
local _namesByString = {
   Attr = 1,
   TitleName = 9,
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
