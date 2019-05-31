local MSG_Tianqibaoku = {}
local Network = GameCenter.Network

function MSG_Tianqibaoku.RegisterMsg()
    Network.CreatRespond("MSG_Tianqibaoku.ResBaokuOpenState",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Tianqibaoku.ResOpenBaokuPanel",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Tianqibaoku.ResBaokuGold",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Tianqibaoku.ResGetBaokuReward",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Tianqibaoku.ResExchangeBaokuItem",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Tianqibaoku.ResLookMyBaoku",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Tianqibaoku.ResBaokuToBackpack",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Tianqibaoku.ResNewRecord",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Tianqibaoku.G2PisBaokuOpen",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Tianqibaoku.G2PSynRecordInfo",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Tianqibaoku.P2GreturnBaokuInfo",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Tianqibaoku.G2PgetReward",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Tianqibaoku.P2GgetReward",function (msg)
        --TODO
    end)

end
return MSG_Tianqibaoku

