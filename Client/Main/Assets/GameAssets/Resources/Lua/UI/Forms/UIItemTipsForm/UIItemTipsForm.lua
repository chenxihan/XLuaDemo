------------------------------------------------
--作者： 何健
--日期： 2019-04-18
--文件： UIItemTipsForm.lua
--模块： UIItemTipsForm
--描述： 物品Tips
------------------------------------------------

-- c#类
local UICamera = CS.UICamera
local ItemContianerSystem = CS.Funcell.Code.Logic.ItemContianerSystem
local ItemBase = CS.Funcell.Code.Logic.ItemBase
local UIItem = require "UI.Components.UIItem"

local UIItemTipsForm = {
    --父结点，用于设置位置
    ParentTrans = nil,
    --可使用的button
    ButtonDic = Dictionary:New(),
    --使用等级
    ItemLevelLabel = nil,
    --物品名字
    ItemNameLabel = nil,
    --物品描述
    ItemDesLabel = nil,
    --物品类型
    ItemTypeLabel = nil,
    --Button Tabel
    ButtonTabel = nil,
    --当前显示的物品
    ItemData = nil,
    --显示物品格子 UIItem
    ItemUI = nil,
    --物品显示位置，容器
    Location = ItemTipsLocation.Defult,
    --背景图片，用于计算界面长度
    BackSprite = nil,
    QualityBack = nil,
    IsShowGet = false
}

--继承Form函数
function UIItemTipsForm:OnRegisterEvents()
	self:RegisterEvent(UIEventDefine.UIITEMTIPS_OPEN,self.OnOpen)
	self:RegisterEvent(UIEventDefine.UIITEMTIPS_CLOSE,self.OnClose)
end

function UIItemTipsForm:OnFirstShow()
    self:FindAllComponents()
end
function UIItemTipsForm:OnShowAfter()
    CS.UICamera:AddGenericEventHandler(self.GO)
    self.Hander =  Utils.Handler(self.OnUICameraEventListener, self)
    self:AddCameraClickEvent()
end
function UIItemTipsForm:OnHideBefore()
    self.ItemData = nil
    CS.UICamera:RemoveGenericEventHandler(self.GO)
    self:RemoveCameraClickEvent()
    GameCenter.PushFixEvent(LogicEventDefine.EID_EVENT_BACKFORM_ITEM_UNSELCT)
end
function UIItemTipsForm:OnLoad()
    self.CSForm.UIRegion = CS.Funcell.Plugins.Common.UIFormRegion.TopRegion
end
--注册相机点击事件
function UIItemTipsForm:AddCameraClickEvent()
    -- if CS.UICamera.onClick == nil then
    --     CS.UICamera.onClick = LuaDelegateManager.Add(self.OnUICameraEventListener, self)
    -- else
    --     CS.UICamera.onClick = CS.UICamera.onClick + LuaDelegateManager.Add(self.OnUICameraEventListener, self)
    -- end
    LuaDelegateManager.Add(CS.UICamera, "onClick", self.OnUICameraEventListener, self)
end

--删除相机点击事件
function UIItemTipsForm:RemoveCameraClickEvent()
    -- if CS.UICamera.onClick == nil then
    --     return
    -- end
    -- CS.UICamera.onClick = CS.UICamera.onClick - LuaDelegateManager.Remove(self.OnUICameraEventListener, self)
    LuaDelegateManager.Remove(CS.UICamera, "onClick", self.OnUICameraEventListener, self)
end

function UIItemTipsForm:OnUICameraEventListener(curObj)
    if curObj ~= nil then
        if not self:IsUIInMyUI(curObj) then
            self:OnClose()
        end
    end
