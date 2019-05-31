------------------------------------------------
--作者： _SqL_
--日期： 2019-05-09
--文件： UIRealmForm.lua
--模块： UIRealmForm
--描述： 境界 窗体
------------------------------------------------
local UIShowRoot = require "UI.Forms.UIRealmForm.Root.UIShowRoot"
local UIRealmTaskRoot = require "UI.Forms.UIRealmForm.Root.UIRealmTaskRoot"
local UIPermissionRoot = require "UI.Forms.UIRealmForm.Root.UIPermissionRoot"
local UIRealmUpgradeRoot = require "UI.Forms.UIRealmForm.Root.UIRealmUpgradeRoot"

local UIRealmForm = {
    CloseBtn = nil,
    -- 境界名字
    RealmName = nil,
    -- 境界模型 特效显示root
    ShowRoot = nil,
    -- 境界任务 root
    TaskRoot = nil,
    -- 境界升级 root
    UpgradeRoot = nil,
    -- 境界权限 root
    PermissionRoot = nil,
    AnimModle = nil,
}

function  UIRealmForm:OnRegisterEvents()
    self:RegisterEvent(UIEventDefine.UIRealmForm_OPEN, self.OnOpen)
    self:RegisterEvent(UIEventDefine.UIRealmForm_CLOSE,self.OnClose)
    self:RegisterEvent(LogicEventDefine.EID_EVENT_REFRESH_REALM_TASKLIST, self.RefreshTaskList)
end

function UIRealmForm:OnFirstShow()
    self:FindAllComponents()
    self:OnRegUICallBack()
end

function UIRealmForm:OnShowAfter()
    self.ShowRoot:SetModelShow()
end

function UIRealmForm:OnHideBefore()
    self.ShowRoot:OnHideBefore()
end

function UIRealmForm:FindAllComponents()
    local _trans = self.CSForm.transform
    self.AnimModle = UIAnimationModule(_trans)
    self.AnimModle:AddAlphaAnimation()
    self.RealmName = UIUtils.FindLabel(_trans, "Top/Title")

    local _showTrans = UIUtils.FindTrans(_trans, "Center/ShowRoot")
    self.ShowRoot = UIShowRoot:New(self, _showTrans)
    self.CloseBtn = UIUtils.FindBtn(_trans,"Top/CloseButton")
    local _tasksTrans = UIUtils.FindTrans(_trans, "Right/TaskRoot")
    self.TaskRoot = UIRealmTaskRoot:New(self, _tasksTrans)
    local _permissionTrans = UIUtils.FindTrans(_trans, "Right/PermissionRoot")
    self.PermissionRoot = UIPermissionRoot:New(self, _permissionTrans)
    local _upgradeTrans = UIUtils.FindTrans(_trans, "Right/UpgradeRoot")
    self.UpgradeRoot = UIRealmUpgradeRoot:New(self, _upgradeTrans)
end

function UIRealmForm:OnRegUICallBack()
    UIUtils.AddBtnEvent(self.CloseBtn, self.OnClose, self)
end

-- 刷新境界
function UIRealmForm:RefreshTaskList(obj, sender)
    if self.TaskRoot then
        self.TaskRoot:RefreshTaskList()
    end

    local _id = 0
    local _sys = GameCenter.RealmSystem
    if _sys:GetRealmLv() < _sys:GetRealmTopLv() then
        _id = 1 + _sys:GetRealmLv()
    else
        _id = _sys:GetRealmLv()
    end
    self.RealmName.text = DataConfig.DataState[_id].Name
end

function UIRealmForm:OnOpen(obj, sender)
    self.CSForm:Show(sender)
    self.PermissionRoot:OnOpen()
    if obj then
        self.TaskRoot:OnClose()
        self.UpgradeRoot:OnOpen()
    else
        self.TaskRoot:OnOpen()
        self.UpgradeRoot:OnClose()
    end
    self.AnimModle:PlayEnableAnimation()
end

function UIRealmForm:OnCLose(obj, sender)
    self.CSForm:Hide()
end


return UIRealmForm