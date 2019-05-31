------------------------------------------------
--作者：xihan
--日期：2019-05-17
--文件：AchievementSystem.lua
--模块：AchievementSystem
--描述：成就系统
------------------------------------------------
local AchievementInfo = require("Logic.Achievement.AchievementInfo")
local L_Sort = table.sort

local AchievementSystem = {
    --根据大类存储该类所有数据{[1]={data1，data2,...},...}
    DataTypeDic = nil,
    --每一个id对应一个数据{[101]=data1，[102]=data2,...}
    DataIdDic = nil,
    --已完成的Id列表
    FinishIdList = nil,
    --可以领取奖励的Id列表
    CanGetIdList = nil,
    --未完成的成就，且有进度，这是服务器发来的
    UnfinishedAchievementInfoDic = nil,
}

--系统初始化
function AchievementSystem:Initialize()
    self.FinishIdList = List:New();
    self.CanGetIdList = List:New();
    self.UnfinishedAchievementInfoDic = Dictionary:New();
    -- Debug.LogTable(AchievementSystem:GetDataTypeDic(),"GetDataTypeDic");
end

--系统卸载
function AchievementSystem:UnInitialize()
    self.DataTypeDic = nil;
    self.DataIdDic = nil;
    self.FinishIdList = nil;
    self.CanGetIdList = nil;
end

--配置表是否有该id
function AchievementSystem:IsContains(id)
    return not (not DataConfig.DataAchievement[id]);
end

--获取根据大类存储该类所有数据的字典
function AchievementSystem:GetDataTypeDic()
    if not self.DataTypeDic then
        self:InitUIdata();
    end
    return self.DataTypeDic;
end

--获取每一个id对应一个数据的字典
function AchievementSystem:GetDataIdDic()
    if not self.DataIdDic then
        self:InitUIdata();
    end
    return self.DataIdDic;
end

--根据Id获取对应的数据
function AchievementSystem:GetDataById(id)
    if not self.DataIdDic then
        self:InitUIdata();
    end
    return self.DataIdDic[id];
end

--初始化UI数据
function AchievementSystem:InitUIdata()
    self.DataTypeDic = Dictionary:New();
    self.DataIdDic = Dictionary:New();
    AchievementInfo:NewAll(self.DataTypeDic, self.DataIdDic);
    for _, v in pairs(self.FinishIdList) do
        if self.DataIdDic[v] then
            self.DataIdDic[v].State = AchievementState.Finish;
        else
            Debug.LogTableRed(self.FinishIdList, "FinishIdList");
            Debug.LogError("Error [config without this id]", "MSG_Achievement.ResAchievementInfo", "finishIds", v);
        end
    end

    for _, v in pairs(self.CanGetIdList) do
        if self.DataIdDic[v] then
            self.DataIdDic[v].State = AchievementState.CanGet;
        else
            Debug.LogTableRed(self.CanGetIdList, "CanGetIdList");
            Debug.LogError("Error [config without this id]", "MSG_Achievement.ResAchievementInfo", "canGetIds", v);
        end
    end
    self:DataSort();
end

--清理与UI相关的数据
function AchievementSystem:ClearUIdata()
    self.DataTypeDic = nil;
    self.DataIdDic = nil;
end

--数据排序[可领取>未完成>已完成>小id>大id]
function AchievementSystem:DataSort()
    if self.DataTypeDic then
        self.DataTypeDic:Foreach(function(_, v)
            table.sort(v, function(a, b)
                if a.State == b.State then
                    return a.Count < b.Count;
                else
                    return a.State > b.State;
                end
            end)
        end)
    end
end

--获取完成了的成就点
function AchievementSystem:GetFinishAcievementCountByType(type)
    local _typeCounts = {};
    for _,v in pairs(self.FinishIdList) do
        local _data = self.DataIdDic[v];
        local _bigType = _data.DataAchievementItem.BigType;
        if not _typeCounts[_bigType] then
            _typeCounts[_bigType] = 0;
        end
        _typeCounts[_bigType] = _typeCounts[_bigType] + _data.DataAchievementItem.AddAchievement;
    end
    return _typeCounts[type] or 0;
end

--获取完成了的总成就
function AchievementSystem:GetFinishAcievementCount()
    local _count = 0;
    for _,v in pairs(self.FinishIdList) do
        _count = _count + self.DataIdDic[v].DataAchievementItem.AddAchievement;
    end
    return _count;
