------------------------------------------------
--作者： 薛超
--日期： 2019-05-09
--文件： UIMySelfBossCopyForm.lua
--模块： UIMySelfBossCopyForm
--描述： 个人BOSS副本左侧界面数据
------------------------------------------------
local UIEventListener = CS.UIEventListener
local NGUITools = CS.NGUITools

local UIMySelfBossCopyForm = {
    BossListTime = nil, --左侧BOSS列表
    ListGrid = nil, --列表节点
    ListClone = nil, --克隆体

    OffsetTime = 0.5, --间隔时间更新
    CurTime = 0, --当前时间
    Layer = 0, --当前阶
    RemainTime = 0, --刷新剩余时间
    RemainLab = nil, --剩余时间
    OnClickEvent = nil,
}

function UIMySelfBossCopyForm:OnRegisterEvents()
	self:RegisterEvent(UIEventDefine.UIMySelfBossCopyForm_OPEN,self.OnOpen)
    self:RegisterEvent(UIEventDefine.UIMySelfBossCopyForm_CLOSE,self.OnClose)
    self:RegisterEvent(LogicEventDefine.BOSS_EVENT_MYSELF_BOSSSTAGE, self.UpDateBossStage)
    self:RegisterEvent(LogicEventDefine.BOSS_EVENT_MYSELF_REMAINTEAM, self.UpDateRemaintime)
    self:RegisterEvent(LogicEventDefine.BOSS_EVENT_MYSELF_COPYINFO, self.UpDateInfo)
end

--打开
function UIMySelfBossCopyForm:OnOpen(obj, sender)
    self.CSForm:Show(sender)
end

--关闭
function UIMySelfBossCopyForm:OnClose(obj,sender)
    self.CSForm:Hide()
end

function UIMySelfBossCopyForm:OnFirstShow()
    self:FindAllComponents()
    self:RegUICallback()
end

--注册UI上面的事件，比如点击事件等
function UIMySelfBossCopyForm:RegUICallback()
    self.OnClickEvent = Utils.Handler( self.OnClickLeftBtn,self)
end

--查找组件
function UIMySelfBossCopyForm:FindAllComponents()
    self.ListGrid = UIUtils.FindGrid(self.Trans,"Left/Offset/Scroll/Grid")
    self.ListClone = UIUtils.FindGo(self.Trans,"Left/Offset/Scroll/Grid/Clone")
    self.RemainLab = UIUtils.FindLabel(self.Trans,"Left/Time")
end