end
function UIItemTipsForm:IsUIInMyUI(go)
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
function UIItemTipsForm:OnOpen(obj, sender)
    local itemSelect = obj
    if (nil ~= itemSelect and nil ~= itemSelect.ShowGoods and nil ~= itemSelect.SelectObj) then
        self.CSForm:Show(sender)
        self.ItemData = itemSelect.ShowGoods
        self:SetItemInfo()
        self.Location = itemSelect.Locatioin
        self.IsShowGet = itemSelect.isShowGetBtn
        self:ResetFucBtn(self.Location == ItemTipsLocation.Defult and itemSelect.isShowGetBtn == true)
        if (itemSelect.isResetPosion) then
            self:AdapterTipsPos(itemSelect.SelectObj)
        else
            UnityUtils.SetLocalPosition(self.Trans, 0, 0, 0)
        end
    else
        self:OnClose()
    end
end

--查找UI上各个控件
function UIItemTipsForm:FindAllComponents()
    local trans = self.Trans
    self.ParentTrans = trans:Find("Container")

    --操作按钮
    local button = trans:Find("Container/Table/ButtonUse"):GetComponent("UIButton")
    button.onClick:Clear()
    EventDelegate.Add(button.onClick, Utils.Handler(self.TipsViewBtnFuction, self))
    self.ButtonDic:Add(button, ItemOpertion.Use)

    button = trans:Find("Container/Table/ButtonGet"):GetComponent("UIButton")
    button.onClick:Clear()
    EventDelegate.Add(button.onClick, Utils.Handler(self.TipsViewBtnFuction, self))
    self.ButtonDic:Add(button, ItemOpertion.Get)

    button = trans:Find("Container/Table/ButtonSell"):GetComponent("UIButton")
    button.onClick:Clear()
    EventDelegate.Add(button.onClick, Utils.Handler(self.TipsViewBtnFuction, self))
    self.ButtonDic:Add(button, ItemOpertion.Sell)

    button = trans:Find("Container/Table/MarketBtn"):GetComponent("UIButton")
    button.onClick:Clear()
    EventDelegate.Add(button.onClick, Utils.Handler(self.TipsViewBtnFuction, self))
    self.ButtonDic:Add(button, ItemOpertion.Stall)

    button = trans:Find("Container/Table/ButtonBatch"):GetComponent("UIButton")
    button.onClick:Clear()
    EventDelegate.Add(button.onClick, Utils.Handler(self.TipsViewBtnFuction, self))
    self.ButtonDic:Add(button, ItemOpertion.Batch)

    button = trans:Find("Container/Table/ButtonSynth"):GetComponent("UIButton")
    button.onClick:Clear()
    EventDelegate.Add(button.onClick, Utils.Handler(self.TipsViewBtnFuction, self))
    self.ButtonDic:Add(button, ItemOpertion.Synth)

    button = trans:Find("Container/Table/ButtonGive"):GetComponent("UIButton")
    button.onClick:Clear()
    EventDelegate.Add(button.onClick, Utils.Handler(self.TipsViewBtnFuction, self))
    self.ButtonDic:Add(button, ItemOpertion.Give)

    --关闭按钮
    local CloseBtn = trans:Find("Container/ButtonClose"):GetComponent("UIButton")
    CloseBtn.onClick:Clear()
    EventDelegate.Add(CloseBtn.onClick, Utils.Handler(self.OnBtnCloseClick, self))
    -- CloseBtn = trans:Find("Container/BigBack"):GetComponent("UIButton")
    -- CloseBtn.onClick:Clear()
    -- EventDelegate.Add(CloseBtn.onClick, Utils.Handler(self.OnBtnCloseClick, self))

    --其他
    self.ItemNameLabel = trans:Find("Container/Top/Name"):GetComponent("UILabel")
    self.ItemLevelLabel = trans:Find("Container/Top/ItemLevel/ItemLevel"):GetComponent("UILabel")
    self.ItemTypeLabel = trans:Find("Container/Top/ItemType/ItemType"):GetComponent("UILabel")
    self.ItemDesLabel = trans:Find("Container/ItemDesLabel"):GetComponent("UILabel")
    self.ButtonTabel = trans:Find("Container/Table"):GetComponent("UITable")
    self.BackSprite = trans:Find("Container/Background"):GetComponent("UISprite")
 --   self.ItemUI = UIUtils.RequireUIItem(trans:Find("Container/Top/UIItem"))
    self.ItemUI = UIItem:New(trans:Find("Container/Top/UIItem"))
    self.ItemUI.IsShowTips = false
    self.QualityBack = UIUtils.FindSpr(trans, "Container/Background/QualityBack")
