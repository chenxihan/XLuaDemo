local MSG_Stronger = {}
local Network = GameCenter.Network

function MSG_Stronger.RegisterMsg()
    Network.CreatRespond("MSG_Stronger.ResDailyRechargeRewardInfo",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Stronger.ResDailyRechargeReward",function (msg)
        --TODO
    end)

end
return MSG_Stronger

