------------------------------------------------
--作者： 何健
--日期： 2019-04-22
--文件： UINewEquipTipsForm.lua
--模块： UINewEquipTipsForm
--描述： 装备Tips
------------------------------------------------

local UICompContainer = require("UI.Components.UICompContainer")
local DescAttrInfo = require("UI.Forms.UINewEquipTipsForm.DescAttrInfo")
local UIAttComponent = require("UI.Forms.UINewEquipTipsForm.UIAttributeComponent")
local UIItem = require("UI.Components.UIItem")
local ItemBase = CS.Funcell.Code.Logic.ItemBase
local ItemContianerSystem = CS.Funcell.Code.Logic.ItemContianerSystem
local Equipment = CS.Funcell.Code.Logic.Equipment
local L_BattlePropTools = CS.Funcell.Code.Logic.BattlePropTools
local EquipmentType = CS.Funcell.Code.Global.EquipmentType

local UINewEquipTipsForm ={
    -- 装备名字  --Label
    EquipNameLabel = nil,
    DressEquipNameLabel = nil,
    -- 装备icon  --UIItem
    EquipIconItem = nil,
    DressEquipIconItem = nil,
    -- 装备部位   --Label
    EquipType = nil,
    DressEquipType = nil,
    --装备战力
    PowerLabel = nil,
    DressPowerLabel = nil,
    -- 职业要求
    EquipOccLabel = nil,
    DressEquipOccLabel = nil,
    -- 等级要求
    EquipLevelLabel = nil,
    DressEquipLevelLabel = nil,

    --背景 根据装备品质变化
    QualityBack = nil,
    DressQualityBack = nil,

    --已穿载提示，在打开身上的装备时候需要显示
    DressTipsGo = nil,

    -- ScrollView
    AttributeScrollView = nil,
    -- 布局控件Table
    AttributeTable = nil,
    DressAttTable = nil,
    DressContainerGo = nil,

    --基础属性
    BaseAttContainer = nil,
    BaseAttGrid = nil,
    DressBaseAttContainer = nil,
    DressBaseAttGrid = nil,

    --对比界面基本信息父结点
    DressBaseGo = nil,
    --对比属性父结点
    DressAttGo = nil,
    --保存TIPS来源
    FromObj = nil,

    --操作按钮字典
    ButtonDic = Dictionary:New(),
    ButtonTable = nil,

    --仓库积分
    DonateNumLabel = nil,
    --仓库积分ICON
    CoinIcon = nil,

    -- 套装对比信息
    SuitGo = nil,
    SuitName = nil,
    SuitPropDesc = nil,
    DressSuitGo = nil,
    DressSuitName = nil,
    DressSuitProDesc = nil,

    EquipmentData = nil,
    DressEquipData = nil,
    Location = ItemTipsLocation.Defult
}
--继承Form函数
function UINewEquipTipsForm:OnRegisterEvents()
	self:RegisterEvent(UIEventDefine.UIEQUIPTIPSFORM_OPEN,self.OnOpen)
	self:RegisterEvent(UIEventDefine.UIEQUIPTIPSFORM_CLOSE,self.OnClose)
end

function UINewEquipTipsForm:OnFirstShow()
    self:FindAllComponents()
    self.CSForm:AddAlphaAnimation()
end

function UINewEquipTipsForm:OnHideBefore()
    self.Location = ItemTipsLocation.Defult
    GameCenter.PushFixEvent( LogicEventDefine.EID_EVENT_BACKFORM_ITEM_UNSELCT )
    self:RemoveCameraClickEvent()
end
function UINewEquipTipsForm:OnLoad()
end
function UINewEquipTipsForm:OnShowAfter()
    self.CSForm.UIRegion = CS.Funcell.Plugins.Common.UIFormRegion.TopRegion
    self:AddCameraClickEvent()
end
--注册相机点击事件
function UINewEquipTipsForm:AddCameraClickEvent()
    LuaDelegateManager.Add(CS.UICamera, "onClick", self.OnUICameraEventListener, self)
end

--删除相机点击事件
function UINewEquipTipsForm:RemoveCameraClickEvent()
    LuaDelegateManager.Remove(CS.UICamera, "onClick", self.OnUICameraEventListener, self)
end

function UINewEquipTipsForm:OnUICameraEventListener(curObj)
    if curObj ~= nil then
        if not self:IsUIInMyUI(curObj) then
            self:OnClose()
        end
    end
