--文件是自动生成,请勿手动修改.来自数据文件:horse_mythical
local M = {
   [101] = {17589, 17590, 300, 0, 141, 101, 10, 17591, 1, 1, 40300, 1, 17592, 17590, 1, -148},
   [102] = {17593, 17594, 350, 0, 993, 102, 10, 17595, 1, 2, 42600, 1, 17596, 17594, 1, -142},
   [103] = {17597, 17598, 350, 1, 507, 103, 10, 17599, 1, 3, 41600, 1, 17600, 17601, 2, -170},
   [104] = {17597, 17602, 350, 1, 1124, 104, 20, 17603, 1, 4, 43800, 1, 17600, 17602, 2, -145},
   [105] = {17604, 17605, 350, 0, 1123, 105, 10, 17606, 1, 5, 43100, 2, 17607, 17605, 3, -151},
   [106] = {17608, 17609, 250, 1, 93, 106, 10, 17610, 1, 6, 41100, 1, 17611, 17609, 2, -148},
   [107] = {17612, 17613, 400, 1, 990, 107, 10, 17614, 1, 7, 42500, 1, 17615, 17613, 2, -180},
   [108] = {17616, 17617, 350, 1, 514, 108, 10, 17618, 1, 8, 41500, 1, 17619, 17617, 2, -145},
   [109] = {17616, 17620, 250, 1, 1153, 109, 1, 17621, 1, 9, 43500, 1, 17619, 17620, 2, -145},
   [110] = {17622, 17623, 350, 1, 527, 110, 20, 17624, 1, 10, 41200, 1, 17625, 17623, 2, -150},
   [111] = {17626, 17627, 600, 1, 526, 111, 10, 17628, 1, 11, 41700, 5, 17629, 17630, 3, -151},
   [112] = {17631, 17632, 500, 1, 211, 112, 10, 17633, 1, 12, 41900, 1, 17634, 17635, 2, -152},
}
local _namesByNum = {
   CameraSize = 3,
   CanFly = 4,
   Icon = 5,
   Id = 6,
   MaxLevel = 7,
   Notice = 9,
   Priority = 10,
   Res = 11,
   RideNum = 12,
   Type = 15,
   YNum = 16,
}
local _namesByString = {
   ActiveAttr = 1,
   ActiveItem = 2,
   Name = 8,
   TrainAttr = 13,
   TrainItem = 14,
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
