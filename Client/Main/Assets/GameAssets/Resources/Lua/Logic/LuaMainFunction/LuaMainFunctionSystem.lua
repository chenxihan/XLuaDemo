local LuaMainFunctionSystem = {}

--打开成长基金界面
local function GrowthPlanCallBack(param)
	GameCenter.PushFixEvent(UIEventDefine.UIRechargeActivityForm_OPEN, RechargeFormDefine.RechargeGrowthPlan)
end
--打开首充界面
local function RechargeFirstTipsCallBack(param)
	GameCenter.PushFixEvent(UIEventDefine.UIGrowthPlanForm_OPEN)
end

--打开造化面板
local function OpenNaturePanel(param)
	GameCenter.PushFixEvent(UIEventDefine.UINatureForm_OPEN,NatureEnum.Wing)
end

--打开造化翅膀升级面板
local function OpenNatureWingPanel(param)
	GameCenter.PushFixEvent(UIEventDefine.UINatureForm_OPEN,{NatureEnum.Wing,NatureSubEnum.BaseUpLevel})
end


--打开造化翅膀吃果子面板
local function OpenNatureWingDrugPanel(param)
	GameCenter.PushFixEvent(UIEventDefine.UINatureForm_OPEN,{NatureEnum.Wing,NatureSubEnum.Drug})
end

--打开造化翅膀化形
local function OpenNatureWingFashaionPanel(param)
	GameCenter.PushFixEvent(UIEventDefine.UINatureFashionForm_OPEN,NatureEnum.Wing)
end

--打开造化翅膀模型显示界面
local function OpenNatureWingModelShowPanel(param)
	GameCenter.PushFixEvent(UIEventDefine.UINatureModelShowForm_OPEN,NatureEnum.Wing)
end

--打开造化法器
local function OpenNatureTalismanPanel(param)
	GameCenter.PushFixEvent(UIEventDefine.UINatureForm_OPEN,{NatureEnum.Talisman,NatureSubEnum.BaseUpLevel})
end

--打开造化法器吃果子
local function OpenNatureTalismanDrugPanel(param)
	GameCenter.PushFixEvent(UIEventDefine.UINatureForm_OPEN,{NatureEnum.Talisman,NatureSubEnum.Drug})
end

--打开造化法器化形
local function OpenNatureTalismanFashionPanel(param)
	GameCenter.PushFixEvent(UIEventDefine.UINatureFashionForm_OPEN,NatureEnum.Talisman)
end

--打开造化法器模型显示界面
local function OpenNatureTalismanModelShowPanel(param)
	GameCenter.PushFixEvent(UIEventDefine.UINatureModelShowForm_OPEN,NatureEnum.Talisman)
end

--打开造化阵法
local function OpenNatureMagicPanel(param)
	GameCenter.PushFixEvent(UIEventDefine.UINatureForm_OPEN,{NatureEnum.Magic,NatureSubEnum.BaseUpLevel})
end

--打开造化阵法吃果子
local function OpenNatureMagicDrugPanel(param)
	GameCenter.PushFixEvent(UIEventDefine.UINatureForm_OPEN,{NatureEnum.Magic,NatureSubEnum.Drug})
end

--打开造化阵法化形
local function OpenNatureMagicFashionPanel(param)
	GameCenter.PushFixEvent(UIEventDefine.UINatureFashionForm_OPEN,NatureEnum.Magic)
end

--打开造化法器模型显示界面
local function OpenNatureMagicModelShowPanel(param)
	GameCenter.PushFixEvent(UIEventDefine.UINatureModelShowForm_OPEN,NatureEnum.Magic)
end

--打开造化神兵
local function OpenNatureWeaponLevelPanel(param)
	GameCenter.PushFixEvent(UIEventDefine.UINatureWeaponForm_OPEN,{NatureEnum.Weapon,NatureSubEnum.BaseUpLevel})
end

--打开造化神兵突破
local function OpenNatureWeaponBreakPanel(param)
	GameCenter.PushFixEvent(UIEventDefine.UINatureWeaponForm_OPEN,{NatureEnum.Weapon,NatureSubEnum.Drug})
