local MSG_Recharge = {}
local Network = GameCenter.Network

function MSG_Recharge.RegisterMsg()
    Network.CreatRespond("MSG_Recharge.ResGetRechargeGoldRseult",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Recharge.ResGetRechargeDouble",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Recharge.ResCanGetRechargeReturn",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Recharge.ResRechargeTypeData",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Recharge.ResRechargeTotalValue",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Recharge.ResRechargeAwardPanel",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Recharge.ResGetRechargeAward",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Recharge.ResOpenDiamondInvest",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Recharge.ResDiamondInvest",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Recharge.ResGetInvestReturn",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Recharge.ResOpenDayGiftPannel",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Recharge.ResReceiveDayGiftResult",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Recharge.SyncInvestUpInfo",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Recharge.ResInvestUp",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Recharge.ResGetInvestUpEarnings",function (msg)
        --TODO
    end)

end
return MSG_Recharge

