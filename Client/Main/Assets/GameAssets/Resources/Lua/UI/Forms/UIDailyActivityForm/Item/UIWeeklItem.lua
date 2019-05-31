------------------------------------------------
--作者： _SqL_
--日期： 2019-04-22
--文件： UIWeeklItem.lua
--模块： UIWeeklItem
--描述： 周历Item
------------------------------------------------

local UIWeeklItem = {
    Trans = nil,
    Name = nil,                                                 -- 活动名字显示
    Time = nil,                                                 -- 时间显示
    Btn = nil,                                                  -- 按钮
    OpenSprite = nil,                                           -- 活动开启显示
    SelectSprite = nil,                                         -- 选中显示
    Info = nil,                                                 -- 活动信息
    ID = 0,                                                     -- 对应DataActiveWeek的id
}

function UIWeeklItem:New(trans, id)
    local _m = Utils.DeepCopy(self)
    _m.Trans = trans
    _m.ID = id
    _m:FindAllComponents()
    _m:RegUICallback()
    _m:Show()
    return _m
end

function UIWeeklItem:FindAllComponents()
    self.Btn = self.Trans:GetComponent("UIButton")
    self.Name = UIUtils.FindLabel(self.Trans,"Name")
    self.Time = UIUtils.FindLabel(self.Trans, "Time")
    self.OpenSprite = UIUtils.FindSpr(self.Trans, "Open")
    self.SelectSprite = UIUtils.FindSpr(self.Trans, "Select")

    self.OpenSprite.gameObject:SetActive(false)
    self.SelectSprite.gameObject:SetActive(false)
end

function UIWeeklItem:RefreshWeekly(week)
    local _cfg = DataConfig.DataActiveWeek[self.ID]
    if _cfg.Week == week then
        self.OpenSprite.gameObject:SetActive(true)
    elseif week == 0 and _cfg.Week == 7 then
        self.OpenSprite.gameObject:SetActive(true)
    else
        self.OpenSprite.gameObject:SetActive(false)
    end
    self.Name.text = _cfg.Name
    self.Time.text = _cfg.Time
    self.Info = GameCenter.DailyActivitySystem.AllActivityDic[_cfg.ActiveId]
end

function UIWeeklItem:RegUICallback()
    UIUtils.AddBtnEvent( self.Btn, self.OnBtnClick, self)
end

function UIWeeklItem:OnBtnClick()
    if self.Info ~= nil then
        GameCenter.PushFixEvent(UIEventDefine.UIActivityTipsForm_OPEN, self.Info)
    else
        GameCenter.MsgPromptSystem:ShowPrompt("缺少配置")
    end
end

function UIWeeklItem:Clone(go, parentTrans, id)
    local obj = UnityUtils.Clone(go, parentTrans).transform
    return self:New(obj, id)
end

function UIWeeklItem:Show()
    if not self.Trans.gameObject.activeSelf then
        self.Trans.gameObject:SetActive(true)
    end
end

function UIWeeklItem:Close()
    self.Trans.gameObject:SetActive(false)
end

return UIWeeklItem