end

--是否有红点[该id的成就]
function AchievementSystem:IsRedPointById(FunctionId)
    -- return self.CanGetIdList:Contains(id);
    local _DataAchievement = DataConfig.DataAchievement;
    for _, v in pairs(self.CanGetIdList) do
        local _item = _DataAchievement[v];
        if _item then
            local _t = Utils.SplitStr(_item.Condition, "_");
            if tonumber(_t[1]) == FunctionId then
                return true;
            end
        else
            Debug.LogError("Error [config without this id]", v);
        end
    end
    return false;
end
--是否有红点[该类型的所有成就]
function AchievementSystem:IsRedPointByType(bigType)
    local _DataAchievement = DataConfig.DataAchievement;
    for _, v in pairs(self.CanGetIdList) do
        local _item = _DataAchievement[v];
        if _item then
            if _item.BigType == bigType then
                return true;
            end
        else
            Debug.LogError("Error [config without this id]", v);
        end
    end
    return false;
end
--是否有红点[该成就系统]
function AchievementSystem:IsRedPoint()
    return self.CanGetIdList:Count() > 0;
end

--刷新小红点
function AchievementSystem:RefreshRedPoint()
    GameCenter.MainFunctionSystem:SetAlertFlag(FunctionStartIdCode.ChengjiuBase, self:IsRedPoint());
    GameCenter.MainFunctionSystem:SetAlertFlag(FunctionStartIdCode.ChengJiu, self:IsRedPoint());
end
--========================================================[msg]========================================================
--发送领取奖励
function AchievementSystem:SendGetMsg(id)
    GameCenter.Network.Send("MSG_Achievement.ReqGetAchievement", {id = id});
end

--上线收到的成就列表
function AchievementSystem:ResAchievementInfo(msg)
    Debug.LogTableRed(msg, "MSG_Achievement.ResAchievementInfo");
    --检查1
    if not msg  then
        Debug.LogTableRed(msg, "MSG_Achievement.ResAchievementInfo");
        Debug.LogError("Error [server msg]", "MSG_Achievement.ResAchievementInfo");
        return;
    end
    --检查2
    local _checkTable = {};
    local _DataAchievement = DataConfig.DataAchievement;
    local _finishIds = msg.hasGetIds;
    if _finishIds then
        for i=#_finishIds,1,-1 do
            local _finishId = _finishIds[i];
            if not _DataAchievement[_finishId] then
                Debug.LogError("Error [config without this id]", "MSG_Achievement.ResAchievementInfo", "finishIds", _finishIds[i]);
                table.remove(_finishIds, i)
            else
                if _checkTable[_finishId] == 1 then
                    Debug.LogError("Error [repeating]",_finishId);
                    table.remove(_finishIds, i)
                else
                    _checkTable[_finishId] = 1;
                end
            end
        end
    end

    local _canGetIds = msg.canGetIds;
    if _canGetIds then
        for i=#_canGetIds,1,-1 do
            local _canGetId = _canGetIds[i];
            if not _DataAchievement[_canGetId] then
                Debug.LogError("Error [config without this id]", "MSG_Achievement.ResAchievementInfo", "finishIds", _canGetIds[i]);
                table.remove(_canGetIds, i)
            else
                if _checkTable[_canGetId] == 2 then
                    Debug.LogError("Error [repeating]",_canGetId);
                    table.remove(_canGetIds, i)
                elseif _checkTable[_canGetId] == 1 then
                    Debug.LogError("Error [server logic]",_canGetId);
                    table.remove(_canGetIds, i)
                else
                    _checkTable[_canGetId] = 2;
                end
            end
        end
    end

    local _unfinishInfos = msg.infos;
    if _unfinishInfos then
        for i=#_unfinishInfos,1,-1 do
            local _item = _unfinishInfos[i];
            if not _DataAchievement[_item.id] then
                Debug.LogError("Error [config without this id]", "MSG_Achievement.ResAchievementInfo", "finishIds", _canGetIds[i]);
                table.remove(_unfinishInfos, i)
            else
                if _checkTable[_item.id] == 3 then
                    Debug.LogError("Error [repeating]",_item.id);
                    table.remove(_canGetIds, i)
                elseif _checkTable[_item.id] == 2 then
                    Debug.LogError("Error [server logic]",_item.id);
                    table.remove(_canGetIds, i)
                elseif _checkTable[_item.id] == 1 then
                    Debug.LogError("Error [server logic]",_item.id);
                    table.remove(_canGetIds, i)
                else
                    _checkTable[_item.id] = 3;
                end
            end
            self.UnfinishedAchievementInfoDic:Add(_item.id, _item);
        end
    end

    self.FinishIdList = List:New(_finishIds);
    self.CanGetIdList = List:New(_canGetIds);
    --刷新小红点
    self:RefreshRedPoint()
