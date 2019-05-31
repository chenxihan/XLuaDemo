------------------------------------------------
--作者： _SqL_
--日期： 2019-05-13
--文件： UISearchCommonItem.lua
--模块： UISearchCommonItem
--描述： 活跃度宝箱Item
------------------------------------------------

local UISearchCommonItem = {
    Lv = nil,
    Name = nil,
    PlayerHead = nil,
    AddFriendBtn = nil,
    SelectedTex = nil,
    Career = nil,
    PlayerInfo = nil,
    SelectBtn = nil,
}

function UISearchCommonItem:New(owner, trans)
    local _m = Utils.DeepCopy(self)
    _m.Owner = owner
    _m.Trans = trans
    _m:FindAllComponents()
    _m.Trans.gameObject:SetActive(true)
    _m:RegUICallback()
    return _m
end

function UISearchCommonItem:FindAllComponents()
    self.Lv = UIUtils.FindLabel(self.Trans, "Lv")
    self.Name = UIUtils.FindLabel(self.Trans, "Name")
    self.Career = UIUtils.FindSpr(self.Trans, "Career")
    self.SelectedTex = UIUtils.FindTrans(self.Trans, "SelectedTex")
    self.AddFriendBtn = UIUtils.FindBtn(self.Trans, "AddBtn")
    self.SelectBtn = self.Trans:GetComponent("UIButton")

    local _head = UIUtils.FindTrans(self.Trans, "Head/UIPlayerHead")
    self.PlayerHead = UnityUtils.RequireComponent(_head, "Funcell.GameUI.Form.UIPlayerHead")
end

function UISearchCommonItem:SetInfo(info)
    self.Trans.gameObject:SetActive(true)
    self.PlayerInfo = info
    self.Lv.text = info.lv
    self.Name.text = info.name
    local _carrerStr = tostring(info.career)
    self.PlayerHead:SetInfo(true, info.playerId, Utils.GetEnumNumber(_carrerStr), info.lv)
end

function UISearchCommonItem:SetSelect()
    self.Owner.CurrPlayerID = self.PlayerInfo.playerId
    self.SelectedTex.gameObject:SetActive(true)
    if self.Owner.SelectItem then
        self.Owner.SelectItem.SelectedTex.gameObject:SetActive(false)
    end
    self.Owner.SelectItem = self
end

function UISearchCommonItem:OnAddFriendBtnClick()
    GameCenter.FriendSystem:AddRelation(FriendType.Friend, self.PlayerInfo.playerId)
end

function UISearchCommonItem:RegUICallback()
    UIUtils.AddBtnEvent(self.SelectBtn, self.SetSelect, self)
    UIUtils.AddBtnEvent(self.AddFriendBtn, self.OnAddFriendBtnClick, self)
end

function UISearchCommonItem:Clone(owner, go, parentTrans)
    local obj = UnityUtils.Clone(go, parentTrans).transform
    return self:New(owner, obj)
end

return UISearchCommonItem