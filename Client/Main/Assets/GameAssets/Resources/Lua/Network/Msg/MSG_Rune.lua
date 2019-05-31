local MSG_Rune = {}
local Network = GameCenter.Network

function MSG_Rune.RegisterMsg()
    Network.CreatRespond("MSG_Rune.ResSyncRune",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Rune.ResActionRuneResult",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Rune.ResResolveRuneResult",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Rune.ResUpRuneResult",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Rune.ResSuitData",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Rune.ResUseSoulResult",function (msg)
        --TODO
    end)

end
return MSG_Rune

