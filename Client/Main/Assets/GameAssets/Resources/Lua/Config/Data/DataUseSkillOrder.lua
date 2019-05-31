--文件是自动生成,请勿手动修改.来自数据文件:UseSkillOrder
local M = {
   [0] = {0, 18694},
   [1] = {1, 18694},
   [2] = {2, 18694},
}
local _namesByNum = {
   Occ = 1,
}
local _namesByString = {
   SkillOrder = 2,
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
