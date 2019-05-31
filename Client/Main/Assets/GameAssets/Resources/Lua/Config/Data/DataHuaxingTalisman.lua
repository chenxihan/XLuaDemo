--文件是自动生成,请勿手动修改.来自数据文件:HuaxingTalisman
local M = {
   [9102101] = {12009, 160, 844, 9102101, 18533, 18534, 18535},
   [9102102] = {12010, 160, 845, 9102102, 18536, 18537, 18535},
   [9102103] = {12011, 160, 846, 9102103, 18538, 18539, 18535},
   [9102104] = {12012, 160, 847, 9102104, 18540, 18541, 18535},
   [9102105] = {12013, 160, 848, 9102105, 18542, 18543, 18535},
   [9102106] = {12014, 160, 849, 9102106, 18544, 18545, 18535},
   [9102107] = {12015, 160, 850, 9102107, 18546, 18547, 18535},
   [9102108] = {12016, 160, 851, 9102108, 18548, 18549, 18535},
   [9102109] = {12017, 160, 852, 9102109, 18550, 18551, 18535},
   [9102110] = {12018, 200, 853, 9102110, 18552, 18553, 18535},
}
local _namesByNum = {
   ActiveItem = 1,
   CameraSize = 2,
   Icon = 3,
   Id = 4,
}
local _namesByString = {
   Name = 5,
   RentAtt = 6,
   StarItemnum = 7,
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
