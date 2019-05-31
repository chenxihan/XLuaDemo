--文件是自动生成,请勿手动修改.来自数据文件:share
local M = {
   [10005] = {5, 1, 43040, 10005, 0, 43039, 43038, 1},
   [10006] = {6, 1, 43037, 10006, 0, 43039, 43036, 1},
   [10007] = {7, 1, 43035, 10007, 0, 43039, 43034, 1},
   [20100] = {100, 1, 16692, 20100, 0, 43039, 43033, 2},
   [20200] = {200, 1, 16694, 20200, 0, 43039, 43032, 2},
   [20300] = {300, 1, 43031, 20300, 0, 43039, 43030, 2},
   [20400] = {400, 1, 43029, 20400, 0, 43039, 43028, 2},
   [30001] = {1, 1, 43027, 30001, 0, 43039, 43026, 3},
   [30002] = {2, 1, 43025, 30002, 0, 43039, 43026, 3},
   [30003] = {3, 1, 43024, 30003, 0, 43039, 43026, 3},
   [30004] = {4, 1, 43023, 30004, 0, 43039, 43026, 3},
   [40000] = {0, -1, 43022, 40000, 0, 43039, 43021, 4},
   [50000] = {0, -1, 43020, 50000, 0, 43039, 43019, 5},
   [60000] = {0, -1, 43018, 60000, 0, 43039, 43017, 6},
   [70000] = {0, 1, 43016, 70000, 0, 43039, 43015, 7},
   [80000] = {0, 1, 43014, 80000, 0, 43039, 43013, 8},
}
local _namesByNum = {
   Condition = 1,
   Count = 2,
   Id = 4,
   ModelId = 5,
   Type = 8,
}
local _namesByString = {
   Description = 3,
   Rewards = 6,
   Text = 7,
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