------------------------------------------------
--作者：gzg
--日期：2019-03-25
--文件：GameCenter.lua
--模块：GameCenter
--描述：游戏逻辑的中心,保存几乎所有的逻辑信息
------------------------------------------------
--//模块引用
local CSGameCenter = CS.Funcell.Code.Center.GameCenter

--//模块定义
local GameCenter = {
    IsCoreInit = false,
    IsLogicInit = false,
}

--创建核心系统
function GameCenter:NewCoreSystem()
    --网络管理类
    self.Network = require("Network.Network")    
    --UI管理类
    self.UIFormManager = require("UI.Base.UIFormManager")
    --地图逻辑管理类
    self.MapLogicSystem = require("Logic.MapLogicEx.MapLogicExSystem")

    ---定义从CS引用来的核心系统
    self.EventManager = CSGameCenter.EventManager
    self.TextureManager = CSGameCenter.TextureManager
    self.GameSceneSystem = CSGameCenter.GameSceneSystem
    self.MapLogicSwitch = CSGameCenter.MapLogicSwitch
end

--核心系统初始化
function GameCenter:CoreInitialize()
    if self.IsCoreInit then
        return
    end
    self.Network.Init()

    self.IsCoreInit = true
end

--核心系统卸载
function GameCenter:CoreUninitialize()
    if not self.IsCoreInit then
        return
    end
    self.Network = nil
    Utils.RemoveRequiredByName("Network.Network")
    self.UIFormManager = nil
    Utils.RemoveRequiredByName("UI.Base.UIFormManager")
    self.MapLogicSystem = nil
    Utils.RemoveRequiredByName("Logic.MapLogicEx.MapLogicExSystem")

    self.IsCoreInit = false
end


--创建逻辑系统
function GameCenter:NewLogicSystem()
    
    --成长基金系统
    self.GrowthPlanSystem = require("Logic.GrowthPlan.GrowthPlanSystem")
    --提示系统
    self.MsgPromptSystem = require("Logic.MsgPrompt.MsgPromptSystem")
    self.TransferSystem = require("Logic.Transfer.TransferSystem")
    self.TransferSystemMsg = require("Logic.Transfer.TransferSystemMsg")
    self.LuaMainFunctionSystem = require("Logic.LuaMainFunction.LuaMainFunctionSystem")
    self.OfflineOnHookSystem = require("Logic.OfflineOnHook.OfflineOnHookSystem")
    self.NatureSystem = require("Logic.Nature.NatureSystem")
    self.CopyMapSystem = require("Logic.CopyMapSystem.CopyMapSystem")
    self.DailyActivitySystem = require("Logic.DailyActivity.DailyActivitySystem")
    self.LianQiForgeSystem = require("Logic.LianQiForge.LianQiForgeSystem")
    self.LianQiGemSystem = require("Logic.LianQiGem.LianQiGemSystem")
    self.RankSystem = require("Logic.Rank.RankSystem")
    self.GodBookSystem = require("Logic.GodBook.GodBookSystem")
    --识海系统
    self.PlayerShiHaiSystem = require("Logic.PlayerShiHai.PlayerShiHaiSystem")
    self.FactionSkillSystem = require("Logic.FactionSkill.FactionSkillSystem")
    --福地系统
    self.FuDiSystem = require("Logic.FuDi.FuDiSystem")
    --BOSS系统
    self.BossSystem = require("Logic.Boss.BossSystem")
    --反馈系统
    self.FeedBackSystem = require("Logic.FeedBack.FeedBackSystem");
    -- 境界系统
    self.RealmSystem = require("Logic.Realm.RealmSystem")
    --成就系统
    self.AchievementSystem = require("Logic.Achievement.AchievementSystem")
    -- 婚姻系统
    self.MarrySystem = require("Logic.Marry.MarrySystem")
    -- 红包
    self.RedPacketSystem = require("Logic.RedPacket.RedPacketSystem")
    --首席竞技场系统
    self.ArenaShouXiSystem = require("Logic.ArenaShouXi.ArenaShouXiSystem")
    --前往BOSS所在地system
    self.BossInfoTipsSystem = require("Logic.BossInfoTips.BossInfoTipsSystem")
    --法宝系统
    self.TreasureSystem = require("Logic.Treasure.TreasureSystem")
end

