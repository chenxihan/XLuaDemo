
------------------------------------------------
--作者： xc
--日期： 2019-04-11
--文件： TransferSystemMsg.lua
--模块： TransferSystemMsg
--描述： 转职消息处理类
------------------------------------------------
--引用

local DianFengFourState = CS.Funcell.Code.Logic.DianFengFourState

local TransferSystemMsg = {}

local ResultCode = {
    Success = 0,--成功
    Goods_Short = 1,  --物品不足
    Lv_Short = 2,  --等级不足
    Exp_Short = 3, --经验未满
    Max_Grade = 4,  --最大转职等级了
    UnKnow = 5,    --未知错误
}


function TransferSystemMsg:ReqChangeJob( )
    GameCenter.Network.Send("MSG_Player.ReqChangeJob",{})
end

function TransferSystemMsg:GS2U_ResChangeJobResult(result)
    if result.result == ResultCode.Success then
        local _p = GameCenter.GameSceneSystem:GetLocalPlayer()
        if _p then
            _p.GradeLevel = result.grade
        end
        local _cfgId = (_p.Occ + 1) * 1000 + _p.GradeLevel
        local _cfg = DataConfig.DataChangejob[_cfgId]
        if _cfg.GenderClass == 4 then
            GameCenter.DianFengLvSystem.CurState = DianFengFourState.Default
        else
            GameCenter.TaskManager.TransferTaskStep = 0
            GameCenter.TransferSystem.TransferData.IsAccessTask = false
            GameCenter.TransferSystem.TransferData.CanTransfer = false
            GameCenter.PushFixEvent(LogicEventDefine.EID_EVENT_TRANSFER_RESULT_UPDATE, true)
            GameCenter.RedPointSystem:CleraFuncCondition(FunctionStartIdCode.Transfer)
        end
        local _modelId = GameCenter.TransferSystem:GetModelCfgId(_p.Occ, _p.PropMoudle.GradeLevel)
        if _modelId ~= 0 then
            _p:EquipWithType(FSkinPartCode.TransVfx, _modelId)
        end
        GameCenter.PushFixEvent(LogicEventDefine.EID_EVENT_TRANSFER_SUCCESS);
    end
end

return TransferSystemMsg
