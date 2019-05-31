
------------------------------------------------
--作者： cy
--日期： 2019-04-16
--文件： OfflineOnHookSystem.lua
--模块： OfflineOnHookSystem
--描述： 离线挂机系统
------------------------------------------------

local OfflineOnHookSystem = {
    AddExpItemID = {1003, 1002, 1001},
    AddOnHookTimeItemID = 1004,
    RemainOnHookTime = 0,   --精确到秒
    OfflineHookResult = {},
}

function OfflineOnHookSystem:ReqHookSetInfo()
    GameCenter.Network.Send("MSG_Hook.ReqHookSetInfo", {})
end

function OfflineOnHookSystem:GS2U_ResHookSetInfo(result)
    self.RemainOnHookTime = result.hookRemainTime
    GameCenter.PushFixEvent(LogicEventDefine.EID_EVENT_UPDATE_HOOKSITTING, result)
end

function OfflineOnHookSystem:GS2U_ResOfflineHookResult(result)
    self.RemainOnHookTime = result.hookRemainTime
    self.OfflineHookResult = result
    GameCenter.PushFixEvent(UIEventDefine.UIOnHookForm_OPEN)
end

--返回的是整数
function OfflineOnHookSystem:GetHourAndMinuteBySecond(second)
    local h = second / 3600
    second = second % 3600
    local m = second / 60
    --返回整数
    return math.modf( h ), math.modf( m )
end

return OfflineOnHookSystem