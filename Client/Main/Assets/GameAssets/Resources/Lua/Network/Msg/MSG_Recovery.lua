local MSG_Recovery = {}
local Network = GameCenter.Network

function MSG_Recovery.RegisterMsg()
    Network.CreatRespond("MSG_Recovery.ResOpenRecoveryPanlResult",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Recovery.ResRecoveryResult",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Recovery.ResRecoveryRedPoint",function (msg)
        --TODO
    end)

end
return MSG_Recovery

