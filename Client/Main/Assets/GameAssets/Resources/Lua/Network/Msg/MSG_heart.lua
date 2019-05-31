local MSG_heart = {}
local Network = GameCenter.Network

function MSG_heart.RegisterMsg()
    Network.CreatRespond("MSG_heart.ResHeart",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_heart.ResReconnectSign",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_heart.ResHeartFailed",function (msg)
        --TODO
    end)

end
return MSG_heart

