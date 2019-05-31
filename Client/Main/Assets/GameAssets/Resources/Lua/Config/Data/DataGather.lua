--文件是自动生成,请勿手动修改.来自数据文件:Gather
local M = {
   [9000008] = {0, 1, 41094, 2000, 1, 0, 0, 0, 0, 300, 9000008, 100, 1, 41095, 699997, 0, 1, 1, 70, 1, 0},
   [10002] = {0, 1, 41096, 3000, 1, 0, 0, 0, 0, 1015, 10002, 50, 1, 41097, 610014, 1, 0, 0, 100, 1, 1},
}
local _namesByNum = {
   AfterType = 1,
   CollectTime = 4,
   DropNum = 6,
   EffectId = 7,
   EnemyFlag = 8,
   FriendsFlag = 9,
   Icon = 10,
   Id = 11,
   LogicBodySize = 12,
   Res = 15,
   Share = 16,
   ShowName = 17,
   ShowButton = 18,
   SizeScale = 19,
   Type = 21,
}
local _namesByString = {
   AnimName = 2,
   CollectInfo = 3,
   Dialog = 5,
   MultType = 13,
   Name = 14,
   TakHinde = 20,
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
