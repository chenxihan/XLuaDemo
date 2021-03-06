--文件是自动生成,请勿手动修改.来自数据文件:soulclone_set
local M = {
   [2322] = {38581, 90, 1452, 2322, 125, 38582, 1},
   [3747] = {38583, 270, 1452, 3747, 250, 38584, 1},
   [14756] = {38585, 620, 1452, 14756, 500, 38586, 1},
   [14759] = {38587, 1320, 1452, 14759, 1000, 38588, 1},
   [14761] = {38589, 2720, 1452, 14761, 2000, 38590, 1},
   [14779] = {38591, 945, 1455, 14779, 1350, 38592, 2},
   [2358] = {38593, 2695, 1455, 2358, 2500, 38594, 2},
   [14783] = {38595, 5110, 1455, 14783, 3450, 38596, 2},
   [14786] = {38597, 8085, 1455, 14786, 4250, 38598, 2},
   [14789] = {38599, 11795, 1455, 14789, 5300, 38600, 2},
   [14805] = {38601, 90, 1453, 14805, 125, 38602, 3},
   [14807] = {38603, 270, 1453, 14807, 250, 38604, 3},
   [2420] = {38605, 620, 1453, 2420, 500, 38606, 3},
   [14812] = {38607, 1320, 1453, 14812, 1000, 38608, 3},
   [14814] = {38609, 2720, 1453, 14814, 2000, 38610, 3},
   [14830] = {38611, 90, 1454, 14830, 125, 38612, 4},
   [14833] = {38613, 270, 1454, 14833, 250, 38614, 4},
   [14836] = {38615, 620, 1454, 14836, 500, 38616, 4},
   [14838] = {38617, 1320, 1454, 14838, 1000, 38618, 4},
   [14841] = {38619, 2720, 1454, 14841, 2000, 38620, 4},
}
local _namesByNum = {
   Explain = 2,
   Icon = 3,
   Levelup = 5,
   Type = 7,
}
local _namesByString = {
   Desc = 1,
   Id = 4,
   Name = 6,
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
