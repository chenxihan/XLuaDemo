local MSG_PeopleSoul = {}
local Network = GameCenter.Network

function MSG_PeopleSoul.RegisterMsg()
    Network.CreatRespond("MSG_PeopleSoul.ResOnlineSendAllPeopleSoul",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_PeopleSoul.ResDeletePeopleSoul",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_PeopleSoul.ResUpdatePeopleSoul",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_PeopleSoul.ResAddNewPeopleSoul",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_PeopleSoul.ResResolveSetting",function (msg)
        --TODO
    end)

end
return MSG_PeopleSoul

