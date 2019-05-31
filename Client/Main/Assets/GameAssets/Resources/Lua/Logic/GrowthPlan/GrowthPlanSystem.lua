------------------------------------------------
--作者： xihan
--日期： 2019-04-26
--文件： GrowthPlanSystem.lua
--模块： GrowthPlanSystem
--描述： 成长基金系统
------------------------------------------------

local GrowthPlanData = {}
--模块定义
function GrowthPlanData.New(cfg)
	local _M = {
		Cfg = cfg,
		IsAward = false,
		Order = - 1,
		Condition = 0,
	}
	return _M
end

local PeopleWelfareData = {}

function PeopleWelfareData.New()
	local _M = {
		ModelId = 0,
		State = 0,
	}
	return _M
end

--模块定义
local GrowthPlanSystem = {
	--是否购买成长基金 bool
	IsBuy = false,
	--购买总人数 int
	BuyNum = 0,
	--全民福利剩余时间 float
	RemainTime = 0,
	--List<GrowthPlanData>
	DataList = {},
	--List<PeopleWelfareData>
	PeopleWelfareList = {},
}

 --float
local SyncTime = 0
local Refrence = 0

--初始化
function GrowthPlanSystem:Initialize()
	if self.DataList ~= nil then
		self.DataList = {}
	end

	for _, v in pairs(DataConfig.DataGrowthFund) do
		table.insert(self.DataList, GrowthPlanData.New(v))
	end
	Refrence = 0
end

--msg-----------------------------------------------
--请求激活成长基金
function GrowthPlanSystem:ReqActiveGrowthFind()
	GameCenter.Network.Send("MSG_Welfare.ReqActiveGrowthFind", {})
end

--领取成长基金
function GrowthPlanSystem:ReqReceiveGrowthFind(lv)
	GameCenter.Network.Send("MSG_Welfare.ReqReceiveGrowthFind", {level = lv})
end

--打开UI
function GrowthPlanSystem:GS2U_ResGrowthFind(result)
	if result == nil then
		return
	end
	GameCenter.RedPointSystem:RemoveFuncCondition(FunctionStartIdCode.GrowthPlan, 100)
	self.IsBuy = result.haveActive
	self.BuyNum = result.haveParchaseNum
	self.RemainTime = result.remainTime
	SyncTime = CS.UnityEngine.Time.realtimeSinceStartup
	self.PeopleWelfareList = {}
	local isShowPwReard = false
	if result.universalRewardState and next(result.universalRewardState) then
		for i = 1, #result.universalRewardState do
			local data = PeopleWelfareData.New()
			data.ModelId = result.universalRewardState[i].modelId
			data.State = result.universalRewardState[i].state
			if data.State == 1 then
				isShowPwReard = true
			end
			table.insert(self.PeopleWelfareList, data)
		end
	end
	if not isShowPwReard then
		GameCenter.RedPointSystem:RemoveFuncCondition(FunctionStartIdCode.GrowthPlan, 200)
	end
	if self.IsBuy then
		if GameCenter.RedPointSystem:OneConditionsIsReach(FunctionStartIdCode.GrowthPlan, 100) then
			GameCenter.RedPointSystem:RemoveFuncCondition(FunctionStartIdCode.GrowthPlan, 100)
		end
		if result.haveReceiveList and next(result.haveReceiveList) then
			for i = 1, #result.haveReceiveList do
				for m = 1, #self.DataList do
					if result.haveReceiveList[i] == self.DataList[m].Cfg.Level then
						self.DataList[m].IsAward = true
					end
				end
			end
		end
		for i = 1, #self.DataList do
			if not self.DataList[i].IsAward and GameCenter.GameSceneSystem:GetLocalPlayerLevel() >= self.DataList[i].Cfg.Level then
				GameCenter.RedPointSystem:AddFuncCondition(FunctionStartIdCode.GrowthPlan, self.DataList[i].Cfg.Level,
				 CS.Funcell.Code.Logic.RedPointLevelCondition(self.DataList[i].Cfg.Level))
			end
		end
	else
		if Refrence == 0 then
			GameCenter.RedPointSystem:AddFuncCondition(FunctionStartIdCode.GrowthPlan, 100, CS.Funcell.Code.Logic.RedPointCustomCondition(true))
		end
	end
	GameCenter.PushFixEvent(LogicEventDefine.EID_EVENT_REFRESH_GROWTHPLAN_UI, self.IsBuy)
	Refrence = Refrence + 1
end

--请求激活成长基金结果返回
function GrowthPlanSystem:GS2U_ResActiveGrowthResult(result)
	if result == nil then
		return
	end
	if result.success then
		self.IsBuy = true
		GameCenter.RedPointSystem:RemoveFuncCondition(FunctionStartIdCode.GrowthPlan, 100)
		for i = 1, #self.DataList do
			if not self.DataList[i].IsAward and GameCenter.GameSceneSystem:GetLocalPlayerLevel() >= self.DataList[i].Cfg.Level then
				GameCenter.RedPointSystem:AddFuncCondition(FunctionStartIdCode.GrowthPlan, self.DataList[i].Cfg.Level,
				 CS.Funcell.Code.Logic.RedPointCustomCondition(true))
			end
		end

		--激活成功
		GameCenter.PushFixEvent(LogicEventDefine.EID_EVENT_REFRESH_GROWTHPLAN_UI, result.success)
	end
end

--请求领取成长基金结果返回
function GrowthPlanSystem:GS2U_ResGetGrowthRewardResult(result)
	if result == nil then
		return
	end
	if result.success then
		--领取成功
		for i = 1, #self.DataList do
			if result.level == self.DataList[i].Cfg.Level then
				self.DataList[i].IsAward = true
				GameCenter.RedPointSystem:RemoveFuncCondition(FunctionStartIdCode.GrowthPlan, self.DataList[i].Cfg.Level)
			end
		end
		GameCenter.PushFixEvent(LogicEventDefine.EID_EVENT_REFRESH_GROWTHPLAN_UI)
	end
end

function GrowthPlanSystem:SortWelfareItem()
	table.sort(self.DataList, function(a, b)
		if a.IsAward == b.IsAward then
			return a.Cfg.Level < b.Cfg.Level
		else
			return b.IsAward
		end
	end)
end

return GrowthPlanSystem