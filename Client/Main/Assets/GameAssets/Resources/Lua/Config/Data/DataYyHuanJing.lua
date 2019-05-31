--文件是自动生成,请勿手动修改.来自数据文件:YyHuanJing
local M = {
   [30001] = {260, 1, 5150, 36076, 36077, 36078, 260, 18, 30001, 1, 5150, 65001, 17706, 670000, 600000, 400},
   [30002] = {280, 1, 5150, 36079, 36077, 36078, 260, 15, 30002, 1, 5150, 65002, 17708, 930000, 600000, 320},
   [30003] = {300, 1, 5150, 36080, 36081, 36082, 260, 17, 30003, 1, 5150, 65003, 5757, 1230000, 1200000, 400},
   [30004] = {320, 1, 5150, 36083, 36081, 36082, 260, 31, 30004, 1, 5150, 65004, 5759, 1690000, 1200000, 450},
   [30005] = {340, 1, 5150, 36084, 36085, 36086, 260, 26, 30005, 1, 5150, 65005, 5761, 2120000, 1800000, 400},
   [30006] = {360, 1, 5150, 36087, 36085, 36086, 260, 20, 30006, 1, 5150, 65006, 5763, 2740000, 1800000, 1200},
   [30007] = {380, 1, 5150, 36088, 36089, 36090, 260, 19, 30007, 1, 5150, 65007, 5765, 3320000, 2400000, 1200},
   [30008] = {400, 1, 5150, 36091, 36089, 36090, 260, 34, 30008, 1, 5150, 65008, 5767, 3970000, 3000000, 500},
}
local _namesByNum = {
   BossLevel = 1,
   CanShow = 2,
   CloneID = 3,
   EnterLevel = 7,
   HeadIcon = 8,
   ID = 9,
   Layer = 10,
   Mapsid = 11,
   Monsterid = 12,
   Power = 14,
   ReviveTime = 15,
   Size = 16,
}
local _namesByString = {
   Coordinates = 4,
   Describe = 5,
   Drop = 6,
   Pos = 13,
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
