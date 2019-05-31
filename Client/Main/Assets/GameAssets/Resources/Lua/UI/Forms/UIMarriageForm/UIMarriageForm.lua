------------------------------------------------
--作者： dhq
--日期： 2019-05-10
--文件： UIMarriageForm.lua
--模块： UIMarriageForm
--描述： 婚姻系统的入口
------------------------------------------------
local UIListMenu = require "UI.Components.UIListMenu.UIListMenu"
local UIMarryInfoPanel = require "UI.Forms.UIMarriageForm.MarriageInfoPanel.UIMarryInfoPanel"
local UIMarryHousePanel = require "UI.Forms.UIMarriageForm.MarriageHousePanel.UIMarryHousePanel"
local UIMarryChildPanel = require "UI.Forms.UIMarriageForm.UIMarryChildPanel"
local UIMarryBoxPanel = require "UI.Forms.UIMarriageForm.UIMarryBoxPanel"
local UIMarryBlessPanel = require "UI.Forms.UIMarriageForm.MarriageBless.UIMarryBlessPanel"
local UIMarriageForm = 
{
    --UIListMenu
    ListMenu = nil,
    --UIButton
    CloseBtn = nil,
    --BagFormSubPanel 保存打开的标签
    CurPanel = 0,
    --itemModel 打开界面所用到的数据
    CurData = nil,
    TitleLabel = nil,
    BackTexture = nil,

    -- 婚姻信息界面
    MarryInfoPanel = nil,
    -- 仙居界面
    MarryHousePanel = nil,
    -- 仙娃界面
    MarryChildPanel = nil,
    -- 宝匣界面
    MarryBoxPanel = nil,
    -- 祈福界面
    MarryBlessPanel = nil
}

--注册事件函数, 提供给CS端调用.
function UIMarriageForm:OnRegisterEvents()
	self:RegisterEvent(UIEventDefine.UIMarriageForm_OPEN,self.OnOpen)
	self:RegisterEvent(UIEventDefine.UIMarriageForm_CLOSE,self.OnClose)
end

--Load函数, 提供给CS端调用.
function UIMarriageForm:OnLoad()
	Debug.Log("Lua OnLoad")
end

--第一只显示函数, 提供给CS端调用.
function UIMarriageForm:OnFirstShow()
	self:FindAllComponents()
end

--显示之前的操作, 提供给CS端调用.
function UIMarriageForm:OnShowBefore()
	Debug.Log("Lua OnShowBefore")
end

--显示后的操作, 提供给CS端调用.
function UIMarriageForm:OnShowAfter()
	self:LoadTextures()
end

--隐藏之前的操作, 提供给CS端调用.
function UIMarriageForm:OnHideBefore()
	Debug.Log("Lua OnHideBefore")
end

--隐藏之后的操作, 提供给CS端调用.
function UIMarriageForm:OnHideAfter()
	Debug.Log("Lua OnHideAfter")
end

--卸载事件的操作, 提供给CS端调用.
function UIMarriageForm:OnUnRegisterEvents()
	Debug.Log("Lua OnUnRegisterEvents")
end

--UnLoad的操作, 提供给CS端调用.
function UIMarriageForm:OnUnload()
	Debug.Log("Lua OnUnload")
end

--窗体卸载的操作, 提供给CS端调用.
function UIMarriageForm:OnFormDestroy()
	Debug.Log("Lua OnFormDestroy")
end

