------------------------------------------------
--作者： 王圣
--日期： 2019-04-26
--文件： RankMenuData.lua
--模块： RankMenuData
--描述： 排行榜菜单数据类
------------------------------------------------
--引用
local ChildMenuData = require "Logic.Rank.MenuData.RankChildMenuData"
local RankMenuData = {
    --大菜单id
    MenuType = 0,
    MenuName = nil,
    ChildMenuDic = Dictionary:New(),
}

--New 
function RankMenuData:New()
    local _m = Utils.DeepCopy(self)
    return _m
end

--添加菜单
function RankMenuData:AddMenu(cfg)
    local childMenu = self:GetChildMenu(cfg.Id)
    childMenu:SetCfg(cfg)
    self.MenuType = cfg.Type
    self.MenuName = cfg.TypeName
end

--获取子菜单
function RankMenuData:GetChildMenu(id)
    if self.ChildMenuDic:ContainsKey(id) then
        return self.ChildMenuDic[id]
    else
        local childMenu = ChildMenuData:New()
        self.ChildMenuDic:Add(id,childMenu)
        return childMenu
    end
end

--获取第一个子菜单数据
function RankMenuData:GetFirstChildMenu()
    for k,v in pairs(self.ChildMenuDic) do
        return v
    end
end

function RankMenuData:GetChildMenuData(key)
    for k,v in pairs(self.ChildMenuDic) do
        if k == key then
            return v
        end
    end
end
return RankMenuData