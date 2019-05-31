------------------------------------------------
--作者： _SqL_
--日期： 2019-04-22
--文件： UICrossServerActivityRoot.lua
--模块： UICrossServerActivityRoot
--描述： 跨服活动Root
------------------------------------------------
local ActivityItem = require "UI.Forms.UIDailyActivityForm.Item.UICrossServerActivityItem"

local UICrossServerActivityRoot = {
    -- Owner
    Owner = nil,
    -- Trans
    Trans = nil,
    -- 活动item trans
    Item = nil,
    -- 活动item parent
    ListPanel = nil,
    -- 活动日程面板
    TipsPanel = nil,
    -- 活动日程面板Title
    TipsTitleDesc = nil,
    -- 活动日程面板关闭按钮
    CloseTipsBtn = nil,
    -- 活动日程item parent
    TipsListPanel = nil,
    -- 活动日程item trans
    TipsItemTrans = nil,
    -- 动画组件
    AnimModule = nil,
}

function UICrossServerActivityRoot:New(owner, trans)
    self.Owner = owner
    self.Trans = trans
    self:FindAllComponents()
    self:RegUICallback()
    self:Close()
    return self
end

function UICrossServerActivityRoot:FindAllComponents()
    self.Item = UIUtils.FindTrans(self.Trans, "ListPanel/Item")
    self.ListPanel = UIUtils.FindTrans(self.Trans,"ListPanel")
    self.TipsPanel = UIUtils.FindTrans(self.Trans, "TipsPanel")
    self.TipsPanel.gameObject:SetActive(false)
    self.TipsTitleDesc = UIUtils.FindLabel(self.Trans,"TipsPanel/Title")
    self.CloseTipsBtn = UIUtils.FindBtn(self.Trans, "TipsPanel/CloseBtn")
    self.TipsListPanel = UIUtils.FindTrans(self.TipsPanel, "ListPanel")
    self.TipsItemTrans = UIUtils.FindTrans(self.TipsPanel,"ListPanel/Item")
    self.AnimModule = UIAnimationModule(self.Trans)
    self.AnimModule:AddAlphaAnimation()
end

function UICrossServerActivityRoot:RegUICallback()
    UIUtils.AddBtnEvent(self.CloseTipsBtn, self.HideTips, self)
end

function UICrossServerActivityRoot:RefreshActivity()
    local _index = 0
    local _activityList = GameCenter.DailyActivitySystem.CrossServerActivityDic
    for k, v in pairs(_activityList) do
        local _item = nil
        if _index < self.ListPanel.childCount then
            _item = ActivityItem:New(self, self.ListPanel:GetChild(_index), v)
        else
            _item = ActivityItem:Clone(self, self.Item.gameObject, self.ListPanel, v)
        end
        _index = _index + 1
    end
    UnityUtils.GridResetPosition(self.ListPanel)
end

-- 显示活动的开启日程
function UICrossServerActivityRoot:ShowTips(info)
    self.TipsPanel.gameObject:SetActive(true)
    for i = 0, self.TipsListPanel.childCount - 1 do
        self.TipsListPanel:GetChild(i).gameObject:SetActive(false)
    end
    self.TipsTitleDesc.text = ""
    if info ~= nil then
        local _index = 0
        for k , v in pairs(info) do
            if _index < self.TipsListPanel.childCount then
                self:SetTipsInfo(self.TipsListPanel:GetChild(_index), v.ServerName, v.WorldLv)
            else
                self:SetTipsInfo(self:CloneTipsItme(self.TipsItemTrans), v.ServerName, v.WorldLv)
            end
            _index = _index + 1
        end
        UnityUtils.GridResetPosition(self.TipsListPanel)
    end
end

function UICrossServerActivityRoot:HideTips()
    self.TipsPanel.gameObject:SetActive(false)
end

function UICrossServerActivityRoot:SetTipsInfo(trans , serverName, worldLv)
    trans.gameObject:SetActive(true)
    UIUtils.FindLabel(trans, "Offset/WorldLv").text = worldLv
    UIUtils.FindLabel(trans, "Offset/ServerName").text = serverName
end

function UICrossServerActivityRoot:Show()
    if not self.Trans.gameObject.activeSelf then
        self.Trans.gameObject:SetActive(true)
        self.AnimModule:PlayEnableAnimation()
    end
end

function UICrossServerActivityRoot:Close()
    self.Trans.gameObject:SetActive(false)
end

function UICrossServerActivityRoot:CloneTipsItme(obj)
    local _trans = GameObject.Instantiate(obj).transform
    _trans:SetParent(self.TipsListPanel)
    UnityUtils.ResetTransform(_trans)
    return _trans
end

return UICrossServerActivityRoot