--文件是自动生成,请勿手动修改.来自数据文件:skill_level_passive
local M = {
   [1] = {1, 18644},
   [2] = {2, 18645},
   [3] = {3, 18646},
   [4] = {4, 18647},
   [5] = {5, 18648},
   [6] = {6, 18649},
   [7] = {7, 18650},
   [8] = {8, 18651},
}
local _namesByNum = {
   Id = 1,
}
local _namesByString = {
   Skills = 2,
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
