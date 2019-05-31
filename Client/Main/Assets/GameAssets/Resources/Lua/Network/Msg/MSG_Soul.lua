local MSG_Soul = {}
local Network = GameCenter.Network

function MSG_Soul.RegisterMsg()
    Network.CreatRespond("MSG_Soul.ResUpdateSoul",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Soul.ResUpdateHunterLevel",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Soul.ResDeleteSoul",function (msg)
        --TODO
    end)

end
return MSG_Soul

