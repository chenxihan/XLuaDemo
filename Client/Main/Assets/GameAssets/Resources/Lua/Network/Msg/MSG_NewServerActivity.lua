local MSG_NewServerActivity = {}
local Network = GameCenter.Network

function MSG_NewServerActivity.RegisterMsg()
    Network.CreatRespond("MSG_NewServerActivity.ResActivityList",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_NewServerActivity.ResGetReward",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_NewServerActivity.ResCurLeaseWing",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_NewServerActivity.SyncAllMenUpInfo",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_NewServerActivity.SyncDailyRechargeInfo",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_NewServerActivity.ResUniversalBossResult",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_NewServerActivity.SyncGuildHegemonyInfo",function (msg)
        --TODO
    end)

end
return MSG_NewServerActivity

