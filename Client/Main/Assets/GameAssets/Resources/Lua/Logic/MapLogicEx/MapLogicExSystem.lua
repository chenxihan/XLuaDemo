------------------------------------------------
--作者： 杨全福
--日期： 2019-04-15
--文件： MapLogicExSystem.lua
--模块： MapLogicExSystem
--描述： 地图逻辑类
------------------------------------------------

local PlayerPrefs = CS.UnityEngine.PlayerPrefs

--构造函数
local MapLogicExSystem = {
    MapCfg = nil,                        --当前所在场景配置
    ActiveLogicMoudle = nil,             --当前的副本逻辑文件名
    ActiveLogic = nil,                   --当前激活的逻辑
    CacheMsg = List:New(),               --缓存的消息
    MainUIState = nil,                   --主界面分页状态
    LeftUIState = nil,                   --左侧分页状态
    CopyFormUIState = nil,               --副本分页状态
}

--进入场景处理
function MapLogicExSystem:OnEnterScene(mapId)
    Debug.Log("MapLogicExSystem:OnEnterScene" .. mapId)
    --查找地图配置
    self.MapCfg = DataConfig.DataMapsetting[mapId]
    --创建逻辑脚本
    self:NewMapLogic()

    self.MainUIState = nil
    self.LeftUIState = nil
    self.CopyFormUIState = nil

    if self.ActiveLogic ~= nil then
        if self.ActiveLogic.OnEnterScene ~= nil then
            --进入场景处理
            self.ActiveLogic:OnEnterScene(self)
        end
        if self.ActiveLogic.GetMainUIState ~= nil then
            self.MainUIState = self.ActiveLogic:GetMainUIState()
        end
        if self.MainUIState == nil then
            self.MainUIState = self:GetMainUIState()
        end

        if self.ActiveLogic.GetMainLeftUIState ~= nil then
            self.LeftUIState = self.ActiveLogic:GetMainLeftUIState()
        end
        if self.LeftUIState == nil then
            self.LeftUIState = self:GetMainLeftUIState()
        end

        --设置主界面开关状态
        GameCenter.MapLogicSwitch:SetMainUIStates(self.MainUIState)
        GameCenter.MapLogicSwitch:SetMainLeftUIStates(self.LeftUIState)

        if self.CopyFormUIState ~= nil then
            GameCenter.MapLogicSwitch:SetCopyFormUIState(self.CopyFormUIState)
        end

        --处理缓存的消息
        if self.ActiveLogic.OnMsgHandle ~= nil then
            for i = 1, self.CacheMsg:Count() do
                self.ActiveLogic:OnMsgHandle(self.CacheMsg[i])
            end
        end
        self.CacheMsg:Clear()

        self:PlayEnterCinematic()
    end
end

--离开场景处理
function MapLogicExSystem:OnLeaveScene()
    Debug.Log("MapLogicExSystem:OnLeaveScene" .. self.MapCfg.MapId)

    if GameCenter.MapLogicSwitch.IsCopyMap then
        --copy
        GameCenter.PushFixEvent(LogicEventDefine.EID_EVENT_CLOSE_ALL_FORM, 
            {"UIHUDForm", "UIMainForm", "UIGuideForm", "UIReliveForm", "UIMsgPromptForm", "UIMsgMarqueeForm", "UILoadingForm", "UICinematicForm", "UIGetEquipTIps", "UIPowerSaveForm" });
    else
        --normal
        GameCenter.PushFixEvent(LogicEventDefine.EID_EVENT_CLOSE_ALL_FORM, 
            {"UIReliveForm", "UIHUDForm", "UIMainForm", "UIGuideForm", "UICopyTeamAskForm", "UICopyTeamPrepareForm", "UICrossMatchingForm", "UILoadingForm", "UIMsgPromptForm", "UIMsgMarqueeForm", "UICinematicForm", "UICopyMapResultExForm", "UIGetEquipTIps", "UIPowerSaveForm" });
    end

    if self.ActiveLogic ~= nil and self.ActiveLogic.OnLeaveScene ~= nil then
        --离开场景处理
        self.ActiveLogic:OnLeaveScene()
    end
    self.ActiveLogic = nil

    if self.ActiveLogicMoudle ~= nil then
        --卸载脚本
        Utils.RemoveRequiredByName(self.ActiveLogicMoudle)
        self.ActiveLogicMoudle = nil
    end

    self.MapCfg = nil
    self.CacheMsg:Clear()
    self.MainUIState = nil
    self.LeftUIState = nil
    self.CopyFormUIState = nil
    --清空立即前往BOSS所在地system的配置表ID，以免其他系统误用
    GameCenter.BossInfoTipsSystem.CustomCfgID = 0
    GameCenter.MapLogicSwitch:Reset()
