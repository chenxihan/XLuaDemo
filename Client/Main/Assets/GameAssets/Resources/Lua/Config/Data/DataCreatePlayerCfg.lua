--文件是自动生成,请勿手动修改.来自数据文件:CreatePlayerCfg
local M = {
   [0] = {18557, 18558, 0, 18559, 18560, 18561, 200, 3000100, 1, 0, 25, 2000100},
   [1] = {18562, 18563, 1, 18559, 18564, 18565, 216, 3100100, 1, 0, 112, 2100100},
   [2] = {18557, 18566, 2, 18559, 18567, 8527, 165, 3200100, 1, 1, 213, 2200100},
   [3] = {18557, 18568, 3, 18559, 18569, 8591, 180, 3300100, 1, 1, 315, 2300100},
   [4] = {18557, 18570, 4, 18559, 18571, 8622, 180, 3400100, 1, 1, 413, 2400100},
   [5] = {18557, 18572, 5, 18559, 18573, 8640, 216, 3500100, 1, 0, 512, 2500100},
}
local _namesByNum = {
   Id = 3,
   ModelHeight = 7,
   ModelID = 8,
   Sex = 10,
   SkillVfxID = 11,
   WeaponID = 12,
}
local _namesByString = {
   BlurArgs = 1,
   HeadIcon = 2,
   IdleAnimName = 4,
   JobDes = 5,
   JobName = 6,
   PlayAnimName = 9,
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
