--文件是自动生成,请勿手动修改.来自数据文件:equip_inten_class
local M = {
   [1] = {1, 80, 20875},
   [2] = {2, 160, 20876},
   [3] = {3, 240, 20877},
   [4] = {4, 320, 20878},
   [5] = {5, 400, 20879},
   [6] = {6, 480, 20880},
   [7] = {7, 560, 20881},
   [8] = {8, 640, 20882},
   [9] = {9, 720, 20883},
   [10] = {10, 800, 20884},
   [11] = {11, 880, 20885},
   [12] = {12, 960, 20886},
   [13] = {13, 1040, 20887},
   [14] = {14, 1120, 20888},
   [15] = {15, 1200, 20889},
   [16] = {16, 1280, 20890},
   [17] = {17, 1360, 20891},
   [18] = {18, 1440, 20892},
   [19] = {19, 1520, 20893},
   [20] = {20, 1600, 20894},
   [21] = {21, 1680, 20895},
   [22] = {22, 1760, 20896},
   [23] = {23, 1840, 20897},
   [24] = {24, 1920, 20898},
   [25] = {25, 2000, 20899},
   [26] = {26, 2080, 20900},
   [27] = {27, 2160, 20901},
}
local _namesByNum = {
   Id = 1,
   Level = 2,
}
local _namesByString = {
   Value = 3,
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
