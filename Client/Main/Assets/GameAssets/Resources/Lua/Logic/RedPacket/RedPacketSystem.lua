------------------------------------------------
--作者： 何健
--日期： 2019-05-27
--文件： RedPacketSystem.lua
--模块： RedPacketSystem
--描述： 红包系统逻辑处理
------------------------------------------------
local L_RPInfo = require "Logic.RedPacket.RedpacketInfo"
local L_LogInfo = require "Logic.RedPacket.RedPacketLogInfo"
local L_CheckInfo = require "Logic.RedPacket.CheckRedPacketInfo"
local RedPacketSystem = {
    --是否打开红包界面
    IsOpenPanel = false,
    --红包列表
    RpInfoList = List:New(),
    --红包日志列表
    RpLogList = List:New(),
    --查看或抢到的的红包ID
    CheckRpID = 0,
    --查看的红包具体数据
    CheckRpPlayerInfo = List:New()
}

function RedPacketSystem:Initialize()
    self.CheckRpID = 0
end

function RedPacketSystem:UnInitialize()
    self.CheckRpPlayerInfo:Clear()
    self.RpInfoList:Clear()
    self.RpLogList:Clear()
end

--根据红包ID，获取红包数据
function RedPacketSystem:GetRedPacketInfoById(id)
    for i = 1, #self.RpInfoList do
        if self.RpInfoList[i].RpID == id then
            return self.RpInfoList[i]
        end
    end
end

--查看红包或抢红包的数据
function RedPacketSystem:GetRedPacketByCheckOrGet()
    for i = 1, #self.RpInfoList do
        if self.RpInfoList[i].RpID == self.CheckRpID then
            return self.RpInfoList[i]
        end
    end
end

--是否有红包可以打开
function RedPacketSystem:HasRedPaketToOpen()
    for i = 1, #self.RpInfoList do
        -- 1 表明可以发红包，未领取并且剩余个数大于0才显示红点
        if self.RpInfoList[i].OwnType == 1 or (self.RpInfoList[i].Mark == false and self.RpInfoList[i].CurNum > 0) then
            return true
        end
    end
    return false
end

--服务器返回红包列表及日志列表
function RedPacketSystem:GS2U_ResRedpacketList(msg)
    self.RpInfoList:Clear()
    self.RpLogList:Clear()
    if msg.rpinfo then
        for i = 1, #msg.rpinfo do
            local _info = L_RPInfo:New()
            _info.RpID = msg.rpinfo[i].rpId
            _info.MaxValue = msg.rpinfo[i].maxValue
            _info.CurNum = msg.rpinfo[i].curnum
            _info.MaxNum = msg.rpinfo[i].maxnum
            _info.SendTime = msg.rpinfo[i].sendtime
            _info.RoleID = msg.rpinfo[i].roleId
            _info.RoleName = msg.rpinfo[i].roleName
            _info.Demo = msg.rpinfo[i].demo
            _info.Mark = msg.rpinfo[i].mark
            _info.OwnType = msg.rpinfo[i].owntype
            self.RpInfoList:Add(_info)
        end
    end
    self:CompareInfoList()
    if msg.rploginfo then
        for i = 1, #msg.rploginfo do
            local _info = L_LogInfo:NewWithMsg(msg.rploginfo[i])
            self.RpLogList:Add(_info)
        end
    end
    -- 刷新红包记录
    GameCenter.PushFixEvent(LogicEventDefine.EID_EVENT_UPDATE_REDPACKET_LOG)
    -- 刷新红包显示
    GameCenter.PushFixEvent(LogicEventDefine.EID_EVENT_UPDATE_RED_PACKKET)
    self:CountMineRedpackage()

    -- 刷新公会系统里面的红包界面红点
    GameCenter.GuildSystem:OnSetRedPoint()
end

