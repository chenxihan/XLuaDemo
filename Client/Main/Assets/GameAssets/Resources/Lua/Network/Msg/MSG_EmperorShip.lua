local MSG_EmperorShip = {}
local Network = GameCenter.Network

function MSG_EmperorShip.RegisterMsg()
    Network.CreatRespond("MSG_EmperorShip.ResEmperorShipInfo",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_EmperorShip.ResEmperorShipChange",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_EmperorShip.ResCloneInfo",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_EmperorShip.ResCloneInfoChange",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_EmperorShip.ResFollowBoss",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_EmperorShip.ResCurGodDamnedValue",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_EmperorShip.ResBeginCountDown",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_EmperorShip.ResCloneEnd",function (msg)
        --TODO
    end)

end
return MSG_EmperorShip

