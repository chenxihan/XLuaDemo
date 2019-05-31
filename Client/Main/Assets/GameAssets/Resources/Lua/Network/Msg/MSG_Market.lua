local MSG_Market = {}
local Network = GameCenter.Network

function MSG_Market.RegisterMsg()
    Network.CreatRespond("MSG_Market.ResMarketUpItem",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Market.ResMarketUpFailure",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Market.ResMarketLogList",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Market.ResMarketSortList",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Market.ResMyMarketList",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Market.ResBuyItemFailure",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Market.ResCoinList",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Market.ResGetMarketCoin",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Market.ResSellItemList",function (msg)
        --TODO
    end)

end
return MSG_Market

