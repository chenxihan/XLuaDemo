------------------------------------------------
--作者： _SqL_
--日期： 2019-04-30
--文件： UIShowRoot.lua
--模块： UIShowRoot
--描述： 境界 模型特效展示 Root
------------------------------------------------

local UIShowRoot = {
    Owner = nil,
    Trans = nil,
    -- 模型显示组件
    SkinComp = nil,
    -- 特效显示组件
    VfxComp = nil,
    -- 特效挂载对象
    VfxParent = nil,
}

function  UIShowRoot:New(owner, trans)
    self.Owner = owner
    self.Trans = trans
    self:FindAllComponents()
    return self
end

function UIShowRoot:FindAllComponents()
    self.VfxParent = UIUtils.FindTrans(self.Trans, "VFXViewRoot")
    local _skinTrans = UIUtils.FindTrans(self.Trans, "UIRoleSkinCompoent")
    self.SkinComp = UIUtils.RequireUIRoleSkinCompoent(_skinTrans)
    if self.SkinComp then
        self.SkinComp:OnFirstShow(self.Owner.CSForm, FSkinTypeCode.Player, "sit")
    end

    self:PlayVfx(ModelTypeCode.UIVFX, 001)
end

function UIShowRoot:SetModelShow()
    self.SkinComp:ResetRot()
    self.SkinComp:ResetSkin()
    self.SkinComp:SetCameraSize(1.3)
    self.SkinComp:SetEquip(FSkinPartCode.Body, RoleVEquipTool.GetLPBodyModel())
    self.SkinComp:SetEquip(FSkinPartCode.Weapon, RoleVEquipTool.GetLPWeaponModel())
end

function UIShowRoot:PlayVfx(type, vfxId)
	self.Vfx = CS.Funcell.Core.Asset.FGameObjectVFX(type, vfxId);
	self.Vfx:SetParent(self.VfxParent, true);
	self.Vfx:SetLayer(LayerUtils.UITop, true);
	self.Vfx:Play(1);
	self._showTips = true;
end

function UIShowRoot:OnHideBefore()
    self.SkinComp:ResetSkin()
    -- self.VfxComp:OnDestory()
end

function UIShowRoot:OnOpen()
    self.Trans.gameObject:SetActive(true)
end

function UIShowRoot:OnCLose()
    self.Trans.gameObject:SetActive(false)
end

return UIShowRoot