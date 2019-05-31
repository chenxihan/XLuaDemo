local MSG_ElementTemple = {}
local Network = GameCenter.Network

function MSG_ElementTemple.RegisterMsg()
    Network.CreatRespond("MSG_ElementTemple.ResOpenElementTemplePanel",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_ElementTemple.ResContinuedTime",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_ElementTemple.ResElementTempleMonsterRefreshInfo",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_ElementTemple.ResElementTempleEngyerZero",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_ElementTemple.ResBattleChangeState",function (msg)
        --TODO
    end)

end
return MSG_ElementTemple

