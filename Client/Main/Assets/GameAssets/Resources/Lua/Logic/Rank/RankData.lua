------------------------------------------------
--作者： 王圣
--日期： 2019-04-26
--文件： RankData.lua
--模块： RankData
--描述： 排行榜数据类
------------------------------------------------
--引用
local MenuData = require "Logic.Rank.MenuData.RankMenuData"
local RankData = {
    --我的排名
    MyRank = 0,
    --我的战斗力
    MyPower = 0,
    MenuList = List:New(),
}

--New 
function RankData:New()
    local _m = Utils.DeepCopy(self)
    return _m
end

--解析配置表数据
function RankData:ParseCfg(cfg)
    if cfg == nil then
        return
    end
    local menu = self:GetMenu(cfg.Type)
    menu:AddMenu(cfg)
end

--获取Menu
function RankData:GetMenu(type)
    local isExist = false
    for i = 1 , #self.MenuList do
        if self.MenuList[i].MenuType == type then
            isExist = true
            return self.MenuList[i]
        end
    end
    if isExist == false then
        --创建一个Menu
        local menu = MenuData:New()
        menu.MenuType = type
        self.MenuList:Add(menu)
        return menu
    end
end
--
function RankData:GetItemList(rankId)
    for i = 1, #self.MenuList do
        local childMenuData = self.MenuList[i]:GetChildMenuData(rankId)
        if childMenuData ~= nil then
            return childMenuData:GetItemList()
        end
    end
end

--添加Item数据
function RankData:AddItemInfo(rankKind, info)
    for i = 1, #self.MenuList do
        local childMenuData = self.MenuList[i]:GetChildMenuData(rankKind)
        if childMenuData ~= nil then
            return childMenuData:AddItemData(info)
        end
    end
    local lp = GameCenter.GameSceneSystem:GetLocalPlayer()
    if lp ~= nil then
        self.MyPower = lp.FightPower
    end
end

--获取Compare数据by RankId
function RankData:GetCompareDataByRankId(rankId)
    for i = 1, #self.MenuList do
        local childMenuData = self.MenuList[i]:GetChildMenuData(rankId)
        if childMenuData ~= nil then
            return childMenuData:GetCompareData()
        end
    end
end
return RankData