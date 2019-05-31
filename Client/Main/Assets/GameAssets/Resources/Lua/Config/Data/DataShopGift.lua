--文件是自动生成,请勿手动修改.来自数据文件:shop_gift
local M = {
   [14] = {80062, 86400, 501001, 287, 14, 37597, 37598},
   [50003] = {80063, 86400, 501002, 287, 50003, 37599, 37600},
   [50004] = {80064, 86400, 501003, 287, 50004, 37601, 37602},
   [50045] = {80065, 86400, 501004, 287, 50045, 37603, 37604},
   [50048] = {80065, 86400, 501004, 287, 50048, 37603, 37604},
   [50030] = {80066, 86400, 501005, 287, 50030, 37605, 37606},
   [50029] = {80066, 86400, 501005, 287, 50029, 37605, 37606},
   [2] = {80067, 86400, 501006, 287, 2, 37607, 37608},
}
local _namesByNum = {
   BuyID = 1,
   CountTime = 2,
   GoodsID = 3,
   Icon = 4,
   ItemID = 5,
}
local _namesByString = {
   ItemShow = 6,
   Name = 7,
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
