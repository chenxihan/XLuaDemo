--文件是自动生成,请勿手动修改.来自数据文件:comboKill
local M = {
   [1] = {0, 1, 0, 21220},
   [3] = {0, 3, 0, 21221},
   [5] = {1, 5, 3, 21222},
   [10] = {2, 10, 5, 21223},
   [15] = {3, 15, 10, 21224},
   [20] = {5, 20, 15, 21225},
   [30] = {10, 30, 20, 21226},
}
local _namesByNum = {
   ComboKillScore = 1,
   Count = 2,
   ShutDownScore = 3,
}
local _namesByString = {
   Title = 4,
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