end

--关闭按钮点击及背景点击响应
function UIItemTipsForm:OnBtnCloseClick()
    self:OnClose()
end

--操作按钮点击，如使用按钮
function UIItemTipsForm:TipsViewBtnFuction()
    local buttonType = nil
    --遍历按钮字典
    for k, v in pairs(self.ButtonDic) do
        if k == CS.UIButton.current then
            buttonType = v
        end
    end
    if buttonType == ItemOpertion.Use then
        if self.Location == ItemTipsLocation.PutInStorage then
            ItemContianerSystem.RequestToStore(self.ItemData.Index)
        elseif self.Location == ItemTipsLocation.Synth then
            GameCenter.PushFixEvent(LogicEventDefine.EID_EVENT_UPDATE_ITEMSYNTH_ITEMPUT, self.ItemData)
        elseif self.Location == ItemTipsLocation.SynthPutOut then
            GameCenter.PushFixEvent(LogicEventDefine.EID_EVENT_UPDATE_ITEMSYNTH_ITEMPUTOUT, self.ItemData)
        elseif self.Location == ItemTipsLocation.OutStorage then
            ItemContianerSystem.RequestToBag(self.ItemData.Index)
        elseif (self.Location == ItemTipsLocation.Market) then
            if GameCenter.ShopSystem.MarketOwnInfoDic.Values.Count >= 16 then
                GameCenter.MsgPromptSystem.ShowPrompt(DataConfig.DataMessageString.Get("C_UI_SHOP_SHANGJIAITEMMAX"))
            else
                GameCenter.PushFixEvent(UIEventDefine.UIShopAuctionShelvesForm_OPEN, self.ItemData)
            end
        else
            if self.ItemData:IsCanUse(ItemOpertion.Use) == false then
                GameCenter.MsgPromptSystem.ShowPrompt(DataConfig.DataMessageString.Get("C_ITEM_CANNOTUSE"))
            else
                if self.ItemData:IsNeedSecond() and self.ItemData.IsBind == false and self.ItemData.ItemInfo.Bind == 2 then
                    local sText = nil
                    sText = UIUtils.CSFormat(DataConfig.DataMessageString.Get("C_ITEM_USE_BIND_TIPS"), UIUtils.CSFormat("[{0}]{1}[-]", ItemBase.GetQualityStrColor(self.ItemData.ItemInfo.Color), self.ItemData.Name))
                    GameCenter.MsgPromptSystem:ShowMsgBox(sText, DataConfig.DataMessageString.Get("C_MSGBOX_NO"), DataConfig.DataMessageString.Get("C_MSGBOX_YES"), function(x)
                        if x == MsgBoxResultCode.Button2 then
                            self:UseItem()
                        end
                    end)
                end
                self:UseItem()
            end
        end
    elseif buttonType == ItemOpertion.Sell then
        if self.ItemData:IsNeedSecond() then
            local sText = nil
            sText = UIUtils.CSFormat(DataConfig.DataMessageString.Get("C_ITEM_SELL_CONFIRM_TIPS"), UIUtils.CSFormat("[{0}]{1}[-]", ItemBase.GetQualityStrColor(self.ItemData.ItemInfo.Color), self.ItemData.Name))
            GameCenter.MsgPromptSystem:ShowMsgBox(sText, DataConfig.DataMessageString.Get("C_MSGBOX_NO"), DataConfig.DataMessageString.Get("C_MSGBOX_YES"), function(x)
                if x == MsgBoxResultCode.Button2 then
                    self:SellItem()
                end
            end)
        end
        self:SellItem()
    elseif buttonType == ItemOpertion.Get then
        GameCenter.ItemQuickGetSystem:OpenItemQuickGetForm(self.ItemData.CfgID)
    elseif buttonType == ItemOpertion.Synth then
        local objct = { BagFormSubEnum.Synth, self.ItemData}
        GameCenter.PushFixEvent(UIEventDefine.UIPlayerBagBaseForm_OPEN, objct)
    elseif buttonType == ItemOpertion.Batch then
        if self.ItemData.Count > 1 then
            GameCenter.PushFixEvent(UIEventDefine.UIITEMBATCH_OPEN, self.ItemData)
        else
            ItemContianerSystem.RequestUseItem(self.ItemData.DBID)
        end
    end
    self:OnClose()
