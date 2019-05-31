--文件是自动生成,请勿手动修改.来自数据文件:temple
local M = {
   [1] = {1003, 21112, 432000, 0, 5501, 30, 21113, 10, 21114, 1004, 21115, 1, 864000, 600, 480, 21116, 0},
   [2] = {1005, 21117, 432000, 1, 5502, 30, 21118, 10, 21114, 1006, 21119, 2, 864000, 600, 480, 21120, 0},
}
local _namesByNum = {
   BackVfx = 1,
   CanCutTime = 3,
   CanDrop = 4,
   CloneID = 5,
   CutTime = 6,
   Integral = 8,
   ModelVfx = 10,
   Process = 12,
   SealTime = 13,
   Star2 = 14,
   Star3 = 15,
   WorldLevel = 17,
}
local _namesByString = {
   Boss = 2,
   FirstAward = 7,
   Item = 9,
   Name = 11,
   WeekAreward = 16,
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
