--文件是自动生成,请勿手动修改.来自数据文件:HuaxingWeapon
local M = {
   [9103101] = {11009, 160, 844, 9103101, 36225, 18534, 18535},
   [9103102] = {11010, 160, 845, 9103102, 36226, 18537, 18535},
   [9103103] = {11011, 160, 846, 9103103, 36227, 18539, 18535},
   [9103104] = {11012, 160, 847, 9103104, 36228, 18541, 18535},
   [9103105] = {11013, 160, 848, 9103105, 36229, 18543, 18535},
   [9103106] = {11014, 160, 849, 9103106, 36230, 18545, 18535},
   [9103107] = {11015, 160, 850, 9103107, 36231, 18547, 18535},
   [9103108] = {11016, 160, 851, 9103108, 36232, 18549, 18535},
   [9103109] = {11017, 160, 852, 9103109, 36233, 18551, 18535},
   [9103110] = {11018, 200, 853, 9103110, 36234, 18553, 18535},
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
