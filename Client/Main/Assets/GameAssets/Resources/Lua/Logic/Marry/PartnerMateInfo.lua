
------------------------------------------------
--作者： dhq
--日期： 2019-05-5
--文件： PartnerMateInfo.lua
--模块： PartnerMateInfo
--描述： 配偶的外观信息
------------------------------------------------
local PartnerMateInfo =
{
    --等级
    Level = nil,
    --职业
    Career = nil,
    --衣服装备Id
    ClothesEquipId = nil,
    --武器装备Id
    WeaponsEquipId = nil,
    --衣服部位的星级
    ClothesStar = nil,
    --武器部位的星级
    WeaponStar = nil,
    --时装身体Id
    FashionBodyId = nil,
    --时装武器Id
    FashionWeaponId = nil,
    --翅膀Id
    WingId = nil,
    --时装星级
    FashionLayer = nil,
    --角色转职阶位等级
    Degree = nil,
}

function PartnerMateInfo:New()
    local _m = Utils.DeepCopy(self)
    return _m
end

function PartnerMateInfo:UpdateNetData(mateInfo)
    --等级
    self.Level = mateInfo.level
    --职业
    self.Career = mateInfo.career
    --衣服装备Id
    self.ClothesEquipId = mateInfo.clothesEquipId
    --武器装备Id
    self.WeaponsEquipId = mateInfo.weaponsEquipId
    --衣服部位的星级
    self.ClothesStar = mateInfo.clothesStar
    --武器部位的星级
    self.WeaponStar = mateInfo.weaponStar
    --时装身体Id
    self.FashionBodyId = mateInfo.fashionBodyId
    --时装武器Id
    self.FashionWeaponId = mateInfo.fashionWeaponId
    --翅膀Id
    self.WingId = mateInfo.wingId
    --时装星级
    self.FashionLayer = mateInfo.fashionLayer
    --角色转职阶位等级
    self.Degree = mateInfo.degree
    return self
end

return PartnerMateInfo