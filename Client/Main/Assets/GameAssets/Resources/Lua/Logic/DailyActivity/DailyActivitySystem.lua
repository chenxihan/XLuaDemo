
------------------------------------------------
--作者： _SqL_
--日期： 2019-04-23
--文件： DailyActivitySystem.lua
--模块： DailyActivitySystem
--描述： 日常系统
------------------------------------------------
local DailyActivityData = require "Logic.DailyActivity.DailyActivityData"

local DailyActivitySystem = {
    CurrActive = 0,                                                -- 当前获取的活跃值 所有活动的获取的叠加
    MaxActive = 0,                                                 -- 可获取的最大活跃值 所有活动的叠加
    GiftCount = 0,                                                 -- 活跃宝箱的数量
    ReceiveGiftIDList = List:New(),                                -- 以领取过的宝箱ID
    DailyActivityDic = Dictionary:New(),                           -- 日常活动
    LimitActivityDic = Dictionary:New(),                           -- 限时活动
    CrossServerActivityDic = Dictionary:New(),                     -- 跨服活动
    AllActivityDic = Dictionary:New(),                             -- 所有活动
    OpenPushActivityList = List:New(),                             -- 打开推送的活动

    --记录添加的计时器列表
    AddedTimerList = List:New(),
    --记录添加的活动icon列表
    AddedMenuIconList = List:New();
}

function DailyActivitySystem:Initialize()
    local _maxActive = 0
    for k, v in pairs(DataConfig.DataDailyReward) do
        if v.QNeedintegral >= _maxActive then
            _maxActive = v.QNeedintegral
        end
    end
    self.MaxActive = _maxActive
    self.GiftCount = #DataConfig.DataDailyReward
    self:AddTimer();
end

function DailyActivitySystem:UnInitialize()
    self.ReceiveGiftIDList:Clear()
    self.DailyActivityDic:Clear()
    self.LimitActivityDic:Clear()
    self.CrossServerActivityDic:Clear()
    self.OpenPushActivityList:Clear()
    self:RemoveTimer();
end

-- 请求打开日常界面
function DailyActivitySystem:ReqActivePanel()
    GameCenter.Network.Send("MSG_Dailyactive.ReqDailyActivePanel",{})
end

-- 领取活跃宝箱
function DailyActivitySystem:ReqGetActiveReward(giftID)
    local _req = {}
    _req.id = giftID
    GameCenter.Network.Send("MSG_Dailyactive.ReqGetActiveReward", _req)
end

-- 请求打开推送的活动
function DailyActivitySystem:ReqDailyPushIds(idList)
    local _req = {}
    local _temp = {}
    if idList ~= nil and idList:Count() > 1 then
        for i=1,idList:Count() do
            table.insert(_temp, idList[i])
        end
    end
    _req.activeIdList = _temp
    GameCenter.Network.Send("MSG_Dailyactive.ReqDailyPushIds", _req)
end

-- 参加活动 (目前仅限副本)
function DailyActivitySystem:ReqJoinActivity(id)
    local _req = {}
    _req.dailyId = id
    GameCenter.Network.Send("MSG_Dailyactive.ReqJoinDaily", _req)
end

-- 初始化日常活动的信息
function DailyActivitySystem:InitData(data)
    local _activityData = DailyActivityData:New(data.activeId)
    _activityData.Open = data.open
    _activityData.Hide = data.hide
    _activityData.Count = data.progress
    _activityData.CurrActive = data.activePoint
    _activityData.Complete = _activityData.Count >= _activityData.TotalCount
    return _activityData
end

-- 添加值
function DailyActivitySystem:AddValue(dic, key, value)
    if dic:ContainsKey(key) then
        dic[key] = value
    else
        dic:Add(key, value)
    end
end

-- 日常界面打开返回
function DailyActivitySystem:GS2U_ResActivePenel(msg)
    Debug.Log("GS2U_ResActivePenel msg.value = ", msg.value)
    self.CurrActive = msg.value
    if msg.drawIdList ~= nil then
        self.ReceiveGiftIDList:Clear()
        for i = 1, #msg.drawList do
            self.ReceiveGiftIDList:Add(msg.drawList[i])

        end
    end
    table.sort(msg.dailyInfoList,function(a, b)
        local _Cfg1 = DataConfig.DataDaily[a.activeId]
        local _Cfg2 = DataConfig.DataDaily[b.activeId]
        if _Cfg1 and  _Cfg2 then
            return tonumber(_Cfg1.Sort) < tonumber(_Cfg2.Sort)
        end
    end)

    for i =1, #msg.dailyInfoList do
        local _id = msg.dailyInfoList[i].activeId
        local _cfg = DataConfig.DataDaily[_id]
        if not _cfg then
            Debug.LogError("DataDaily not contains key = ", _id)
            return
        end
        local _activityType = _cfg.Fbtype
        if not msg.dailyInfoList[i].hide then
            if _activityType == ActivityTypeEnum.Daily then
                self:AddValue(self.DailyActivityDic, _id, self:InitData(msg.dailyInfoList[i]))
            elseif _activityType == ActivityTypeEnum.Limit then
                self:AddValue(self.LimitActivityDic, _id, self:InitData(msg.dailyInfoList[i]))
            elseif _activityType == ActivityTypeEnum.CrossServer then
                self:AddValue(self.CrossServerActivityDic, _id, self:InitData(msg.dailyInfoList[i]))
            end
        end
        self:AddValue(self.AllActivityDic, _id, self:InitData(msg.dailyInfoList[i]))
    end
    GameCenter.PushFixEvent(UIEventDefine.UIDailyActivityForm_OPEN, ActivityPanelTypeEnum.Daily)
