------------------------------------------------
--作者： _SqL_
--日期： 2019-05-13
--文件： UISearchCommonRoot.lua
--模块： UISearchCommonRoot
--描述： 好友搜索 Base Root
------------------------------------------------
local SearchCommonItem = require "UI.Forms.UISearchFriendForm.Item.UISearchCommonItem"

local UISearchCommonRoot = {
    Owner = nil,
    Trans = nil,
    ListPanel = nil,
    Item = nil,
    CurrPlayerID = nil,
    Show = false,
    SelectItem = nil,
}

function  UISearchCommonRoot:New(owner, trans)
    local _m = Utils.DeepCopy(self)
    _m.Owner = owner
    _m.Trans = trans
    _m:FindAllComponents()
    return _m
end

function UISearchCommonRoot:OnHideBefore()
    for i = 0, self.ListPanel.childCount - 1 do
        self.ListPanel:GetChild(i).gameObject:SetActive(false)
    end
end

function UISearchCommonRoot:FindAllComponents()
    self.ListPanel = UIUtils.FindTrans(self.Trans, "ListPanel")
    self.Item = UIUtils.FindTrans(self.Trans, "ListPanel/Item")
end

function UISearchCommonRoot:RefreshPlayerList(list)
    self:OnOpen()
    local _index = 0
    for i = 0, list.Count - 1 do
        local _item = nil
        if _index <= self.ListPanel.childCount - 1 then
            _item = SearchCommonItem:New(self, self.ListPanel:GetChild(_index))
        else
            _item = SearchCommonItem:Clone(self, self.Item.gameObject, self.ListPanel)
        end
        _item:SetInfo(list[i])
        _index = _index + 1
    end
    UnityUtils.GridResetPosition(self.ListPanel)
    UnityUtils.ScrollResetPosition(self.ListPanel)
end

function UISearchCommonRoot:OnOpen()
    self.Trans.gameObject:SetActive(true)
    self.Show = true
end

function UISearchCommonRoot:OnCLose()
    self.Trans.gameObject:SetActive(false)
    self.Show = false
    self:OnHideBefore()
end

return UISearchCommonRoot