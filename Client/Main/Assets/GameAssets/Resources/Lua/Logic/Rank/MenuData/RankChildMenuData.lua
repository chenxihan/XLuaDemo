------------------------------------------------
--作者： 王圣
--日期： 2019-04-26
--文件： RankChildMenuData.lua
--模块： RankChildMenuData
--描述： 排行榜子菜单数据类
------------------------------------------------
--引用
local ItemData = require "Logic.Rank.ItemData.RankItemData"
local CompareData = require "Logic.Rank.ItemData.RankCompareData"
local RankChildMenuData = {
    Cfg = nil,
    CompareInfo = nil,
    ItemList = List:New(),
}

--New 
function RankChildMenuData:New()
    local _m = Utils.DeepCopy(self)
    return _m
end

--设置子菜单配置数据
function RankChildMenuData:SetCfg(cfg)
    self.Cfg = cfg
    if self.CompareInfo == nil then
        self.CompareInfo = CompareData:New()
    end
end

--设置itemList数据
function RankChildMenuData:AddItemData(rankInfo)
    if rankInfo == nil then
        return
    end 
    for i = 1,#rankInfo do
        local data = self:GetData(rankInfo[i].roleId)
        if data == nil then
            data = ItemData:New(rankInfo[i])
            self.ItemList:Add(data)
        end
        data:SetData(rankInfo[i])
    end
end

function RankChildMenuData:GetData(roleId)
    for i = 1,#self.ItemList do
        if self.ItemList[i].RoleId == roleId then
            return self.ItemList[i]
        end
    end
    return nil
end

--获取ItemList
function RankChildMenuData:GetItemList()
    return self.ItemList
end

--获取Compare数据
function RankChildMenuData:GetCompareData()
    return self.CompareInfo
end

return RankChildMenuData