--查找控件
function UIMarriageForm:FindAllComponents()
    local trans = self.Trans
    self.BackTexture = UIUtils.FindTex(trans, "BgTex")

    self.CloseBtn = trans:Find("CloseBtn"):GetComponent("UIButton")
    UIUtils.AddBtnEvent(self.CloseBtn, self.OnClickCloseBtn, self)

    self.ListMenu = UIListMenu:OnFirstShow(self.CSForm, UIUtils.FindTrans(self.Trans, "UIListMenu"))
    self.ListMenu:ClearSelectEvent();
    self.ListMenu:AddSelectEvent(Utils.Handler(self.OnClickCallBack, self))
    self.ListMenu.IsHideIconByFunc = true

    self.MarryInfoPanel = UIMarryInfoPanel:OnFirstShow(UIUtils.FindTrans(self.Trans, "Center/MarryInfoPanel"), self)
    self.MarryHousePanel = UIMarryHousePanel:OnFirstShow(UIUtils.FindTrans(self.Trans, "Center/MarryHousePanel"), self)
    self.MarryChildPanel = UIMarryChildPanel:OnFirstShow(UIUtils.FindTrans(self.Trans, "Center/ChildPanel"), self)
    self.MarryBoxPanel = UIMarryBoxPanel:OnFirstShow(UIUtils.FindTrans(self.Trans, "Center/BoxPanel"), self)
    self.MarryBlessPanel = UIMarryBlessPanel:OnFirstShow(UIUtils.FindTrans(self.Trans, "Center/BlessPanel"), self)
    --self.TitleLabel = UIUtils.FindLabel(trans, "Title")

end

function UIMarriageForm:OnOpen(obj, sender)
    self.CSForm:Show(sender)
    if obj ~= nil then
        self.CurPanel = obj[1]
        if obj[2] ~= nil then
            self.CurData = obj[2]
        end
    end
    self.ListMenu:RemoveAll()
    --self.ListMenu:AddIcon(MarriageSubEnum.Main, DataConfig.DataMessageString.Get("C_JUESE_BEIBAO"), FunctionStartIdCode.Bag, "bag_1", nil, "bag_2")
    self.ListMenu:AddIcon(MarriageSubEnum.Main, "信息", FunctionStartIdCode.Bag, "bag_1", nil, "bag_2")
    self.ListMenu:AddIcon(MarriageSubEnum.House, "仙居", FunctionStartIdCode.Store, "sshop_1", nil, "sho_2")
    self.ListMenu:AddIcon(MarriageSubEnum.Child, "仙娃", FunctionStartIdCode.BagSynth, "moneybg_1", nil, "moneybg_2")
    self.ListMenu:AddIcon(MarriageSubEnum.Box, "宝匣", FunctionStartIdCode.EquipSynthesis, "moneybg_3", nil, "moneybg_14")
    self.ListMenu:AddIcon(MarriageSubEnum.Bless, "祈福", FunctionStartIdCode.EquipSynthesis, "moneybg_3", nil, "moneybg_14")
    self.ListMenu:SetSelectById(self.CurPanel)
end

function UIMarriageForm:OnClickCallBack(id, select)
    --开启
    if select then
        if id == MarriageSubEnum.Main then
            self.MarryInfoPanel:Show(self.CurPanel)
        end
        if id == MarriageSubEnum.House then
            self.MarryHousePanel:Show(self.CurPanel)
        end
        if id == MarriageSubEnum.Child then
            self.MarryChildPanel:Show(self.CurPanel)
        end
        if id == MarriageSubEnum.Box then
            self.MarryBoxPanel:Show(self.CurPanel)
        end
        if id == MarriageSubEnum.Bless then
            self.MarryBlessPanel:Show(self.CurPanel)
        end
    -- 关闭
    else
        if id == MarriageSubEnum.Main then
            self.MarryInfoPanel:Hide()
        end
        if id == MarriageSubEnum.House then
            self.MarryHousePanel:Hide()
        end
        if id == MarriageSubEnum.Child then
            self.MarryChildPanel:Hide()
        end
        if id == MarriageSubEnum.Box then
            self.MarryBoxPanel:Hide()
        end
        if id == MarriageSubEnum.Bless then
            self.MarryBlessPanel:Hide()
        end
    end
end

function UIMarriageForm:OnClickCloseBtn()
    self:OnClose()
end

function UIMarriageForm:Update()
    if self.ListMenu ~= nil then
        self.ListMenu:Update()
    end
end

--加载texture
function UIMarriageForm:LoadTextures()
    self.CSForm:LoadTexture(self.BackTexture,AssetUtils.GetImageAssetPath(ImageTypeCode.UI, "bag_back"))
end

return UIMarriageForm