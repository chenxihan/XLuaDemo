------------------------------------------------
--作者： _SqL_
--日期： 2019-05-27
--文件： UIPlayerEquipRoot.lua
--模块： UIPlayerEquipRoot
--描述： 玩家基础属性 时装
------------------------------------------------
local Equipment = CS.Funcell.Code.Logic.Equipment

local UIPlayerEquipRoot = {
    Owner = nil,
    Trans = nil,
    PlayerID = nil,                             -- 玩家id
    PlayerName = nil,                           -- 玩家名字
    PlayerLv = nil,                             -- 玩家等级
    RealmLv = nil,                              -- 玩家境界等级
    CareerIcon = nil,                           -- 职业icon
    GuildName = nil,                            -- 工会名字
    GuildTrans = nil,                           -- 工会显示Trans
    Power = nil,                                -- 战斗力
    SkinComp = nil,                             -- 模型渲染组件
    AddFriendBtn = nil,                         -- 添加好友按钮
    ComparedBtn = nil,                          -- 对比按钮
    EquipListPanel = nil,                       -- 装备item 父节点
    EquipItem = nil,                            -- 装备Item trans
    EquipStartLvList = nil,                     -- 储存装备星际的list
}



function UIPlayerEquipRoot:New(owner, trans)
    self.Owner = owner
    self.Trans = trans
    self:FindAllComponents()
    self:RegUICallback()
    return self
end

function UIPlayerEquipRoot:FindAllComponents()
    self.PlayerName = UIUtils.FindLabel(self.Trans, "Base/Name")
    self.PlayerLv = UIUtils.FindLabel(self.Trans, "Base/Level")
    self.RealmLv = UIUtils.FindSpr(self.Trans, "Base/Realm")
    self.CareerIcon = UIUtils.FindSpr(self.Trans, "Base/Career")
    self.GuildTrans = UIUtils.FindTrans(self.Trans, "Base/Guild")
    self.GuildName = UIUtils.FindLabel(self.Trans, "Base/Guild/Name")
    self.Power = UIUtils.FindLabel(self.Trans, "Power/Value")
    self.AddFriendBtn = UIUtils.FindBtn(self.Trans, "AddFriend")
    self.ComparedBtn = UIUtils.FindBtn(self.Trans, "ComparedBtn")
    self.EquipListPanel = UIUtils.FindTrans(self.Trans, "Equip/EquipList")

    local _t = UIUtils.FindTrans(self.Trans, "UIRoleSkinCompoent")
    self.SkinComp = UIUtils.RequireUIRoleSkinCompoent(_t)
    if self.SkinComp then
        self.SkinComp:OnFirstShow(self.Owner.CSForm, FSkinTypeCode.Player)
    end
end

-- 设置模型
function UIPlayerEquipRoot:SetModelShow(bodyId, wingId, weaponId)
    self.SkinComp:ResetRot()
    self.SkinComp:ResetSkin()
    self.SkinComp:SetCameraSize(1.8)
    self.SkinComp:SetEquip(FSkinPartCode.Body, bodyId)
    -- self.SkinComp:SetEquip(FSkinPartCode.Wing, wingId)
    self.SkinComp:SetEquip(FSkinPartCode.Weapon, weaponId)
end

function UIPlayerEquipRoot:RestSkinModel()
    self.SkinComp:ResetSkin()
end

-- 刷新角色信息
function UIPlayerEquipRoot:RefreshPlayerInfo(data)
    self.PlayerID = data.roleId
    self.PlayerName.text = data.roleName
    self.PlayerLv.text = data.roleLv
    self.Power.text = data.fightPoint
    self.EquipStartLvList = data.partStar
    if data.guildName and data.guildName ~= "" then
        self.GuildTrans.gameObject:SetActive(true)
        self.GuildName.text = data.guildName
    else
        self.GuildTrans.gameObject:SetActive(false)
    end
    if data.vip > 0 then
        self.CareerIcon.gameObject:SetActive(true)
        self.CareerIcon.spriteName = tostring(data.vip)
    else
        self.CareerIcon.gameObject:SetActive(false)
    end
    if data.equipList then
        local _bodyId = 0
        local _weaponId = 0
        for i = 0, data.equipList.Count - 1 do
            local _info = Equipment(data.equipList[i])
            if _info then
                self:SetEquip(i,_info, false)
                if _info.ItemInfo.Part == Utils.GetEnumNumber(tostring(EquipmentType.Weapon)) then
                    _weaponId = RoleVEquipTool.GetWeaponModelID(data.career, _info.ItemInfo.Id, self:GetEquipStartlv(_info.ItemInfo.Id))
                elseif _info.ItemInfo.Part == Utils.GetEnumNumber(tostring(EquipmentType.Clothes)) then
                    _bodyId = RoleVEquipTool.GetBodyModelID(data.career, _info.ItemInfo.Id, self:GetEquipStartlv(_info.ItemInfo.Id))
                end
            else
                Debug.LogError("SetEquip error _info = nil")
            end
        end
        self:SetModelShow(_bodyId, RoleVEquipTool.GetWingModelID(data.career, data.wingId), _weaponId)
    end
end

-- 设置装备
function UIPlayerEquipRoot:SetEquip(index, equipInfo, bind)
    local _go = self.EquipListPanel:GetChild(index)
    if _go then
        local _item = UIUtils.RequireEquipmentItem(_go)
        _item:UpdateEquipment(equipInfo, equipInfo.ItemInfo.Part, self:GetEquipStartlv(equipInfo.ItemInfo.Part), bind)
    else
        Debug.LogError("EquipListPanel get child fail  index = ",index)
    end
end

-- 获取装备星级
function UIPlayerEquipRoot:GetEquipStartlv(id)
    if not self.EquipStartLvList then
        return 0
    end
    for i = 0, self.EquipStartLvList.Count - 1 do
        if id == self.EquipStartLvList[i].key then
            return self.EquipStartLvList[i].value
        end
    end
    return 0
end

-- 添加好友
function UIPlayerEquipRoot:OnAddFriendClick()
    GameCenter.FriendSystem:AddRelation(FriendType.Friend, self.PlayerID)
end

function UIPlayerEquipRoot:RegUICallback()
    UIUtils.AddBtnEvent(self.AddFriendBtn, self.OnAddFriendClick, self)
end

return UIPlayerEquipRoot