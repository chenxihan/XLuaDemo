local MSG_StateVip = {}
local Network = GameCenter.Network

function MSG_StateVip.RegisterMsg()
    Network.CreatRespond("MSG_StateVip.ResGetReward",function (msg)
        GameCenter.RealmSystem:GS2U_ResGetRealmTaskReward(msg)
    end)

    Network.CreatRespond("MSG_StateVip.ResStateVip",function (msg)
        GameCenter.RealmSystem:GS2U_ResRealmTask(msg)
    end)

    Network.CreatRespond("MSG_StateVip.ResStateVipRedPoint",function (msg)
        GameCenter.RealmSystem:GS2U_RealmShowRedPoint(msg)
    end)

    Network.CreatRespond("MSG_StateVip.ResStateVipBroadcast",function (msg)
        GameCenter.RealmSystem:GS2U_RealmLevelUp(msg)
    end)

    Network.CreatRespond("MSG_StateVip.ResStateVipGiftList",function (msg)
        GameCenter.RealmSystem:GS2U_ResRealmGiftList(msg)
    end)

    Network.CreatRespond("MSG_StateVip.ResDelStateVipGift",function (msg)
        --TODO
    end)


    Network.CreatRespond("MSG_StateVip.ResCurrStateVipGift",function (msg)
        GameCenter.RealmSystem:GS2U_ResRealmGift(msg)
    end)

end
return MSG_StateVip

