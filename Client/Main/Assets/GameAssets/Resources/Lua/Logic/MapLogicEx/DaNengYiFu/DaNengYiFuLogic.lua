------------------------------------------------
--作者： 杨全福
--日期： 2019-05-21
--文件： DaNengYiFuLogic.lua
--模块： DaNengYiFuLogic
--描述： 大能遗府副本逻辑
------------------------------------------------

local DaNengYiFuLogic = {
    Parent = nil,
    RemainTime = 0.0,
    CurCopyMapDataID = 0,
}

function DaNengYiFuLogic:OnEnterScene(parent)
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
    GameCenter.MapLogicSwitch.IsPlaneCopyMap = false
    GameCenter.MapLogicSwitch.HoldFighting = true

    --关掉菜单
    GameCenter.PushFixEvent(LogicEventDefine.EID_EVENT_CLOSE_MAINMENU)
    --关掉副本界面
    GameCenter.PushFixEvent(UIEventDefine.UICopyMapForm_CLOSE);
end

function DaNengYiFuLogic:OnLeaveScene()
    GameCenter.PushFixEvent(UIEventDefine.UIDNYFCopyMainForm_CLOSE);
end

--更新
function DaNengYiFuLogic:Update(dt)
    if self.RemainTime > 0.0 then
        self.RemainTime = self.RemainTime - dt;
    end
end

function DaNengYiFuLogic:OnMsgHandle(msg)
    if msg.MsgID == GameCenter.Network.GetMsgID("MSG_copyMap.ResStartCopyInfo") then
        --副本时间
        self.RemainTime = msg.remainTime;
        self.CurCopyMapDataID = msg.copyId;
        --打开副本主界面
        GameCenter.PushFixEvent(UIEventDefine.UIDNYFCopyMainForm_OPEN, msg);
    elseif msg.MsgID == GameCenter.Network.GetMsgID("MSG_copyMap.ResStartCopyResult") then
        --主角准备退出
        GameCenter.MapLogicSwitch:DoPlayerExitPrepare();
        --结算协议
        GameCenter.PushFixEvent(UIEventDefine.UIDNYFResultForm_OPEN, msg);
    end
end

function DaNengYiFuLogic:GetMainUIState()
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
        [MainFormSubPanel.SelectPkMode] = false,      --选择PK模式
        [MainFormSubPanel.FunctionFly] = true,        --新功能开启飞行界面
        [MainFormSubPanel.FastPrompt] = true,         --快速提醒界面
        [MainFormSubPanel.FastBts] = false,           --快速操作按钮界面
        [MainFormSubPanel.Ping] = true,               --ping
        [MainFormSubPanel.Combo] = true,              --连击界面
        [MainFormSubPanel.SkillWarning] = false,      --技能释放警示
        [MainFormSubPanel.CustomBtn] = false,         --自定义按钮
        [MainFormSubPanel.DynamicActivity] = true,    --动态活动按钮
        [MainFormSubPanel.SitDown] = true,            --打坐
    }
end

function DaNengYiFuLogic:GetMainLeftUIState()
    return {
        [MainLeftSubPanel.Task] = false,        --任务分页
        [MainLeftSubPanel.Team] = false,        --队伍分页
        [MainLeftSubPanel.Copy] = false,       --副本分页
        [MainLeftSubPanel.Other] = false,      --其他分页
    }
end

return DaNengYiFuLogic;