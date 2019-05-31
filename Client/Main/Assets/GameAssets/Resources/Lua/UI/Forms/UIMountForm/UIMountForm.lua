------------------------------------------------
--作者： xc
--日期： 2019-05-06
--文件： UIMountForm.lua
--模块： UIMountForm
--描述： 坐骑面板
------------------------------------------------
--引用
local UIListMenu = require "UI.Components.UIListMenu.UIListMenu"

local UIMountForm = {
    UIListMenu = nil,--列表
    Form = MountEnum.Begin, --分页类型
    TabForm = 1, --子分页类型
    CloseBtn = nil,--关闭按钮
    AnimModule = nil, --动画模块
    BackTexture = nil, --Texture
}

function UIMountForm:OnRegisterEvents()
	self:RegisterEvent(UIEventDefine.UIMountForm_OPEN,self.OnOpen)
	self:RegisterEvent(UIEventDefine.UIMountForm_CLOSE,self.OnClose)
end

function UIMountForm:OnOpen(obj, sender)
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
        self.Form = MountEnum.Begin
    end
	self.UIListMenu:SetSelectById(self.Form)
end

function UIMountForm:OnClose(obj, sender)
    self.CSForm:Hide()
end

--注册UI上面的事件，比如点击事件等
function UIMountForm:RegUICallback()
	self.CloseBtn.onClick:Clear();
	EventDelegate.Add(self.CloseBtn.onClick, Utils.Handler(self.OnClickCloseBtn, self))
end

function UIMountForm:OnFirstShow()
    self:FindAllComponents()
    self:RegUICallback()
end

function UIMountForm:OnShowAfter()
    self:LoadTextures()
end

function UIMountForm:OnShowBefore()
    self.AnimModule:PlayEnableAnimation()
end

function UIMountForm:OnHideBefore()
    self.UIListMenu:SetSelectByIndex(-1);
    self.AnimModule:PlayDisableAnimation()
end

--点击界面上关闭按钮
function UIMountForm:OnClickCloseBtn()
	self:OnClose(nil, nil)
end

function UIMountForm:FindAllComponents() 
    self.UIListMenu = UIListMenu:OnFirstShow(self.CSForm, UIUtils.FindTrans(self.Trans, "Right/UIListMenu"))
    self.UIListMenu:AddIcon(NatureEnum.Mount,DataConfig.DataMessageString.Get("NATUREMOUNT"),FunctionStartIdCode.Mount)
    self.UIListMenu:AddSelectEvent(Utils.Handler(self.OnMenuSelect,self))
    self.UIListMenu.IsHideIconByFunc = true
    self.CloseBtn = UIUtils.FindBtn(self.Trans,"Top/closeButton")
    self.BackTexture = UIUtils.FindTex(self.Trans,"BgTexture")
    self.AnimModule = UIAnimationModule(self.Trans)
    self.AnimModule:AddPositionAnimation(180,0,UIUtils.FindTrans(self.Trans,"Right"))
end

function UIMountForm:OnMenuSelect(id, sender)
    self.Form = id
    if sender then
        self:OpenSubForm(id)
    else
        self:CloseSubForm(id)
    end
end

function UIMountForm:OpenSubForm(id)
    if id == MountEnum.BaseGrowUp then --坐骑
        GameCenter.PushFixEvent(UIEventDefine.UIMountGrowUpForm_OPEN, self.TabForm, self.CSForm)
    end
end

function UIMountForm:CloseSubForm(id)
    if id == MountEnum.BaseGrowUp then --坐骑
        GameCenter.PushFixEvent(UIEventDefine.UIMountGrowUpForm_CLOSE, self.TabForm, self.CSForm)
    end
end

--加载texture
function UIMountForm:LoadTextures()
    self.CSForm:LoadTexture(self.BackTexture,AssetUtils.GetImageAssetPath(ImageTypeCode.UI, "bag_back"))
end


return UIMountForm