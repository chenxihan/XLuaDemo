--文件是自动生成,请勿手动修改.来自数据文件:Equip_refi
local M = {
   [1] = {17551, 5000, 17551, 3000, 1, 50, 17551},
   [2] = {17552, 5000, 17552, 3000, 2, 70, 17552},
   [3] = {17553, 5000, 17553, 3000, 3, 90, 17553},
}
local _namesByNum = {
   BasicProbability = 2,
   BestProbability = 4,
   Id = 5,
   Level = 6,
}
local _namesByString = {
   BasicConsume = 1,
   BestConsume = 3,
   PerfectConsume = 7,
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
