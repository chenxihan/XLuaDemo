--文件是自动生成,请勿手动修改.来自数据文件:vipLevel
local M = {
   [0] = {1, 685, 1, 0, 10, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 33626, 1, 17844, 0, 0, 0, 10, 1000, 10, 0, -1, -1, 0, 0},
   [1] = {1, 685, 1, 1, 11, 0, 0, 1008, 1, 1, 0, 0, 0, 0, 1, 0, 33627, 1, 33628, 0, 1, 60, 11, 1000, 11, 1, -1, 1800000, 1, 0},
   [2] = {1, 685, 1, 2, 12, 0, 0, 1008, 1, 1, 0, 0, 1, 0, 2, 0, 33629, 1, 33630, 0, 2, 300, 12, 1500, 12, 1, -1, 0, 2, 0},
   [3] = {1, 685, 1, 3, 12, 0, 0, 1008, 1, 1, 0, 0, 1, 0, 2, 0, 33631, 1, 33632, 0, 3, 680, 13, 1500, 13, 2, -1, 0, 2, 0},
   [4] = {1, 685, 2, 4, 13, 1, 0, 1008, 1, 1, 0, 0, 1, 0, 3, 0, 33633, 1, 33634, 0, 4, 1200, 14, 2000, 14, 2, -1, 0, 3, 0},
   [5] = {1, 685, 2, 5, 13, 1, 0, 1008, 1, 1, 1, 0, 2, 0, 3, 0, 33635, 1, 33636, 0, 5, 25000, 15, 2000, 15, 3, -1, 0, 3, 0},
   [6] = {1, 685, 3, 6, 14, 1, 0, 1008, 1, 1, 1, 0, 2, 0, 4, 0, 33637, 1, 33638, 1, 6, 50000, 16, 2500, 16, 3, -1, 0, 4, 0},
   [7] = {1, 685, 3, 7, 14, 1, 0, 1008, 1, 1, 1, 0, 2, 0, 4, 0, 33639, 1, 33640, 1, 7, 100000, 17, 2500, 17, 4, -1, 0, 4, 0},
   [8] = {1, 685, 4, 8, 15, 1, 0, 1008, 1, 1, 1, 0, 3, 0, 5, 0, 33641, 1, 33642, 1, 8, 200000, 18, 3000, 18, 4, -1, 0, 5, 0},
   [9] = {1, 685, 4, 9, 15, 1, 0, 1008, 1, 1, 1, 0, 3, 0, 5, 0, 33643, 1, 33644, 1, 9, 500000, 19, 3000, 19, 5, -1, 0, 5, 0},
}
local _namesByNum = {
   BossElementsTemple = 3,
   BossGodCloneNum = 4,
   BossGodRuinsNum = 5,
   BossHome = 6,
   BossPersonalNum = 7,
   BuffID = 8,
   CanFreeTranspot = 9,
   CanSell = 10,
   CanSkipCloneStory = 11,
   CloneBombing = 12,
   CloneExpNum = 13,
   CloneManyPeople = 14,
   CloneStoryNum = 15,
   CloneTrial = 16,
   HearseDiftNum = 20,
   Level = 21,
   NeedSpend = 22,
   PrayExpNum = 23,
   PrayMoneyCritChance = 24,
   PrayMoneyNum = 25,
   TitleID = 26,
   TitleIDtime = 27,
   VipOverTime = 28,
   YingLingDianNum = 29,
   YyHuanJingNum = 30,
}
local _namesByString = {
   AddBuyCount = 1,
   AddItemUseCount = 2,
   Des = 17,
   Equip = 18,
   Gift = 19,
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