end

--更新
function MapLogicExSystem:Update(dt)
    if self.ActiveLogic ~= nil and self.ActiveLogic.Update ~= nil then
        self.ActiveLogic:Update(dt);
    end
end

--创建地图逻辑处理类
function MapLogicExSystem:NewMapLogic()
    if self.MapCfg.MapLogicType == MapLogicTypeDefine.WanYaoTa then
        self.ActiveLogicMoudle = "Logic.MapLogicEx.WanYaoTa.WanYaoTaLogic"
    elseif self.MapCfg.MapLogicType == MapLogicTypeDefine.DaNengYiFu then
        self.ActiveLogicMoudle = "Logic.MapLogicEx.DaNengYiFu.DaNengYiFuLogic"
    elseif self.MapCfg.MapLogicType == MapLogicTypeDefine.XianJieZhiMen then
        self.ActiveLogicMoudle = "Logic.MapLogicEx.XianJieZhiMen.XianJieZhiMenLogic"
    elseif self.MapCfg.MapLogicType == MapLogicTypeDefine.PlaneCopy then
        self.ActiveLogicMoudle = "Logic.MapLogicEx.PlaneCopy.PlaneCopyLogic"
    elseif self.MapCfg.MapLogicType == MapLogicTypeDefine.YZZDCopy then
        self.ActiveLogicMoudle = "Logic.MapLogicEx.YZZDCopy.YZZDMapLogic"
    elseif self.MapCfg.MapLogicType == MapLogicTypeDefine.SZZQCopy then
        self.ActiveLogicMoudle = "Logic.MapLogicEx.SZZQLogic.SZZQMapLogic"
    elseif self.MapCfg.MapLogicType == MapLogicTypeDefine.FuDiCopy then
        self.ActiveLogicMoudle = "Logic.MapLogicEx.FuDiCopy.FuDiLogic"
    elseif self.MapCfg.MapLogicType == MapLogicTypeDefine.FuDiDuoBaoCopy then
        self.ActiveLogicMoudle = "Logic.MapLogicEx.FuDiCopy.FuDiDuoBaoLogic"
    elseif self.MapCfg.MapLogicType == MapLogicTypeDefine.MySelfBossCopy then
        self.ActiveLogicMoudle = "Logic.MapLogicEx.MySelfBoss.MySelfBossLogic"
    elseif self.MapCfg.MapLogicType == MapLogicTypeDefine.WorldBossCopy then
        self.ActiveLogicMoudle = "Logic.MapLogicEx.NewWorldBoss.NewWorldBossLogic"
    elseif self.MapCfg.MapLogicType == MapLogicTypeDefine.ArenaShouXi then
        self.ActiveLogicMoudle = "Logic.MapLogicEx.ArenaShouXi.ArenaShouXiLogic"
    else
        self.ActiveLogicMoudle = "Logic.MapLogicEx.Normal.NormalMapLogic"
    end

    if self.ActiveLogicMoudle ~= nil then
        --注册副本逻辑脚本
        self.ActiveLogic = require(self.ActiveLogicMoudle)
    end
end

--处理协议
function MapLogicExSystem:OnMsgHandle(msg)
    if self.ActiveLogic == nil then
        --还未进入场景，缓存消息
        self.CacheMsg:Add(msg)
    else
        --已经进入场景，直接处理消息
        if self.ActiveLogic.OnMsgHandle ~= nil then
            self.ActiveLogic:OnMsgHandle(msg)
        end
    end
end

