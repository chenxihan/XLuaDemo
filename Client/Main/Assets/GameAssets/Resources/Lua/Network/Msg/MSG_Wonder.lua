local MSG_Wonder = {}
local Network = GameCenter.Network

function MSG_Wonder.RegisterMsg()
    Network.CreatRespond("MSG_Wonder.ResOpenWonderPanel",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Wonder.ResUseItemResult",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Wonder.ResWingInfo",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Wonder.ResUseAttrFruitResult",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Wonder.ResEquipSealChangeSync",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Wonder.ResActiveModelResult",function (msg)
        --TODO
    end)

end
return MSG_Wonder

