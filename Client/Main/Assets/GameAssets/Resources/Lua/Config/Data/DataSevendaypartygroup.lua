--文件是自动生成,请勿手动修改.来自数据文件:sevendaypartygroup
local M = {
   [1] = {18237, 18238, 18239, 18240, 18241, 1, 1, 18242, 18237, 18243, 1},
   [2] = {18244, 18238, 18239, 18245, 18246, 2, 2, 18247, 18248, 18249, 3},
   [3] = {18250, 18238, 18239, 18251, 18246, 3, 3, 18252, 18253, 18254, 2},
   [4] = {18255, 18238, 18239, 18256, 18257, 4, 4, 18258, 14554, 18259, 4},
   [5] = {18260, 18238, 18239, 18261, 18241, 5, 5, 4861, 14571, 18262, 5},
   [6] = {18263, 18238, 18239, 18264, 18265, 6, 6, 18266, 18263, 18267, 6},
}
local _namesByNum = {
   Icon = 6,
   Id = 7,
   Type = 11,
}
local _namesByString = {
   Award = 1,
   Desc1 = 2,
   Desc2 = 3,
   Desc3 = 4,
   Desc4 = 5,
   Name = 8,
   Strong = 9,
   Texture = 10,
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
