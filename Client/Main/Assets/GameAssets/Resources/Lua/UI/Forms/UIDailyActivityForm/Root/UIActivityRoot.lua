------------------------------------------------
--作者： _SqL_
--日期： 2019-04-22
--文件： UIActivityRoot.lua
--模块： UIActivityRoot
--描述： 活动Root
------------------------------------------------
local UIActivityItem = require "UI.Forms.UIDailyActivityForm.Item.UIActivityItem"

local UIActivityRoot = {
    -- Owner
    Owner = nil,
    -- Trans
    Trans = nil,
    -- 活动item Trans
    Item = nil,
    -- 活动item parent
    ListPanel = nil,
    -- 动画组件
    AnimModule = nil,
}

function UIActivityRoot:New(owner, trans)
    local _m = Utils.DeepCopy(self)
    _m.Owner = owner
    _m.Trans = trans
    _m:FindAllComponents()
    _m:Close()
    return _m
end

function UIActivityRoot:FindAllComponents()
    self.Item = UIUtils.FindTrans(self.Trans, "ListPanel/Item")
    self.ListPanel = UIUtils.FindTrans(self.Trans,"ListPanel")
    self.AnimModule = UIAnimationModule(self.Trans)
    self.AnimModule:AddAlphaAnimation()
end

function UIActivityRoot:RefreshActivity(activityList)
    local _index = 0
    for i = 0, self.ListPanel.childCount - 1 do
        self.ListPanel:GetChild(i).gameObject:SetActive(false)
    end
    for k, v in pairs(activityList) do
        local _cfg = DataConfig.DataDaily[v.ID]
        local _item = nil
        if _index < self.ListPanel.childCount then
            _item = UIActivityItem:New(self.ListPanel:GetChild(_index), v)
        else
            _item = UIActivityItem:Clone(self.Item.gameObject, self.ListPanel, v)
        end
        _item:RefreshInfo()
        _index = _index + 1
    end
    UnityUtils.GridResetPosition(self.ListPanel)
end

function UIActivityRoot:Show()
    if not self.Trans.gameObject.activeSelf then
        self.Trans.gameObject:SetActive(true)
        self.AnimModule:PlayEnableAnimation()
    end
end

function UIActivityRoot:Close()
    self.Trans.gameObject:SetActive(false)
end

return UIActivityRoot