local MSG_Pet = {}
local Network = GameCenter.Network

function MSG_Pet.RegisterMsg()
    Network.CreatRespond("MSG_Pet.ResSyncPet",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Pet.ResBattlePet",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Pet.ResPetList",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Pet.ResSpiritInfo",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Pet.ResSpiritLayerUp",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Pet.ResRuneInfo",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Pet.ResRuneStarUp",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Pet.ResRuneLayerUp",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Pet.ResEnterPetIsland",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Pet.ResExploreSoul",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Pet.ResCatchSoul",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Pet.ResSendPetLevel",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Pet.ResUpException",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Pet.ResChangePetStateRes",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Pet.ResSoulExpired",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Pet.ResPetAttachSoulInfo",function (msg)
        --TODO
    end)

end
return MSG_Pet

