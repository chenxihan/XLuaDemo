--文件是自动生成,请勿手动修改.来自数据文件:hallows_model
local M = {
   [1] = {16008, 16009, 1213, 1, 10, 1, 18664, 16008, 16009, 18665},
   [2] = {16010, 16011, 1214, 2, 10, 1, 18666, 16010, 16011, 18667},
   [3] = {16012, 16013, 1215, 3, 10, 1, 18668, 16012, 16013, 4269},
   [4] = {16014, 16015, 1216, 4, 10, 1, 18669, 16014, 16015, 4270},
   [5] = {16016, 16017, 1217, 5, 10, 1, 18670, 16016, 16017, 4279},
   [6] = {16018, 16019, 1220, 6, 10, 1, 18671, 16018, 16019, 18672},
   [7] = {16020, 16021, 1221, 7, 10, 1, 18673, 16020, 16021, 18674},
   [8] = {16022, 16023, 1222, 8, 10, 1, 18675, 16022, 16023, 18676},
}
local _namesByNum = {
   Icon = 3,
   Id = 4,
   MaxLevel = 5,
   Notice = 6,
}
local _namesByString = {
   ActiveAttr = 1,
   ActiveItem = 2,
   Res = 7,
   TrainAttr = 8,
   TrainItem = 9,
   UiRes = 10,
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
