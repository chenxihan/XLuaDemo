local MSG_Card = {}
local Network = GameCenter.Network

function MSG_Card.RegisterMsg()
    Network.CreatRespond("MSG_Card.ResCards",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Card.ResSmeltResult",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Card.ResUpdateAward",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Card.ResCardLevel",function (msg)
        --TODO
    end)

end
return MSG_Card

