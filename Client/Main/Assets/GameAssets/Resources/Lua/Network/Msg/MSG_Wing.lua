local MSG_Wing = {}
local Network = GameCenter.Network

function MSG_Wing.RegisterMsg()
    Network.CreatRespond("MSG_Wing.ResWingInfo",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Wing.ResOpenWingPanel",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Wing.ResWingTransmog",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Wing.ResWingStarUp",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Wing.ResChangeWing",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Wing.ResChangeWingState",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Wing.ResOtherPlayerWingInfo",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Wing.ResActiveWingInfo",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Wing.ResMagicFeatherInfo",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Wing.ResActiveMagicFeather",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Wing.ResWearMagicFeather",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Wing.ResGetMagicFeatherFragment",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Wing.ResCanActiveWingList",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Wing.ResTrainWingModel",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Wing.ResWingModelInfo",function (msg)
        --TODO
    end)

end
return MSG_Wing