end
function UINewEquipTipsForm:IsUIInMyUI(go)
    if go == nil then
        return false
    end
    if go == self.GO then
        return true
    end
    if (CS.Funcell.Core.Base.UnityUtils.CheckChild(self.Trans, go.transform)) then
        return true
    end
    return false
end

--开启事件
function UINewEquipTipsForm:OnOpen(obj, sender)
    local itemSelect = obj
    if nil ~= itemSelect then
        if itemSelect.ShowGoods ~= nil then
            self.EquipmentData = itemSelect.ShowGoods
            self.Location = itemSelect.Locatioin;
            self.FromObj = itemSelect.SelectObj;
            self.CSForm:Show(sender)
            self:UpdateBtn()
            if self.EquipmentData ~= nil and (self.Location == ItemTipsLocation.Bag or self.Location == ItemTipsLocation.Defult
                or self.Location == ItemTipsLocation.OutGuildStore) then
                self.DressEquipData = GameCenter.EquipmentSystem:GetPlayerDressEquip(EquipmentType.__CastFrom(self.EquipmentData.ItemInfo.Part))
            end
            self:UpdateForm()
            self:OnSetPosition(itemSelect.SelectObj.transform)
        else
            self:OnClose()
        end
    else
        self:OnClose()
    end
end

--查找所有控件
function UINewEquipTipsForm:FindAllComponents()
    self.DressTipsGo = UIUtils.FindGo(self.Trans, "Right/Container/TipsTop/Dress")
    self.EquipNameLabel = UIUtils.FindLabel(self.Trans, "Right/Container/TipsTop/EquipName")
    self.DressEquipNameLabel = UIUtils.FindLabel(self.Trans, "Right/Container/Comparison/TipsTop/Head/EquipName")
    self.EquipIconItem = UIItem:New(self.Trans:Find("Right/Container/TipsTop/Item"))
    self.DressEquipIconItem = UIItem:New(self.Trans:Find("Right/Container/Comparison/TipsTop/Item"))
    self.EquipType = UIUtils.FindLabel(self.Trans, "Right/Container/TipsTop/Head/EquipType/Label")
    self.DressEquipType = UIUtils.FindLabel(self.Trans, "Right/Container/Comparison/TipsTop/EquipType/Label")
    self.PowerLabel = UIUtils.FindLabel(self.Trans, "Right/Container/Bottom/Power/Label")
    self.DressPowerLabel = UIUtils.FindLabel(self.Trans, "Right/Container/Comparison/Bottom/Power/Label")
    self.EquipOccLabel = UIUtils.FindLabel(self.Trans, "Right/Container/TipsTop/Head/EquipOcc")
    self.DressEquipOccLabel = UIUtils.FindLabel(self.Trans, "Right/Container/Comparison/TipsTop/EquipOcc")
    self.EquipLevelLabel = UIUtils.FindLabel(self.Trans, "Right/Container/Bottom/EquipLevel")
    self.DressEquipLevelLabel = UIUtils.FindLabel(self.Trans, "Right/Container/Comparison/Bottom/EquipLevel")
    self.AttributeScrollView = UIUtils.FindScrollView(self.Trans, "Right/Container/Middle/Panel")
    self.AttributeTable = UIUtils.FindTable(self.Trans, "Right/Container/Middle/Panel/Table")
    self.DressAttTable = UIUtils.FindTable(self.Trans, "Right/Container/Middle/Panel/Table0")
    self.BaseAttGrid = UIUtils.FindGrid(self.Trans, "Right/Container/Middle/Panel/Table/1_ZAttribute")
    self.DressBaseAttGrid = UIUtils.FindGrid(self.Trans, "Right/Container/Middle/Panel/Table0/1_ZAttribute")
    self.DressBaseGo = UIUtils.FindGo(self.Trans, "Right/Container/Comparison")
    self.DressAttGo = UIUtils.FindGo(self.Trans, "Right/Container/Middle/Panel/Table0")
    self.QualityBack = UIUtils.FindSpr(self.Trans, "Right/Container/Backgroup/bg")
    self.DressQualityBack = UIUtils.FindSpr(self.Trans, "Right/Container/Comparison/Backgroup/bg")
    self.SuitGo = UIUtils.FindGo(self.Trans, "Right/Container/Middle/Panel/Table/5_SuitPro")
    self.SuitName = UIUtils.FindLabel(self.Trans, "Right/Container/Middle/Panel/Table/5_SuitPro/Name")
    self.SuitPropDesc = UIUtils.FindLabel(self.Trans, "Right/Container/Middle/Panel/Table/5_SuitPro/ProDesc")
    self.DressSuitGo = UIUtils.FindGo(self.Trans, "Right/Container/Middle/Panel/Table0/5_SuitPro")
    self.DressSuitName = UIUtils.FindLabel(self.Trans, "Right/Container/Middle/Panel/Table0/5_SuitPro/Name")
    self.DressSuitProDesc = UIUtils.FindLabel(self.Trans, "Right/Container/Middle/Panel/Table0/5_SuitPro/ProDesc")
    self.DonateNumLabel = UIUtils.FindLabel(self.Trans, "Right/Container/Bottom/DonateNum")
    self.ButtonTable = UIUtils.FindTable(self.Trans, "Right/Container/Bottom/MoreGrop/Table")
    self.DressContainerGo = UIUtils.FindGo(self.Trans, "Right/Container/Middle/ContainerLeft")
    self.CoinIcon = UnityUtils.RequireComponent(self.Trans:Find("Right/Container/Bottom/DonateNum/Icon"), "Funcell.GameUI.Form.UIIconBase")
    self.CoinIcon:UpdateIcon(ItemBase.GetItemIcon(1))
    local _tmpTrans = UIUtils.FindTrans(self.Trans, "Right/Container/Middle/Panel/Table/1_ZAttribute")
    local _cnt = _tmpTrans.childCount
    local _c = UICompContainer:New()
    self.BaseAttContainer = _c
    for i = 0 , _cnt - 1 do
        local _btn = UIAttComponent:New(_tmpTrans:GetChild(i))
        _c:AddNewComponent(_btn)
    end
    _c:SetTemplate()

    _tmpTrans = UIUtils.FindTrans(self.Trans, "Right/Container/Middle/Panel/Table0/1_ZAttribute");
    _cnt = _tmpTrans.childCount
    _c = UICompContainer:New()
    self.DressBaseAttContainer = _c
    for i = 0 , _cnt - 1 do
        local _btn = UIAttComponent:New(_tmpTrans:GetChild(i))
        _c:AddNewComponent(_btn)
    end
    _c:SetTemplate()

    -- local button = UIUtils.FindBtn(self.Trans, "Container")
    -- UIUtils.AddBtnEvent(button, self.OnClose, self)
    local button = UIUtils.FindBtn(self.Trans, "Right/Container/Bottom/MoreGrop/Table/EquipBtn")
    UIUtils.AddBtnEvent(button, self.OnClickEquipBtn, self)
    self.ButtonDic:Add(EquipButtonType.Equiped, button)
    button = UIUtils.FindBtn(self.Trans, "Right/Container/Bottom/MoreGrop/Table/SellBtn")
    UIUtils.AddBtnEvent(button, self.OnClickSellBtn, self)
    self.ButtonDic:Add(EquipButtonType.Sell, button)
    button = UIUtils.FindBtn(self.Trans, "Right/Container/Bottom/MoreGrop/Table/MarketBtn")
    UIUtils.AddBtnEvent(button, self.OnClickMarketUpBtn, self)
    self.ButtonDic:Add(EquipButtonType.MarketUp, button)
    button = UIUtils.FindBtn(self.Trans, "Right/Container/Bottom/MoreGrop/Table/PutBtn")
    UIUtils.AddBtnEvent(button, self.OnClickPutBtn, self)
    self.ButtonDic:Add(EquipButtonType.PutStorage, button)
    button = UIUtils.FindBtn(self.Trans, "Right/Container/Bottom/MoreGrop/Table/QuChuBtn")
    UIUtils.AddBtnEvent(button, self.OnClickQuchuBtn, self)
    self.ButtonDic:Add(EquipButtonType.QuChu, button)
    button = UIUtils.FindBtn(self.Trans, "Right/Container/Bottom/MoreGrop/Table/DonateBtn")
    UIUtils.AddBtnEvent(button, self.OnClickDonateBtn, self)
    self.ButtonDic:Add(EquipButtonType.GuildStore, button)
    button = UIUtils.FindBtn(self.Trans, "Right/Container/Bottom/MoreGrop/Table/DestoryBtn")
    UIUtils.AddBtnEvent(button, self.OnClickDestoryBtn, self)
    self.ButtonDic:Add(EquipButtonType.Destory, button)
    button = UIUtils.FindBtn(self.Trans, "Right/Container/Bottom/MoreGrop/Table/SplitBtn")
    UIUtils.AddBtnEvent(button, self.OnClickSplitBtn, self)
    self.ButtonDic:Add(EquipButtonType.Split, button)
