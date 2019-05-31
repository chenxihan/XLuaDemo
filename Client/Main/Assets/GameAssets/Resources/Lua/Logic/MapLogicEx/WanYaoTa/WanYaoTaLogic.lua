------------------------------------------------
--作者： 杨全福
--日期： 2019-05-13
--文件： WanYaoTaLogic.lua
--模块： WanYaoTaLogic
--描述： 万妖塔副本逻辑
------------------------------------------------

local WanYaoTaLogic = {
    --父逻辑系统
    Parent = nil,
    --剩余时间
    RemainTime = 0.0,
    --当前层数
    CurLevel = 0,
    --当前产生的总伤害
    AllDamage = 0,
}

function WanYaoTaLogic:OnEnterScene(parent)
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
    --关掉副本界面
    GameCenter.PushFixEvent(UIEventDefine.UICopyMapForm_CLOSE);

    self.IsShowEnterTips = false;

    --进入就开始挂机
    GameCenter.MandateSystem:Start();
end

function WanYaoTaLogic:OnLeaveScene()
    --打开小地图功能
    GameCenter.MainFunctionSystem:SetFunctionVisible(FunctionStartIdCode.AreaMap, true);
    --关闭主界面
    GameCenter.PushFixEvent(UIEventDefine.UIWYTCopyMainForm_CLOSE);
end

--更新
function WanYaoTaLogic:Update(dt)
    if self.RemainTime > 0.0 then
        self.RemainTime = self.RemainTime - dt;
    end
end

--处理协议
function WanYaoTaLogic:OnMsgHandle(msg)
    if msg.MsgID == GameCenter.Network.GetMsgID("MSG_copyMap.ResChallengeInfo") then
        --副本时间
        self.RemainTime = msg.endTime;
        --当前关卡
        self.CurLevel = msg.challengeLevel;
        local _copyData = GameCenter.CopyMapSystem:FindCopyDataByType(CopyMapTypeEnum.TowerCopy);
        if _copyData ~= nil then
            _copyData:OnFinishLevel(self.CurLevel);
        end
        GameCenter.PushFixEvent(UIEventDefine.UIWYTCopyMainForm_OPEN, self);
    elseif msg.MsgID == GameCenter.Network.GetMsgID("MSG_copyMap.ResChallengeEndInfo") then
        --结算消息
        GameCenter.PushFixEvent(UIEventDefine.UIWYTResultForm_OPEN, msg);
    end
end

function WanYaoTaLogic:GetMainUIState()
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

function WanYaoTaLogic:GetMainLeftUIState()
    return {
        [MainLeftSubPanel.Task] = true,        --任务分页
        [MainLeftSubPanel.Team] = true,        --队伍分页
        [MainLeftSubPanel.Copy] = false,       --副本分页
        [MainLeftSubPanel.Other] = false,      --其他分页
    }
end

return WanYaoTaLogic;