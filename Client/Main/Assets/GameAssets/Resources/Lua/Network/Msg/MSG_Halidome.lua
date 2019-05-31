local MSG_Halidome = {}
local Network = GameCenter.Network

function MSG_Halidome.RegisterMsg()
    Network.CreatRespond("MSG_Halidome.ResHalidomeList",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Halidome.ResHalidomeOperResult",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Halidome.ResCurWearHalidome",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Halidome.ResChangeHalidomeState",function (msg)
        --TODO
    end)

end
return MSG_Halidome