end

--获取成就奖励返回
function AchievementSystem:ResGetAchievement(msg)
    local _msgid = msg.id;
    if not msg or not _msgid then
        Debug.LogTableRed(msg, "MSG_Achievement.ResGetAchievement");
        Debug.LogError("Error [server msg]", "MSG_Achievement.ResGetAchievement");
        return;
    end
    if self:IsContains(_msgid) then
        if self.CanGetIdList:Contains(_msgid) then
            self.CanGetIdList:Remove(_msgid)
        else
            Debug.LogError("Error [server logic]",_msgid)
        end
        if not self.FinishIdList:Contains(_msgid) then
            self.FinishIdList:Add(_msgid);
            if self.DataIdDic then
                self.DataIdDic[_msgid].State = AchievementState.Finish;
                self:DataSort();
            end
        else
            Debug.LogError("Error [repeating]", "MSG_Achievement.ResGetAchievement", "getIds", _msgid);
            return;
        end
    else
        Debug.LogTableRed(msg, "MSG_Achievement.ResGetAchievement");
        Debug.LogError("Error [config without this id]", "MSG_Achievement.ResGetAchievement", "getIds", _msgid);
        return;
    end
    --刷新小红点
    self:RefreshRedPoint()
    --更新界面
    GameCenter.PushFixEvent(LogicEventDefine.EID_EVENT_UPDATE_ACHFORM);
end

--更新成就列表
function AchievementSystem:ResUpdateAchivement(msg)
    Debug.LogTableRed(msg, "MSG_Achievement.ResUpdateAchivement");
    if not msg or not msg.infos then
        Debug.LogTableRed(msg, "MSG_Achievement.ResUpdateAchivement");
        Debug.LogError("Error [server msg]", "MSG_Achievement.ResUpdateAchivement");
        return;
    end
    for k,v in pairs(msg.infos) do
        if self.DataIdDic then
            local _item = self.DataIdDic[v.id]
            if _item then
                _item.Progress = v.pro;
                _item.State = v.state == 0 and AchievementState.None or (v.state == 1 and AchievementState.CanGet or AchievementState.Finish);
            end
        end

        local _unfinishItem = self.UnfinishedAchievementInfoDic[v.id];
        if v.state == 0 then
            if _unfinishItem then
                _unfinishItem.pro = v.pro;
                _unfinishItem.state = v.state;
            else
                self.UnfinishedAchievementInfoDic:Add(v.id, v);
            end
        elseif v.state == 1 then
            if not self.CanGetIdList:Contains(v.id) then
                self.CanGetIdList:Add(v.id);
                if _unfinishItem then
                    self.UnfinishedAchievementInfoDic:Remove(v.id);
                end
            else
                Debug.LogError("Error [repeating]", "MSG_Achievement.ResUpdateAchivement", v.id);
            end
        elseif v.state == 2 then
            if not self.FinishIdList:Contains(v.id) then
                self.FinishIdList:Add(v.id);
                if _unfinishItem then
                    self.UnfinishedAchievementInfoDic:Remove(v.id);
                end
            else
                Debug.LogError("Error [repeating]", "MSG_Achievement.ResUpdateAchivement", v.id);
            end
            if self.CanGetIdList:Contains(v.id) then
                self.CanGetIdList:Remove(v.id);
            end
            if self.UnfinishedAchievementInfoDic[v.id] then
                self.UnfinishedAchievementInfoDic:Remove(v.id);
            end
        end
    end
    self:DataSort();
    --刷新小红点
    self:RefreshRedPoint()
    --更新界面
    GameCenter.PushFixEvent(LogicEventDefine.EID_EVENT_UPDATE_ACHFORM);
end

return AchievementSystem