--播放剧情
function MapLogicExSystem:PlayEnterCinematic()
    local _playCinematic = false
    --先要判断是否播放过了
    local key = "" .. self.MapCfg.MapId .. "_" .. GameCenter.GameSceneSystem:GetLocalPlayerID()
    if PlayerPrefs.GetInt(key, 0) == 0 then
        --_playCinematic = GameCenter.CinematicSystem.CheckSceneToCinematic(Scene.MapId, (b) => { OnSceneCinematicFinish(); });
        PlayerPrefs.SetInt(key, 1)
    end
    if _playCinematic == false then
        GameCenter.PushFixEvent(UIEventDefine.UILOADINGFORM_CLOSE);
        self:OnSceneCinematicFinish()
    end
end

--进入场景剧情播放完成
function MapLogicExSystem:OnSceneCinematicFinish()
    --引导检测
    Debug.Log("MapLogicExSystem:OnSceneCinematicFinish")
    GameCenter.GuideSystem:Check(GuideTriggerType.EnterMap, self.MapCfg.MapId)
    --if (_mapCfg.PkState == 0)
    --{
        --不能PK
     --   GameCenter.ChatSystem.AddSystemChat(Funcell.Cfg.Data.DeclareMessageString.Get(Funcell.Cfg.Data.DeclareMessageString.C_ENTERMAPTIPS_SAFE));
    --}
    --else
    --{
        --可以PK
     --   GameCenter.ChatSystem.AddSystemChat(Funcell.Cfg.Data.DeclareMessageString.Get(Funcell.Cfg.Data.DeclareMessageString.C_ENTERMAPTIPS_WEIXIAN));
    --}
    GameCenter.PlayerSkillSystem:OnEnterScene()
    GameCenter.MainFunctionSystem:OnEnterScene()

    --GameCenter.PushFixEvent(LogicEventDefine.EID_EVENT_UPDATE_RECORDER_STEP, new object[] { Funcell.Update.Recorder.StepType.EnterMainScene });            
end

--发送离开地图消息
--askText为询问退出的内容，不传则默认
function MapLogicExSystem:SendLeaveMapMsg(needAsk, askText)
    if needAsk then
        askText = askText or DataConfig.DataMessageString.Get("C_COPY_EXIT_ASK");
        GameCenter.MsgPromptSystem:ShowMsgBox(askText, function(code)
                if code == MsgBoxResultCode.Button2 then
                    GameCenter.Network.Send("MSG_copyMap.ReqCopyMapOut", {})
                end
            end);
    else
        GameCenter.Network.Send("MSG_copyMap.ReqCopyMapOut", {})
    end
end

function MapLogicExSystem:GetMainUIState()
    return {
        [MainFormSubPanel.PlayerHead] = true,         --主角头像
        [MainFormSubPanel.PetHead] = false,           --宠物头像
        [MainFormSubPanel.TargetHead] = true,         --目标头像
        [MainFormSubPanel.TopMenu] = true,            --顶部菜单
        [MainFormSubPanel.MiniMap] = true,            --小地图
        [MainFormSubPanel.Realm] = false,     --境界
        [MainFormSubPanel.TaskAndTeam] = true,        --任务和组队
        [MainFormSubPanel.Joystick] = true,           --摇杆
        [MainFormSubPanel.Exp] = true,                --经验
        [MainFormSubPanel.MiniChat] = true,           --小聊天框
        [MainFormSubPanel.Skill] = true,              --技能
        [MainFormSubPanel.FlyControl] = true,         --飞行控制
        [MainFormSubPanel.SelectPkMode] = true,       --选择PK模式
        [MainFormSubPanel.FunctionFly] = true,        --新功能开启飞行界面
        [MainFormSubPanel.FastPrompt] = true,         --快速提醒界面
        [MainFormSubPanel.FastBts] = false,            --快速操作按钮界面
        [MainFormSubPanel.Ping] = true,               --ping
        [MainFormSubPanel.Combo] = true,              --连击界面
        [MainFormSubPanel.SkillWarning] = false,      --技能释放警示
        [MainFormSubPanel.CustomBtn] = true,          --自定义按钮
        [MainFormSubPanel.DynamicActivity] = true,    --动态活动按钮
        [MainFormSubPanel.SitDown] = true,            --打坐
    }
end

function MapLogicExSystem:GetMainLeftUIState()
    return {
        [MainLeftSubPanel.Task] = true,        --任务分页
        [MainLeftSubPanel.Team] = true,        --队伍分页
        [MainLeftSubPanel.Copy] = false,       --副本分页
        [MainLeftSubPanel.Other] = false,      --其他分页
    }
end

return MapLogicExSystem