end

--装备按钮
function UINewEquipTipsForm:OnClickEquipBtn()
    if self.Location == ItemTipsLocation.Market then
        if GameCenter.ShopSystem.MarketOwnInfoDic.Values.Count >= 16 then
            GameCenter.MsgPromptSystem:ShowPrompt(DataConfig.DataMessageString.Get("C_UI_SHOP_SHANGJIAITEMMAX"))
        else
            GameCenter.PushFixEvent(UIEventDefine.UIShopAuctionShelvesForm_OPEN, self.EquipmentData)
        end
    else
        if self.EquipmentData.ContainerType == ContainerType.ITEM_LOCATION_EQUIP then
            GameCenter.EquipmentSystem:RequestEquipUnWear(self.EquipmentData.DBID)
        else
            GameCenter.EquipmentSystem:RequestEquipWear(self.EquipmentData)
        end
    end
    self:OnClose()
end
--出售按钮
function UINewEquipTipsForm:OnClickSellBtn()
    local list = List:New()
    list:Add(self.EquipmentData.DBID)
    if self.EquipmentData.ItemInfo.Quality >= Utils.GetEnumNumber(tostring(QualityCode.Violet)) then
        GameCenter.MsgPromptSystem:ShowMsgBox(UIUtils.CSFormat(DataConfig.DataMessageString.Get("C_UI_EQUIP_EQUIPTIPS_SELLCOMFIRM"), ItemBase.GetQualityStrColor(QualityCode.__CastFrom(self.EquipmentData.ItemInfo.Quality)), self.EquipmentData.ItemInfo.Name),
            DataConfig.DataMessageString.Get("C_MSGBOX_CANCEL"), DataConfig.DataMessageString.Get("C_MSGBOX_OK"), function(x)
              if x == MsgBoxResultCode.Button2 then
                  GameCenter.EquipmentSystem:ReqEqipSell(list)
              end
            end)
    else
        GameCenter.EquipmentSystem:ReqEqipSell(list)
    end
    self:OnClose()