end

--打开造化神兵化形
local function OpenNatureWeaponFashionPanel(param)
	GameCenter.PushFixEvent(UIEventDefine.UINatureFashionForm_OPEN,NatureEnum.Weapon)
end


--打开造化法器模型显示界面
local function OpenNatureWeaponModelShowPanel(param)
	GameCenter.PushFixEvent(UIEventDefine.UINatureModelShowForm_OPEN,NatureEnum.Weapon)
end

--打开副本面板
local function OpenCopyMapPanel(param)
	GameCenter.PushFixEvent(UIEventDefine.UICopyMapForm_OPEN, {UICopyMainPanelEnum.SinglePanel, UISingleCopyPanelEnum.TowerPanel})
end

--打开副本面板单人分页
local function OpenCopyMapSinglePanel(param)
	GameCenter.PushFixEvent(UIEventDefine.UICopyMapForm_OPEN, {UICopyMainPanelEnum.SinglePanel, UISingleCopyPanelEnum.TowerPanel})
end

--打开副本面板爬塔副本分页
local function OpenCopyMapTowerPanel(param)
	GameCenter.PushFixEvent(UIEventDefine.UICopyMapForm_OPEN, {UICopyMainPanelEnum.SinglePanel, UISingleCopyPanelEnum.TowerPanel})
end

--打开副本面板星级副本分页
local function OpenCopyMapStarPanel(param)
	GameCenter.PushFixEvent(UIEventDefine.UICopyMapForm_OPEN, {UICopyMainPanelEnum.SinglePanel, UISingleCopyPanelEnum.StarPanel})
end

--打开副本面板队伍分页
local function OpenCopyMapTeamPanel(param)
	GameCenter.PushFixEvent(UIEventDefine.UICopyMapForm_OPEN, {UICopyMainPanelEnum.SinglePanel, 0})
end


--炼器主面板
local function LianQiCallBack(param)
	GameCenter.PushFixEvent(UIEventDefine.UILianQiForm_OPEN, {LianQiSubEnum.Forge, LianQiForgeSubEnum.Strength})
end

--炼器 一级分页：锻造
local function LianQiForgeCallBack(param)
	GameCenter.PushFixEvent(UIEventDefine.UILianQiForm_OPEN, {LianQiSubEnum.Forge, LianQiForgeSubEnum.Strength})
end

--炼器 一级分页：锻造 下的 二级分页：装备强化
local function LianQiForgeStrengthCallBack(param)
	GameCenter.PushFixEvent(UIEventDefine.UILianQiForm_OPEN, {LianQiSubEnum.Forge, LianQiForgeSubEnum.Strength})
end

--炼器 一级分页：宝石
local function LianQiGemCallBack(param)
	GameCenter.PushFixEvent(UIEventDefine.UILianQiForm_OPEN, {LianQiSubEnum.Gem, LianQiGemSubEnum.Begin})
end

--炼器 一级分页：宝石 下的 二级分页：宝石镶嵌
local function LianQiGemInlayCallBack(param)
	GameCenter.PushFixEvent(UIEventDefine.UILianQiForm_OPEN, {LianQiSubEnum.Gem, LianQiGemSubEnum.Inlay})
end

--炼器 一级分页：宝石 下的 二级分页：宝石精炼
local function LianQiGemRefineCallBack(param)
	GameCenter.PushFixEvent(UIEventDefine.UILianQiForm_OPEN, {LianQiSubEnum.Gem, LianQiGemSubEnum.Refine})
end

--炼器 一级分页：宝石 下的 二级分页：仙玉镶嵌
local function LianQiGemJadeCallBack(param)
	GameCenter.PushFixEvent(UIEventDefine.UILianQiForm_OPEN, {LianQiSubEnum.Gem, LianQiGemSubEnum.Jade})
end

--坐骑
local function OpenMountForm(param)
	GameCenter.PushFixEvent(UIEventDefine.UIMountForm_OPEN, {MountEnum.BaseGrowUp, NatureSubEnum.MountEatEquip})
end

