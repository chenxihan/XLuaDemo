--文件是自动生成,请勿手动修改.来自数据文件:marry_ring
local M = {
   [1] = {960, 15658, -1, 900001, 15659, 15660, 979, 1, 651001, 15661, 1, 900001, 80, 15662},
   [2] = {2160, 15663, -1, 0, 15664, 1, 976, 2, 651002, 15665, 1, 0, 180, 15666},
   [3] = {3480, 15667, -1, 0, 15668, 1, 978, 3, 651003, 15669, 1, 0, 290, 15670},
   [4] = {7080, 15671, -1, 0, 15672, 1, 975, 4, 651004, 15673, 1, 0, 590, 15674},
   [5] = {11880, 15675, -1, 0, 15676, 1, 981, 5, 651005, 15677, 1, 0, 990, 15678},
   [6] = {15480, 15679, -1, 0, 15680, 1, 977, 6, 651006, 15681, 1, 0, 1290, 15682},
   [7] = {19080, 15683, -1, 0, 15684, 1, 983, 7, 651007, 15685, 1, 0, 1590, 15686},
   [8] = {23880, 15687, -1, 0, 15688, 1, 982, 8, 651008, 15689, 1, 0, 1990, 15690},
   [9] = {35880, 15691, -1, 0, 15692, 15693, 984, 9, 651009, 15694, 1, 900002, 2990, 15695},
}
local _namesByNum = {
   AddIntimacy = 1,
   AttType = 3,
   BuffId = 4,
   Icon = 7,
   Level = 8,
   ModelId = 9,
   Radio = 11,
   SkillId = 12,
   UpGold = 13,
}
local _namesByString = {
   Attributes = 2,
   Degree = 5,
   Dis = 6,
   Name = 10,
   UpNeedItem = 14,
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
