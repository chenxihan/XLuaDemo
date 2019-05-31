local MSG_BossHome = {}
local Network = GameCenter.Network

function MSG_BossHome.RegisterMsg()
    Network.CreatRespond("MSG_BossHome.ResBossHomeInfo",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_BossHome.ResBossRecord",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_BossHome.ResYYHJBossInfo",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_BossHome.ResYyhjBossRefreshInfo",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_BossHome.ResHomeBossRefreshInfo",function (msg)
        --TODO
    end)

end
return MSG_BossHome

