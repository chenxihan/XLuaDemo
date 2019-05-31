--文件是自动生成,请勿手动修改.来自数据文件:level_reward
local M = {
   [30] = {-1, 1, 30, 33769, 33770},
   [50] = {-1, 1, 50, 33771, 33770},
   [70] = {-1, 1, 70, 33772, 33773},
   [110] = {-1, 1, 110, 1, 33774},
   [130] = {-1, 1, 130, 1, 33775},
   [160] = {-1, 1, 160, 33776, 33777},
   [180] = {-1, 0, 180, 1, 33778},
   [200] = {-1, 0, 200, 1, 33779},
   [220] = {200, 0, 220, 33780, 33781},
   [240] = {50, 0, 240, 1, 33782},
   [260] = {20, 0, 260, 33783, 33784},
   [300] = {3, 0, 300, 33785, 33786},
}
local _namesByNum = {
   LimitValue = 1,
   PaoPao = 2,
   QLevel = 3,
}
local _namesByString = {
   QRewardEquip = 4,
   QRewardItem = 5,
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
