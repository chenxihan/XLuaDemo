------------------------------------------------
--作者： 何健
--日期： 2019-05-30
--文件： UIGetEquipTIps.lua
--模块： UIGetEquipTIps
--描述： 装备获得自动穿戴界面
------------------------------------------------
local L_UIItem = require("UI.Components.UIItem")

local UIGetEquipTIps = {
    --总的倒计时时间，倒计时完后自动穿戴装备
    AllShowTime = 5,
    --当前倒计时
    CurTime = 0,
    --是否正在倒计时
    IsCountDown = false,
    --装备图标
    EquipItem = nil,
    --标题
    TitleLabel = nil,
    --装备按钮
    EquipBtn = nil,
    EquipBtnGo = nil,
    EquipBtnLabel = nil,
    --飞行动画
    TweenPos = nil,
    --飞行动画的ICON，用装备ICON来制作tweenposition
    TweenPosIcon = nil,
    TweenPosGo = nil,
    --增加的战力显示
    PowerAddLabel = nil,
    --装备数据
    Data = nil,
}

-- 继承Form函数
function UIGetEquipTIps:OnRegisterEvents()
	self:RegisterEvent(UIEventDefine.UIEQUIPGET_TIPS_OPEN,self.OnOpen)
	self:RegisterEvent(UIEventDefine.UIEQUIPGET_TIPS_CLOSE,self.OnClose)
    self:RegisterEvent(LogicEventDefine.EID_EVENT_UI_EQUIPSUCESS_FLAY, self.OnEquipSuc)
    self:RegisterEvent(LogicEventDefine.EVENT_ITEM_CHANGE_UPDATE, self.OnItemChange)
    self:RegisterEvent(LogicEventDefine.EID_EVENT_CLOSEREMAINTIME_EQUIP, self.OnCloseCountDown)
end

function UIGetEquipTIps:OnFirstShow()
    self.EquipItem = L_UIItem:New(UIUtils.FindTrans(self.Trans, "Container/Back/Item"))
    self.EquipBtn = UIUtils.FindBtn(self.Trans, "Container/Back/BtnEquip")
    self.EquipBtnGo = UIUtils.FindGo(self.Trans, "Container/Back/BtnEquip")
    self.EquipBtnLabel = UIUtils.FindLabel(self.Trans, "Container/Back/BtnEquip/Label")
    self.TitleLabel = UIUtils.FindLabel(self.Trans, "Container/Back/Title")
    self.PowerAddLabel = UIUtils.FindLabel(self.Trans, "Container/Back/PowerAdd/Label")
    self.TweenPosGo = UIUtils.FindGo(self.Trans, "Container/Flay")
    self.TweenPos = UIUtils.FindTweenPosition(self.Trans, "Container/Flay")
    self.TweenPosIcon = UIUtils.RequireUIIconBase(UIUtils.FindTrans(self.Trans, "Container/Flay"))

    UIUtils.AddBtnEvent(self.EquipBtn, self.OnBtnEquip, self)

    local button = UIUtils.FindBtn(self.Trans, "Container/Back/CloseBtn")
    UIUtils.AddBtnEvent(button, self.OnCliseBtnClick, self)

    self.TweenPos.onFinished:Clear()
    EventDelegate.Add(self.TweenPos.onFinished, Utils.Handler(self.OnMoveFinish, self))

    self.CSForm.UIRegion = UIFormRegion.TopRegion
    self.IsCountDown = false
    self.CurTime = 0

    local _item = DataConfig.DataGlobal[149]
    if _item then
        self.AllShowTime = tonumber(_item.Params)
    end

    self.CSForm:AddAlphaScaleAnimation(nil, 0, 1, 1, 0, 1, 1)
end

function UIGetEquipTIps:OnShowAfter()
    self.CSForm.FormType = CS.Funcell.Plugins.Common.UIFormType.Hint
    self.TweenPosGo:SetActive(false)
    self:OnUpdateForm()
