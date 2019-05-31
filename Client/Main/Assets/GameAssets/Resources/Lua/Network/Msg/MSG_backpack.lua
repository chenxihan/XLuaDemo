local MSG_backpack = {}
local Network = GameCenter.Network

function MSG_backpack.RegisterMsg()
    Network.CreatRespond("MSG_backpack.ResItemInfos",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_backpack.ResItemAdd",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_backpack.ResItemChange",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_backpack.ResItemDelete",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_backpack.ResCoinInfos",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_backpack.ResCoinChange",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_backpack.ResOpenBagCellSuccess",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_backpack.ResOpenBagCellFailed",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_backpack.ResCompoundResult",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_backpack.ResOpenGiftEffects",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_backpack.ResItemNotEnough",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_backpack.ResExpChange",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_backpack.ResUseItemMakeBuff",function (msg)
        --TODO
    end)

end
return MSG_backpack

