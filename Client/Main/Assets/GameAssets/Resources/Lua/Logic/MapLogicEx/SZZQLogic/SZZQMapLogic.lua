------------------------------------------------
--作者： 杨全福
--日期： 2019-05-07
--文件： SZZQMapLogic.lua
--模块： SZZQMapLogic
--描述： 圣战之启副本逻辑
------------------------------------------------

local SZZQMapLogic = {
    --父逻辑系统
    Parent = nil,
    --剩余时间
    RemainTime = 0.0,
    --副本ID
    CurCopyMapDataID = 0,
}

function SZZQMapLogic:OnEnterScene(parent)
    self.Parent = parent

    --设置开关
    GameCenter.MapLogicSwitch.CanRide = false;
    GameCenter.MapLogicSwitch.CanFly = false;
    GameCenter.MapLogicSwitch.CanRollDoge = true;
    GameCenter.MapLogicSwitch.CanMandate = true;
    GameCenter.MapLogicSwitch.CanOpenTeam = false;
    GameCenter.MapLogicSwitch.ShowNewFunction = false;
    GameCenter.MapLogicSwitch.UseAutoStrikeBack = true;
    GameCenter.MapLogicSwitch.CanTeleport = false;
    GameCenter.MapLogicSwitch.IsCopyMap = true;
    GameCenter.MapLogicSwitch.IsPlaneCopyMap = false;
    GameCenter.MapLogicSwitch.HoldFighting = false;
    GameCenter.MapLogicSwitch.CampIcons = nil;

    --关掉小地图功能
    GameCenter.MainFunctionSystem:SetFunctionVisible(FunctionStartIdCode.AreaMap, false);
    --关掉菜单
    GameCenter.PushFixEvent(LogicEventDefine.EID_EVENT_CLOSE_MAINMENU);
    --关掉进入界面
    GameCenter.PushFixEvent(UIEventDefine.UISZZQEnterForm_CLOSE);

    --设置特殊的阵营Icon，用于展示到头顶
    local _compCfg = DataConfig.DataGlobal[1314];
    if _compCfg ~= nil then
        local _compIconTable = {}
        local _compIcons = Utils.SplitStrByTableS(_compCfg.Params);
        for i = 1, #_compIcons do
            _compIconTable[_compIcons[i][1]] = _compIcons[i][2];
        end
        GameCenter.MapLogicSwitch:SetCampIcons(_compIconTable);
    end

    --进入就开始挂机
    GameCenter.MandateSystem:Start();
end

function SZZQMapLogic:OnLeaveScene()
    --打开小地图功能
    GameCenter.MainFunctionSystem:SetFunctionVisible(FunctionStartIdCode.AreaMap, true);
    --关掉副本主界面
    GameCenter.PushFixEvent(UIEventDefine.UISZZQCopyMainForm_CLOSE);
    --阵营icon设置为空
    GameCenter.MapLogicSwitch:SetCampIcons(nil);
end

--更新
function SZZQMapLogic:Update(dt)
    if self.RemainTime > 0.0 then
        self.RemainTime = self.RemainTime - dt;
    end
end

--处理协议
function SZZQMapLogic:OnMsgHandle(msg)
    if msg.MsgID == GameCenter.Network.GetMsgID("MSG_copyMap.ResCopymapNeedTime") then
        --副本时间
        self.RemainTime = msg.EndTime;
        self.CurCopyMapDataID = msg.modelId;
    elseif msg.MsgID == GameCenter.Network.GetMsgID("MSG_copyMap.ResTeamCampWar") then
        --副本信息
        GameCenter.PushFixEvent(UIEventDefine.UISZZQCopyMainForm_OPEN, msg);
    elseif msg.MsgID == GameCenter.Network.GetMsgID("MSG_copyMap.ResTeamCampWarRank") then
        --排名信息
        GameCenter.PushFixEvent(UIEventDefine.UISZZQRankForm_OPEN, msg);
    elseif msg.MsgID == GameCenter.Network.GetMsgID("MSG_copyMap.ResTeamCampWarEndInfo") then
        --主角准备退出
        GameCenter.MapLogicSwitch:DoPlayerExitPrepare();
        --结算协议
        GameCenter.PushFixEvent(UIEventDefine.UISZZQResultForm_OPEN, msg);
    end
end

function SZZQMapLogic:GetMainUIState()
    return {
        [MainFormSubPanel.PlayerHead] = true,         --主角头像
        [MainFormSubPanel.PetHead] = false,           --宠物头像
        [MainFormSubPanel.TargetHead] = true,         --目标头像
        [MainFormSubPanel.TopMenu] = true,            --顶部菜单
        [MainFormSubPanel.MiniMap] = true,            --小地图
        [MainFormSubPanel.Realm] = false,             --境界
        [MainFormSubPanel.TaskAndTeam] = false,       --任务和组队
        [MainFormSubPanel.Joystick] = true,           --摇杆
        [MainFormSubPanel.Exp] = true,                --经验
        [MainFormSubPanel.MiniChat] = true,           --小聊天框
        [MainFormSubPanel.Skill] = true,              --技能
        [MainFormSubPanel.FlyControl] = true,         --飞行控制
        [MainFormSubPanel.SelectPkMode] = true,       --选择PK模式
        [MainFormSubPanel.FunctionFly] = true,        --新功能开启飞行界面
        [MainFormSubPanel.FastPrompt] = true,         --快速提醒界面
        [MainFormSubPanel.FastBts] = true,            --快速操作按钮界面
        [MainFormSubPanel.Ping] = true,               --ping
        [MainFormSubPanel.Combo] = true,              --连击界面
        [MainFormSubPanel.SkillWarning] = false,      --技能释放警示
        [MainFormSubPanel.CustomBtn] = false,         --自定义按钮
        [MainFormSubPanel.DynamicActivity] = true,    --动态活动按钮
        [MainFormSubPanel.SitDown] = false,           --打坐
    }
end

function SZZQMapLogic:GetMainLeftUIState()
    return {
        [MainLeftSubPanel.Task] = false,        --任务分页
        [MainLeftSubPanel.Team] = false,        --队伍分页
        [MainLeftSubPanel.Copy] = false,       --副本分页
    }
end

return SZZQMapLogic;