local MSG_SeekTreasure = {}
local Network = GameCenter.Network

function MSG_SeekTreasure.RegisterMsg()
    Network.CreatRespond("MSG_SeekTreasure.ResOpenSeekTreasurePanel",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_SeekTreasure.ResSeekPriTreasureOne",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_SeekTreasure.ResSeekPriTreasureTen",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_SeekTreasure.ResSeekSeniorTreasureOne",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_SeekTreasure.ResSeekSeniorTreasureTen",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_SeekTreasure.ResHasFreeSeekChance",function (msg)
        --TODO
    end)

end
return MSG_SeekTreasure

