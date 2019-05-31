------------------------------------------------
--作者： _SqL_
--日期： 2019-04-22
--文件： UIPushRoot.lua
--模块： UIPushRoot
--描述： 推送Root
------------------------------------------------
local UIPushItem = require "UI.Forms.UIDailyActivityForm.Item.UIPushItem"

local UIPushRoot = {
    Owner = nil,
    Trans = nil,
    Item = nil,
    ListPanel = nil,
    AnimModule = nil,
    PushActivityIdList = List:New(),
}

function UIPushRoot:New(owner, trans)
    self.Owner = owner
    self.Trans = trans
    self:FindAllComponents()
    self:Close()
    return self
end

function UIPushRoot:FindAllComponents()
    self.Item = UIUtils.FindTrans(self.Trans, "ListPanel/Item")
    self.ListPanel = UIUtils.FindTrans(self.Trans,"ListPanel")
    self.AnimModule = UIAnimationModule(self.Trans)
    self.AnimModule:AddAlphaAnimation()
end

function UIPushRoot:RefreshPushActivity()
    self.PushActivityIdList = Utils.DeepCopy(GameCenter.DailyActivitySystem.OpenPushActivityList)
    local _index = 0
    for i = 0, self.ListPanel.childCount - 1 do
        self.ListPanel:GetChild(i).gameObject:SetActive(false)
    end
    for k, v in pairs(DataConfig.DataDailyNotice) do
        local _item = nil
        if _index < self.ListPanel.childCount then
            _item = UIPushItem:New(self, self.ListPanel:GetChild(_index), v.ID)
        else
            _item = UIPushItem:Clone(self, self.Item.gameObject, self.ListPanel, v.ID)
        end
        if self.PushActivityIdList:Contains(v.ID) then
            _item:UpdateSelect()
        end
        _index = _index + 1
    end
    UnityUtils.GridResetPosition(self.ListPanel)
end

function UIPushRoot:CheckPustActivityList()
    if not GameCenter.DailyActivitySystem.OpenPushActivityList:Equal(self.PushActivityIdList) then
        GameCenter.DailyActivitySystem:ReqDailyPushIds(self.PushActivityIdList)
    end
end

function UIPushRoot:Show()
    self.Trans.gameObject:SetActive(true)
    self:RefreshPushActivity()
    self.AnimModule:PlayEnableAnimation()
end

function UIPushRoot:Close()
    self.Trans.gameObject:SetActive(false)
    self:CheckPustActivityList()
end

return UIPushRoot