end
--上架/摆摊出售按钮点击
function UINewEquipTipsForm:OnClickMarketUpBtn()
    if GameCenter.ShopSystem.MarketOwnInfoDic.Values.Count >= 16 then
        GameCenter.MsgPromptSystem:ShowPrompt(DataConfig.DataMessageString.Get("C_UI_SHOP_SHANGJIAITEMMAX"))
    else
        GameCenter.PushFixEvent(UIEventDefine.UIShopAuctionShelvesForm_OPEN, self.EquipmentData)
    end
    self:OnClose()
end
--放入放出按钮
function UINewEquipTipsForm:OnClickPutBtn()
    if self.Location == ItemTipsLocation.PutInStorage then
        ItemContianerSystem.RequestToStore(self.EquipmentData.Index)
    elseif self.Location == ItemTipsLocation.OutStorage then
        ItemContianerSystem.RequestToBag(self.EquipmentData.Index)
    elseif self.Location == ItemTipsLocation.PutInSell then
        GameCenter.PushFixEvent(LogicEventDefine.EID_EVENT_BACKFORM_PUTINSELL, self.FromObj)
    elseif self.Location == ItemTipsLocation.OutSell then
        GameCenter.PushFixEvent(LogicEventDefine.EID_EVENT_BACKFORM_OUTSELL, self.FromObj)
    else
        GameCenter.PushFixEvent(LogicEventDefine.EID_EVENT_UI_EQUIPSELECT_UPDATE, self.EquipmentData)
    end
    self:OnClose()
end
--天启宝库取出
function UINewEquipTipsForm:OnClickQuchuBtn()
    GameCenter.PushFixEvent(LogicEventDefine.EID_EVENT_APOCALYPASEQUCHU)
    self:OnClose()
end
--公会仓库捐献装备
function UINewEquipTipsForm:OnClickDonateBtn()
    local list = List:New()
    list:Add(self.EquipmentData.DBID)

    -- //捐献
    if self.Location == ItemTipsLocation.PutinGuildStore then
        GameCenter.GuildRepertorySystem:ReqSubmitEquip(list)
    elseif self.Location == ItemTipsLocation.OutGuildStore then
        GameCenter.GuildRepertorySystem:ReqChangeEquip(list)
    end
end
-- 公会仓库销毁按钮
function UINewEquipTipsForm:OnClickDestoryBtn()
    local list = List:New()
    list:Add(self.EquipmentData.DBID)
    GameCenter.GuildRepertorySystem:ReqDestroyEquip(list)
end

-- 装备拆解，主要用于神装
function UINewEquipTipsForm:OnClickSplitBtn()
    GameCenter.PushFixEvent(UIEventDefine.UIEquipSplitForm_OPEN, self.EquipmentData)