end
-- 使用按钮
function UIItemTipsForm:UseItem()
    if self.ItemData.ItemInfo.UesUIId ~= 0 then
        self:OpenFunction()
        return
    end

    ItemContianerSystem.RequestUseItem(self.ItemData.DBID)
    self:OnClose()
end

-- 打开其他功能面板
function UIItemTipsForm:OpenFunction()
    GameCenter.MainFunctionSystem:DoFunctionCallBack(FunctionStartIdCode.__CastFrom(self.ItemData.ItemInfo.UesUIId), nil)
end

-- 出售物品
function UIItemTipsForm:SellItem()
    if  self.ItemData.Count > 1 then
        GameCenter.PushFixEvent(UIEventDefine.UIITEMSELL_OPEN, self.ItemData)
    else
        ItemContianerSystem.RequestSellItem(self.ItemData.DBID)
    end
    self:OnClose()
end

-- 设置tips面板上的具体内容
function UIItemTipsForm:SetItemInfo()
    local localPlayer = GameCenter.GameSceneSystem:GetLocalPlayer()
    if self.ItemData ~= nil and localPlayer ~= nil then
        self.ItemNameLabel.text = self.ItemData.Name
        local textColor = ItemBase.GetQualityColor(self.ItemData.ItemInfo.Color)
        self.ItemNameLabel.color = textColor

        local sText = nil
        local levelValue = CommonUtils.GetLevelDesc(self.ItemData.ItemInfo.Level)
        sText = UIUtils.CSFormat(DataConfig.DataMessageString.Get("C_MAIN_NON_PLAYER_SHOW_LEVEL"), levelValue)
        local levelString = "";
        local typeString = "";
        if (self.ItemData:CheckLevel(localPlayer.Level)) then
            levelString = ItemBase.GetCanUseColorString(sText)
        else
            levelString = ItemBase.GetCanNotUseColorString(sText)
        end
        self.ItemLevelLabel.text = levelString

        typeString = ItemBase.GetTypeNameWitType(Utils.GetEnumNumber(tostring(self.ItemData.Type)))
        if typeString ~= nil then
            self.ItemTypeLabel.text = typeString;
        end

        self.ItemUI:InitWithItemData(self.ItemData, 0, false, self.IsShowGet, self.Location)
        self.ItemUI.IsShowTips = false
        self.ItemDesLabel.text = self.ItemData.ItemInfo.Description
        local qualityCode = QualityCode.__CastFrom(self.ItemData.ItemInfo.Color)
        self.QualityBack.spriteName = ItemBase.GetQualityBackName(qualityCode)
    end
end

