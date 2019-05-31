--文件是自动生成,请勿手动修改.来自数据文件:pet
local M = {
   [1] = {80001, 98, 1, 857, 1, 1, 0, 42157, 1},
   [2] = {80002, 105, 2, 42158, 1, 1, 0, 42159, 1},
   [3] = {80003, 112, 3, 42160, 1, 1, 0, 42161, 1},
   [4] = {80004, 119, 4, 42162, 1, 1, 0, 42163, 1},
   [5] = {80005, 134, 5, 42164, 1, 1, 0, 42165, 1},
   [6] = {80006, 124, 6, 42166, 1, 1, 0, 42167, 1},
   [7] = {80007, 125, 7, 42168, 1, 1, 0, 42169, 1},
   [8] = {80008, 126, 8, 42170, 1, 1, 0, 42171, 1},
   [9] = {80009, 137, 9, 42172, 1, 1, 0, 42173, 1},
   [14] = {80014, 189, 14, 42174, 1, 42175, 1, 42176, 1},
   [10] = {80010, 141, 10, 42177, 220, 1, 0, 42178, 1},
   [11] = {80011, 155, 11, 42179, 220, 1, 0, 42180, 1},
   [12] = {80012, 145, 12, 42181, 220, 1, 0, 42182, 1},
   [13] = {80013, 146, 13, 42183, 220, 1, 0, 42184, 1},
   [15] = {80015, 165, 15, 42185, 220, 1, 0, 42186, 1},
   [16] = {80016, 166, 16, 42187, 220, 1, 0, 42188, 1},
   [20] = {80017, 193, 20, 42189, 220, 1, 0, 42190, 1},
   [21] = {80018, 197, 21, 42191, 220, 1, 0, 42192, 1},
   [22] = {80019, 201, 22, 42193, 220, 1, 0, 42194, 1},
   [23] = {80020, 207, 23, 42195, 220, 1, 0, 42196, 1},
   [24] = {80021, 213, 24, 42197, 220, 42198, 1, 42199, 1},
}
local _namesByNum = {
   AttackSkill = 1,
   Head = 2,
   Id = 3,
   NeedLevel = 5,
   Notice = 7,
   Type = 9,
}
local _namesByString = {
   Name = 4,
   NeedPet = 6,
   PassiveSkill = 8,
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