--文件是自动生成,请勿手动修改.来自数据文件:guild_trial
local M = {
   [1] = {1000000, 3000, 300, 1, 37668},
   [140] = {1000001, 3001, 300, 140, 37668},
   [190] = {1000002, 3002, 300, 190, 37668},
   [205] = {1000003, 3003, 150, 205, 37668},
   [240] = {1000004, 3004, 300, 240, 37668},
   [250] = {1000005, 3005, 300, 250, 37668},
   [260] = {1000006, 3006, 300, 260, 37668},
   [290] = {1000007, 3007, 300, 290, 37668},
   [305] = {1000008, 3008, 300, 305, 37668},
   [350] = {1000009, 3009, 500, 350, 37668},
   [370] = {1000009, 3010, 300, 370, 37668},
   [450] = {1000009, 3011, 300, 450, 37668},
   [500] = {1000009, 3012, 1000, 500, 37668},
}
local _namesByNum = {
   Auction = 1,
   BOSSID = 2,
   CameraSize = 3,
   Num = 4,
}
local _namesByString = {
   Pos = 5,
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