--初始化网络消息
function UIMySelfBossCopyForm:InitMsg()
    Debug.LogError("!!!!!!!!!!!!!!!!!!!!!!!InitMsg")
    local _list = GameCenter.MapLogicSystem.ActiveLogic.Msg
    if _list then
        if self.BossListTime then
            self.BossListTime:Clear()
        end
        self.BossListTime = List:New()
        self.Layer = _list.layer
        self.RemainTime = GameCenter.BossSystem.MySelfBossRefshTime
        local _listobj = NGUITools.AddChilds(self.ListGrid.gameObject,self.ListClone,#_list.info)
        for i=1,#_list.info do
            local _go = _listobj[ i -1]
            local _info = _list.info[i]
            local _name = UIUtils.FindLabel(_go.transform,"Name")
            local _monsterDb = DataConfig.DataMonster[_info.monsterid]
            _name.text = _monsterDb.Name
            local _level = UIUtils.FindLabel(_go.transform,"Level")
            local _messagestr = DataConfig.DataMessageString.Get("C_MAIN_NON_PLAYER_SHOW_LEVEL")
            _messagestr = UIUtils.CSFormat(_messagestr,_monsterDb.Level)
            _level.text =  _messagestr
            local _time =  UIUtils.FindLabel(_go.transform,"Time")
            local _reviewtime = _info.time - GameCenter.HeartSystem.ServerTime
            self:SetReviewTime(_reviewtime,_time,false,_info.active)
            local _date = {TimeLabel = _time,MonsterId = _info.monsterid,Time = _info.time,Active = _info.active}
            self.BossListTime:Add(_date)
            UIEventListener.Get(_go).parameter = _info
            UIEventListener.Get(_go).onClick = self.OnClickEvent
        end
        self.ListGrid:Reposition()
    end
end

--点击按钮
function UIMySelfBossCopyForm:OnClickLeftBtn(go)
    local _info = UIEventListener.Get(go).parameter
    local _pos = GameCenter.BossSystem:GetBossPos(_info.monsterid,self.Layer)
    local _x,_z = GameCenter.BossSystem:AnalysisPos(_pos)
    local _mapid = GameCenter.GameSceneSystem:GetActivedMapID()
    GameCenter.PathSearchSystem:SearchPathToPos(_mapid,Vector3(_x,0,_z))
end

function UIMySelfBossCopyForm:OnShowBefore()
    self:InitMsg()
end

--网络消息初始化
function UIMySelfBossCopyForm:UpDateInfo()
    self:InitMsg()
end

--更新剩余刷新时间
function UIMySelfBossCopyForm:UpDateRemaintime(time)
    self.RemainTime = time
    local _remaintime = self.RemainTime < GameCenter.HeartSystem.ServerTime and 0 or self.RemainTime - GameCenter.HeartSystem.ServerTime
    self:SetReviewTime(_remaintime,self.RemainLab,true,false)
end

--BOSS是否存活状态
function UIMySelfBossCopyForm:UpDateBossStage(info,sender)
    if self.BossListTime then
        local _info = self.BossListTime:Find(
            function(code)
                return code.MonsterId == info.monsterid
            end
        )
        _info.Active = info.active
        _info.Time = info.time
        local _curbosstime = 0
        if not _info.Active then
            _curbosstime = _info.Time - GameCenter.HeartSystem.ServerTime
            if _curbosstime <= 0 then
                local _offsettime = GameCenter.HeartSystem.ServerTime - _info.time
                _info.Time = _info.Time + GameCenter.BossSystem:GetBossReviewTimeByIs(self.Layer,_info.MonsterId) - _offsettime
            end
        end
        self:SetReviewTime(_curbosstime,_info.TimeLabel,false,_info.Active)
    end
end

--设置时间显示
function UIMySelfBossCopyForm:SetReviewTime(reviewTime,textlab,isremintime,isactive)
    local t1, t2 = math.modf(reviewTime % 60)
    local _secound = t1
    local _minute = math.FormatNumber((reviewTime // 60) % 60)
    local _hour = math.FormatNumber((reviewTime // 3600) % 60)
    local _day = math.FormatNumber((reviewTime // 43200))
    if isremintime then
        if _day > 0 then --有天数
            local _messagestr = DataConfig.DataMessageString.Get("BOSS_MYSELF_DAYHOUR")
            _messagestr = UIUtils.CSFormat(_messagestr,_day,_hour,_minute)
            textlab.text = _messagestr
        elseif reviewTime <= 0 then --没有刷新时间
            textlab.text = DataConfig.DataMessageString.Get("BOSS_MYSELF_NOTTIME")
        else
            local _messagestr = DataConfig.DataMessageString.Get("BOSS_MYSELF_HOURMINUTE")
            _messagestr = UIUtils.CSFormat(_messagestr,_hour,_minute,_secound)
            textlab.text = _messagestr
        end
    else
        if isactive then --存活
            textlab.text = DataConfig.DataMessageString.Get("BOSS_MYSELF_ACTIVE")
        elseif reviewTime <= 0 then --未刷新
            textlab.text = DataConfig.DataMessageString.Get("BOSS_MYSELF_NOTACTIVE")
        else
            local _messagestr = DataConfig.DataMessageString.Get("BOSS_MYSELF_REMAINTIME")
            _messagestr = UIUtils.CSFormat(_messagestr,_hour,_minute,_secound)
            textlab.text = _messagestr
        end
    end
end

function UIMySelfBossCopyForm:Update(dt)
    if self.BossListTime then
        if self.CurTime >= self.OffsetTime  then
            self.CurTime = 0
            local _remaintime = self.RemainTime < GameCenter.HeartSystem.ServerTime and 0 or  self.RemainTime - GameCenter.HeartSystem.ServerTime
            self:SetReviewTime(_remaintime,self.RemainLab,true,false)
            for i=1,#self.BossListTime do
                local _info = self.BossListTime[i]
                local _curbosstime = 0
                if not _info.Active then
                    _curbosstime = _info.Time - GameCenter.HeartSystem.ServerTime
                    if _curbosstime <= 0 then
                        local _offsettime = GameCenter.HeartSystem.ServerTime - _info.time
                        _info.Time = _info.Time + GameCenter.BossSystem:GetBossReviewTimeByIs(self.Layer,_info.MonsterId) - _offsettime
                    end
                end
                self:SetReviewTime(_curbosstime,_info.TimeLabel,false,_info.Active)
            end
        else
            self.CurTime = self.CurTime + dt
        end
    end
end


return UIMySelfBossCopyForm