--坐骑升级
local function OpenMountLevelForm(param)
	GameCenter.PushFixEvent(UIEventDefine.UIMountForm_OPEN, {MountEnum.BaseGrowUp, NatureSubEnum.BaseUpLevel})
end

--坐骑吃果子
local function OpenMountDrugForm(param)
	GameCenter.PushFixEvent(UIEventDefine.UIMountForm_OPEN, {MountEnum.BaseGrowUp, NatureSubEnum.BaseUpLevel})
end

--坐骑化形
local function OpenMountFashionForm(param)
	GameCenter.PushFixEvent(UIEventDefine.UINatureFashionForm_OPEN, NatureEnum.Mount)
end

--坐骑模型显示
local function OpenMountModelShowForm(param)
	GameCenter.PushFixEvent(UIEventDefine.UINatureModelShowForm_OPEN, NatureEnum.Mount)
end

--世界BOSS界面
local function OpenWorldBossForm(param)
	GameCenter.PushFixEvent(UIEventDefine.UIBossForm_OPEN, BossEnum.WorldBoss)
end
--个人BOSS界面
local function OpenMySelfBossForm(param)
	GameCenter.PushFixEvent(UIEventDefine.UIBossForm_OPEN, BossEnum.MySelfBoss)
end
--勇者之颠
local function OpenYZZDEnterForm(param)
	GameCenter.PushFixEvent(UIEventDefine.UIYZZDEnterForm_OPEN)
end
--三界战场
local function OpenSZZQEnterForm(param)
	GameCenter.PushFixEvent(UIEventDefine.UISZZQEnterForm_OPEN)
end


--所有打开界面的注册
local functionStartkMap = {
	[FunctionStartIdCode.GrowthPlan] = GrowthPlanCallBack,
	[FunctionStartIdCode.RechargeFirstTips] = RechargeFirstTipsCallBack,

	[FunctionStartIdCode.Nature] = OpenNaturePanel,
	[FunctionStartIdCode.NatureWingLevel] = OpenNatureWingPanel,
	[FunctionStartIdCode.NatureWingDrug] = OpenNatureWingDrugPanel,
	[FunctionStartIdCode.NatureWingFashion] = OpenNatureWingFashaionPanel,
	[FunctionStartIdCode.NatureWingModelShow] = OpenNatureWingModelShowPanel,
	[FunctionStartIdCode.NatureTalismanLevel] = OpenNatureTalismanPanel,
	[FunctionStartIdCode.NatureTalismanDrug] = OpenNatureTalismanDrugPanel,
	[FunctionStartIdCode.NatureTalismanFashion] = OpenNatureTalismanFashionPanel,
	[FunctionStartIdCode.NatureTalismanModelShow] = OpenNatureTalismanModelShowPanel,
	[FunctionStartIdCode.NatureMagicLevel] = OpenNatureMagicPanel,
	[FunctionStartIdCode.NatureMagicDrug] = OpenNatureMagicDrugPanel,
	[FunctionStartIdCode.NatureMagicFashion] = OpenNatureMagicFashionPanel,
	[FunctionStartIdCode.NatureMagicModelShow] = OpenNatureMagicModelShowPanel,
	[FunctionStartIdCode.NatureWeaponLevel] = OpenNatureWeaponLevelPanel,
	[FunctionStartIdCode.NatureWeaponBreak] = OpenNatureWeaponBreakPanel,
	[FunctionStartIdCode.NatureWeaponFashion] = OpenNatureWeaponFashionPanel,
	[FunctionStartIdCode.NatureWeaponModelShow] = OpenNatureWeaponModelShowPanel,	
	[FunctionStartIdCode.Mount] = OpenMountForm,
	[FunctionStartIdCode.MountBase] = OpenMountForm,
	[FunctionStartIdCode.MountBaseAttr] = OpenMountForm,
	[FunctionStartIdCode.MountLevel] = OpenMountLevelForm,
	[FunctionStartIdCode.MountDrug] = OpenMountDrugForm,
	[FunctionStartIdCode.MountFashion] = OpenMountFashionForm,
	[FunctionStartIdCode.MountModelShow] = OpenMountModelShowForm,
	[FunctionStartIdCode.MountEatEquip] = OpenMountForm,

	[FunctionStartIdCode.CopyMap] = OpenCopyMapPanel,
	[FunctionStartIdCode.SingleCopyMap] = OpenCopyMapSinglePanel,
	[FunctionStartIdCode.TowerCopyMap] = OpenCopyMapTowerPanel,
	[FunctionStartIdCode.StarCopyMap] = OpenCopyMapStarPanel,
	[FunctionStartIdCode.TeamCopyMap] = OpenCopyMapTeamPanel,

	[FunctionStartIdCode.LianQi] = LianQiCallBack,
	[FunctionStartIdCode.LianQiForge] = LianQiForgeCallBack,
	[FunctionStartIdCode.LianQiForgeStrength] = LianQiForgeStrengthCallBack,
	[FunctionStartIdCode.LianQiGem] = LianQiGemCallBack,
	[FunctionStartIdCode.LianQiGemInlay] = LianQiGemInlayCallBack,
	[FunctionStartIdCode.LianQiGemRefine] = LianQiGemRefineCallBack,
	[FunctionStartIdCode.LianQiGemJade] = LianQiGemJadeCallBack,
	[FunctionStartIdCode.Boss] = OpenWorldBossForm,
	[FunctionStartIdCode.MySelfBoss] = OpenMySelfBossForm,
	[FunctionStartIdCode.WorldBoss] = OpenWorldBossForm,

	[FunctionStartIdCode.ArenaYZZD] = OpenYZZDEnterForm,
	[FunctionStartIdCode.ArenaSZZQ] = OpenSZZQEnterForm,
}

