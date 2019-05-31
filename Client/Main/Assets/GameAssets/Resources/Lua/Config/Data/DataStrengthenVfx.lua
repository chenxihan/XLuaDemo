--文件是自动生成,请勿手动修改.来自数据文件:StrengthenVfx
local M = {
   [4] = {4, 400001, 400101, 400201, 400301},
   [8] = {8, 400002, 400102, 400202, 400302},
   [16] = {16, 400003, 400103, 400203, 400303},
   [24] = {24, 400004, 400104, 400204, 400304},
   [32] = {32, 400005, 400105, 400205, 400305},
   [40] = {40, 400006, 400106, 400206, 400306},
   [48] = {48, 400007, 400107, 400207, 400307},
   [56] = {56, 400008, 400108, 400208, 400308},
   [64] = {64, 400009, 400109, 400209, 400309},
   [72] = {72, 400010, 400110, 400210, 400310},
   [80] = {80, 400011, 400111, 400211, 400311},
}
local _namesByNum = {
   Level = 1,
   Vfx = 2,
   Vfx1 = 3,
   Vfx2 = 4,
   Vfx3 = 5,
}
local _namesByString = {
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
