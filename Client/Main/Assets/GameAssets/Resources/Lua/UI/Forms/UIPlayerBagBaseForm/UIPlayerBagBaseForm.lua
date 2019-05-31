------------------------------------------------
--作者： 何健
--日期： 2019-04-17
--文件： UIPlayerBagBaseForm.lua
--模块： UIPlayerBagBaseForm
--描述： 背包底板，主要做列表按钮
------------------------------------------------
local UIListMenu = require "UI.Components.UIListMenu.UIListMenu"
local UIPlayerBagBaseForm = {
    --UIListMenu
    ListMenu = nil,
    --UIButton
    CloseBtn = nil,
    --BagFormSubPanel 保存打开的标签
    CurPanel = 0,
    --itemModel 打开界面所用到的数据
    CurData = nil,
    TitleLabel = nil,
    BackTexture = nil
}

--继承Form函数
function UIPlayerBagBaseForm:OnRegisterEvents()
	self:RegisterEvent(UIEventDefine.UIPlayerBagBaseForm_OPEN,self.OnOpen)
	self:RegisterEvent(UIEventDefine.UIPlayerBagBaseForm_CLOSE,self.OnClose)
end

function UIPlayerBagBaseForm:OnFirstShow()
	self:FindAllComponents()
end
function UIPlayerBagBaseForm:OnHideBefore()
    self.CurPanel = BagFormSubEnum.Bag
end
function UIPlayerBagBaseForm:OnShowAfter()
    self:LoadTextures()
end

function UIPlayerBagBaseForm:OnOpen(obj, sender)
    self.CSForm:Show(sender)
    if obj ~= nil then
        self.CurPanel = obj[1]
        if obj[2] ~= nil then
            self.CurData = obj[2]
        end
    end
    self.ListMenu:RemoveAll()
    self.ListMenu:AddIcon(BagFormSubEnum.Bag, DataConfig.DataMessageString.Get("C_JUESE_BEIBAO"), FunctionStartIdCode.Bag, "bag_1", nil, "bag_2")
    self.ListMenu:AddIcon(BagFormSubEnum.Store, DataConfig.DataMessageString.Get("C_JUESE_CANGKU"), FunctionStartIdCode.Store, "sshop_1", nil, "sho_2")
    self.ListMenu:AddIcon(BagFormSubEnum.Synth, "合成", FunctionStartIdCode.BagSynth, "moneybg_1", nil, "moneybg_2")
    self.ListMenu:AddIcon(BagFormSubEnum.EquipSyn, "合装", FunctionStartIdCode.EquipSynthesis, "moneybg_3", nil, "moneybg_14")
    self.ListMenu:SetSelectById(self.CurPanel)
end

--查找UI上各个控件
function UIPlayerBagBaseForm:FindAllComponents()
    local trans = self.Trans
    self.BackTexture = UIUtils.FindTex(trans, "BgTexture")
    local listTrans = trans:Find("UIListMenu")
    self.ListMenu = UIListMenu:OnFirstShow(self.CSForm, listTrans)
    self.ListMenu:ClearSelectEvent();
    self.ListMenu:AddSelectEvent(Utils.Handler(self.OnClickCallBack, self))
    self.ListMenu.IsHideIconByFunc = true

    self.TitleLabel = UIUtils.FindLabel(trans, "Title")

    self.CloseBtn = trans:Find("CloseBtn"):GetComponent("UIButton")
    self.CloseBtn.onClick:Clear()
    UIUtils.AddBtnEvent(self.CloseBtn, self.OnClickCloseBtn, self)
end

function UIPlayerBagBaseForm:OnClickCallBack(id, select)
    if select then
        if id == BagFormSubEnum.Bag then
            self.TitleLabel.text = DataConfig.DataMessageString.Get("C_JUESE_BEIBAO")
            GameCenter.PushFixEvent(UIEventDefine.UIPlayerBagForm_OPEN, id, self.CSForm)
        end
        if id == BagFormSubEnum.Store then
            self.TitleLabel.text = DataConfig.DataMessageString.Get("C_JUESE_CANGKU")
            GameCenter.PushFixEvent(UIEventDefine.UIPlayerBagForm_OPEN, id, self.CSForm)
            GameCenter.PushFixEvent(UIEventDefine.UIPlayerStoreForm_OPEN, nil, self.CSForm)
        end
        if id == BagFormSubEnum.Synth then
            self.TitleLabel.text = "合成"
            GameCenter.PushFixEvent(UIEventDefine.UIItemSynthForm_OPEN, self.CurData)
            GameCenter.PushFixEvent(UIEventDefine.UIPlayerBagForm_CLOSE)
        end
        if id == BagFormSubEnum.EquipSyn then
            self.TitleLabel.text = "合装"
            GameCenter.PushFixEvent(UIEventDefine.UIEquipSynthForm_OPEN, nil, self.CSForm)
            GameCenter.PushFixEvent(UIEventDefine.UIPlayerBagForm_CLOSE)
        end
    else
        if id == BagFormSubEnum.Store then
            GameCenter.PushFixEvent(UIEventDefine.UIPlayerStoreForm_CLOSE)
        end
        if id == BagFormSubEnum.Synth then
            GameCenter.PushFixEvent(UIEventDefine.UIItemSynthForm_CLOSE)
            self.CurData = nil
        end
        if id == BagFormSubEnum.EquipSyn then
            GameCenter.PushFixEvent(UIEventDefine.UIEquipSynthForm_CLOSE)
        end
    end
end

function UIPlayerBagBaseForm:OnClickCloseBtn()
    self:OnClose()
end

--加载texture
function UIPlayerBagBaseForm:LoadTextures()
    self.CSForm:LoadTexture(self.BackTexture,AssetUtils.GetImageAssetPath(ImageTypeCode.UI, "bag_back"))
end
return UIPlayerBagBaseForm