--文件是自动生成,请勿手动修改.来自数据文件:HuaxingMagic
local M = {
   [9101101] = {13006, 160, 844, 9101101, 43145, 18534, 18535},
   [9101102] = {13007, 160, 845, 9101102, 43144, 18537, 18535},
   [9101103] = {13008, 160, 846, 9101103, 43143, 18539, 18535},
   [9101104] = {13009, 160, 847, 9101104, 43142, 18541, 18535},
   [9101105] = {13010, 160, 848, 9101105, 43141, 18543, 18535},
   [9101106] = {13011, 160, 849, 9101106, 43140, 18545, 18535},
   [9101107] = {13012, 160, 850, 9101107, 43139, 18547, 18535},
   [9101108] = {13013, 160, 851, 9101108, 43138, 18549, 18535},
   [9101109] = {13014, 160, 852, 9101109, 43137, 18551, 18535},
   [9101110] = {13015, 200, 853, 9101110, 43136, 18553, 18535},
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
