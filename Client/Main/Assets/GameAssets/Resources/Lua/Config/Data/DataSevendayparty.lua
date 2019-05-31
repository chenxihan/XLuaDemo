--文件是自动生成,请勿手动修改.来自数据文件:sevendayparty
local M = {
   [101] = {1, 18574, 1, 18575, 3, 18576, 101, 18577, 1, 1, 1, 0, 1, 1},
   [102] = {1, 18574, 1, 18578, 3, 18579, 102, 18580, 5, 2, 1, 0, 1, 1},
   [103] = {1, 18574, 1, 18581, 3, 18582, 103, 18583, 20, 6, 1, 0, 1, 1},
   [104] = {2, 5870, 1, 18584, 3, 1, 104, 18585, 0, 0, 0, 0, 1, 1},
   [201] = {1, 14889, 3, 18586, 4, 18587, 201, 18588, 1, 1, 3, 0, 3, 2},
   [202] = {1, 14889, 3, 18589, 4, 18590, 202, 18591, 5, 2, 3, 0, 3, 2},
   [203] = {1, 14889, 3, 18592, 4, 18593, 203, 18594, 20, 6, 3, 0, 3, 2},
   [204] = {2, 14886, 3, 18595, 4, 1, 204, 18596, 0, 0, 0, 0, 3, 2},
   [301] = {1, 18597, 4, 18598, 5, 18599, 301, 18600, 1, 1, 2, 0, 4, 3},
   [302] = {1, 18597, 4, 18601, 5, 18602, 302, 18600, 5, 2, 2, 0, 4, 3},
   [303] = {1, 18597, 4, 18603, 5, 18604, 303, 18605, 20, 6, 2, 0, 4, 3},
   [304] = {2, 18606, 4, 18607, 5, 1, 304, 18608, 0, 0, 0, 0, 4, 3},
   [401] = {1, 18609, 5, 18610, 6, 18611, 401, 18612, 1, 1, 4, 0, 5, 4},
   [402] = {1, 18609, 5, 18613, 6, 18614, 402, 18612, 5, 2, 4, 0, 5, 4},
   [403] = {1, 18609, 5, 18615, 6, 18616, 403, 18617, 20, 6, 4, 0, 5, 4},
   [404] = {2, 18618, 5, 18619, 6, 1, 404, 18620, 0, 0, 0, 0, 5, 4},
   [501] = {1, 18621, 6, 18622, 7, 18623, 501, 18624, 1, 1, 5, 0, 6, 5},
   [502] = {1, 18621, 6, 18625, 7, 18626, 502, 18627, 5, 2, 5, 0, 6, 5},
   [503] = {1, 18621, 6, 18628, 7, 18629, 503, 18630, 20, 6, 5, 0, 6, 5},
   [504] = {2, 18631, 6, 18632, 7, 1, 504, 18633, 0, 0, 0, 0, 6, 5},
   [601] = {1, 18634, 7, 18635, 8, 18636, 601, 18637, 1, 1, 7, 0, 7, 6},
   [602] = {1, 18634, 7, 18638, 8, 18639, 602, 18640, 5, 2, 7, 0, 7, 6},
   [603] = {1, 18634, 7, 18641, 8, 18642, 603, 18643, 20, 6, 7, 0, 7, 6},
   [604] = {2, 18652, 7, 18653, 8, 1, 604, 18654, 0, 0, 0, 0, 7, 6},
}
local _namesByNum = {
   CanGetCount = 1,
   Day = 3,
   EndDay = 5,
   ID = 7,
   Max = 9,
   Min = 10,
   RankConditions = 11,
   RecipientType = 12,
   StartDay = 13,
   Type = 14,
}
local _namesByString = {
   Conditions = 2,
   Desc = 4,
   EquipAward = 6,
   ItemAward = 8,
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
