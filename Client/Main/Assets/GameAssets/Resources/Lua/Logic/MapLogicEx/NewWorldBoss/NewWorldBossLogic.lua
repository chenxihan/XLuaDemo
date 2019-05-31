------------------------------------------------
--作者： cy
--日期： 2019-05-22
--文件： NewWorldBossLogic.lua
--模块： NewWorldBossLogic
------------------------------------------------

local NewWorldBossLogic = {
    --父逻辑系统
    Parent = nil,
    Msg = nil, --服务器返回消息
}

function NewWorldBossLogic:OnEnterScene(parent)
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
    GameCenter.MapLogicSwitch.EventOpen = UIEventDefine.UINewWorldBossCopyForm_OPEN
    GameCenter.MapLogicSwitch.EventClose = UIEventDefine.UINewWorldBossCopyForm_CLOSE
    GameCenter.MapLogicSwitch.OtherName = DataConfig.DataMessageString.Get("BOSS_WORLD_TITTLE")
    GameCenter.MapLogicSwitch.OtherSprName = "tongyong"

    local _bossID = GameCenter.BossSystem.CurSelectBossID
    if _bossID <= 0 then
        _bossID = GameCenter.BossInfoTipsSystem.CustomCfgID
    end
    local _bossCfg = DataConfig.DataBossnewWorld[_bossID]
    if _bossCfg then
        local _curMapID = self.Parent.MapCfg.MapId
        if _curMapID == _bossCfg.CloneMap then
            local _posList = Utils.SplitStr(_bossCfg.Pos, "_")
            local _pos = Vector2(tonumber(_posList[1]),tonumber(_posList[2]))
            GameCenter.PathSearchSystem:SearchPathToPosBoss(true, _pos, _bossID)
        end
    end
end

function NewWorldBossLogic:OnLeaveScene()
    self.Msg = nil
    GameCenter.BossSystem.CurSelectBossID = 0
end

--处理协议
function NewWorldBossLogic:OnMsgHandle(msg)
    
end

function NewWorldBossLogic:GetMainUIState()
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

function NewWorldBossLogic:GetMainLeftUIState()
    return {
        [MainLeftSubPanel.Task] = false,        --任务分页
        [MainLeftSubPanel.Team] = true,        --队伍分页
        [MainLeftSubPanel.Copy] = false,       --副本分页
        [MainLeftSubPanel.Other] = true,      --其他分页
    }
end

return NewWorldBossLogic