end

-- //更新按钮
function UINewEquipTipsForm:UpdateBtn()
    local willShow = List:New()
    if self.Location == ItemTipsLocation.Bag then
        -- //装备
        local btnTrans = self:SetWillShowButton(EquipButtonType.Equiped, willShow)
        local label = UIUtils.FindLabel(btnTrans, "Name")
        label.text = DataConfig.DataMessageString.Get("C_EQUIPTIPS_BTN_EQUIP")

        -- //出售
        self:SetWillShowButton(EquipButtonType.Sell, willShow)
        if not self.EquipmentData.IsBind and GameCenter.MainFunctionSystem:FunctionIsVisible(FunctionStartIdCode.AuctionHouse) then
            self:SetWillShowButton(EquipButtonType.MarketUp, willShow);
        end

        -- //拆解
        if self.EquipmentData.ItemInfo.EquipDismantling == 1 then
            self:SetWillShowButton(EquipButtonType.Split, willShow)
        end
    -- elseif self.Location ==  ItemTipsLocation.Equip then -- //从身上打开
    --     -- //装备
    --     local btnTrans = self:SetWillShowButton(EquipButtonType.Equiped, willShow)
    --     local label = UIUtils.FindLabel(btnTrans, "Name")
    --     label.text = DataConfig.DataMessageString.Get("C_EQUIPTIPS_BTN_UNEQUIP")
    elseif self.Location ==   ItemTipsLocation.OutStorage then --//从仓库中打开
        -- //从仓库提取
        local btnTrans = self:SetWillShowButton(EquipButtonType.PutStorage, willShow)
        local label = UIUtils.FindLabel(btnTrans, "Name")
        label.text = DataConfig.DataMessageString.Get("C_ITEM_STORAGETOBAG")
    elseif self.Location == ItemTipsLocation.PutInStorage then --在仓库打开状态下,从背包打开
        -- //放入仓库
        local btnTrans = self:SetWillShowButton(EquipButtonType.PutStorage, willShow)
        local label = UIUtils.FindLabel(btnTrans, "Name")
        label.text = DataConfig.DataMessageString.Get("C_ITEM_BAGTOSTORAGE")
    elseif self.Location == ItemTipsLocation.OutSell then --//从分解界面中打开
        local btnTrans = self:SetWillShowButton(EquipButtonType.PutStorage, willShow)
        local label = UIUtils.FindLabel(btnTrans, "Name")
        label.text = DataConfig.DataMessageString.Get("C_ITEM_STORAGETOBAG")
    elseif self.Location == ItemTipsLocation.PutInSell then --在分解界面打开状态下,从背包打开
        local btnTrans = self:SetWillShowButton(EquipButtonType.PutStorage, willShow)
        local label = UIUtils.FindLabel(btnTrans, "Name")
        label.text = DataConfig.DataMessageString.Get("C_ITEM_BAGTOSTORAGE")
    elseif self.Location == ItemTipsLocation.EquipSelect then
        local btnTrans = self:SetWillShowButton(EquipButtonType.PutStorage, willShow)
        local label = UIUtils.FindLabel(btnTrans, "Name")
        label.text = DataConfig.DataMessageString.Get("C_ITEM_BAGTOSTORAGE")
    elseif self.Location == ItemTipsLocation.Market then
        local btnTrans = self:SetWillShowButton(EquipButtonType.Equiped, willShow)
        local label = UIUtils.FindLabel(btnTrans, "Name")
        label.text = DataConfig.DataMessageString.Get("UI_EQUIP_EQUIPSHANGJIA")
    elseif self.Location ==  ItemTipsLocation.TianQiBaoKu then
        self:SetWillShowButton(EquipButtonType.QuChu, willShow)
    elseif self.Location == ItemTipsLocation.PutinGuildStore then
        local btnTrans = self:SetWillShowButton(EquipButtonType.GuildStore, willShow)
        local label = UIUtils.FindLabel(btnTrans, "Name")
        label.text = DataConfig.DataMessageString.Get("C_UI_EQUIP_EQUIPTIPS_DONATE")
    elseif self.Location == ItemTipsLocation.OutGuildStore then
        local btnTrans = self:SetWillShowButton(EquipButtonType.GuildStore, willShow)
        local label = UIUtils.FindLabel(btnTrans, "Name")
        label.text = DataConfig.DataMessageString.Get("C_UI_EQUIP_EQUIPTIPS_CHANGE")
    end

    for k, v in pairs(self.ButtonDic) do
        v.gameObject:SetActive(false)
    end

    for idx = 1, willShow:Count() do
        willShow[idx].gameObject:SetActive(true)
    end
    self.ButtonTable.repositionNow = true
