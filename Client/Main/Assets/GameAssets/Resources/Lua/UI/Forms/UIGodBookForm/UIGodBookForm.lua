------------------------------------------------
--作者： _SqL_
--日期： 2019-04-30
--文件： UIGodBookForm.lua
--模块： UIGodBookForm
--描述： 天书 窗体
------------------------------------------------
local UITaskRoot = require "UI.Forms.UIGodBookForm.Root.UITaskRoot"
local UIAmuletRoot = require "UI.Forms.UIGodBookForm.Root.UIAmuletRoot"

local UIGodBookForm = {
    CurrAmulet = 0,                                 -- 当前显示的符咒
    TaskRoot = nil,                                 -- 符咒任务列表root
    AmuletRoot = nil,                               -- 符咒列表root
    CloseBtn = nil,
    AnimModule = nil,
}

function  UIGodBookForm:OnRegisterEvents()
    self:RegisterEvent(UIEventDefine.UIGodBookForm_OPEN, self.OnOpen)
    self:RegisterEvent(UIEventDefine.UIGodBookForm_CLOSE,self.OnClose)
    self:RegisterEvent(LogicEventDefine.EID_EVENT_REFRESH_AMULETINFO,self.RefreshAmuletInfo)
    self:RegisterEvent(LogicEventDefine.EID_EVENT_REFRESH_AMULETPANEL,self.RefreshAmuletPanel)
end

function UIGodBookForm:OnFirstShow()
    self:FindAllComponents()
    self:OnRegUICallBack()
end

function UIGodBookForm:FindAllComponents()
    local _trans = self.CSForm.transform
    self.AnimModule = UIAnimationModule(_trans)
    self.AnimModule:AddAlphaAnimation()
    self.CloseBtn = UIUtils.FindBtn(_trans, "closeButton")
    local _taskRoot = UIUtils.FindTrans(_trans, "Center/TaskRoot")
    self.TaskRoot = UITaskRoot:New(self, _taskRoot)
    local _amuletRoot = UIUtils.FindTrans(_trans, "Center/AmuletRoot")
    self.AmuletRoot = UIAmuletRoot:New(self, _amuletRoot)
end

function UIGodBookForm:OnRegUICallBack()
    UIUtils.AddBtnEvent(self.CloseBtn, self.OnClose, self)
end

-- 刷新符咒信息 面板
function UIGodBookForm:RefreshAmuletPanel(obj, sender)
    if obj then
        self.TaskRoot:RefreshTaskList(obj)
        self.AmuletRoot:SetActiveBtnRedPoint(GameCenter.GodBookSystem:GetAmuletActiveStatus(obj))
    end
end

-- 刷新符咒信息
function UIGodBookForm:RefreshAmuletInfo(obj, sender)
    self.AmuletRoot:RefreshAmuletInfo(obj)
end

function UIGodBookForm:OnOpen(obj, sender)
    self.CSForm:Show(sender)
    self.AmuletRoot:RefreshAmuletInfo(AmuletEnum.LuoFan)
    self.AnimModule:PlayEnableAnimation()
end

function UIGodBookForm:OnCLose(obj, sender)
    self.CSForm:Hide()
end

return UIGodBookForm