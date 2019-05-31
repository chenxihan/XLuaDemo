------------------------------------------------
--作者： _SqL_
--日期： 2019-04-22
--文件： UIPushItem.lua
--模块： UIPushItem
--描述： 日常活动 推送 Item
------------------------------------------------

local UIPushItem = {
    Trans = nil,
    -- 选中显示
    SelectedSpr = nil,
    -- 未选中显示
    CancelSelectedSpr = nil,
    -- 活动名字
    ActivityName = nil,
    -- 活动说明
    Desc = nil,
    -- 按钮
    Btn = nil,
    -- 是否打开推送
    OpenPush = false,
    -- 父对象
    Owner = nil,
}

function UIPushItem:New(owner ,trans, id)
    local _m = Utils.DeepCopy(self)
    _m.Trans = trans
    _m.ID = id
    _m.Owner = owner
    _m:FindAllComponents()
    _m:RegUICallback()
    _m:Show()
    _m:RefreshInfo()
    return _m
end

function UIPushItem:FindAllComponents()
    self.Desc = UIUtils.FindLabel(self.Trans,"Desc")
    self.ActivityName = UIUtils.FindLabel(self.Trans, "Name")
    self.Btn = UIUtils.FindBtn(self.Trans, "SwitchBtn")
    self.SelectedSpr = UIUtils.FindSpr(self.Trans, "SwitchBtn/Seclect")
    self.SelectedSpr.gameObject:SetActive(false)
    self.CancelSelectedSpr = UIUtils.FindSpr(self.Trans, "SwitchBtn/CancelSeclect")
    self.CancelSelectedSpr.gameObject:SetActive(true)
end

function UIPushItem:RefreshInfo()
    local _cfg = DataConfig.DataDaily[self.ID]
    self.ActivityName.text = _cfg.Name
    self.Desc.text = _cfg.OpenTimeDes
end

-- 更新选中状态
function UIPushItem:UpdateSelect()
    self.SelectedSpr.gameObject:SetActive(true)
    self.CancelSelectedSpr.gameObject:SetActive(false)
end

function UIPushItem:RegUICallback()
    UIUtils.AddBtnEvent(self.Btn, self.OnBtnClick, self)
end

function UIPushItem:OnBtnClick()
    self.SelectedSpr.gameObject:SetActive(not self.SelectedSpr.gameObject.activeSelf)
    self.CancelSelectedSpr.gameObject:SetActive(not self.SelectedSpr.gameObject.activeSelf)
    self.OpenPush = self.SelectedSpr.gameObject.activeSelf
    local _contains = self.Owner.PushActivityIdList:Contains(self.ID)
    if self.OpenPush  and (not _contains) then
        self.Owner.PushActivityIdList:Add(self.ID)
    elseif (not self.OpenPush) and _contains then
        self.Owner.PushActivityIdList:Remove(self.ID)
    end
end

function UIPushItem:Clone(owner, go, parentTrans, id)
    local obj = UnityUtils.Clone(go, parentTrans).transform
    return self:New(owner, obj, id)
end

function UIPushItem:Show()
    if not self.Trans.gameObject.activeSelf then
        self.Trans.gameObject:SetActive(true)
    end
end

function UIPushItem:Close()
    self.Trans.gameObject:SetActive(false)
end

return UIPushItem