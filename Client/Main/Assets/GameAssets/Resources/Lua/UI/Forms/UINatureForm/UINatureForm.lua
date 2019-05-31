------------------------------------------------
--作者： xc
--日期： 2019-04-16
--文件： UINatureForm.lua
--模块： UINatureForm
--描述： 造化面板
------------------------------------------------
--引用
local UIListMenu = require "UI.Components.UIListMenu.UIListMenu"

local UINatureForm = {
    UIListMenu = nil,--列表
    Form = NatureEnum.Begin, --分页类型
    TabForm = 1, --子分页类型
    CloseBtn = nil,--关闭按钮
    AnimModule = nil, --动画模块
    BackTexture = nil, --Texture
}

function UINatureForm:OnRegisterEvents()
	self:RegisterEvent(UIEventDefine.UINatureForm_OPEN, self.OnOpen)
	self:RegisterEvent(UIEventDefine.UINatureForm_CLOSE, self.OnClose)
end

function UINatureForm:OnOpen(obj, sender)
    self.CSForm:Show(sender)
    self.Form = -1;
	if obj then
		if type(obj) == "table" then
			if #obj == 2 then
				self.Form = obj[1]
				self.TabForm = obj[2]
			end
		else
			self.Form = obj
		end
    end
    if self.Form == -1 then
        local _artFlag = false
        for i = NatureEnum.Begin, NatureEnum.Count do 
            if i == NatureEnum.Wing then --翅膀
                _artFlag = GameCenter.MainFunctionSystem:GetAlertFlag(FunctionStartIdCode.NatureWing)
                if _artFlag then
                    self.Form = NatureEnum.Wing
                end
            elseif i == NatureEnum.Talisman then --法宝
                _artFlag = GameCenter.MainFunctionSystem:GetAlertFlag(FunctionStartIdCode.NatureTalisman)
                if _artFlag then
                    self.Form = NatureEnum.Talisman
                end
            elseif i == NatureEnum.Magic then --阵法
                _artFlag = GameCenter.MainFunctionSystem:GetAlertFlag(FunctionStartIdCode.NatureMagic)
                if _artFlag then
                    self.Form = NatureEnum.Magic
                end
            elseif i == NatureEnum.Weapon then --神兵
                _artFlag = GameCenter.MainFunctionSystem:GetAlertFlag(FunctionStartIdCode.NatureWeapon)
                if _artFlag then
                    self.Form = NatureEnum.Weapon
                end
            end
        end
    end
    if self.Form == -1 then
        self.Form = NatureEnum.Begin
    end
	self.UIListMenu:SetSelectById(self.Form)
end

function UINatureForm:OnClose(obj, sender)
    self.CSForm:Hide()
end

--注册UI上面的事件，比如点击事件等
function UINatureForm:RegUICallback()
	self.CloseBtn.onClick:Clear();
	EventDelegate.Add(self.CloseBtn.onClick, Utils.Handler(self.OnClickCloseBtn, self))
end

function UINatureForm:OnFirstShow()
    self:FindAllComponents()
    self:RegUICallback()
end

function UINatureForm:OnShowAfter()
    self:LoadTextures()
end

function UINatureForm:OnShowBefore()
    self.AnimModule:PlayEnableAnimation()
end

function UINatureForm:OnHideBefore()
    self.UIListMenu:SetSelectByIndex(-1);
    self.AnimModule:PlayDisableAnimation()
end

--点击界面上关闭按钮
function UINatureForm:OnClickCloseBtn()
	self:OnClose(nil, nil)
end

function UINatureForm:FindAllComponents()
    self.UIListMenu = UIListMenu:OnFirstShow(self.CSForm, UIUtils.FindTrans(self.Trans, "Right/UIListMenu"))
    self.UIListMenu:AddIcon(NatureEnum.Wing,DataConfig.DataMessageString.Get("NATUREWING"),FunctionStartIdCode.NatureWing)
    self.UIListMenu:AddIcon(NatureEnum.Talisman,DataConfig.DataMessageString.Get("NATURETALISMAN"),FunctionStartIdCode.NatureTalisman)
    self.UIListMenu:AddIcon(NatureEnum.Magic,DataConfig.DataMessageString.Get("NATUREMAGIC"),FunctionStartIdCode.NatureMagic)
    self.UIListMenu:AddIcon(NatureEnum.Weapon,DataConfig.DataMessageString.Get("NATUREWEAPON"),FunctionStartIdCode.NatureWeapon)
    self.UIListMenu:AddSelectEvent(Utils.Handler(self.OnMenuSelect,self))
    self.UIListMenu.IsHideIconByFunc = true
    self.CloseBtn = UIUtils.FindBtn(self.Trans,"Top/closeButton")
    self.BackTexture = UIUtils.FindTex(self.Trans,"BgTexture")
    self.AnimModule = UIAnimationModule(self.Trans)
    self.AnimModule:AddPositionAnimation(180,0,UIUtils.FindTrans(self.Trans,"Right"))
end

function UINatureForm:OnMenuSelect(id, sender)
    self.Form = id
    if sender then
        self:OpenSubForm(id)
    else
        self:CloseSubForm(id)
    end
end

function UINatureForm:OpenSubForm(id)
    if id == NatureEnum.Wing then --翅膀
        GameCenter.PushFixEvent(UIEventDefine.UINatureWingForm_OPEN, self.TabForm, self.CSForm)
    elseif id == NatureEnum.Talisman then --法宝
        GameCenter.PushFixEvent(UIEventDefine.UINatureTalismanForm_OPEN, self.TabForm, self.CSForm)
    elseif id == NatureEnum.Magic then --阵法
        GameCenter.PushFixEvent(UIEventDefine.UINatureMagicForm_OPEN, self.TabForm, self.CSForm)
    elseif id == NatureEnum.Weapon then --神兵
        GameCenter.PushFixEvent(UIEventDefine.UINatureWeaponForm_OPEN, self.TabForm, self.CSForm)
    end
end

function UINatureForm:CloseSubForm(id)
    if id == NatureEnum.Wing then --翅膀
        GameCenter.PushFixEvent(UIEventDefine.UINatureWingForm_CLOSE, self.TabForm, self.CSForm)
    elseif id == NatureEnum.Talisman then --法宝
        GameCenter.PushFixEvent(UIEventDefine.UINatureTalismanForm_CLOSE, self.TabForm, self.CSForm)
    elseif id == NatureEnum.Magic then--阵法
        GameCenter.PushFixEvent(UIEventDefine.UINatureMagicForm_CLOSE, self.TabForm, self.CSForm)
    elseif id == NatureEnum.Weapon then--神兵
        GameCenter.PushFixEvent(UIEventDefine.UINatureWeaponForm_CLOSE, self.TabForm, self.CSForm)
    end
end

--加载texture
function UINatureForm:LoadTextures()
    self.CSForm:LoadTexture(self.BackTexture,AssetUtils.GetImageAssetPath(ImageTypeCode.UI, "bag_back"))
end


return UINatureForm