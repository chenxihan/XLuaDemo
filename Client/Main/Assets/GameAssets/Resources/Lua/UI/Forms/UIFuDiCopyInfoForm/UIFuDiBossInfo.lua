
------------------------------------------------
--作者： 王圣
--日期： 2019-05-16
--文件： UIFuDiBossInfo.lua
--模块： UIFuDiBossInfo
--描述： UIFuDiBossInfo组件
------------------------------------------------

-- c#类
local UIFuDiBossInfo = {
    Id = 0,
    Sort = 0,
    MonsterId = 0,
    Pos = nil,
    TimeTick = 0,
    SyncTime = 0,
    Trans = nil,
    NameLabel = nil,
    TimeLabel = nil,
    TypeLabel = nil,
    Select = nil,
    Btn = nil,
}

local MonsterType = {
    Leader = 1,
    Elet = 2,
    HuWei = 3,
}

function UIFuDiBossInfo:New(trans)
    if trans == nil then
        return
    end
    local _m = Utils.DeepCopy(self)
    _m.Trans = trans
    _m.NameLabel = trans:Find("Name"):GetComponent("UILabel")
    _m.TimeLabel = trans:Find("Time"):GetComponent("UILabel")
    _m.TypeLabel = trans:Find("MonsterType"):GetComponent("UILabel")
    _m.Select = trans:Find("Select")
    _m.Select.gameObject:SetActive(false)
    _m.Btn = UIUtils.RequireUIButton(_m.Trans)
    return _m
end

function UIFuDiBossInfo:SetDefaultData(cfg)
    if cfg == nil then
        return
    end
    self.Id = cfg.Id
    self.Sort = cfg.Sort
    local monsterCfg = DataConfig.DataMonster[cfg.MonsterID]
    if monsterCfg == nil then
        return
    end
    self.NameLabel.text = monsterCfg.Name
    UIUtils.SetGreen(self.TimeLabel)
    self.TimeLabel.text = "已刷新"
    --china
    if cfg.Type == MonsterType.Leader then
        self.TypeLabel.text = "首领"
    elseif cfg.Type == MonsterType.Elet then
        self.TypeLabel.text = "精英"
    elseif cfg.Type == MonsterType.HuWei then
        self.TypeLabel.text = "护卫"
    end
    self.MonsterId = cfg.MonsterID
    local list = Utils.SplitStr(cfg.Pos,'_')
    self.Pos = Vector2(tonumber(list[1]),tonumber(list[2]))
end

function UIFuDiBossInfo:SetData(data)
    if data == nil then
        return
    end
    self.Id = data.monsterModelId
    local monsterId = DataConfig.DataGuildBattleBoss[data.monsterModelId].MonsterID
    self.NameLabel.text = DataConfig.DataMonster[monsterId].Name
    if data.resurgenceTime == 0 then
        --还活着
        UIUtils.SetRed(self.TimeLabel)
        self.TimeLabel.text = "已刷新"
    else
        self.TimeTick = data.resurgenceTime
        self.SyncTime = Time.GetRealtimeSinceStartup()
        --复活倒计时
        UIUtils.SetRed(self.TimeLabel)
        self.TimeLabel.text = Time.FormatTimeHHMMSS(data.resurgenceTime)
    end
    --china
    if data.monsterType == MonsterType.Leader then
        self.TypeLabel.text = "首领"
    elseif data.monsterType == MonsterType.Elet then
        self.TypeLabel.text = "精英"
    elseif data.monsterType == MonsterType.HuWei then
        self.TypeLabel.text = "护卫"
    end
end

function UIFuDiBossInfo:GetTime()
    return self.TimeTick - (Time.GetRealtimeSinceStartup()- self.SyncTime)
end

function UIFuDiBossInfo:Update(dt)
    local time = self:GetTime()
    if time>0 then
        time = math.ceil(time)
        self.TimeLabel.text = Time.FormatTimeHHMMSS(time)
    else
        self.TimeTick = 0
    end
end
return UIFuDiBossInfo