--逻辑系统初始化
function GameCenter:LogicInitialize()
    if self.IsLogicInit then 
        return
    end
    ---定义从CS引用来的逻辑系统
    self.RedPointSystem = CSGameCenter.RedPointSystem
    self.WelfareSystem = CSGameCenter.WelfareSystem
    self.ItemContianerSystem = CSGameCenter.ItemContianerSystem
    self.ItemQuickGetSystem = CSGameCenter.ItemQuickGetSystem
    self.EquipmentSystem = CSGameCenter.EquipmentSystem
    self.GameSetting = CSGameCenter.GameSetting;
    self.TaskManager = CSGameCenter.TaskManager;
    self.TaskBeHaviorManager = CSGameCenter.TaskBeHaviorManager;
    self.WorldMapInfoManager = CSGameCenter.WorldMapInfoManager
    self.MandateSystem = CSGameCenter.MandateSystem
    self.MsgPromptSystem = CSGameCenter.MsgPromptSystem
    self.HuSongSystem = CSGameCenter.HuSongSystem
    self.PlayerSkillSystem = CSGameCenter.PlayerSkillSystem
    self.TaskManagerMsg = CSGameCenter.TaskManagerMsg
    self.TeamSystem = CSGameCenter.TeamSystem
    self.ServerListSystem = CSGameCenter.ServerListSystem;
    self.LoginSystem = CSGameCenter.LoginSystem;
    self.PathFinderSystem = CSGameCenter.PathFinderSystem
    self.MainFunctionSystem = CSGameCenter.MainFunctionSystem
    self.LoadingSystem = CSGameCenter.LoadingSystem
    self.GuideSystem = CSGameCenter.GuideSystem
    self.WorldLevelSystem = CSGameCenter.WorldLevelSystem
    self.PeopleSoulSystem = CSGameCenter.PeopleSoulSystem
    self.RechargeSystem = CSGameCenter.RechargeSystem
    self.ItemTipsMgr = CSGameCenter.ItemTipsMgr
    self.GuildSystem = CSGameCenter.GuildSystem
    self.MainCustomBtnSystem = CSGameCenter.MainCustomBtnSystem
    self.FriendSystem = CSGameCenter.FriendSystem
    self.MailSystem = CSGameCenter.MailSystem
    self.SDKSystem = CSGameCenter.SDKSystem;
    self.HeartSystem = CSGameCenter.HeartSystem
    self.NumberInputSystem = CSGameCenter.NumberInputSystem
    self.PathSearchSystem = CSGameCenter.PathSearchSystem
    self.GuildRepertorySystem = CSGameCenter.GuildRepertorySystem
    self.TimerEventSystem = CSGameCenter.TimerEventSystem
    self.LanguageConvertSystem = CSGameCenter.LanguageConvertSystem
    self.VariableSystem = CS.Funcell.Code.Logic.VariableSystem;

    --成长基金系统
    self.GrowthPlanSystem:Initialize()
    -- --加载所有配置
    --造化系统
    self.NatureSystem:Initialize()
    -- DataConfig.LoadAll()
    self.CopyMapSystem:Initialize()
    -- 日常活动系统
    self.DailyActivitySystem:Initialize()
    --炼器锻造系统
    self.LianQiForgeSystem:Initialize()
    --炼器宝石系统
    self.LianQiGemSystem:Initialize()
    --排行榜
    self.RankSystem:Initialize()
    -- 天书系统
    self.GodBookSystem:Initialize()
    -- 宗派技能系统
    self.FactionSkillSystem:Initialize()
    --反馈系统
    self.FeedBackSystem:Initialize();
    --境界系统
    self.RealmSystem:Initialize()
    --成就系统
    self.AchievementSystem:Initialize()

    self.IsLogicInit = true
    --BossSystem
    self.BossSystem:Initialize()
    --婚姻系统
    self.MarrySystem:Initialize()
    self.RedPacketSystem:Initialize()
    --首席竞技场系统
    self.ArenaShouXiSystem:Initialize()
    --法宝系统
    self.TreasureSystem:Initialize()
end

