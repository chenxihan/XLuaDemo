--文件是自动生成,请勿手动修改.来自数据文件:photoFilter
local M = {
   [1] = {1, 100, 4, 1, 90, 20709, 30},
   [2] = {1, 300, 4, 2, 75, 20710, 3},
   [3] = {1, 352, 4, 3, 44, 20711, 15},
   [4] = {1, 219, 4, 4, 114, 20712, 45},
   [5] = {1, 300, 4, 5, 245, 20713, 55},
}
local _namesByNum = {
   BlurIterations = 1,
   BlurSize = 2,
   DownSampleFactor = 3,
   Id = 4,
   Intensity = 5,
   Threshhold = 7,
}
local _namesByString = {
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
