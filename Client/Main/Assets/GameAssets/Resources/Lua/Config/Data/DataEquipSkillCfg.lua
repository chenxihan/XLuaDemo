--文件是自动生成,请勿手动修改.来自数据文件:EquipSkillCfg
local M = {
   [0] = {42232, 42233, 42234, 42235, 42236, 0},
   [1] = {42232, 42233, 42234, 42235, 42236, 1},
   [2] = {42232, 42233, 42234, 42235, 42236, 2},
   [3] = {42232, 42233, 42234, 42235, 42236, 3},
   [4] = {42232, 42233, 42234, 42235, 42236, 4},
   [5] = {42232, 42233, 42234, 42235, 42236, 5},
   [6] = {42232, 42233, 42234, 42235, 42236, 6},
   [7] = {42232, 42233, 42234, 42235, 42236, 7},
}
local _namesByNum = {
   Num = 6,
}
local _namesByString = {
   Book1 = 1,
   Book2 = 2,
   Book3 = 3,
   Book4 = 4,
   Book5 = 5,
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