end

--更新界面
function UINewEquipTipsForm:UpdateForm()
    if(self.EquipmentData ~= nil) then
        if self.EquipmentData.ItemInfo ~= nil then
            self:UpdateHeadInfo()
            self:UpdateAttribute()
            self:UpdateComparison()
            self:OnSetDonateNum()
        end
    end
end

-- /// 设置仓库积分
function UINewEquipTipsForm:OnSetDonateNum()
    if self.EquipmentData.ItemInfo.WarehouseIntegral ~= 0 and
        (self.Location == ItemTipsLocation.PutinGuildStore or self.Location == ItemTipsLocation.OutGuildStore) then
        self.DonateNumLabel.text = tostring(self.EquipmentData.ItemInfo.WarehouseIntegral)
    else
        self.DonateNumLabel.text = ""
    end
end

-- //更新属性信息
function UINewEquipTipsForm:UpdateAttribute()
    self:SetRequireInfo()
    self:SetEquipAttributes()
end

-- //更新对比界面
function UINewEquipTipsForm:UpdateComparison()
    if self.DressEquipData ~= nil and (self.Location == ItemTipsLocation.Bag or self.Location == ItemTipsLocation.Defult or self.Location == ItemTipsLocation.OutGuildStore) then
        self.DressBaseGo:SetActive(true)
        self.DressAttGo:SetActive(true)
        self.DressContainerGo:SetActive(true)
    else
        self.DressAttGo:SetActive(false)
        self.DressBaseGo:SetActive(false)
        self.DressContainerGo:SetActive(false)
    end
end

-- 更新头信息
function UINewEquipTipsForm:UpdateHeadInfo()
    self:SetEquipName()
    self:SetEquipIcon()
    self:SetEquipType()
    self:SetPowerValue()
    self:SetQualityBackSpr()
    if self.Location ==  ItemTipsLocation.Equip then
        self.DressTipsGo:SetActive(true)
    else
        self.DressTipsGo:SetActive(false)
    end
end

-- 设置装备名字
function UINewEquipTipsForm:SetEquipName()
    self.EquipNameLabel.text = string.format("[%s]%s[-]", Equipment.GetQualityStrColor(QualityCode.__CastFrom(self.EquipmentData.ItemInfo.Quality)), self.EquipmentData.Name)
    if self.DressEquipData ~= nil then
        self.DressEquipNameLabel.text = string.format("[%s]%s[-]", Equipment.GetQualityStrColor(QualityCode.__CastFrom(self.DressEquipData.ItemInfo.Quality)), self.DressEquipData.Name)
    end
end

-- 装备icon
function UINewEquipTipsForm:SetEquipIcon()
    if self.DressEquipData ~= nil then
        self.DressEquipIconItem:InitWithItemData(self.DressEquipData, self.DressEquipData.Count, false)
        self.DressEquipIconItem.IsShowTips = false
    end
    self.EquipIconItem:InitWithItemData(self.EquipmentData, self.EquipmentData.Count, false)
    self.EquipIconItem.IsShowTips = false
end

-- 类型
function UINewEquipTipsForm:SetEquipType()
    local type = Equipment.GetEquipNameWithType(EquipmentType.__CastFrom(self.EquipmentData.ItemInfo.Part))
    self.EquipType.text = UIUtils.CSFormat(DataConfig.DataMessageString.Get("LEVEL_FOR_JIE"), self.EquipmentData.ItemInfo.Grade) .. type
    if self.DressEquipData ~= nil then
        if self.DressEquipData.ItemInfo ~= nil then
            type = Equipment.GetEquipNameWithType(EquipmentType.__CastFrom(self.DressEquipData.ItemInfo.Part))
            self.DressEquipType.text = UIUtils.CSFormat(DataConfig.DataMessageString.Get("LEVEL_FOR_JIE"), self.DressEquipData.ItemInfo.Grade) .. type
        end
    end
end

function UINewEquipTipsForm:SetPowerValue()
    self.PowerLabel.text = tostring(self.EquipmentData.ItemInfo.Score)
    if self.DressEquipData ~= nil then
        if self.DressEquipData.ItemInfo ~= nil then
            self.DressPowerLabel.text = tostring(self.DressEquipData.ItemInfo.Score)
        end
    end
