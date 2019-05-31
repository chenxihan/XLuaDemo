
------------------------------------------------
--作者： 王圣
--日期： 2019-04-22
--文件： RankSystem.lua
--模块： RankSystem
--描述： 排行榜系统类
------------------------------------------------
--引用
local RankData = require "Logic.Rank.RankData"
local RankPlayerInfo = require "Logic.Rank.RankPlayerInfo"
local RankCompareData = require "Logic.Rank.ItemData.RankCompareData"
local RankSystem = {
    CurFunctionId = -1,
    CurSelectRankIndex = -1,
    --今日剩余崇拜次数
    TodayRemainPraiseNum = 0,
    CurRankList = nil,
    Data = nil,
    CurRankData = nil,
    CurImageInfo = nil,
    --对比数据data
    CompareData = nil,
    IsLocalServer = false,
}

--初始化排行榜Cfg
function RankSystem:Initialize()
    self.Data = RankData:New()
    for k,v in pairs(DataConfig.DataRankBase) do
        self.Data:ParseCfg(v)
    end
end

--获取传入子菜单对应的排行数据
function RankSystem:GetItemByChildMenuId(childMenuId)
    return self.Data:GetItemList(childMenuId)
end

function RankSystem:GetRankDataByPlayerId(playerId)
    for i = 1,#self.CurRankList do
        if self.CurRankList[i].RoleId == playerId then
            return self.CurRankList[i]
        end
    end
    return nil
end

-------------------req消息（Msg）相关------------------
--请求type对应的排行榜数据
function RankSystem:ReqRankInfo(type)
	GameCenter.Network.Send("MSG_RankList.ReqRankInfo", {rankKind = type})
end

--请求玩家外观数据
function RankSystem:ReqRankPlayerImageInfo(palyerId)
    GameCenter.Network.Send("MSG_RankList.ReqRankPlayerImageInfo", {rankPlayerId = palyerId})
end

--请求崇拜玩家
function RankSystem:ReqWorship(playerId)
    GameCenter.Network.Send("MSG_RankList.ReqWorship", {worshipPlayerId = playerId})
end

--请求属性对比
function RankSystem:ReqCompareAttr(playerId)
    GameCenter.Network.Send("MSG_RankList.ReqCompareAttr", {comparePlayerId = playerId})
end

------------------res消息（Msg）-------------------
function RankSystem:GS2U_ResRankInfo(result)
    self.TodayRemainPraiseNum = result.todayRemainWorshipNum
    self.Data:AddItemInfo(result.rankKind, result.rankInfoList)
    GameCenter.PushFixEvent(LogicEventDefine.EID_EVENT_RANK_REFRESH)
end

function RankSystem:GS2U_ResRankPlayerImageInfo(result)
    if self.CurImageInfo == nil then
        self.CurImageInfo = RankPlayerInfo:New()
    end
    self.CurImageInfo:Parase(result.imageInfo)
    GameCenter.PushFixEvent(LogicEventDefine.EID_EVENT_RANK_UPDATE_MODEL, self.CurImageInfo)
end

function RankSystem:GS2U_ResWorship(result)
    if result.worshipResult ==0 then
        --崇拜失败
    elseif result.worshipResult == 1 then
        self.TodayRemainPraiseNum  = result.todayRemainWorshipNum
        self.CurImageInfo.BePraiseNum = self.CurImageInfo.BePraiseNum + 1
        GameCenter.PushFixEvent(LogicEventDefine.EID_EVENT_RANK_SHOWSHENG)
    end
end

function RankSystem:GS2U_ResRankRedPointTip(result)
end

--返回对比数据
function RankSystem:GS2U_ResRankCompareData(result)
    if result == nil then
        return
    end
    if self.CompareData == nil then
        self.CompareData = RankCompareData:New()
    end
    self.CompareData:SetData(result)
    GameCenter.PushFixEvent(LogicEventDefine.EID_EVENT_RANK_SHOWCOMPARE)
end

return RankSystem