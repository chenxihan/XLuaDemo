------------------------------------------------
--作者： 杨全福
--日期： 2019-04-15
--文件： PlaneCopyLogic.lua
--模块： PlaneCopyLogic
--描述： 位面副本逻辑
------------------------------------------------

local PlaneCopyLogic = {
    Parent = nil
}

function PlaneCopyLogic:OnEnterScene(parent)
    self.Parent = parent

    --设置开关
    GameCenter.MapLogicSwitch.CanRide = false
    GameCenter.MapLogicSwitch.CanFly = false
    GameCenter.MapLogicSwitch.CanRollDoge = true
    GameCenter.MapLogicSwitch.CanMandate = true
    GameCenter.MapLogicSwitch.CanOpenTeam = false
    GameCenter.MapLogicSwitch.ShowNewFunction = false
    GameCenter.MapLogicSwitch.UseAutoStrikeBack = true
    GameCenter.MapLogicSwitch.CanTeleport = false
    GameCenter.MapLogicSwitch.IsCopyMap = true
    GameCenter.MapLogicSwitch.IsPlaneCopyMap = true
    GameCenter.MapLogicSwitch.HoldFighting = true

    --关掉菜单
    GameCenter.PushFixEvent(LogicEventDefine.EID_EVENT_CLOSE_MAINMENU)
    --打开副本主界面
    GameCenter.PushFixEvent(UIEventDefine.UIPlaneCopyMainForm_OPEN, self.Parent.MapCfg.MapId);
end

function PlaneCopyLogic:OnLeaveScene()
    GameCenter.PushFixEvent(UIEventDefine.UIPlaneCopyMainForm_CLOSE);
end

function PlaneCopyLogic:OnMsgHandle(msg)
end

function PlaneCopyLogic:GetMainUIState()
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
        [MainFormSubPanel.SelectPkMode] = false,      --选择PK模式
        [MainFormSubPanel.FunctionFly] = true,        --新功能开启飞行界面
        [MainFormSubPanel.FastPrompt] = true,         --快速提醒界面
        [MainFormSubPanel.FastBts] = false,            --快速操作按钮界面
        [MainFormSubPanel.Ping] = true,               --ping
        [MainFormSubPanel.Combo] = true,              --连击界面
        [MainFormSubPanel.SkillWarning] = false,      --技能释放警示
        [MainFormSubPanel.CustomBtn] = false,         --自定义按钮
        [MainFormSubPanel.DynamicActivity] = true,    --动态活动按钮
        [MainFormSubPanel.SitDown] = true,            --打坐
    }
end

function PlaneCopyLogic:GetMainLeftUIState()
    return {
        [MainLeftSubPanel.Task] = true,        --任务分页
        [MainLeftSubPanel.Team] = true,        --队伍分页
        [MainLeftSubPanel.Copy] = false,       --副本分页
        [MainLeftSubPanel.Other] = false,      --其他分页
    }
end

return PlaneCopyLogic