--文件是自动生成,请勿手动修改.来自数据文件:FightSoulHunting
local M = {
   [1] = {1, 8000, 19560, 0, 1, 19561, 4000, 67},
   [2] = {1, 10000, 19562, 0, 2, 19563, 4000, 68},
   [3] = {1, 20000, 19564, 0, 3, 19565, 3000, 69},
   [4] = {19566, 40000, 19567, 0, 4, 19568, 4000, 70},
   [5] = {1, 80000, 19569, 0, 5, 19570, 0, 71},
}
local _namesByNum = {
   ConsumeGold = 2,
   Icon = 4,
   Id = 5,
   NextProbability = 7,
   VfxId = 8,
}
local _namesByString = {
   CallDropRate = 1,
   DropRate = 3,
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
