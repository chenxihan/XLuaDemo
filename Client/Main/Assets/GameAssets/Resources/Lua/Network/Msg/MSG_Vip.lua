local MSG_Vip = {}
local Network = GameCenter.Network

function MSG_Vip.RegisterMsg()
    Network.CreatRespond("MSG_Vip.ResVipInfo",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Vip.ResVipLevelChange",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Vip.ResGetGiftSuccess",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Vip.ResVipCountCenter",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Vip.ResBuyCloneTimes",function (msg)
        --TODO
    end)

end
return MSG_Vip

