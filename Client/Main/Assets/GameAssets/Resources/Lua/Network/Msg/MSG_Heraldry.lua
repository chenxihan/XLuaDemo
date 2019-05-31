local MSG_Heraldry = {}
local Network = GameCenter.Network

function MSG_Heraldry.RegisterMsg()
    Network.CreatRespond("MSG_Heraldry.ResHeraldryPlay",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Heraldry.ResHeraldryRest",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Heraldry.ResHeraldryRenew",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Heraldry.ResPlayerHeraldryChange",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Heraldry.ResSyncHeraldry",function (msg)
        --TODO
    end)

end
return MSG_Heraldry

