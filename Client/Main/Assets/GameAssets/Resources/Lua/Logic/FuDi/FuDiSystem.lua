
------------------------------------------------
--作者： 王圣
--日期： 2019-05-10
--文件： FuDiSystem.lua
--模块： FuDiSystem
--描述： 福地系统类
------------------------------------------------
--引用
local GuildRankData = require "Logic.FuDi.FuDiGuildRankData"
local FuDiPreviewData = require "Logic.FuDi.FuDiPreviewData"
local FuDiBossShowData = require "Logic.FuDi.FuDiBossShowData"
local FuDiDuoBaoCopyInfo = require "Logic.FuDi.FuDiDuoBaoCopyInfo"
local FuDiSystem = {
    PreviewData = nil,
    BossShowData = nil,
    DuoBaoCopyInfo = nil,
    --怒气值
    Anger = 0,
    --当前点击的boss ID
    CurSelectBossId = 0,
    RankList = List:New(),
}

function FuDiSystem:BoxIsRecived(score)
    local b = false
    for i = 1,#self.PreviewData.ReceivedList do
        if self.PreviewData.ReceivedList[i] == score then
            b = true
        end
    end
    return b
end

---------------------msg----------------------
--请求打开称号排行
function FuDiSystem:ReqOpenRankPanel()
	GameCenter.Network.Send("MSG_GuildActivity.ReqOpenRankPanel")
end
--请求打开福地boss总揽
function FuDiSystem:ReqOpenAllBossPanel()
    GameCenter.Network.Send("MSG_GuildActivity.ReqOpenAllBossPanel")
end
--请求领取日常积分奖励
function FuDiSystem:ReqDayScoreReward(id)
    GameCenter.Network.Send("MSG_GuildActivity.ReqDayScoreReward",{id = id})
end
--请求打开福地boss宗派详细信息
function FuDiSystem:ReqOpenDetailBossPanel(fuDiIndex)
    GameCenter.Network.Send("MSG_GuildActivity.ReqOpenDetailBossPanel",{type = fuDiIndex})
end
--请求关注boss   type = 1 关注 = 2 取消关注
function FuDiSystem:ReqAttentionMonster(id,type)
    GameCenter.Network.Send("MSG_GuildActivity.ReqAttentionMonster",{monsterModelId = id,type = type})
end
--请求打开夺宝UI
function FuDiSystem:ReqSnatchPanel()
    GameCenter.Network.Send("MSG_GuildActivity.ReqSnatchPanel")
end
--请求夺宝副本数据
function FuDiSystem:ReqPanelReady()
    GameCenter.Network.Send("MSG_GuildActivity.ReqPanelReady")
end



--返回福地称号面板数据
function FuDiSystem:ResOpenRankPanel(result)
    if result.guildRank == nil then
        return
    end
    for i = 1,#result.guildRank do
        local guildRankInfo = GuildRankData:New(result.guildRank[i])
        self.RankList:Add(guildRankInfo)
    end
    GameCenter.PushFixEvent(LogicEventDefine.EID_EVENT_UPDATE_FUDIRANKFORM)
end

--返回福地总揽数据
function FuDiSystem:ResOpenAllBossPanel(result)
    if result == nil then
        return
    end
    if self.PreviewData == nil then
        self.PreviewData = FuDiPreviewData:New(result)
    else
        self.PreviewData:SetData(result)
    end
    GameCenter.PushFixEvent(LogicEventDefine.EID_EVENT_FUDIBOSS_ZONGLAN_UPDATE)
end

--返回福地boss宗派详细信息
function FuDiSystem:ResOpenDetailBossPanel(result)
    if result == nil then
        return
    end
    if self.BossShowData == nil then
        self.BossShowData = FuDiBossShowData:New(result)
    end
    self.BossShowData:SetData(result)
    GameCenter.PushFixEvent(LogicEventDefine.EID_EVENT_FUDIBOSS_INFO_UPDATE)
end
--
function FuDiSystem:ResUpdateMonsterResurgenceTime(result)
    if result == nil then
        return
    end
    if result.state == 1 then
        GameCenter.PushFixEvent(UIEventDefine.UIFuDiCopyInfoForm_Open,result)
    else    
        GameCenter.PushFixEvent(LogicEventDefine.EID_EVENT_FUDIBOSS_INFO_UPDATE,result)
    end
end
--返回关注怪物id
function FuDiSystem:ResAttentionMonster(result)
    if result == nil then
        return 
    end
    local bossData = self.BossShowData:GetBossById(result.attention)
    if bossData ~= nil then
        if result.type == 1 then
            bossData.IsAttention = true
        elseif result.type ==2 then
            bossData.IsAttention = false
        end
    end
end
--关注的怪物刷新了
function FuDiSystem:ResAttentionMonsterRefresh(result)
    if result == nil then
        return 
    end
    GameCenter.PushFixEvent(UIEventDefine.UIAttentionForm_Open,result.monsterModelId)
end
--同步怒气值
function FuDiSystem:ResSynAnger(result)
    if result == nil then
        return 
    end
    self.Anger = result.anger
    GameCenter.PushFixEvent(LogicEventDefine.EID_EVENT_FUDIBOSS_INFO_UPDATE)
end
--同步波数和剩余怪物数量
function FuDiSystem:ResSynMonster(result)
    if result == nil then
        return 
    end
    if self.DuoBaoCopyInfo == nil then
        self.DuoBaoCopyInfo = FuDiDuoBaoCopyInfo:New()
    end
    self.DuoBaoCopyInfo:SetData(result)
    GameCenter.PushFixEvent(LogicEventDefine.EID_EVENT_UPDATE_FUDIDUOBAO_COPYINFO)
end
--同步伤害排名
function FuDiSystem:ResSynHarmRank(result)
    if result == nil then
        return 
    end
    if result.rank ~= nil then
        self.DuoBaoCopyInfo:SetDamage(result)
    end
    GameCenter.PushFixEvent(LogicEventDefine.EID_EVENT_UPDATE_FUDIDUOBAO_COPYINFO)
end
--返回单开夺宝面板a
function FuDiSystem:ResSnatchPanel(result)
    if result == nil then
        return 
    end
    GameCenter.PushFixEvent(LogicEventDefine.EID_EVENT_UPDATE_FUDIDUOBAO,result.guildScore)
end
return FuDiSystem