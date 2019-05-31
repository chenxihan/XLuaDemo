local MSG_store = {}
local Network = GameCenter.Network

function MSG_store.RegisterMsg()
    Network.CreatRespond("MSG_store.ResStoreItemInfos",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_store.ResStoreItemAdd",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_store.ResStoreItemChange",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_store.ResStoreItemDelete",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_store.ResOpenStoreCellSuccess",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_store.ResOpenStoreCellFailed",function (msg)
        --TODO
    end)

end
return MSG_store

