local MSG_Backend = {}
local Network = GameCenter.Network

function MSG_Backend.RegisterMsg()
    Network.CreatRespond("MSG_Backend.ResFuncOpenList",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Backend.ResSwitchFunction",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Backend.ResFuncOpenRoleInfo",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Backend.ResActivityClientInfo",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Backend.ResCrossActivityClientInfo",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Backend.ResIsActivityCanGet",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Backend.ResGetActivityRewardSuccess",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Backend.ResRewardAgainResult",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Backend.ResActivitySendToFriendSuccess",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Backend.P2GResCrossRankIsReceive",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Backend.P2GResCrossRankData",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Backend.ResOpenPaySendItemPanel",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Backend.ResPaySendItemClientInfo",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Backend.ResGetDailyRechargeReward",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Backend.ResFirstKillOpenState",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Backend.ResActivityRemainTime",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Backend.ResTimeLimitGift",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Backend.ResCloudBuyInfo",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Backend.ResCloudBuy",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Backend.ResSyncCloudBuy",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Backend.ResLuckyReward",function (msg)
        --TODO
    end)

end
return MSG_Backend

