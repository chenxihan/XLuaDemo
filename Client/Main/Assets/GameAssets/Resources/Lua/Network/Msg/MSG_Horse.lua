local MSG_Horse = {}
local Network = GameCenter.Network

function MSG_Horse.RegisterMsg()
    Network.CreatRespond("MSG_Horse.ResChangeHorse",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Horse.ResChangeRideState",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Horse.ResFlyActionRes",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Horse.ResUpdateHightRes",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Horse.ResActiveHorseInfo",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Horse.ResInviteMessageDisPatcher",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Horse.ResSameRideNoticeAll",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Horse.ResSameRideDown",function (msg)
        --TODO
    end)

end
return MSG_Horse