end

function UIGetEquipTIps:OnHideBefore()
    return not self.IsCountDown
end

function UIGetEquipTIps:OnHideAfter()
    GameCenter.EquipmentSystem.IsShowFlay = false
    GameCenter.EquipmentSystem:ShowNextNewGetEquip()
end

--帧更新，更新倒计时
function UIGetEquipTIps:Update()
    if self.IsCountDown then
        local lostTime = 0
        self.CurTime = self.CurTime + Time.GetDeltaTime()
        if  self.CurTime < self.AllShowTime then
            lostTime = math.ceil(self.AllShowTime - self.CurTime)
            if lostTime > 0 then
                self.EquipBtnLabel.text = UIUtils.CSFormat(DataConfig.DataMessageString.Get("C_GETEQUIPTIPS_AUTOEQUIP"), lostTime)
            end
        else
            self:OnBtnEquip()
        end
    end
end

--穿戴按钮点击
function UIGetEquipTIps:OnBtnEquip()
    if self.Data.ItemInfo.IsCheck == 1 then
        GameCenter.ItemTipsMgr:ShowTips(self.Data, self.EquipBtnGo, ItemTipsLocation.Bag)
    else
        self.IsCountDown = false
        GameCenter.EquipmentSystem.IsShowFlay = true
        GameCenter.EquipmentSystem:RequestEquipWear(self.Data)
    end
    self:OnClose()
end

--打开界面事件
function UIGetEquipTIps:OnOpen(obj, sender)
    if obj ~= nil then
        self.Data = obj
        self.CSForm:Show(sender)
        self.CurTime = 0
        if self.Data.ItemInfo.IsCheck == 1 then
            self.IsCountDown = false
            self.EquipBtnLabel.text = DataConfig.DataMessageString.Get("C_FRIEND_SCORIALITY_LOOK")
        else
            self.IsCountDown = true
        end
    end
end

--点击界面上关闭按钮
function UIGetEquipTIps:OnCliseBtnClick()
    self.IsCountDown = false
    self:OnClose()
end

--装备穿载成功后，播放动画
function UIGetEquipTIps:OnEquipSuc(obj, sender)
    -- self.TweenPosGo:SetActive(true)
    -- self.TweenPos:ResetToBeginning()
    -- self.TweenPos:PlayForward()
    self:OnClose()
end

--物品信息改变，如果背包中没有该物品，则关闭界面
function UIGetEquipTIps:OnItemChange(obj, sender)
    if GameCenter.ItemContianerSystem:GetItemCfgIdWithUID(ContainerType.ITEM_LOCATION_BAG, self.Data.DBID) == 0 then
        self:OnClose()
    end
end

--关闭倒计时,用于返回登陆时关闭界面
function UIGetEquipTIps:OnCloseCountDown(obj, sender)
    self.IsCountDown = false
end

--加载界面数据显示
function UIGetEquipTIps:OnUpdateForm()
    if self.Data ~= nil then
        if self.Data.ItemInfo ~= nil then
            self.EquipItem:InitWithItemData(self.Data, 1)
            self.TweenPosIcon:UpdateIcon(self.Data.ItemInfo.Icon)
            self.TitleLabel.text = DataConfig.DataMessageString.Get("C_EQUIP_GET_NB_EQUIP_TIPS")
            self.EquipBtnGo:SetActive(true)

            local itemFight = self.Data.ItemInfo.Score
            local itemFightBody = itemFight
            local BodyEquip = GameCenter.EquipmentSystem:GetPlayerDressEquip(EquipmentType.__CastFrom(self.Data.ItemInfo.Part))
            if BodyEquip ~= nil then
                itemFightBody = itemFight - BodyEquip.ItemInfo.Score
            end
            self.PowerAddLabel.text = tostring(itemFightBody)
        end
    end
end

--动画结速
function UIGetEquipTIps:OnMoveFinish()
    self:OnClose()
end
return UIGetEquipTIps