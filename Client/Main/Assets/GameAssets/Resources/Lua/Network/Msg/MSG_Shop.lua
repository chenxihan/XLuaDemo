local MSG_Shop = {}
local Network = GameCenter.Network

function MSG_Shop.RegisterMsg()
    Network.CreatRespond("MSG_Shop.ResShopItemList",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Shop.ResBuySuccess",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Shop.ResBuyFailure",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Shop.ResShopSubList",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Shop.ResShopShengMiList",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Shop.ResShengMiFreshFailure",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Shop.ResNpcShopList",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Shop.ResSellMyBagItem",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Shop.ResNpcShopBuyItem",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Shop.ResGoldShopList",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Shop.ResGoldShopBuyItem",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Shop.ResGiftBagList",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Shop.ResBuyExpPool",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Shop.ResMyAllToBuyItem",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Shop.ResMysteriousBusinessmanList",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Shop.ResExchangeResult",function (msg)
        --TODO
    end)

end
return MSG_Shop

