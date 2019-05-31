------------------------------------------------
--作者：xihan
--日期：2019-05-28
--文件：ArenaShouXiSystem.lua
--模块：ArenaShouXiSystem
--描述：首席竞技场系统
------------------------------------------------
-- "Error [config without this id]"
-- "Error [repeating]"
-- "Error [conflict]"
-- "Error [server msg]"
-- "Error [parameters Invalid]"
-- "Error [server logic]"

local ArenaShouXiSystem = {}

local L_Sort = table.sort
local L_Send = GameCenter.Network.Send;

--积分
local L_Score = nil;
--排名
local L_Rank = nil;
--剩余次数
local L_RemainCount = nil;
--剩余CD时间
local L_RemainCD = nil;
--挑战玩家
local L_FightPlayers = nil;
--记录保持者
local L_TopPlayers = nil;
--战斗记录
local L_Reports = nil;
--昨日排名
local L_YesterdayRank = nil;
--是否获得奖励
local L_IsHaveAward = nil;
--是否离开竞技场地图
local L_IsLevelArenaMap = nil;
--当前目标ID
local L_TargetID = nil;
--战斗结果
local L_BattleReport = nil;
--重置每日排名的剩余时间
local L_RemainTimeByResetRank = nil;

--系统初始化
function ArenaShouXiSystem:Initialize()
    L_Score = 0;
    L_Rank = 0;
    L_RemainCount = 0;
    L_RemainCD = 0;
end

--系统卸载
function ArenaShouXiSystem:UnInitialize()
    L_Score = 0;
    L_Rank = 0;
    L_RemainCount = 0;
    L_RemainCD = 0;
    L_FightPlayers = nil;
    L_TopPlayers = nil;
    L_Reports = nil;
    L_YesterdayRank = nil;
    L_IsHaveAward = false;
    L_IsLevelArenaMap = false;
    L_TargetID = 0;
    L_BattleReport = nil;
end

--配置表是否有该id
function ArenaShouXiSystem:IsContains(id)
    return not (not false);
end


--初始化UI数据
function ArenaShouXiSystem:InitUIdata()

end

--清理与UI相关的数据
function ArenaShouXiSystem:ClearUIdata()

end

--是否有红点
function ArenaShouXiSystem:IsRedPoint()
    return L_RemainCount > 0 or L_IsHaveAward;
end

--刷新小红点
function ArenaShouXiSystem:RefreshRedPoint()
    GameCenter.MainFunctionSystem:SetAlertFlag(FunctionStartIdCode.Arena, self:IsRedPoint());
end

--获取积分
function ArenaShouXiSystem:GetScore()
    return L_Score;
end
--获取排名
function ArenaShouXiSystem:GetRank()
    return L_Rank;
end
--剩余次数
function ArenaShouXiSystem:GetRemainCount()
    return L_RemainCount;
end
--剩余时间
function ArenaShouXiSystem:GetRemainCD()
    return L_RemainCD;
end
--挑战玩家
function ArenaShouXiSystem:GetFightPlayers()
    return L_FightPlayers;
end
--记录保持者
function ArenaShouXiSystem:GetTopPlayers()
    return L_TopPlayers;
end
--战斗记录
function ArenaShouXiSystem:GetReports()
    return L_Reports;
end
--昨日排名
function ArenaShouXiSystem:GetYesterdayRank()
    return L_YesterdayRank;
end
--是否有奖励可获得
function ArenaShouXiSystem:IsHaveAward()
    return L_IsHaveAward;
end
--是否离开竞技场地图
function ArenaShouXiSystem:IsLevelArenaMap()
    return L_IsLevelArenaMap;
end
--当前目标ID
function ArenaShouXiSystem:GetTargetID()
    return L_TargetID;
end
--====[msg]====[msg]====[msg]====[msg]====[msg]====[msg]====[msg]====[msg]====[msg]====[msg]====[msg]====[msg]====[msg]====

--================[Req]================[Req]================[Req]================[Req]================[Req]================
--打开jjc
function ArenaShouXiSystem:ReqOpenJJC()
    L_Send("MSG_JJC.ReqOpenJJC");
