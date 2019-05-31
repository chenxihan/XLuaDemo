--文件是自动生成,请勿手动修改.来自数据文件:growthFund_all
local M = {
   [50] = {37669, 50, 0, 0},
   [100] = {37670, 100, 100, 24},
   [200] = {37671, 200, 0, 0},
   [300] = {37672, 300, 300, 96},
   [400] = {37673, 400, 0, 0},
   [500] = {37674, 500, 0, 0},
}
local _namesByNum = {
   Number = 2,
   NumberUp = 3,
   RenovateBegin = 4,
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
