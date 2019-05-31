--文件是自动生成,请勿手动修改.来自数据文件:kuafu_statue_evaluate
local M = {
   [1] = {7047, 1},
   [2] = {7048, 2},
   [3] = {7049, 3},
   [4] = {7050, 4},
   [5] = {7051, 5},
}
local _namesByNum = {
   Id = 2,
}
local _namesByString = {
   Content = 1,
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