end

--更换对手
function ArenaShouXiSystem:ReqChangeTarget()
    L_Send("MSG_JJC.ReqChangeTarget");
end

--挑战
function ArenaShouXiSystem:ReqChallenge(targetID)
    --uint64 targetID
    L_Send("MSG_JJC.ReqChallenge",{targetID = targetID});
end

--领奖
function ArenaShouXiSystem:ReqGetAward()
    L_Send("MSG_JJC.ReqGetAward");
end

--添加挑战次数
function ArenaShouXiSystem:ReqAddChance()
    L_Send("MSG_JJC.ReqAddChance");
end

--获取昨天排名
function ArenaShouXiSystem:ReqGetYesterdayRank()
    L_Send("MSG_JJC.ReqGetYesterdayRank");
end

--获取战报
function ArenaShouXiSystem:ReqGetReport()
    L_Send("MSG_JJC.ReqGetReport");
end

--退出jjc
function ArenaShouXiSystem:ReqJJCexit()
    L_Send("MSG_JJC.ReqJJCexit");
end

--================[Res]================[Res]================[Res]================[Res]================[Res]================
-- //挑战对象
-- message JJCobject
-- {
-- 	required uint64 roleID = 1;	//目标id
-- 	required int32	rank = 2; //职业
-- 	required string	name = 3; //角色名
-- 	required int32	career = 4; //职业
-- 	required int32	level = 5; //等级
-- 	optional int32	weaponId = 6; //武器ModelID
-- 	optional int32	wingId = 7; //翅膀
-- 	required int32 grade = 8; // 转职等级
-- 	optional int32 clothesEquipId = 9;//衣服装备ID
-- 	optional int32 weaponsEquipId = 10;//武器装备Id
-- 	required int32 clothesStar = 11;//衣服部位的星级
-- 	required int32 weaponStar = 12;//武器部位的星级
-- 	required int64 fightPower = 13;//战斗力
-- 	optional int32 fashionBodyId = 14 [default = 0];//时装身体ID
-- 	optional int32 fashionWeaponId = 15 [default = 0];//时装武器ID
-- 	optional int32 fashionLayer = 16[default = 0];//时装星级
-- 	optional bool nameMark = 17;//名字是否需要翻译 false 不翻译， true需要翻译
-- }