function UIItemTipsForm:ResetFucBtn(isShow)
    -- //调整使用按钮位置
    if self.ItemData == nil then
        Debug.LogError("物品信息不存在，请检查原因 ItemTipsForm");
        return
    end
    local willShowBtn = Dictionary:New()

    for k, v in pairs(self.ButtonDic) do
        k.gameObject:SetActive(false)
        if isShow then
            if v == ItemOpertion.Get then
                if self.ItemData.ItemInfo.GetText ~= nil then
                    willShowBtn:Add(v, k)
                end
            end
        else
            if self.Location == ItemTipsLocation.PutInStorage or self.Location == ItemTipsLocation.Synth then
                if v == ItemOpertion.Use then
                    local name = k.transform:Find("Text"):GetComponent("UILabel")
                    name.text = DataConfig.DataMessageString.Get("C_ITEM_BAGTOSTORAGE")
                    willShowBtn:Add(v, k)
                end
            elseif self.Location == ItemTipsLocation.OutStorage or self.Location == ItemTipsLocation.SynthPutOut then
                if v == ItemOpertion.Use then
                    local name = k.transform:Find("Text"):GetComponent("UILabel")
                    name.text = DataConfig.DataMessageString.Get("C_ITEM_STORAGETOBAG")
                    willShowBtn:Add(v, k)
                end
            elseif self.Location == ItemTipsLocation.EquipSelect then
                if v == ItemOpertion.Use then
                    local name = k.transform:Find("Text"):GetComponent("UILabel")
                    name.text = DataConfig.DataMessageString.Get("C_ITEM_BAGTOSTORAGE")
                    willShowBtn:Add(v, k)
                end
            elseif self.Location == ItemTipsLocation.Market then
                if v == ItemOpertion.Use then
                    local name = k.transform:Find("Text"):GetComponent("UILabel")
                    name.text = DataConfig.DataMessageString.Get("UI_EQUIP_EQUIPSHANGJIA")
                    willShowBtn:Add(v, k)
                end
            else
                if v == ItemOpertion.Use and self.Location == ItemTipsLocation.Bag
                    and self.ItemData.Type ~= ItemType.Task and self.ItemData:IsCanUse(ItemOpertion.Use) then
                    local name = k.transform:Find("Text"):GetComponent("UILabel")
                    name.text = DataConfig.DataMessageString.Get("C_ITEM_USE")
                    willShowBtn:Add(v, k)
                elseif v == ItemOpertion.Sell and self.Location == ItemTipsLocation.Bag
                    and self.ItemData:IsCanUse(ItemOpertion.Sell) then
                    willShowBtn:Add(v, k)
                elseif v == ItemOpertion.Stall and self.Location == ItemTipsLocation.Bag
                    and self.ItemData.IsBind == false and GameCenter.MainFunctionSystem:FunctionIsVisible(FunctionStartIdCode.AuctionHouse)
                    and self.ItemData:IsCanUse(ItemOpertion.Stall) then
                    willShowBtn:Add(v, k)
                elseif v == ItemOpertion.Batch and self.Location == ItemTipsLocation.Bag
                    and self.ItemData:IsCanUse(ItemOpertion.Batch) then
                    willShowBtn:Add(v, k)
                elseif v == ItemOpertion.Synth and self.Location == ItemTipsLocation.Bag
                    and self.ItemData:IsCanUse(ItemOpertion.Synth) then
                    willShowBtn:Add(v, k)
                elseif v == ItemOpertion.Give and self.Location == ItemTipsLocation.Bag and self.ItemData:IsCanUse(ItemOpertion.Give) then
                    willShowBtn:Add(v, k)
                elseif v == ItemOpertion.Get and self.Location == ItemTipsLocation.Bag and self.ItemData:IsCanUse(ItemOpertion.Get) then
                    willShowBtn:Add(v, k)
                end
            end
        end                
    end
    for k, v in pairs(willShowBtn) do
        v.gameObject:SetActive(true)
    end
    self.ButtonTabel.repositionNow = true
end
function UIItemTipsForm:AdapterTipsPos(clickObj)
    local panel = self.Trans:GetComponent("UIPanel")
    local width = panel.root.manualWidth
    local hight = panel.root.manualHeight
    local scale =1 / panel.root.transform.localScale.x
    local x = clickObj.transform.position.x * scale
    local y = (clickObj.transform.position.y - 2000) * scale
    if x > width / 2 - 360 then
        x = x - 360
    end
    if y < hight / 2 * (-1) + self.BackSprite.height + 20 then
        y = hight / 2 * (-1) + self.BackSprite.height + 20
    end
    UnityUtils.SetPosition(self.ParentTrans, x / scale, y / scale + 2000, 0)
end
return UIItemTipsForm