--通过功能ID的枚举码,来打开相应功能
function LuaMainFunctionSystem:DoFunctionCallBack(code, param)
	local _callBack = functionStartkMap[code]
	if _callBack then
		_callBack(param)
	else
		Debug.LogError(string.format("LuaMainFunctionSystem:DoFunctionCallBack(%s) not implement!", code))
	end
end

--功能开启时的回调
function LuaMainFunctionSystem:OnFunctionOpen(code, isNew)
	if code == FunctionStartIdCode.GrowthPlan then

	elseif code == FunctionStartIdCode.NatureWingLevel or code == FunctionStartIdCode.NatureWingDrug 
	or code == FunctionStartIdCode.NatureWingFashion then
		GameCenter.NatureSystem:ReqNatureInfo(NatureEnum.Wing)
	elseif code == FunctionStartIdCode.NatureTalismanLevel or code == FunctionStartIdCode.NatureTalismanDrug 
	or code == FunctionStartIdCode.NatureTalismanFashion then
		GameCenter.NatureSystem:ReqNatureInfo(NatureEnum.Talisman)
	elseif code == FunctionStartIdCode.NatureMagicLevel or code == FunctionStartIdCode.NatureMagicDrug 
	or code == FunctionStartIdCode.NatureMagicFashion then
		GameCenter.NatureSystem:ReqNatureInfo(NatureEnum.Magic)
	elseif code == FunctionStartIdCode.NatureWeaponLevel or code == FunctionStartIdCode.NatureWeaponBreak 
	or code == FunctionStartIdCode.NatureWeaponFashion then
		GameCenter.NatureSystem:ReqNatureInfo(NatureEnum.Weapon)
	elseif code == FunctionStartIdCode.MountLevel or code == FunctionStartIdCode.MountDrug 
	or code == FunctionStartIdCode.MountBaseAttr or code == FunctionStartIdCode.MountFashion then
		GameCenter.NatureSystem:ReqNatureInfo(NatureEnum.Mount)
	elseif code == FunctionStartIdCode.CopyMap then
		--发送获取挑战副本的消息
		GameCenter.CopyMapSystem:ReqOpenChallengePanel();
	elseif code == FunctionStartIdCode.PlayerJingJie then
		GameCenter.PlayerShiHaiSystem:ReqShiHaiData();
	end
end

return LuaMainFunctionSystem