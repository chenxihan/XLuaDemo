local MSG_Fashion = {}
local Network = GameCenter.Network

function MSG_Fashion.RegisterMsg()
    Network.CreatRespond("MSG_Fashion.ResUpdateFashion",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Fashion.ResOnlineFashions",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Fashion.ResFashionBodyBroadcast",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Fashion.ResFashionWeaponBroadcast",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Fashion.ResStarInfo",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Fashion.ResStarLayerUp",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Fashion.ResUpException",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Fashion.ResFashionLayerBroadcast",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Fashion.ResTrainModel",function (msg)
        --TODO
    end)

end
return MSG_Fashion

