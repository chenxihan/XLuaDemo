--文件是自动生成,请勿手动修改.来自数据文件:SZZQAward
local M = {
   [1] = {42145, 1, 42146, 1, 1, 1298, 0},
   [2] = {42147, 2, 42148, 3, 2, 1297, 1},
   [3] = {42149, 3, 42150, 6, 4, 1296, 2},
   [4] = {42151, 4, 42152, 10, 7, 1295, 3},
   [5] = {42153, 5, 42154, 15, 11, 1315, 4},
}
local _namesByNum = {
   Id = 2,
   RankMax = 4,
   RankMin = 5,
   ResIcon = 6,
   UesExpIndex = 7,
}
local _namesByString = {
   Award = 1,
   Name = 3,
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
