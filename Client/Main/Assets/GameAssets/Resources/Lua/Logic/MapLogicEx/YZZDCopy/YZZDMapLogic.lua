------------------------------------------------
--作者： 杨全福
--日期： 2019-05-06
--文件： YZZDMapLogic.lua
--模块： YZZDMapLogic
--描述： 勇者之颠副本逻辑
------------------------------------------------

local YZZDMapLogic = {
    --父逻辑系统
    Parent = nil,
    --是否已经展示了进入提示
    IsShowEnterTips = false,
    --剩余时间
    RemainTime = 0.0,
}

function YZZDMapLogic:OnEnterScene(parent)
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
    --关掉进入的界面
    GameCenter.PushFixEvent(UIEventDefine.UIYZZDEnterForm_CLOSE);

    self.IsShowEnterTips = false;

      --进入就开始挂机
      GameCenter.MandateSystem:Start();
end

function YZZDMapLogic:OnLeaveScene()
    --打开小地图功能
    GameCenter.MainFunctionSystem:SetFunctionVisible(FunctionStartIdCode.AreaMap, true);
    --关掉副本主界面
    GameCenter.PushFixEvent(UIEventDefine.UIYZZDCopyMainForm_CLOSE);
end

--更新
function YZZDMapLogic:Update(dt)
    if self.RemainTime > 0.0 then
        self.RemainTime = self.RemainTime - dt;
    end
end

--处理协议
function YZZDMapLogic:OnMsgHandle(msg)
    if msg.MsgID == GameCenter.Network.GetMsgID("MSG_copyMap.ResCopymapNeedTime") then
        --副本时间
        self.RemainTime = msg.EndTime;
    elseif msg.MsgID == GameCenter.Network.GetMsgID("MSG_zone.ResBravePeakRecord") then
        --打开副本主界面,并且刷新界面
        GameCenter.PushFixEvent(UIEventDefine.UIYZZDCopyMainForm_OPEN, msg);
        --副本信息
        if self.IsShowEnterTips == false then
            --展示进入提示
            GameCenter.PushFixEvent(LogicEventDefine.EID_EVENT_SHOWSKILLWARNING_EFFECT, {DataConfig.DataMessageString.Get("C_ENTERYZZDLEVEL_TIPS", msg.floor), 1.0, 3.0});
            self.IsShowEnterTips = true
        end
    elseif msg.MsgID == GameCenter.Network.GetMsgID("MSG_zone.ResBravePeakSuccessOneFloorNotice") then
        --主角准备退出
        GameCenter.MapLogicSwitch:DoPlayerExitPrepare();
        --通层协议
        GameCenter.PushFixEvent(UIEventDefine.UIYZZDResultForm_OPEN, msg);
    elseif msg.MsgID == GameCenter.Network.GetMsgID("MSG_zone.ResBravePeakResultPanl") then
        --主角准备退出
        GameCenter.MapLogicSwitch:DoPlayerExitPrepare();
        --结算协议
        GameCenter.PushFixEvent(UIEventDefine.UIYZZDEndForm_OPEN, msg);
    end
end

function YZZDMapLogic:GetMainUIState()
    return {
        [MainFormSubPanel.PlayerHead] = true,         --主角头像
        [MainFormSubPanel.PetHead] = false,           --宠物头像
        [MainFormSubPanel.TargetHead] = true,         --目标头像
        [MainFormSubPanel.TopMenu] = true,            --顶部菜单
        [MainFormSubPanel.MiniMap] = true,            --小地图
        [MainFormSubPanel.Realm] = false,     --境界
        [MainFormSubPanel.TaskAndTeam] = false,        --任务和组队
        [MainFormSubPanel.Joystick] = true,           --摇杆
        [MainFormSubPanel.Exp] = true,                --经验
        [MainFormSubPanel.MiniChat] = true,           --小聊天框
        [MainFormSubPanel.Skill] = true,              --技能
        [MainFormSubPanel.FlyControl] = true,         --飞行控制
        [MainFormSubPanel.SelectPkMode] = true,      --选择PK模式
        [MainFormSubPanel.FunctionFly] = true,        --新功能开启飞行界面
        [MainFormSubPanel.FastPrompt] = true,         --快速提醒界面
        [MainFormSubPanel.FastBts] = false,            --快速操作按钮界面
        [MainFormSubPanel.Ping] = true,               --ping
        [MainFormSubPanel.Combo] = true,              --连击界面
        [MainFormSubPanel.SkillWarning] = false,      --技能释放警示
        [MainFormSubPanel.CustomBtn] = false,         --自定义按钮
        [MainFormSubPanel.DynamicActivity] = true,    --动态活动按钮
        [MainFormSubPanel.SitDown] = false,            --打坐
    }
end

function YZZDMapLogic:GetMainLeftUIState()
    return {
        [MainLeftSubPanel.Task] = false,        --任务分页
        [MainLeftSubPanel.Team] = false,        --队伍分页
        [MainLeftSubPanel.Copy] = false,       --副本分页
        [MainLeftSubPanel.Other] = false,      --其他分页
    }
end

return YZZDMapLogic;