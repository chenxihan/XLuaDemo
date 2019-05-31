local MSG_Melting = {}
local Network = GameCenter.Network

function MSG_Melting.RegisterMsg()
    Network.CreatRespond("MSG_Melting.ResOpenMeltingRes",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Melting.ResResetMaterialRes",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Melting.ResUpdateCount",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Melting.ResSendMaterialRes",function (msg)
        --TODO
    end)

end
return MSG_Melting

