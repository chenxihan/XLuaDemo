------------------------------------------------
--作者： 杨全福
--日期： 2019-04-15
--文件： NormalMapLogic.lua
--模块： NormalMapLogic
--描述： 默认的地图逻辑
------------------------------------------------

local NormalMapLogic = {
    Parent = nil
}

function NormalMapLogic:OnEnterScene(parent)
    self.Parent = parent

    --设置开关
    GameCenter.MapLogicSwitch.CanRide = true
    GameCenter.MapLogicSwitch.CanFly = true
    GameCenter.MapLogicSwitch.CanRollDoge = true
    GameCenter.MapLogicSwitch.CanMandate = true
    GameCenter.MapLogicSwitch.CanOpenTeam = true
    GameCenter.MapLogicSwitch.ShowNewFunction = true
    GameCenter.MapLogicSwitch.UseAutoStrikeBack = true
    GameCenter.MapLogicSwitch.CanTeleport = true
    GameCenter.MapLogicSwitch.IsCopyMap = false
    GameCenter.MapLogicSwitch.IsPlaneCopyMap = false
    GameCenter.MapLogicSwitch.HoldFighting = false
end

function NormalMapLogic:OnLeaveScene()
end

function NormalMapLogic:OnMsgHandle(msg)
end

function NormalMapLogic:GetMainUIState()
    return {
        [MainFormSubPanel.PlayerHead] = true,         --主角头像
        [MainFormSubPanel.PetHead] = false,           --宠物头像
        [MainFormSubPanel.TargetHead] = true,         --目标头像
        [MainFormSubPanel.TopMenu] = true,            --顶部菜单
        [MainFormSubPanel.MiniMap] = true,            --小地图
        [MainFormSubPanel.Realm] = true,              --境界
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

function NormalMapLogic:GetMainLeftUIState()
    return {
        [MainLeftSubPanel.Task] = true,        --任务分页
        [MainLeftSubPanel.Team] = true,        --队伍分页
        [MainLeftSubPanel.Copy] = false,       --副本分页
        [MainLeftSubPanel.Other] = false,      --其他分页
    }
end

return NormalMapLogic