--查看红包返回
function RedPacketSystem:GS2U_ResGetRedPacketInfo(msg)
    self.CheckRpID = msg.rpId
    self.CheckRpPlayerInfo:Clear()
    for i = 1, #msg.roleinfo do
        local _info = L_CheckInfo:NewWithMsg(msg.roleinfo[i])
        self.CheckRpPlayerInfo:Add(_info)
    end
    self.CheckRpPlayerInfo:Sort(function (a, b)
        return a.Rpvalue > b.Rpvalue
    end)
    if self.IsOpenPanel then
        GameCenter.PushFixEvent(LogicEventDefine.EID_EVENT_VIEW_RED_PACKET);
    else
        -- //直接显示结果
        GameCenter.MainFunctionSystem:DoFunctionCallBack(FunctionStartIdCode.RedpaketAnimation);
        GameCenter.PushFixEvent(LogicEventDefine.EID_EVENT_ANIMATOIN_PAGE_VIEW_RED_PACKET);
    end
end

--抢红包的返回
function RedPacketSystem:GS2U_ResClickRedpacket(msg)
    if msg.state == 0 or msg.state == 2 then
        if self.IsOpenPanel then
            self.CheckRpID = msg.rpId
            GameCenter.PushFixEvent(LogicEventDefine.EID_EVENT_GET_PACKET_BACK, msg.state)
        else
            GameCenter.MainFunctionSystem:DoFunctionCallBack(FunctionStartIdCode.RedpaketAnimation, msg)
        end
    else
        GameCenter.MsgPromptSystem:ShowPrompt(DataConfig.DataMessageString.Get("REDPACKAGE_HONGBAOBUCUNZAI"))
    end
    GameCenter.PushFixEvent(LogicEventDefine.EID_EVENT_DELETE_PACKAGE, msg.rpId)
end

--发红包返回
function RedPacketSystem:GS2U_ResSendRedPacket(msg)
    if msg.state == 0 then
        GameCenter.PushFixEvent(LogicEventDefine.EID_EVENT_CLOSE_PACKAGE_PACKET_PANEL)
    end
end

--通知有一个新的红包发出了，用于显示红点， 别人发的红包
function RedPacketSystem:GS2U_ResNewRedPacket(msg)
    GameCenter.Network.Send("MSG_redpacket.ReqRedpacketList", {})
    GameCenter.PushFixEvent(LogicEventDefine.EID_EVENT_NEW_PACKAGE, msg.rpId)
end

--通知你有红包可以处理了，用于显示红点， 自己充值收到的系统红包
function RedPacketSystem:GS2U_ResMineHaveRedpacket(msg)
    GameCenter.Network.Send("MSG_redpacket.ReqRedpacketList", {})
    if msg.mineSendNum > 0 then
        GameCenter.PushFixEvent(LogicEventDefine.EID_EVENT_NEW_PACKAGE, -1)
    end

    if msg.rpId ~= nil then
        for i = 1, #msg.rpId do
            GameCenter.PushFixEvent(LogicEventDefine.EID_EVENT_NEW_PACKAGE, msg.rpId[i])
        end
    end
end

--将自己充值获得的红包转发送到公会中
function RedPacketSystem:GS2U_ResSendMineRechargeRedpacket(msg)
    if msg.state == 0 then
        GameCenter.PushFixEvent(LogicEventDefine.EID_EVENT_CLOSE_PACKAGE_PACKET_PANEL)
    end
end

function RedPacketSystem:ReqGetRedPacketInfo()
    GameCenter.Network.Send("MSG_redpacket.ReqGetRedPacketInfo", {rpId = self.CheckRpID})
end

--红包列表排序function
function RedPacketSystem:CompareInfoList()
    self.RpInfoList:Sort(function (a, b)
        local leftValue = 0;
        if a.OwnType == 1 then
            leftValue = 2
        elseif a.Mark then
            leftValue = 3
        elseif a.CurNum > 0 then
            leftValue = 1
        else
            leftValue = 4
        end

        local rightValue = 0
        if b.OwnType == 1 then
            rightValue = 2
        elseif b.Mark then
            rightValue = 3
        elseif b.CurNum > 0 then
            rightValue = 1
        else
            rightValue = 4
        end
        return leftValue > rightValue
    end)
end

-- 检查当前是否还有自己的红包，如果没有，告诉主界面清除提示
function RedPacketSystem:CountMineRedpackage()
    for i = 1, #self.RpInfoList do
        if (self.RpInfoList[i].OwnType == 1) then
            return
        end
    end
    GameCenter.PushFixEvent(LogicEventDefine.EID_EVENT_DELETE_PACKAGE,-1)
end
return RedPacketSystem