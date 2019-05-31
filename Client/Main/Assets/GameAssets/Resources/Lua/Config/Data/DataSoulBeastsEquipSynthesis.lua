--文件是自动生成,请勿手动修改.来自数据文件:SoulBeastsEquipSynthesis
local M = {
   [1] = {1, 2, 3, 2000051, 1, 7, 1, 2420, 18662, 7, 0, 1},
   [2] = {1, 2, 3, 2000052, 2, 7, 2, 2420, 18662, 7, 0, 1},
   [3] = {1, 2, 3, 2000053, 3, 7, 3, 2420, 18662, 7, 0, 1},
   [4] = {1, 2, 3, 2000054, 4, 7, 4, 2420, 18662, 7, 0, 1},
   [5] = {1, 2, 3, 2000055, 5, 7, 5, 2420, 18662, 7, 0, 1},
   [6] = {18663, 3, 3, 2000056, 1, 8, 6, 2420, 18662, 7, 0, 1},
   [7] = {18663, 3, 3, 2000057, 2, 8, 7, 2420, 18662, 7, 0, 1},
   [8] = {18663, 3, 3, 2000058, 3, 8, 8, 2420, 18662, 7, 0, 1},
   [9] = {18663, 3, 3, 2000059, 4, 8, 9, 2420, 18662, 7, 0, 1},
   [10] = {18663, 3, 3, 2000060, 5, 8, 10, 2420, 18662, 7, 0, 1},
}
local _namesByNum = {
   DiamondNumber = 2,
   EquipDiamondNumber = 3,
   EquipID = 4,
   EquipPosition = 5,
   EquipQuality = 6,
   Id = 7,
   Quality = 10,
   Shielding = 11,
   SynthesisLevel = 12,
}
local _namesByString = {
   DemandItem = 1,
   JoinNum = 8,
   JoinNumProbability = 9,
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
