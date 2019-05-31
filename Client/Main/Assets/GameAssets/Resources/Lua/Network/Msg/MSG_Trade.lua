local MSG_Trade = {}
local Network = GameCenter.Network

function MSG_Trade.RegisterMsg()
    Network.CreatRespond("MSG_Trade.ResTradeApply",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Trade.ResTradeCancel",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Trade.ResOpenTradePanel",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Trade.ResTradeItem",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Trade.ResOppositeTradeItem",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Trade.ResUnloadTradeItem",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Trade.ResOppositeUnloadTradeItem",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Trade.ResLockTrade",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Trade.ResOppositeLockTrade",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Trade.ResTrade",function (msg)
        --TODO
    end)

end
return MSG_Trade

