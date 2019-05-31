------------------------------------------------
--作者： 杨全福
--日期： 2019-04-19
--文件： CopyMapSystem.lua
--模块： CopyMapSystem
--描述： 副本系统逻辑类
------------------------------------------------

local TowerCopyMapData = require("Logic.CopyMapSystem.TowerCopyMapData")
local StarCopyMapData = require("Logic.CopyMapSystem.StarCopyMapData")
local CopyMapOpenState = require("Logic.CopyMapSystem.CopyMapOpenState")

--构造函数
local CopyMapSystem = {
    --副本数据
    CopyData = nil,
    --副本开启状态数据
    CopyStateData = nil,
    --星级副本奖励领取情况
    StarCopyAwardState = nil,
    --任务完成事件
    TaskChangeEvent = nil,
    --等级改变事件
    LevelChangeEvent = nil,

}

--初始化
function CopyMapSystem:Initialize()
    self.CopyData = Dictionary:New();
    self.StarCopyAwardState = List:New();
    self.CopyStateData = Dictionary:New();

    --注意此遍历不是按照表顺序遍历的
    for k,v in pairs(DataConfig.DataCloneMap) do
        local _copyData = self:NewData(v);
        if _copyData ~= nil then
            self.CopyData:Add(k, _copyData);
        end
    end

    --注册事件
    self.TaskChangeEvent = Utils.Handler(self.OnTaskChanged,self);
    self.LevelChangeEvent = Utils.Handler(self.OnLevelChanged,self);
    GameCenter.RegFixEventHandle(LogicEventDefine.EID_EVENT_TASKFINISH, self.TaskChangeEvent);
    GameCenter.RegFixEventHandle(LogicEventDefine.EID_EVENT_PLAYER_LEVEL_CHANGED, self.LevelChangeEvent);
end

--反初始化
function CopyMapSystem:UnInitialize()
    self.CopyData:Clear();
    self.CopyData = nil;
    self.StarCopyAwardState = nil;

    --反注册事件
    GameCenter.UnRegFixEventHandle(LogicEventDefine.EID_EVENT_TASKFINISH, self.TaskChangeEvent);
    GameCenter.UnRegFixEventHandle(LogicEventDefine.EID_EVENT_PLAYER_LEVEL_CHANGED, self.LevelChangeEvent);
end

--查找副本数据
function CopyMapSystem:FindCopyData(id)
    return self.CopyData:Get(id);
end

--查找副本数据
function CopyMapSystem:FindCopyDatasByType(type)
    local result = nil
    for _, v in pairs(self.CopyData) do
        if v.CopyCfg.Type == type then
            if result == nil then
                result = List:New();
            end
            result:Add(v);
        end
    end
    return result;
end

--查找副本数据
function CopyMapSystem:FindCopyDataByType(type)
    local result = nil
    for _, v in pairs(self.CopyData) do
        if v.CopyCfg.Type == type then
            result = v;
            break
        end
    end
    return result;
end

--任务改变事件
function CopyMapSystem:OnTaskChanged(obj, sender)
    self:CheckOpenState(true);
end

--等级改变事件
function CopyMapSystem:OnLevelChanged(obj, sender)
    self:CheckOpenState(true);
end

--检查副本开启状态
function CopyMapSystem:CheckOpenState(showOpen)
    local _playerLevel = GameCenter.GameSceneSystem:GetLocalPlayerLevel();
    for _, v in pairs(self.CopyData) do
        if v.CopyCfg.NeedTaskId ~= 0 and GameCenter.TaskManager:IsMainTaskOver(v.CopyCfg.NeedTaskId) == false then
            v.TaskFinish = false;
        else
            v.TaskFinish = true;
        end

        if (v.CopyCfg.MinLv ~= 0 and v.CopyCfg.MinLv > _playerLevel) or (v.CopyCfg.MaxLv ~= 0 and v.CopyCfg.MaxLv < _playerLevel) then
            v.LevelFinish = false;
        else
            v.LevelFinish = true;
        end

        local _isOpen = false;
        if v.LevelFinish and v.TaskFinish then
            _isOpen = true;
        end

        if showOpen == true and _isOpen == true and v.IsOpen == false then
            --展示副本开启界面,发送开启消息
            GameCenter.PushFixEvent(LogicEventDefine.EID_EVENT_BLOCK_ADD_NEWFUNCTION, PromptNewFunctionType.CopyMap, v.CopyID);
        end
    end
end