end
function UINewEquipTipsForm:SetQualityBackSpr()
    self.QualityBack.spriteName = ItemBase.GetQualityBackName(QualityCode.__CastFrom(self.EquipmentData.ItemInfo.Quality))
    if self.DressEquipData ~= nil then
        if self.DressEquipData.ItemInfo ~= nil then
            self.DressQualityBack.spriteName = ItemBase.GetQualityBackName(QualityCode.__CastFrom(self.DressEquipData.ItemInfo.Quality))
        end
    end
end
-- 设置需求 包括职业和等级
function UINewEquipTipsForm:SetRequireInfo()
    self:SetEquipLevel()
    self:SetEquipOcc()
end

-- //装备穿戴等级
function UINewEquipTipsForm:SetEquipLevel()
    local levelStr = UIUtils.CSFormat("{0}级可穿戴", CommonUtils.GetLevelDesc(self.EquipmentData.ItemInfo.Level))
    local lp = GameCenter.GameSceneSystem:GetLocalPlayer()
    if lp ~= nil then
        if lp.Level >= self.EquipmentData.ItemInfo.Level then
            self.EquipLevelLabel.text = levelStr
        else
            self.EquipLevelLabel.text = string.format("[FF0000]%s[-]", levelStr)
        end
    end

    if self.DressEquipData ~= nil then
        levelStr = UIUtils.CSFormat("{0}级可穿戴", CommonUtils.GetLevelDesc(self.DressEquipData.ItemInfo.Level))
        if lp ~= nil then
            if lp.Level >= self.DressEquipData.ItemInfo.Level then
                self.DressEquipLevelLabel.text = levelStr
            else
                self.DressEquipLevelLabel.text = string.format("[FF0000]%s[-]", levelStr)
            end
        end
    end
end

-- //职业
function UINewEquipTipsForm:SetEquipOcc()
    local lp = GameCenter.GameSceneSystem:GetLocalPlayer()
    if lp ~= nil then
        if lp.Occ == Occupation.__CastFrom(self.EquipmentData.ItemInfo.Gender) then
            self.EquipOccLabel.text = Equipment.GetOccNameWithClassID(self.EquipmentData.ItemInfo.Classlevel)
        else
            self.EquipOccLabel.text = string.format("[FF0000]%s[-]", DataConfig.DataChangejob[self.EquipmentData.ItemInfo.Classlevel].Name)
        end

        if self.DressEquipData ~= nil then
            if lp.Occ == Occupation.__CastFrom(self.DressEquipData.ItemInfo.Gender) then
                self.DressEquipOccLabel.text = Equipment.GetOccNameWithClassID(self.DressEquipData.ItemInfo.Classlevel)
            else
                self.DressEquipOccLabel.text = string.format("[FF0000]%s[-]", DataConfig.DataChangejob[self.DressEquipData.ItemInfo.Classlevel].Name)
            end
        end
    end
end

-- 设置属性
function UINewEquipTipsForm:SetEquipAttributes()
    self:SetBaseEquipAtt()
    self:SetSuit()
end

--设置基础属性
function UINewEquipTipsForm:SetBaseEquipAtt()
    local attDic = self.EquipmentData:GetBaseAttribute()
    self.BaseAttContainer:EnQueueAll()
    local e = attDic:GetEnumerator()
    while e:MoveNext() do
        local ui = self.BaseAttContainer:DeQueue(DescAttrInfo:New(e.Current.Key, e.Current.Value))
        ui:SetName(e.Current.Key)
    end
    self.BaseAttContainer:RefreshAllUIData()

    if self.DressEquipData ~= nil then
        if self.DressEquipData.ItemInfo ~= nil then
            attDic = self.DressEquipData:GetBaseAttribute()
            self.DressBaseAttContainer:EnQueueAll()
            e = attDic:GetEnumerator()
            while e:MoveNext() do
                local ui = self.DressBaseAttContainer:DeQueue(DescAttrInfo:New(e.Current.Key, e.Current.Value))
                ui:SetName(e.Current.Key)
            end
            self.DressBaseAttContainer:RefreshAllUIData()
        end
    end
    self.BaseAttGrid.repositionNow = true
    self.DressBaseAttGrid.repositionNow = true
end

