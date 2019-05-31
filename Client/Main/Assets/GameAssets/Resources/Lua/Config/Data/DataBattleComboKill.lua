--文件是自动生成,请勿手动修改.来自数据文件:BattleComboKill
local M = {
   [1] = {1, 21220},
   [2] = {2, 21221},
   [10] = {10, 21222},
   [20] = {20, 21223},
   [30] = {30, 21224},
   [40] = {40, 21225},
   [50] = {50, 21226},
}
local _namesByNum = {
   Count = 1,
}
local _namesByString = {
   Title = 2,
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
