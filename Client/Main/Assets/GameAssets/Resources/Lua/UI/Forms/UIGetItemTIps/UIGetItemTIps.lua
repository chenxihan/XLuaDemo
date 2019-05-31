------------------------------------------------
--作者： 何健
--日期： 2019-05-30
--文件： UIGetItemTIps.lua
--模块： UIGetItemTIps
--描述： 物品获得快速使用界面
------------------------------------------------
local L_UIItem = require("UI.Components.UIItem")
local UIGetItemTIps = {
    --物品显示
    UIItem = nil,
    --使用按钮
    UseBtn = nil,
    --按钮显示文字
    UseLabel = nil,
    --自动使用倒计时
    RemainTime = 0,
    --显示的物品数据
    Data = nil,
}

-- 继承Form函数
function UIGetItemTIps:OnRegisterEvents()
	self:RegisterEvent(UIEventDefine.UIITEMGET_TIPS_OPEN,self.OnOpen)
	self:RegisterEvent(UIEventDefine.UIITEMGET_TIPS_CLOSE,self.OnClose)
    self:RegisterEvent(LogicEventDefine.EVENT_ITEM_CHANGE_UPDATE, self.OnItemChange)
end

function UIGetItemTIps:OnFirstShow()
    self.UIItem = L_UIItem:New(UIUtils.FindTrans(self.Trans, "Container/Back/UIItem"))
    self.UseBtn = UIUtils.FindBtn(self.Trans, "Container/Back/BtnUse")
    self.UseLabel = UIUtils.FindLabel(self.Trans, "Container/Back/BtnUse/Label")

    UIUtils.AddBtnEvent(self.UseBtn, self.OnBtnUse, self)

    local button = UIUtils.FindBtn(self.Trans, "Container/Back/CloseBtn")
    UIUtils.AddBtnEvent(button, self.OnCliseBtnClick, self)

    self.CSForm.UIRegion = UIFormRegion.TopRegion

    self.CSForm:AddAlphaScaleAnimation(nil, 0, 1, 1, 0, 1, 1)
end

function UIGetItemTIps:OnShowAfter()
    self.CSForm.FormType = CS.Funcell.Plugins.Common.UIFormType.Hint
    GameCenter.ItemContianerSystem._isShowTips = true
    self:OnUpdateForm()
end

function UIGetItemTIps:OnHideAfter()
    GameCenter.ItemContianerSystem._isShowTips = false
    GameCenter.ItemContianerSystem:ShowNextNewGetItem()
end

function UIGetItemTIps:Update()
    if not self.Data then
        return
    end
    if self.Data.Type ~= ItemType.Arms then
        return
    end
    if self.RemainTime > 0 then
        self.RemainTime = self.RemainTime - Time.GetDeltaTime()
    end
    if self.RemainTime <= 0 then
        self:OnBtnUse()
        self.RemainTime = 0
    else
        self.UseLabel.text = UIUtils.CSFormat(DataConfig.DataMessageString.Get("C_ITEM_USETIME"), math.ceil(self.RemainTime))
    end
end

function UIGetItemTIps:OnUpdateForm()
    if self.Data ~= nil then
        self.UseLabel.text = DataConfig.DataMessageString.Get("C_ITEM_USE")
        self.UIItem:InitWithItemData(self.Data, 1)
        if self.Data.Type == ItemType.Arms then
            self.RemainTime = 5
        end
    end
end

--打开界面时，保存物品数据
function UIGetItemTIps:OnOpen(obj, sender)
    if obj ~= nil then
        self.Data = obj
        self.CSForm:Show(sender)
    end
end

--物品信息改变，如果背包中没有该物品，则关闭界面
function UIGetItemTIps:OnItemChange(obj, sender)
    if GameCenter.ItemContianerSystem:GetItemCfgIdWithUID(ContainerType.ITEM_LOCATION_BAG, self.Data.DBID) == 0 then
        self:OnClose()
    end
end

--点击界面上关闭按钮
function UIGetItemTIps:OnCliseBtnClick()
    self:OnClose()
end

--使用按钮
function UIGetItemTIps:OnBtnUse()
    if self.Data.ItemInfo.UesUIId ~= 0 then
        GameCenter.MainFunctionSystem:DoFunctionCallBack(FunctionStartIdCode.__CastFrom(self.Data.ItemInfo.UesUIId))
        self:OnClose()
        return
    end

    if self.Data.Count > 1 and self.Data:IsUsedInBatches() then
        GameCenter.PushFixEvent(UIEventDefine.UIITEMBATCH_OPEN, self.Data)
    else
        GameCenter.Network.Send("MSG_backpack.ReqUseItem", {itemId = self.Data.DBID, num = 1})
    end
    self:OnClose()
end
return UIGetItemTIps