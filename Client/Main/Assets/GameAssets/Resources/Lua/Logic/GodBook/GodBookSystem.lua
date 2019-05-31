
------------------------------------------------
--作者： _SqL_
--日期： 2019-04-29
--文件： GodBookSystem.lua
--模块： GodBookSystem
--描述： 天书系统
------------------------------------------------
local AmuletData = require "Logic.GodBook.AmuletData"
local GodBookData = require "Logic.GodBook.GodBookData"

local GodBookSystem = {
    ActiveAmuletID = 0,                                         -- 保存正在激活的符咒id
    OpenForm = false,                                           -- 是否打开面板
    OpenAmuletInfoList = List:New(),                            -- 激活中的的符咒
    OpenAmuletIdList = List:New(),                              -- 激活中的符咒id列表
}

function GodBookSystem:Initialize()
end

function GodBookSystem:UnInitialize()
    self.OpenAmuletIdList:Clear()
    self.OpenAmuletInfoList:Clear()
end

-- 符咒是否可激活
function GodBookSystem:GetAmuletActiveStatus(id)
    if not self.OpenAmuletIdList:Contains(id) then
        return false
    end
    local _amuletData = {}
    for i = 1, self.OpenAmuletInfoList:Count() do
        if self.OpenAmuletInfoList[i].ID == id then
            _amuletData = self.OpenAmuletInfoList[i].TaskList
            if self.OpenAmuletInfoList[i].Status then
                return false
            end
            break
        end
    end
    for i=1,_amuletData:Count() do
        if not (_amuletData[i].Status == AmuletTaskStatusEnum.RECEIVED) then
            return false
        end
    end
    return true
end

-- 获取符咒对应的任务列表
function GodBookSystem:GetTaskList(id)
    if not self.OpenAmuletIdList:Contains(id) then
        return nil
    end
    for i = 1, self.OpenAmuletInfoList:Count() do
        if self.OpenAmuletInfoList[i].ID ==id then
            return self.OpenAmuletInfoList[i].TaskList
        end
    end
end

-- 根据Id获取符咒信息
function GodBookSystem:GetAmuletInfo(id)
    for i = 1, self.OpenAmuletInfoList:Count() do
        if self.OpenAmuletInfoList[i].ID == id then
            return self.OpenAmuletInfoList[i]
        end
    end
end

-- 刷新任务
function GodBookSystem:RefreshTask(index, info)
    local _list = self.OpenAmuletInfoList[index].TaskList
    for j = 1, #_list do
        if _list[j].ID == info.id then
            self.OpenAmuletInfoList[index].TaskList[j]:RefreshData(info)
            break
        end
    end
    if info.status == AmuletTaskStatusEnum.RECEIVED then
        self.OpenAmuletInfoList[index]:SortData()
    end
end

-- 红点条件
function GodBookSystem:IsShowRedPoint(id)
    local _tastList = self:GetTaskList(id)
    if not _tastList then
        return false
    end
    for i = 1, _tastList:Count() do
        if _tastList[i].Status == AmuletTaskStatusEnum.Available then
            return true
        end
    end
    return false
end

-- 设置红点
function GodBookSystem:SetRedPoint()
    local _conditions = List:New();
    local _showRedPoint = false
    for i = 1, self.OpenAmuletInfoList:Count() do
        if self:GetAmuletActiveStatus(self.OpenAmuletInfoList[i].ID) or self:IsShowRedPoint(self.OpenAmuletInfoList[i].ID) then
            _showRedPoint = true
            break
        end
    end
    GameCenter.MainFunctionSystem:SetAlertFlag(FunctionStartIdCode.GodBook, _showRedPoint)
end

-- MSG
-- 请求天书信息
function GodBookSystem:ReqGodBookInfo()
    self.OpenForm = true
    GameCenter.Network.Send("MSG_GodBook.ReqGodBookInfo",{})
end

-- 请求激活符咒
function GodBookSystem:ReqActiveAmulet(id)
    local _req = {}
    _req.amuletId = id
    self.ActiveAmuletID = id
    GameCenter.Network.Send("MSG_GodBook.ReqActiveAmulet", _req)
end

-- 请求领取奖励
function GodBookSystem:ReqGetReward(id)
    local _req = {}
    _req.conditonId = id
    GameCenter.Network.Send("MSG_GodBook.ReqGetReward", _req)
end

-- 天书信息返回
function GodBookSystem:GS2U_ResBookInfo(msg)
    if msg.amulets ~= nil then
        self.OpenAmuletIdList:Clear()
        self.OpenAmuletInfoList:Clear()
        for i = 1, #msg.amulets do
            self.OpenAmuletIdList:Add(msg.amulets[i].id)
            self.OpenAmuletInfoList:Add(GodBookData:New(msg.amulets[i]))
        end
    end
    if self.OpenForm then
        GameCenter.PushFixEvent(UIEventDefine.UIGodBookForm_OPEN)
        self.OpenForm = false
    elseif self.ActiveAmuletID ~= 0 then
        GameCenter.PushFixEvent(LogicEventDefine.EID_EVENT_REFRESH_AMULETINFO, self.ActiveAmuletID)
        self.ActiveAmuletID = 0
    end
    self:SetRedPoint()
end

-- 领取奖励返回
function GodBookSystem:GS2U_ResGetReward(msg)
    local _cfg = DataConfig.DataAmuletCondition[msg.id]
    if not _cfg then
        Debug.LogError("DataAmuletCondition not found key = ", msg.id)
        return
    end
    for i = 1, self.OpenAmuletInfoList:Count() do
        if self.OpenAmuletInfoList[i].ID == _cfg.AmuletId then
            self:RefreshTask(i, {id = msg.id, progress = 0, status = AmuletTaskStatusEnum.RECEIVED})
            break
        end
    end

    GameCenter.PushFixEvent(LogicEventDefine.EID_EVENT_REFRESH_AMULETPANEL, _cfg.AmuletId)
    self:SetRedPoint()
end

-- 符咒条件状态更新
function GodBookSystem:GS2U_ResUpdateCondition(msg)
    Debug.LogError("GS2U_ResUpdateCondition")
    self:SetRedPoint()
end

return GodBookSystem