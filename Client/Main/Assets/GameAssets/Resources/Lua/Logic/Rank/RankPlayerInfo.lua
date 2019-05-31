------------------------------------------------
--作者： 王圣
--日期： 2019-04-29
--文件： RankPlayerInfo.lua
--模块： RankPlayerInfo
--描述： 排行榜玩家数据类
------------------------------------------------
--引用
local RankPlayerInfo = {
    RoleId = 0,
    Career = 0,
    Level = 0,
    --被崇拜次数
    BePraiseNum = 0,
    --武器id
    WeaponsEquipId = 0,
    --武器部位星级
    WeaponStar = 0,
    --衣服部位星级
    ClothesStar = 0,
    --时装身体ID
    FashionBodyId = 0, 
    --时装武器ID
    FashionWeaponId = 0,
    --时装星级
	FashionLayer = 0,
}

function RankPlayerInfo:New()
    local _m = Utils.DeepCopy(self)
    return _m
end

function RankPlayerInfo:Parase(info)
    self.RoleId = info.RoleId
    self.Career = info.career
    self.Level = info.level
    self.BePraiseNum = info.beWorshipedNum
    self.WeaponsEquipId = info.weaponsEquipId
    self.WeaponStar = info.weaponStar
    self.ClothesStar = info.clothesStar
    self.FashionBodyId = info.fashionBodyId
    self.FashionWeaponId = info.fashionWeaponId
    self.FashionLayer = info.fashionLayer
end
return RankPlayerInfo