function UINewEquipTipsForm:SetSuit()
    if self.EquipmentData ~= nil then
        if self.EquipmentData.SuitCfg ~= nil then
            -- local occCfg = DataConfig.DataPlayerOccupation.Get(self.EquipmentData.ItemInfo.Gender)
            -- local attackType = AttackType.Physics
            -- if occCfg ~= nil then
            --     attackType = AttackType.__CastFrom(occCfg.AtkType)
            -- end

            self.SuitGo:SetActive(true)
            self.SuitName.text = string.format("%s%s(%s/%s)", self.EquipmentData.SuitCfg.Cfg.Prefix, self.EquipmentData.SuitCfg.Cfg.Name, self.EquipmentData.CurSuitEquipCount, self.EquipmentData.SuitCfg.NeedpartParts.Count)

            local iterProNum = self.EquipmentData.SuitCfg.Props:GetEnumerator()
            local builder = nil
            while (iterProNum:MoveNext()) do
                local needCount = iterProNum.Current.Key

                local textColor = "00FF00";
                if self.EquipmentData.CurSuitEquipCount < needCount then
                    textColor = "FFFFFF"
                end

                local iterPro = iterProNum.Current.Value:GetEnumerator()
                local first = true
                while (iterPro.MoveNext()) do
                    if builder ~= nil then
                        builder = builder .. "\n"
                    end
                    local proText = nil
                    if first then
                        first = false
                        proText = UIUtils.CSFormat(DataConfig.DataMessageString.Get("C_EQUIP_SUITTIPS"), needCount, L_BattlePropTools.GetBattlePropName(iterPro.Current.Key),
                            L_BattlePropTools.GetBattleValueText(iterPro.Current.Key, iterPro.Current.Value))
                    else
                        proText = UIUtils.CSFormat(DataConfig.DataMessageString.Get("C_EQUIP_SUITTIPS2"), needCount, L_BattlePropTools.GetBattlePropName(iterPro.Current.Key),
                            L_BattlePropTools.GetBattleValueText(iterPro.Current.Key, iterPro.Current.Value))
                    end
                    builder = builder .. string.format("[%s]%s[-]", textColor, proText)
                end
            end
            self.SuitPropDesc.text = builder
        else
                self.SuitGo:SetActive(false)
        end
    end

    if self.DressEquipData ~= nil then
        if self.DressEquipData.SuitCfg ~= nil then
            -- local occCfg = DataConfig.DataPlayerOccupation.Get(self.DressEquipData.ItemInfo.Gender);
            -- local attackType = AttackType.Physics;
            -- if occCfg ~= nil then
            --     attackType = AttackType.__CastFrom(occCfg.AtkType)
            -- end

            self.DressSuitGo:SetActive(true)
            self.DressSuitName.text = string.Format("%s%s(%s/%s)", self.DressEquipData.SuitCfg.Cfg.Prefix, self.DressEquipData.SuitCfg.Cfg.Name, self.DressEquipData.CurSuitEquipCount, self.DressEquipData.SuitCfg.NeedpartParts.Count)

            local iterProNum = self.DressEquipData.SuitCfg.Props:GetEnumerator()
            local builder = nil
            while (iterProNum:MoveNext()) do
                local needCount = iterProNum.Current.Key
                local textColor = "00FF00"
                if self.DressEquipData.CurSuitEquipCount < needCount then
                    textColor = "FFFFFF"
                end
                
                local iterPro = iterProNum.Current.Value:GetEnumerator()
                local first = true
                while (iterPro:MoveNext()) do
                    if (builder ~= nil) then
                        builder = builder .. '\n'
                    end
                    local proText = nil
                    if (first) then
                        first = false
                        proText = UIUtils.CSFormat(DataConfig.DataMessageString.Get("C_EQUIP_SUITTIPS"), needCount, L_BattlePropTools.GetBattlePropName(iterPro.Current.Key),
                            L_BattlePropTools.GetBattleValueText(iterPro.Current.Key, iterPro.Current.Value))
                    else
                        proText = UIUtils.CSFormat(DataConfig.DataMessageString.Get("C_EQUIP_SUITTIPS2"), needCount, L_BattlePropTools.GetBattlePropName(iterPro.Current.Key),
                            L_BattlePropTools.GetBattleValueText(iterPro.Current.Key, iterPro.Current.Value))
                    end
                    builder = builder .. string.format("[%s]%s[-]", textColor, proText)
                end
            end
            self.DressSuitProDesc.text = builder
        end
    else
        self.DressAttGo:SetActive(false)
    end
end

function UINewEquipTipsForm:SetWillShowButton(type, list)
    local btnTrans = self.ButtonDic[type]
    if btnTrans == nil then
        Debug.LogError(type)
    end

    list:Add(btnTrans.transform)
    return btnTrans.transform
end

function UINewEquipTipsForm:OnSetPosition(trans)
    self.Trans.position = trans.position
end
return UINewEquipTipsForm