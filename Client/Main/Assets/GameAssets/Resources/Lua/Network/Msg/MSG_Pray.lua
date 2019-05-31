local MSG_Pray = {}
local Network = GameCenter.Network

function MSG_Pray.RegisterMsg()
    Network.CreatRespond("MSG_Pray.ResSyncPrayInfo",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Pray.ResPraySuccess",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Pray.ResPrayFailed",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Pray.ResPrayTick",function (msg)
        --TODO
    end)

end
return MSG_Pray

