------------------------------------------------
--作者： xc
--日期： 2019-05-10
--文件： UIBossForm.lua
--模块： UIBossForm
--描述： BOSS面板
------------------------------------------------
--引用
local UIListMenu = require "UI.Components.UIListMenu.UIListMenu"

local UIBossForm = {
    UIListMenu = nil,--列表
    Form = NatureEnum.Begin, --分页类型
    CloseBtn = nil,--关闭按钮

    AnimModule = nil, --动画模块
    BackTexture = nil, --Texture
}

function UIBossForm:OnRegisterEvents()
	self:RegisterEvent(UIEventDefine.UIBossForm_OPEN, self.OnOpen)
	self:RegisterEvent(UIEventDefine.UIBossForm_CLOSE, self.OnClose)
end

function UIBossForm:OnOpen(obj, sender)
    self.CSForm:Show(sender)
    self.Form = obj;
	self.UIListMenu:SetSelectById(self.Form)
end

function UIBossForm:OnClose(obj, sender)
    self.CSForm:Hide()
end

--注册UI上面的事件，比如点击事件等
function UIBossForm:RegUICallback()
	self.CloseBtn.onClick:Clear();
	EventDelegate.Add(self.CloseBtn.onClick, Utils.Handler(self.OnClickCloseBtn, self))
end

function UIBossForm:OnFirstShow()
    self:FindAllComponents()
    self:RegUICallback()
end

function UIBossForm:OnShowAfter()
    self:LoadTextures()
end

function UIBossForm:OnShowBefore()
    self.AnimModule:PlayEnableAnimation()
end

function UIBossForm:OnHideBefore()
    self.UIListMenu:SetSelectByIndex(-1);
    self.AnimModule:PlayDisableAnimation()
end

--点击界面上关闭按钮
function UIBossForm:OnClickCloseBtn()
	self:OnClose(nil, nil)
end

function UIBossForm:FindAllComponents()
    self.UIListMenu = UIListMenu:OnFirstShow(self.CSForm, UIUtils.FindTrans(self.Trans, "Right/UIListMenu"))
    self.UIListMenu:AddIcon(BossEnum.WorldBoss,DataConfig.DataMessageString.Get("BOSS_WORLD_TITTLE"),FunctionStartIdCode.WorldBoss)
    self.UIListMenu:AddIcon(BossEnum.MySelfBoss,DataConfig.DataMessageString.Get("BOSS_MYSELF_TITTLE"),FunctionStartIdCode.MySelfBoss)
    self.UIListMenu:AddSelectEvent(Utils.Handler(self.OnMenuSelect,self))
    self.UIListMenu.IsHideIconByFunc = true
    self.CloseBtn = UIUtils.FindBtn(self.Trans,"Top/closeButton")
    self.AnimModule = UIAnimationModule(self.Trans)
    self.AnimModule:AddAlphaAnimation(UIUtils.FindTrans(self.Trans,"Right"))
    self.BackTexture = UIUtils.FindTex(self.Trans,"BgTexture")
end

function UIBossForm:OnMenuSelect(id, sender)
    self.Form = id
    if sender then
        self:OpenSubForm(id)
    else
        self:CloseSubForm(id)
    end
end

function UIBossForm:OpenSubForm(id)
    if id == BossEnum.WorldBoss then --世界BOSS
        GameCenter.PushFixEvent(UIEventDefine.UINewWorldBossForm_OPEN, nil, self.CSForm)
    elseif id == BossEnum.MySelfBoss then --个人BOSS
        GameCenter.PushFixEvent(UIEventDefine.UIMySelfBossForm_OPEN, nil, self.CSForm)
    end
end

function UIBossForm:CloseSubForm(id)
    if id == BossEnum.WorldBoss then --世界BOSS
        GameCenter.PushFixEvent(UIEventDefine.UINewWorldBossForm_CLOSE, nil, self.CSForm)
    elseif id == BossEnum.MySelfBoss then --个人BOSS
        GameCenter.PushFixEvent(UIEventDefine.UIMySelfBossForm_CLOSE, nil, self.CSForm)
    end
end
--加载texture
function UIBossForm:LoadTextures()
    self.CSForm:LoadTexture(self.BackTexture,AssetUtils.GetImageAssetPath(ImageTypeCode.UI, "bag_back"))
end

return UIBossForm