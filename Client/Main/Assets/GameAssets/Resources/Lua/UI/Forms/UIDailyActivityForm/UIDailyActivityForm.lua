------------------------------------------------
--作者： _SqL_
--日期： 2019-04-22
--文件： UIDailyActivityForm.lua
--模块： UIDailyActivityForm
--描述： 日常活动Form
------------------------------------------------

local UIDailyActivityForm = {
    ListMenu = nil,
    CloseBtn = nil,
    BgTex = nil,
    AnimModule = nil,
    -- 日常 活动root 容器
    RootContainer = Dictionary:New(),
}

local UIListMenu = require "UI.Components.UIListMenu.UIListMenu"
local UIPushRoot = require "UI.Forms.UIDailyActivityForm.Root.UIPushRoot"
local UIWeekRoot = require "UI.Forms.UIDailyActivityForm.Root.UIWeekRoot"
local UIActiveRoot = require "UI.Forms.UIDailyActivityForm.Root.UIActiveRoot"
local UIActivityRoot = require "UI.Forms.UIDailyActivityForm.Root.UIActivityRoot"
local UICrossServerActivityRoot = require "UI.Forms.UIDailyActivityForm.Root.UICrossServerActivityRoot"

function UIDailyActivityForm:OnRegisterEvents()
    self:RegisterEvent(UIEventDefine.UIDailyActivityForm_OPEN, self.OnOpen)
    self:RegisterEvent(UIEventDefine.UIDailyActivityForm_CLOSE,self.OnClose)
    self:RegisterEvent(LogicEventDefine.EID_EVENT_REFRESH_ACTIVEPANEL,self.RefreshActivePanel)
end

function UIDailyActivityForm:OnFirstShow()
    self:FindAllComponents()
    self:RegUICallback()
    -- GameCenter.DailyActivitySystem:ReqDailyPushIds(nil)
end

function UIDailyActivityForm:OnOpen(obj, sender)
    self.CSForm:Show(sender)
    self:LoadBgTex()
    self.ListMenu:SetSelectById(obj)
    self.AnimModule:PlayEnableAnimation()
end

function UIDailyActivityForm:OnClose(obj, sender)
    self.CSForm:Hide()
    self.RootContainer[ActivityPanelTypeEnum.Push]:CheckPustActivityList()
end

function UIDailyActivityForm:FindAllComponents()
    local _trans = self.CSForm.transform
    self.AnimModule = UIAnimationModule(_trans)
    self.AnimModule:AddAlphaAnimation()
    self.CloseBtn = UIUtils.FindBtn(_trans,"CloseButton")
    self.BgTex = UIUtils.FindTex(_trans, "Back/BG")

    local _weekRoot = UIUtils.FindTrans(_trans, "Center/WeekRoot")
    local _pushRoot = UIUtils.FindTrans(_trans, "Center/PushRoot")
    local _activeRoot = UIUtils.FindTrans(_trans, "Center/ActiveRoot")
    local _dailyRoot = UIUtils.FindTrans(_trans, "Center/DailyActivityRoot")
    local _limitRoot = UIUtils.FindTrans(_trans, "Center/LimitActivityRoot")
    local _crossServerRoot = UIUtils.FindTrans(_trans, "Center/CrossServerActivityRoot")
    self.RootContainer[ActivityPanelTypeEnum.Week] = UIWeekRoot:New(self, _weekRoot)
    self.RootContainer[ActivityPanelTypeEnum.Push] = UIPushRoot:New(self, _pushRoot)
    self.RootContainer[ActivityPanelTypeEnum.Active] = UIActiveRoot:New(self, _activeRoot)
    self.RootContainer[ActivityPanelTypeEnum.Daily] = UIActivityRoot:New(self, _dailyRoot)
    self.RootContainer[ActivityPanelTypeEnum.Limit] = UIActivityRoot:New(self, _limitRoot)
    self.RootContainer[ActivityPanelTypeEnum.CrossServer]  = UICrossServerActivityRoot:New(self, _crossServerRoot)

    local _listMenu = UIUtils.FindTrans(_trans,"UIListMenu")
    self.ListMenu = UIListMenu:OnFirstShow(self.CSForm, _listMenu)
    self.ListMenu:AddIcon(ActivityPanelTypeEnum.Daily, "日常" , ActivityPanelTypeEnum.Daily)
    self.ListMenu:AddIcon(ActivityPanelTypeEnum.Limit, "限时" , ActivityPanelTypeEnum.Limit)
    self.ListMenu:AddIcon(ActivityPanelTypeEnum.CrossServer, "跨服" , ActivityPanelTypeEnum.CrossServer)
    self.ListMenu:AddIcon(ActivityPanelTypeEnum.Week, "周历" , ActivityPanelTypeEnum.Week)
    self.ListMenu:AddIcon(ActivityPanelTypeEnum.Push, "推送" , ActivityPanelTypeEnum.Push)
end

function UIDailyActivityForm:LoadBgTex()
    self.CSForm:LoadTexture(self.BgTex, AssetUtils.GetImageAssetPath(ImageTypeCode.UI, "bag_back"))
end

function UIDailyActivityForm:RegUICallback()
    UIUtils.AddBtnEvent(self.CloseBtn, self.OnClose, self)
    self.ListMenu:ClearSelectEvent()
    self.ListMenu:AddSelectEvent(Utils.Handler(self.OnClickCallBack, self))
end

function UIDailyActivityForm:OnClickCallBack(id, selected)
    if selected then
        self.RootContainer[id]:Show()
        if id == ActivityPanelTypeEnum.Daily then
            self.RootContainer[ActivityPanelTypeEnum.Active]:Show()
            self.RootContainer[ActivityPanelTypeEnum.Daily]:RefreshActivity(GameCenter.DailyActivitySystem.DailyActivityDic)
        elseif id == ActivityPanelTypeEnum.Limit then
            self.RootContainer[ActivityPanelTypeEnum.Active]:Show()
            self.RootContainer[ActivityPanelTypeEnum.Limit]:RefreshActivity(GameCenter.DailyActivitySystem.LimitActivityDic)
        elseif id == ActivityPanelTypeEnum.CrossServer then
            self.RootContainer[ActivityPanelTypeEnum.CrossServer]:RefreshActivity()
            self.RootContainer[ActivityPanelTypeEnum.Active]:Close()
        else
            self.RootContainer[ActivityPanelTypeEnum.Active]:Close()
        end
    else
        self.RootContainer[id]:Close()
    end
end

function UIDailyActivityForm:RefreshActivePanel(obj, sender)
    self.RootContainer[ActivityPanelTypeEnum.Active]:RefreshActive()
end

return UIDailyActivityForm