------------------------------------------------
--作者： xihan
--日期： 2019-05-28
--文件： ArenaShouXiLogic.lua
--模块： ArenaShouXiLogic
--描述： 首席竞技场副本
------------------------------------------------

local ArenaShouXiLogic = {
    --父逻辑系统
    Parent = nil,
    --是否已经展示了进入提示
    IsShowEnterTips = false,
    --剩余时间
    RemainTime = 0.0,
}

function ArenaShouXiLogic:OnEnterScene(parent)
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

    --关掉小地图功能
    GameCenter.MainFunctionSystem:SetFunctionVisible(FunctionStartIdCode.AreaMap, false);
    --关掉菜单
    GameCenter.PushFixEvent(LogicEventDefine.EID_EVENT_CLOSE_MAINMENU);
    --关闭宗派福地Form
    -- GameCenter.PushFixEvent(UIEventDefine.UIFuDiForm_Close)

    self.IsShowEnterTips = false;
end

function ArenaShouXiLogic:OnLeaveScene()
    --打开小地图功能
    GameCenter.MainFunctionSystem:SetFunctionVisible(FunctionStartIdCode.AreaMap, true);
    --关闭副本UI
    GameCenter.PushFixEvent(UIEventDefine.UIFuDiCopyInfoForm_Close)
end

--更新
function ArenaShouXiLogic:Update(dt)
    if self.RemainTime > 0.0 then
        self.RemainTime = self.RemainTime - dt;
    end
end

--处理协议
function ArenaShouXiLogic:OnMsgHandle(msg)
    if msg.MsgID == GameCenter.Network.GetMsgID("MSG_copyMap.ResCopymapNeedTime") then
        --副本时间
        self.RemainTime = msg.EndTime;
    end
end

function ArenaShouXiLogic:GetMainUIState()
    return {
        [MainFormSubPanel.PlayerHead] = false,         --主角头像
        [MainFormSubPanel.PetHead] = false,           --宠物头像
        [MainFormSubPanel.TargetHead] = true,         --目标头像
        [MainFormSubPanel.TopMenu] = false,            --顶部菜单
        [MainFormSubPanel.MiniMap] = false,            --小地图
        [MainFormSubPanel.Realm] = false,               --境界
        [MainFormSubPanel.TaskAndTeam] = false,        --任务和组队
        [MainFormSubPanel.Joystick] = true,           --摇杆
        [MainFormSubPanel.Exp] = true,                --经验
        [MainFormSubPanel.MiniChat] = false,           --小聊天框
        [MainFormSubPanel.Skill] = true,              --技能
        [MainFormSubPanel.FlyControl] = false,         --飞行控制
        [MainFormSubPanel.SelectPkMode] = false,      --选择PK模式
        [MainFormSubPanel.FunctionFly] = false,        --新功能开启飞行界面
        [MainFormSubPanel.FastPrompt] = false,         --快速提醒界面
        [MainFormSubPanel.FastBts] = false,            --快速操作按钮界面
        [MainFormSubPanel.Ping] = true,               --ping
        [MainFormSubPanel.Combo] = true,              --连击界面
        [MainFormSubPanel.SkillWarning] = false,      --技能释放警示
        [MainFormSubPanel.CustomBtn] = false,         --自定义按钮
        [MainFormSubPanel.DynamicActivity] = false,    --动态活动按钮
        [MainFormSubPanel.SitDown] = false,            --打坐
    }
end

function ArenaShouXiLogic:GetMainLeftUIState()
    return {
        [MainLeftSubPanel.Task] = false,        --任务分页
        [MainLeftSubPanel.Team] = false,        --队伍分页
        [MainLeftSubPanel.Copy] = false,       --副本分页
        [MainLeftSubPanel.Other] = false,      --其他分页
    }
end

return ArenaShouXiLogic;