--文件是自动生成,请勿手动修改.来自数据文件:growthFund
local M = {
   [50] = {18655, 50},
   [100] = {18656, 100},
   [150] = {18657, 150},
   [180] = {18658, 180},
   [220] = {18659, 220},
   [260] = {18660, 260},
   [300] = {18661, 300},
}
local _namesByNum = {
   Level = 2,
}
local _namesByString = {
   Award = 1,
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
