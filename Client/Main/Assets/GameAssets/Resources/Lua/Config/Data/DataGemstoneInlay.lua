--文件是自动生成,请勿手动修改.来自数据文件:GemstoneInlay
local M = {
   [1000] = {1, 22167, 1000, 6, 22168},
   [1001] = {1, 22167, 1001, 6, 22168},
   [1002] = {1, 22167, 1002, 6, 22168},
   [1003] = {1, 22167, 1003, 6, 22168},
   [1004] = {2, 22169, 1004, 6, 22168},
   [1005] = {2, 22169, 1005, 6, 22168},
   [1006] = {2, 22169, 1006, 6, 22168},
   [1007] = {2, 22169, 1007, 6, 22168},
   [2000] = {3, 22170, 2000, 6, 22171},
   [2001] = {3, 22170, 2001, 6, 22172},
   [2002] = {3, 22170, 2002, 6, 22173},
   [2003] = {3, 22170, 2003, 6, 22174},
   [2004] = {4, 22175, 2004, 6, 22176},
   [2005] = {4, 22175, 2005, 6, 22177},
   [2006] = {4, 22175, 2006, 6, 22178},
   [2007] = {4, 22175, 2007, 6, 22179},
}
local _namesByNum = {
   ColorType = 1,
   Id = 3,
   LimitNumber = 4,
}
local _namesByString = {
   GemstoneId = 2,
   LocationCondition = 5,
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