end

-- 请求领取活跃返回
function DailyActivitySystem:GS2U_ResGetActiveReward(msg)
    Debug.Log("GS2U_ResActivePenel msg.result = ", msg.result)
    if msg.result == 0 then
        GameCenter.DailyActivitySystem.ReceiveGiftIDList:Clear()
        for i = 1, #msg.drawIdList do
            GameCenter.DailyActivitySystem.ReceiveGiftIDList:Add(msg.drawIdList[i])
        end
    end
    GameCenter.PushFixEvent(LogicEventDefine.EID_EVENT_REFRESH_ACTIVEPANEL)
end

-- 日常推送返回
function DailyActivitySystem:GS2U_ResDailyPushResult(msg)
    Debug.Log("GS2U_ResDailyPushResult .........................")
    if msg.activeIdList ~= nil then
        self.OpenPushActivityList:Clear()
        for i = 1, #msg.activeIdList do
            self.OpenPushActivityList:Add(msg.activeIdList[i])
        end
    end
end

---------yangqf 2019-5-23 begin----------
--检测时间是否有效
local function CheckTimeValid(timeParams)
    if timeParams == nil or #timeParams < 1 then
        return false;
    end
    for i = 1, #timeParams do
        if #(timeParams[i]) < 2 then
            Debug.LogTable(timeParams[i])
            return false;
        end
        local _startTime = timeParams[i][1];
        local _endTime = timeParams[i][2];
        if #_startTime < 6 or #_endTime < 6 then
            return false;
        end
    end

    return true;
end
--添加计时器
function DailyActivitySystem:AddTimer()
    --添加计时器
    self.AddedTimerList:Clear();
    --注意此遍历不是按照表顺序遍历的
    local _cs = {';', ',', '-'};
    for k,v in pairs(DataConfig.DataDaily) do
        if v.AddOnMenu == 1 then
            local _timeParams = Utils.SplitStrBySeps(v.Time, _cs);
            if CheckTimeValid(_timeParams) then
                for i = 1, #_timeParams do
                local _startTime = _timeParams[i][1];
                local _endTime = _timeParams[i][2];

                local _syear = _startTime[1];
                local _smonth = _startTime[2];
                local _sday = _startTime[3];
                local _sweekDay = _startTime[4];
                local _shour = _startTime[5];
                local _smin = _startTime[6];

                local _eyear = _endTime[1];
                local _emonth = _endTime[2];
                local _eday = _endTime[3];
                local _eweekDay = _endTime[4];
                local _ehour = _endTime[5];
                local _emin = _endTime[6];

                if _sweekDay ~= '*' and _eweekDay ~= '*' then
                    --周活动
                    --开始秒数
                    local _startSecTime = (((_sweekDay - 1) * 24 + _shour) * 60 + _smin) * 60;
                    --结束秒数
                    local _endSecTime = (((_eweekDay - 1) * 24 + _ehour) * 60 + _emin) * 60;
                    --持续时间
                    
                    local _lifeTime = _endSecTime - _startSecTime;
                    local _timerId = GameCenter.TimerEventSystem:AddTimeStampWeekEvent(_startSecTime, _lifeTime,
                                true, v, function(id, remainTime, param)
                                    local _iconId = GameCenter.MainCustomBtnSystem:AddBtn(param.Icon, param.Name, remainTime, param, function(data)
                                        GameCenter.MainFunctionSystem:DoFunctionCallBack(data.CustomData.OpenUI, nil);
                                    end, false, false);
                                    self.AddedMenuIconList:Add(_iconId);
                                end);
                    self.AddedTimerList:Add(_timerId);

                    if v.PushAdvance > 0 then
                        --提前通知展示
                        _timerId = GameCenter.TimerEventSystem:AddTimeStampWeekEvent(_startSecTime - (v.PushAdvance * 60),v.PushAdvance * 60,
                                true, v, function(id, remainTime, param)
                                    local _iconId = GameCenter.MainCustomBtnSystem:AddBtn(param.Icon, param.Name, remainTime, param, function(data)
                                        GameCenter.MsgPromptSystem:ShowPrompt("活动还未开启，请稍等片刻!");
                                    end, false, false);
                                    self.AddedMenuIconList:Add(_iconId);
                                end);
                    end
                else
                end
                end
            end
        end
    end
end

--删除计时器
function DailyActivitySystem:RemoveTimer()
    for i = 1, #self.AddedMenuIconList do
        GameCenter.MainCustomBtnSystem:RemoveBtn(self.AddedMenuIconList[i]);
    end
    self.AddedMenuIconList:Clear();
    --删除计时器
    for i = 1, #self.AddedTimerList do
        GameCenter.TimerEventSystem:RemoveTimerEvent(self.AddedTimerList[i]);
    end
    self.AddedTimerList:Clear();
end
---------yangqf 2019-5-23 end----------

return DailyActivitySystem