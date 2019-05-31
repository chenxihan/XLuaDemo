--文件是自动生成,请勿手动修改.来自数据文件:synthetic_suitStone
local M = {
   [50118] = {50118, 42200, 42201, 1000, 0},
   [50119] = {50119, 42202, 42203, 1000, 0},
   [50120] = {50120, 42204, 42205, 1000, 0},
   [50121] = {50121, 42206, 42207, 1000, 0},
   [50122] = {50122, 42208, 42209, 1000, 0},
   [50123] = {50123, 42210, 42211, 1000, 0},
   [50124] = {50124, 42212, 42201, 1000, 1},
   [50125] = {50125, 42213, 42203, 1000, 1},
   [50126] = {50126, 42214, 42205, 1000, 1},
   [50127] = {50127, 42215, 42207, 1000, 1},
   [50128] = {50128, 42216, 42209, 1000, 1},
   [50129] = {50129, 42217, 42211, 1000, 1},
}
local _namesByNum = {
   Id = 1,
   NeedMoney = 4,
   Type = 5,
}
local _namesByString = {
   Name = 2,
   Need = 3,
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
