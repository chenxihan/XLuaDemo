--文件是自动生成,请勿手动修改.来自数据文件:changeJobFateStar
local M = {
   [101] = {22093, 1391, 101, 22094, 22095, 0, 1, 201924695908},
   [201] = {22093, 1392, 201, 22096, 22097, 101, 2, 302887043861},
   [301] = {22093, 1393, 301, 22098, 22099, 201, 3, 363464452634},
   [401] = {22093, 1394, 401, 22100, 22101, 301, 4, 436157343161},
   [501] = {22093, 1395, 501, 22102, 22103, 401, 5, 523388811793},
   [601] = {22093, 1396, 601, 14526, 22104, 501, 6, 575727692972},
   [701] = {22093, 1397, 701, 22105, 22106, 601, 7, 633300462269},
   [801] = {22093, 1398, 801, 22107, 22108, 701, 8, 759960554723},
   [901] = {22093, 1399, 901, 22109, 22110, 801, 9, 911952665667},
   [1001] = {22093, 1400, 1001, 22111, 22112, 901, 10, 1094343198801},
   [1101] = {22093, 1401, 1101, 22113, 22114, 1001, 11, 1203777518681},
   [1201] = {22093, 1402, 1201, 22115, 22116, 1101, 12, 1324155270549},
}
local _namesByNum = {
   Icon = 2,
   Id = 3,
   ParentId = 6,
   Rune = 7,
   UpNeedExp = 8,
}
local _namesByString = {
   Att = 1,
   Name = 4,
   Need = 5,
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