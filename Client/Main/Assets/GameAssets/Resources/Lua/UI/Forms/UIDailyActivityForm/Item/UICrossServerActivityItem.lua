------------------------------------------------
--作者： _SqL_
--日期： 2019-04-22
--文件： UICrossServerActivityItem.lua
--模块： UICrossServerActivityItem
--描述： 跨服活动Item
------------------------------------------------

local UICrossServerActivityItem = {
    -- Trans
    Trans = nil,
    -- 活动名字
    Name = nil,
    -- 当前阶段
    CurrentStage = nil,
    -- 下一阶段
    NextStage = nil,
    -- 进度按钮
    ScheduleBtn = nil,
    -- 活动信息
    Info = nil,
    -- 父对象
    Owner = nil,
}

function UICrossServerActivityItem:New(owner ,trans, info)
    local _m = Utils.DeepCopy(self)
    self.Owner = owner
    _m.Trans = trans
    _m.ID = info.ID
    _m.Info = info
    _m:FindAllComponents()
    _m:RegUICallback()
    _m:Show()
    _m:RefreshInfo()
    return _m
end

function UICrossServerActivityItem:FindAllComponents()
    self.Name = UIUtils.FindLabel(self.Trans,"Name")
    self.ScheduleBtn = UIUtils.FindBtn(self.Trans,"ScheduleBtn")
    self.CurrentStage = UIUtils.FindLabel(self.Trans,"CurrentStage")
    self.NextStage = UIUtils.FindLabel(self.Trans,"NextStage")
end

function UICrossServerActivityItem:RefreshInfo()
    local _cfg = DataConfig.DataDaily[self.ID]
    self.Name.text = _cfg.Name
end

function UICrossServerActivityItem:RegUICallback()
    UIUtils.AddBtnEvent(self.ScheduleBtn, self.OnScheduleBtnClick, self)
end

-- 跨服活动开启 详情
function UICrossServerActivityItem:OnScheduleBtnClick()
    local info = {
        {ServerName = "渣渣龚胜军", WorldLv = "999"},
        {ServerName = "渣渣龚胜军", WorldLv = "999"},
        {ServerName = "渣渣龚胜军", WorldLv = "999"},
    }
    self.Owner:ShowTips(info)
end

function UICrossServerActivityItem:Clone(owner, go, parentTrans, info)
    local obj = UnityUtils.Clone(go, parentTrans).transform
    return self:New(owner, obj, info)
end

function UICrossServerActivityItem:Show()
    if not self.Trans.gameObject.activeSelf then
        self.Trans.gameObject:SetActive(true)
    end
end

function UICrossServerActivityItem:Close()
    self.Trans.gameObject:SetActive(false)
end

return UICrossServerActivityItem