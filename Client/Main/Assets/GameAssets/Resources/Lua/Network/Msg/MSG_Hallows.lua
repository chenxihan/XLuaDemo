local MSG_Hallows = {}
local Network = GameCenter.Network

function MSG_Hallows.RegisterMsg()
    Network.CreatRespond("MSG_Hallows.ResUpHallowsAttr",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Hallows.ResHallowsModelAction",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Hallows.ResUseStone",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Hallows.ResSyncHallows",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Hallows.ResPlayerHallowsModelChange",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Hallows.ResCulHallowsModel",function (msg)
        --TODO
    end)

end
return MSG_Hallows

