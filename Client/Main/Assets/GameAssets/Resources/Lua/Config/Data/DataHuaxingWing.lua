--文件是自动生成,请勿手动修改.来自数据文件:HuaxingWing
local M = {
   [9100101] = {11009, 160, 844, 9100101, 19452, 18534, 18535},
   [9100102] = {11010, 160, 845, 9100102, 19460, 18537, 18535},
   [9100103] = {11011, 160, 846, 9100103, 19468, 18539, 18535},
   [9100104] = {11012, 160, 847, 9100104, 19476, 18541, 18535},
   [9100105] = {11013, 160, 848, 9100105, 19484, 18543, 18535},
   [9100106] = {11014, 160, 849, 9100106, 19492, 18545, 18535},
   [9100107] = {11015, 160, 850, 9100107, 19499, 18547, 18535},
   [9100108] = {11016, 160, 851, 9100108, 19507, 18549, 18535},
   [9100109] = {11017, 160, 852, 9100109, 19514, 18551, 18535},
   [9100110] = {11018, 200, 853, 9100110, 19521, 18553, 18535},
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
