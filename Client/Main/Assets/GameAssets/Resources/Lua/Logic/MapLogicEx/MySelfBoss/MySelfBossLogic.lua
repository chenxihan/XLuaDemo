------------------------------------------------
--作者： 薛超
--日期： 2019-05-09
--文件： MySelfBossLogic.lua
--模块： MySelfBossLogic
------------------------------------------------

local MySelfBossLogic = {
    --父逻辑系统
    Parent = nil,
    Msg = nil, --服务器返回消息
}

function MySelfBossLogic:OnEnterScene(parent)
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
    GameCenter.MapLogicSwitch.EventOpen = UIEventDefine.UIMySelfBossCopyForm_OPEN
    GameCenter.MapLogicSwitch.EventClose = UIEventDefine.UIMySelfBossCopyForm_CLOSE
    GameCenter.MapLogicSwitch.OtherName =  DataConfig.DataMessageString.Get("MYSELFBOSS_COPY_TITTLE")
    GameCenter.MapLogicSwitch.OtherSprName = "tongyong"

    GameCenter.PushFixEvent(LogicEventDefine.EID_EVENT_CLOSE_MAINMENU)
    --打开道具界面
    GameCenter.PushFixEvent(UIEventDefine.UIMySelfBossCopyItemForm_OPEN)
end

function MySelfBossLogic:OnLeaveScene()
    self.Msg = nil
    GameCenter.PushFixEvent(UIEventDefine.UIMySelfBossCopyItemForm_CLOSE)
end

--处理协议
function MySelfBossLogic:OnMsgHandle(msg)
    if msg.MsgID == GameCenter.Network.GetMsgID("MSG_Boss.ResMySelfBossCopyInfo") then
        self.Msg = msg
        GameCenter.PushFixEvent(LogicEventDefine.BOSS_EVENT_MYSELF_COPYINFO)
    elseif msg.MsgID == GameCenter.Network.GetMsgID("MSG_Boss.ResMySelfBossStage") then
        for i=1,#self.Msg.info do
            if self.Msg.info[i].monsterid == msg.info.monsterid then
                self.Msg.info[i] = msg.info
                break
            end
        end
        GameCenter.PushFixEvent(LogicEventDefine.BOSS_EVENT_MYSELF_BOSSSTAGE,msg.info)
    elseif msg.MsgID == GameCenter.Network.GetMsgID("MSG_Boss.ResMySelfBossItemInfo") then
        self.Msg.iteminfo = msg.info
        GameCenter.PushFixEvent(LogicEventDefine.BOSS_EVENT_MYSELF_COPYITEM,msg.info)
    end
end

function MySelfBossLogic:GetMainUIState()
    return {
        [MainFormSubPanel.PlayerHead] = true,         --主角头像
        [MainFormSubPanel.PetHead] = false,           --宠物头像
        [MainFormSubPanel.TargetHead] = true,         --目标头像
        [MainFormSubPanel.TopMenu] = false,            --顶部菜单
        [MainFormSubPanel.MiniMap] = true,            --小地图
        [MainFormSubPanel.Realm] = false,               --境界
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
        [MainFormSubPanel.SitDown] = false,            --打坐
    }
end

function MySelfBossLogic:GetMainLeftUIState()
    return {
        [MainLeftSubPanel.Task] = false,        --任务分页
        [MainLeftSubPanel.Team] = true,        --队伍分页
        [MainLeftSubPanel.Copy] = false,       --副本分页
        [MainLeftSubPanel.Other] = true,      --其他分页
    }
end

return MySelfBossLogic