--逻辑系统卸载
function GameCenter:LogicUninitialize()
    if not self.IsLogicInit then
        return
    end
    --消息提示系统
    self.MsgPromptSystem = nil
    Utils.RemoveRequiredByName("Logic.MsgPrompt.MsgPromptSystem")
    --成长基金系统
    self.GrowthPlanSystem = nil
    Utils.RemoveRequiredByName("Logic.GrowthPlan.GrowthPlanSystem")
    --造化系统 
    self.NatureSystem:UnInitialize()
    self.NatureSystem = nil
    Utils.RemoveRequiredByName("Logic.Nature.NatureSystem")
    --副本系统
    self.CopyMapSystem:UnInitialize()
    self.CopyMapSystem = nil
    Utils.RemoveRequiredByName("Logic.CopyMapSystem.CopyMapSystem")
    -- 日常活动系统
    self.DailyActivitySystem:UnInitialize()
    self.DailyActivitySystem = nil
    Utils.RemoveRequiredByName("Logic.DailyActivity.DailyActivitySystem")
    --离线挂机系统
    self.OfflineOnHookSystem = nil
    Utils.RemoveRequiredByName("Logic.OfflineOnHook.OfflineOnHookSystem")
    --炼器锻造系统
    self.LianQiForgeSystem:UnInitialize()
    self.LianQiForgeSystem = nil
    Utils.RemoveRequiredByName("Logic.LianQiForge.LianQiForgeSystem")
    --炼器宝石系统
    self.LianQiGemSystem:UnInitialize()
    self.LianQiGemSystem = nil
    Utils.RemoveRequiredByName("Logic.LianQiGem.LianQiGemSystem")
    -- 天书系统
    self.GodBookSystem:UnInitialize()
    self.GodBookSystem = nil
    Utils.RemoveRequiredByName("Logic.GodBook.GodBookSystem")
    --识海系统
    self.PlayerShiHaiSystem = nil
    Utils.RemoveRequiredByName("Logic.PlayerShiHai.PlayerShiHaiSystem")
    --宗派技能系统
    self.FactionSkillSystem:UnInitialize()
    self.FactionSkillSystem = nil
    Utils.RemoveRequiredByName("Logic.FactionSkill.FactionSkillSystem")

     --反馈系统
    self.FeedBackSystem:UnInitialize();
    self.FeedBackSystem = nil;
    Utils.RemoveRequiredByName("Logic.FeedBack.FeedBackSystem");

    -- 境界系统
    self.RealmSystem:UnInitialize()
    self.RealmSystem = nil;
    Utils.RemoveRequiredByName("Logic.Realm.RealmSystem")

    --成就系统
    self.AchievementSystem:UnInitialize()
    self.RealmSystem = nil;
    Utils.RemoveRequiredByName("Logic.Achievement.AchievementSystem")
    
    --BossSystem
    self.BossSystem:UnInitialize()
    self.BossSystem = nil
    Utils.RemoveRequiredByName("Logic.Boss.BossSystem")

    --婚姻系统
    self.MarrySystem:UnInitialize()
    self.MarrySystem = nil
    Utils.RemoveRequiredByName("Logic.Marry.MarrySystem")

    --红包系统
    self.RedPacketSystem:UnInitialize()
    self.RedPacketSystem = nil
    Utils.RemoveRequiredByName("Logic.RedPacket.RedPacketSystem")

    --首席竞技场系统
    self.ArenaShouXiSystem:UnInitialize()
    self.ArenaShouXiSystem = nil
    Utils.RemoveRequiredByName("Logic.Arena.ArenaShouXiSystem")

    --前往BOSS所在地system
    self.BossInfoTipsSystem = nil
    Utils.RemoveRequiredByName("Logic.BossInfoTips.BossInfoTipsSystem")

    --法宝系统
    self.TreasureSystem:UnInitialize()
    self.TreasureSystem = nil
    Utils.RemoveRequiredByName("Logic.Treasure.TreasureSystem")

    self.IsLogicInit = false
    --移除所有Lua端定义的事件
    LuaEventManager.ClearAllLuaEvents();
end

--更新心跳
function GameCenter:Update(deltaTime)
    --Debug.Log("============[Update]================",deltaTime)
    if self.IsCoreInit then
        self.UIFormManager:Update(deltaTime)
    end
    if self.IsLogicInit then
        -- GameCenter.MsgPromptSystem:Update()
        self.MapLogicSystem:Update(deltaTime)
        self.BossSystem:Update(deltaTime)
        self.RealmSystem:Update(deltaTime)
    end
end

function GameCenter:LateUpdate(deltaTime)
    --Debug.Log("============[LateUpdate]================",deltaTime)
    -- if self.IsCoreInit then

    -- end
    -- if self.IsLogicInit then

    -- end
end

function GameCenter:FixedUpdate(fixedDeltaTime)
    --Debug.Log("============[fixedDeltaTime]================",fixedDeltaTime)
    -- if self.IsCoreInit then

    -- end
    -- if self.IsLogicInit then

    -- end
end

function GameCenter.PushFixEvent(eventID, obj, sender)
    LuaEventManager.PushFixEvent(eventID, obj, sender);
end

function GameCenter.RegFixEventHandle(eventID, func , caller)
    LuaEventManager.RegFixEventHandle(eventID, func, caller);
end

function GameCenter.UnRegFixEventHandle(eventID, func,caller)
    LuaEventManager.UnRegFixEventHandle(eventID,  func, caller);
end

return GameCenter