-- message Report
-- {
-- 	required int32 time = 1;	//战报时间
-- 	required int32 type  = 2;	//战报类型
-- 	required string  name  = 3;	//战斗对象
-- 	required int32 rank   = 4;	//排名
-- 	optional bool tiaozhao = 5;//是否是主动挑战
-- 	optional bool nameMark = 6;//名字是否需要翻译 false 不翻译， true需要翻译

--打开jjc result
function ArenaShouXiSystem:ResOpenJJCresult(msg)
    -- required int32 rank = 1;	//排名
	-- required int32 count = 2;	//剩余次数
	-- required int32 cd = 3;		//冷却时间
	-- repeated JJCobject players = 4; //挑战对象
	-- repeated JJCobject rank123 = 5; //前三名
    -- required int32 score = 6;	//当前玩家积分
    Debug.LogTable(msg, "MSG_JJC.ResOpenJJCresult");
    L_Rank = msg.rank;
    L_RemainCount = msg.count;
    L_RemainCD = msg.cd;
    L_Score = msg.score;
    GameCenter.PushFixEvent(LogicEventDefine.EID_EVENT_JJC_UPDATECOUNT);

    L_FightPlayers = List:New(msg.players);
    L_TopPlayers = List:New(msg.rank123);
    -- player.Name = result.rank123[i].nameMark and GameCenter.LanguageConvertSystem.ConvertLan(result.rank123[i].name) or result.rank123[i].name;
    GameCenter.PushFixEvent(LogicEventDefine.EID_EVENT_JJC_UPDATEPLAYERS);
end
--更新挑战次数
function ArenaShouXiSystem:ResUpdateChance(msg)
    -- required int32 count = 1;	//挑战次数
	-- required int32 cd = 2;		//冷却时间
    -- required int32 rank = 3;		//排名
    Debug.LogTable(msg, "MSG_JJC.ResUpdateChance");
    L_Rank = msg.rank;
    L_RemainCount = msg.count;
    L_RemainCD = msg.cd;
    GameCenter.PushFixEvent(LogicEventDefine.EID_EVENT_JJC_UPDATECOUNT);
end
--更换挑战对象
function ArenaShouXiSystem:ResUpdatePlayers(msg)
    -- repeated JJCobject players = 1; //挑战对象列表
    -- repeated JJCobject rank123 = 2; //前三名
    Debug.LogTable(msg, "MSG_JJC.ResUpdatePlayers");
    L_FightPlayers = List:New(msg.players);
    L_TopPlayers = List:New(msg.rank123);
    GameCenter.PushFixEvent(LogicEventDefine.EID_EVENT_JJC_UPDATEPLAYERS);
end
--返回昨日排名
function ArenaShouXiSystem:ResYesterdayRank(msg)
    -- required int32 rank = 1;	//排名
	-- required int32 state = 2;	//状态0 未领取， 1已领取
    -- required int32 time = 3;	//倒计时
    Debug.LogTable(msg, "MSG_JJC.ResYesterdayRank");
    L_YesterdayRank = msg.rank;
    L_IsHaveAward = msg.state == 0;
    L_RemainTimeByResetRank = msg.time;
    GameCenter.PushFixEvent(LogicEventDefine.EID_EVENT_JJC_UPDATEYESTERDAY_RANK);
end
--返回战报数据
function ArenaShouXiSystem:ResReports(msg)
    -- repeated Report reports = 1; //战报
    Debug.LogTable(msg, "MSG_JJC.ResReports");
    L_Reports = List:New(msg.reports);
    GameCenter.PushFixEvent(LogicEventDefine.EID_EVENT_JJC_RECORDUPDATE);
end
--竞技场通知
function ArenaShouXiSystem:ResJJCTargetID(msg)
    -- required uint64 targetID = 1; //挑战对象ID
    Debug.LogTable(msg, "MSG_JJC.ResJJCTargetID");
    L_TargetID = msg.targetID;
    --TODO 这个消息没用
end

--结算界面
function ArenaShouXiSystem:ResJJCBattleReport(msg)
    -- required bool isSuc  = 1;	//是否胜利
    -- required int32 score   = 2;	//获得积分
    -- required int32 curRank  = 3;	//当前排名
    Debug.LogTable(msg, "MSG_JJC.ResJJCBattleReport");
    L_BattleReport = msg;
    L_Score = L_Score + msg.score;
    L_Rank = msg.curRank;
    --打开结算界面
    GameCenter.PushFixEvent(UIEventDefine.UIArenaResultForm_OPEN);
end
--上线发送jjc提示信息
function ArenaShouXiSystem:ResOnlineJJCInfo(msg)
    -- required int32 r_count  = 1;	//挑战次数
    -- required bool  award  = 2;	//奖励领取情况 true 有奖励
    Debug.LogTable(msg, "MSG_JJC.ResOnlineJJCInfo");
    L_RemainCount = msg.r_count;
    L_IsHaveAward = msg.award;
    --刷新小红点
    ArenaShouXiSystem:RefreshRedPoint()
end
--挑战开始返回
function ArenaShouXiSystem:ResStartBattleRes(msg)
    if not msg then
        Debug.LogError("Error [server msg]", "MSG_JJC.ResStartBattleRes");
        return;
    end
    Debug.LogTable(msg, "MSG_JJC.ResStartBattleRes");
    --关闭界面
    -- GameCenter.PushFixEvent(UIEventDefine.UIArenaForm_Close);
end

    -- --刷新小红点
    -- self:RefreshRedPoint()
    -- --更新界面
    -- GameCenter.PushFixEvent(LogicEventDefine.EID_EVENT_UPDATE_ACHFORM);

return ArenaShouXiSystem