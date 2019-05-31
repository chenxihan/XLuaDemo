
------------------------------------------------
--作者： 王圣
--日期： 2019-05-15
--文件： FuDiBossShowItem.lua
--模块： FuDiBossShowItem
--描述： 福地bossShowItem
------------------------------------------------

-- c#类
local FuDiBossShowItem = {
    Type = 0,
    TimeTick = 0,
    SyncTime = 0,
    Trans = nil,
    NameLabel = nil,
    TimeLabel = nil,
    Icon = nil,
    Btn = nil,
}

function FuDiBossShowItem:New(trans,type)
    if trans == nil then
        return
    end
    local _m = Utils.DeepCopy(self)
    _m.Trans = trans
    _m.Type = type
    _m.NameLabel = trans:Find("Sprite/BossName"):GetComponent("UILabel")
    _m.TimeLabel = trans:Find("Sprite/FreshTime"):GetComponent("UILabel")
    _m.Icon = UIUtils.RequireUIIconBase(_m.Trans)
    _m.Btn = UIUtils.RequireUIButton(_m.Trans)
    return _m
end

function FuDiBossShowItem:SetData(data)
    if data == nil then
        return
    end
    self.NameLabel.text = data.Name
    if data.BornTime == 0 then
        --还活着
        self.TimeTick = 0
        UIUtils.SetGreen(self.TimeLabel)
        --china
        self.TimeLabel.text = "已刷新"
    else
        self.TimeTick = data.BornTime
        self.SyncTime = Time.GetRealtimeSinceStartup()
        --复活倒计时
        UIUtils.SetRed(self.TimeLabel)
        self.TimeLabel.text = Time.FormatTimeHHMMSS(data.BornTime)
    end
    self.Icon:UpdateIcon(data.IconId)
end

function FuDiBossShowItem:GetTime()
    return self.TimeTick - (Time.GetRealtimeSinceStartup()- self.SyncTime)
end

function FuDiBossShowItem:Update(dt)
    local time = self:GetTime()
    if time>0 then
        time = math.ceil(time)
        self.TimeLabel.text = Time.FormatTimeHHMMSS(time)
    else
        self.TimeTick = 0
    end
end
return FuDiBossShowItem