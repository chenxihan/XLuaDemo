local MSG_Dailyactive = {}
local Network = GameCenter.Network

function MSG_Dailyactive.RegisterMsg()

    Network.CreatRespond("MSG_Dailyactive.ResGetActiveReward",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Dailyactive.ResDailyActivePenel",function (msg)
        GameCenter.DailyActivitySystem:GS2U_ResActivePenel(msg)
    end)


    Network.CreatRespond("MSG_Dailyactive.ResDailyPushResult",function (msg)
        GameCenter.DailyActivitySystem:GS2U_ResDailyPushResult(msg)
    end)

end
return MSG_Dailyactive

