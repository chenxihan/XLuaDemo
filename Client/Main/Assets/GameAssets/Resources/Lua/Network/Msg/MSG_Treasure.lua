local MSG_Treasure = {}
local Network = GameCenter.Network

function MSG_Treasure.RegisterMsg()
    Network.CreatRespond("MSG_Treasure.ResTreasureUnlockInfo",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Treasure.ResTreasureInfoList",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Treasure.ResTreasureInfo",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Treasure.ResWearTreasure",function (msg)
        --TODO
    end)

end
return MSG_Treasure