--创建副本数据
function CopyMapSystem:NewData(cfgData)
    if cfgData == nil then
        return nil;
    end

    if cfgData.Type == CopyMapTypeEnum.PlaneCopy then
        return nil;
    elseif cfgData.Type == CopyMapTypeEnum.TowerCopy then
        return TowerCopyMapData:New(cfgData);
    elseif cfgData.Type == CopyMapTypeEnum.StarCopy then
        return StarCopyMapData:New(cfgData);
    end
end

--副本基础信息
function CopyMapSystem:ResOpenPanel(msg)
    if msg.infolist == nil then
        return;
    end
    for i = 1, #msg.infolist do
        local _msgData = msg.infolist[i];
        local _copyData = self.CopyData:Get(_msgData.modelId);
        if _copyData ~= nil and _copyData.ParseBaseMsg ~= nil then
            _copyData:ParseBaseMsg(_msgData);
        end
    end
end

--副本开启状态
function CopyMapSystem:ResCloneStateChange(msg)
    for i = 1, #msg.stateList do
        local _msgData = msg.stateList[i];
        local _stateData = self.CopyStateData:Get(_msgData.cloneType);
        if _stateData == nil then
            _stateData = CopyMapOpenState:New();
            _stateData:ParseMsg(_msgData);
            self.CopyStateData:Add(_msgData.cloneType, _stateData);
        else
            _stateData:ParseMsg(_msgData);
        end
    end
    GameCenter.PushFixEvent(LogicEventDefine.EID_EVENT_UPDATE_COPYMAPOPENSTATE);
end

--副本开启状态改变
function CopyMapSystem:ResSingleCloneStateChange(msg)
    local _msgData = msg.state;
    local _stateData = self.CopyStateData:Get(_msgData.cloneType);
    if _stateData == nil then
        _stateData = CopyMapOpenState:New();
        _stateData:ParseMsg(_msgData);
        self.CopyStateData:Add(_msgData.cloneType, _stateData);
    else
        _stateData:ParseMsg(_msgData);
    end
    GameCenter.PushFixEvent(LogicEventDefine.EID_EVENT_UPDATE_COPYMAPOPENSTATE);
end

----------------------------------------公用协议begin-----------------------------------
--请求单人进入副本
function CopyMapSystem:ReqSingleEnterCopyMap(copyId)
    GameCenter.Network.Send("MSG_zone.ReqEnterZone", {type = 1,modelId = copyId});
end

--请求扫荡副本
function CopyMapSystem:ReqSweepCopyMap(copyId)
    GameCenter.Network.Send("MSG_zone.ReqSweepZone", {modelId = copyId});
end
----------------------------------------公用协议begin-----------------------------------


----------------------------------------挑战副本协议begin-----------------------------------
--请求挑战副本界面数据
function CopyMapSystem:ReqOpenChallengePanel()
    GameCenter.Network.Send("MSG_copyMap.ReqOpenChallengePanel", {});
end
--请求继续挑战“挑战副本”
function CopyMapSystem:ReqGoOnChallenge()
    GameCenter.Network.Send("MSG_copyMap.ReqGoOnChallenge", {});
end
--挑战副本界面信息数据
function CopyMapSystem:ResChallengeEnterPanel(msg)
    local _towerData = GameCenter.CopyMapSystem:FindCopyDataByType(CopyMapTypeEnum.TowerCopy);
    if _towerData ~= nil then
        _towerData:ParseMsg(msg);
    end
    --刷新挑战副本界面
    GameCenter.PushFixEvent(LogicLuaEventDefine.EID_EVENT_UPDATE_TIAOZHANFUBEN);
end
----------------------------------------挑战副本协议end-----------------------------------

----------------------------------------星级副本协议begin-----------------------------------
--请求星级副本数据
function CopyMapSystem:ReqOpenStarPanel()
    GameCenter.Network.Send("MSG_copyMap.ReqOpenStarPanel", {});
end
--请求领取星数奖励
function CopyMapSystem:ReqGetStarAward(inIndex)
    GameCenter.Network.Send("MSG_copyMap.ReqGetStarAward", {index = inIndex});
end
--副本信息
function CopyMapSystem:ResOpenStarPanel(msg)
    if msg.datas ~= nil then
        for i = 1, #msg.datas do
            local _msgData = msg.datas[i];
            local _copyData = self:FindCopyData(_msgData.copyId);
            if _copyData ~= nil then
                _copyData:ParseMsg(_msgData);
            end
        end
    end

    self.StarCopyAwardState:Clear();
    for i = 1, #msg.getStates do
        self.StarCopyAwardState:Add(msg.getStates[i]);
    end
    GameCenter.PushFixEvent(LogicLuaEventDefine.EID_REFRESH_STARCOPY_PANEL);
end
----------------------------------------星级副本协议end-----------------------------------

return CopyMapSystem