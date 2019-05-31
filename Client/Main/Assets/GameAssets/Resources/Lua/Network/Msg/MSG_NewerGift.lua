local MSG_NewerGift = {}
local Network = GameCenter.Network

function MSG_NewerGift.RegisterMsg()
    Network.CreatRespond("MSG_NewerGift.ResNewerGiftInfo",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_NewerGift.ResGetNewerGift",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_NewerGift.ResIsArrivalTime",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_NewerGift.ResIconIsDisPlay",function (msg)
        --TODO
    end)

end
return MSG_NewerGift

