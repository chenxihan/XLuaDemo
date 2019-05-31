local MSG_SoulBeast = {}
local Network = GameCenter.Network

function MSG_SoulBeast.RegisterMsg()
    Network.CreatRespond("MSG_SoulBeast.ResSoulBeastEquipList",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_SoulBeast.ResSoulBeastBaseInfo",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_SoulBeast.ResSoulBeastChange",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_SoulBeast.ResSoulBeastEquipDown",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_SoulBeast.ResSoulBeastEquipWear",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_SoulBeast.ResSoulBeastEquipUp",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_SoulBeast.ResSoulBeastEquipAdd",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_SoulBeast.ResSoulBeastItemAdd",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_SoulBeast.ResSoulBeastGridNum",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_SoulBeast.ResDeleteSoulBeast",function (msg)
        --TODO
    end)

end
return MSG_SoulBeast

