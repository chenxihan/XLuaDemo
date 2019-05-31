------------------------------------------------
--作者：xihan
--日期：2019-05-28
--文件：ArenaSystem.lua
--模块：ArenaSystem
--描述：竞技场系统
------------------------------------------------
-- "Error [config without this id]"
-- "Error [repeating]"
-- "Error [conflict]"
-- "Error [server msg]"
-- "Error [parameters Invalid]"
-- "Error [server logic]"

local ArenaSystem = {}

local L_Sort = table.sort
local L_Send = GameCenter.Network.Send;

local L_Score = 0;
local L_Rank = 0;
local L_RemainCount = 0;
local L_RemainTime = 0;
local L_FightPlayers = List:New();
local L_TopPlayers = List:New();
local L_Reports = List:New();
local L_YesterdayRank = nil;
local L_IsGetAward = nil;
local L_IsLevelArenaMap = nil;

--系统初始化
function ArenaSystem:Initialize()

end

--系统卸载
function ArenaSystem:UnInitialize()

end

--配置表是否有该id
function ArenaSystem:IsContains(id)
    return not (not false);
end


--初始化UI数据
function ArenaSystem:InitUIdata()

end

--清理与UI相关的数据
function ArenaSystem:ClearUIdata()

end

--是否有红点
function ArenaSystem:IsRedPoint()
    return false;
end

--刷新小红点
function ArenaSystem:RefreshRedPoint()
    GameCenter.MainFunctionSystem:SetAlertFlag(FunctionStartIdCode.Arena, self:IsRedPoint());
end

--获取积分
function ArenaSystem:GetScore()
    return L_Score;
end
--获取排名
function ArenaSystem:GetRank()
    return L_Rank;
end
--剩余次数
function ArenaSystem:GetRemainCount()
    return L_RemainCount;
end
--剩余时间
function ArenaSystem:GetRemainTime()
    return L_RemainTime;
end
--挑战玩家
function ArenaSystem:GetFightPlayers()
    return L_FightPlayers;
end
--记录保持者
function ArenaSystem:GetTopPlayers()
    return L_TopPlayers;
end
--战斗记录
function ArenaSystem:GetReports()
    return L_Reports;
end
--昨日排名
function ArenaSystem:GetYesterdayRank()
    return L_YesterdayRank;
end
--是否获得奖励
function ArenaSystem:IsGetAward()
    return L_IsGetAward;
end
--是否离开竞技场地图
function ArenaSystem:IsLevelArenaMap()
    return L_IsLevelArenaMap;
end

--====[msg]====[msg]====[msg]====[msg]====[msg]====[msg]====[msg]====[msg]====[msg]====[msg]====[msg]====[msg]====[msg]====

--================[Req]================[Req]================[Req]================[Req]================[Req]================
--打开jjc
function ArenaSystem:ReqOpenJJC()
    L_Send("MSG_JJC.ReqOpenJJC");
end

--更换对手
function ArenaSystem:ReqChangeTarget()
    L_Send("MSG_JJC.ReqChangeTarget");
end

--挑战
function ArenaSystem:ReqChallenge(targetID)
    --uint64 targetID
    L_Send("MSG_JJC.ReqChallenge",{targetID = targetID});
end

--领奖
function ArenaSystem:ReqGetAward()
    L_Send("MSG_JJC.ReqGetAward");
end

--添加挑战次数
function ArenaSystem:ReqAddChance()
    L_Send("MSG_JJC.ReqAddChance");
end

--获取昨天排名
function ArenaSystem:ReqGetYesterdayRank()
    L_Send("MSG_JJC.ReqGetYesterdayRank");
end

--获取战报
function ArenaSystem:ReqGetReport()
    L_Send("MSG_JJC.ReqGetReport");
end

--退出jjc
function ArenaSystem:ReqJJCexit()
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
function ArenaSystem:ResOpenJJCresult(msg)
    -- required int32 rank = 1;	//排名
	-- required int32 count = 2;	//剩余次数
	-- required int32 cd = 3;		//冷却时间
	-- repeated JJCobject players = 4; //挑战对象
	-- repeated JJCobject rank123 = 5; //前三名
    -- required int32 score = 6;	//当前玩家积分
    Debug.LogTable(msg, "MSG_JJC.ResOpenJJCresult");
end
--更新挑战次数
function ArenaSystem:ResUpdateChance(msg)
    -- required int32 count = 1;	//挑战次数
	-- required int32 cd = 2;		//冷却时间
    -- required int32 rank = 3;		//排名
    Debug.LogTable(msg, "MSG_JJC.ResUpdateChance");
end
--更换挑战对象
function ArenaSystem:ResUpdatePlayers(msg)
    -- repeated JJCobject players = 1; //挑战对象列表
    -- repeated JJCobject rank123 = 2; //前三名
    Debug.LogTable(msg, "MSG_JJC.ResUpdatePlayers");
end
--返回昨日排名
function ArenaSystem:ResYesterdayRank(msg)
    -- required int32 rank = 1;	//排名
	-- required int32 state = 2;	//状态0 未领取， 1已领取
    -- required int32 time = 3;	//倒计时
    Debug.LogTable(msg, "MSG_JJC.ResYesterdayRank");
end
--返回战报数据
function ArenaSystem:ResReports(msg)
    -- repeated Report reports = 1; //战报
    Debug.LogTable(msg, "MSG_JJC.ResReports");
end
--竞技场通知
function ArenaSystem:ResJJCTargetID(msg)
    -- required uint64 targetID = 1; //挑战对象ID
    Debug.LogTable(msg, "MSG_JJC.ResJJCTargetID");
end

--结算界面
function ArenaSystem:ResJJCBattleReport(msg)
    -- required bool isSuc  = 1;	//是否胜利
    -- required int32 score   = 2;	//获得积分
    -- required int32 curRank  = 3;	//当前排名
    Debug.LogTable(msg, "MSG_JJC.ResJJCBattleReport");
end
--上线发送jjc提示信息
function ArenaSystem:ResOnlineJJCInfo(msg)
    -- required int32 r_count  = 1;	//挑战次数
    -- required bool  award  = 2;	//奖励领取情况 true 有奖励
    Debug.LogTable(msg, "MSG_JJC.ResOnlineJJCInfo");
end
--挑战开始返回
function ArenaSystem:ResStartBattleRes(msg)
    if not msg then
        Debug.LogError("Error [server msg]", "MSG_JJC.ResStartBattleRes");
        return;
    end
    Debug.LogTable(msg, "MSG_JJC.ResStartBattleRes");
end

    -- --刷新小红点
    -- self:RefreshRedPoint()
    -- --更新界面
    -- GameCenter.PushFixEvent(LogicEventDefine.EID_EVENT_UPDATE_ACHFORM);

return ArenaSystem