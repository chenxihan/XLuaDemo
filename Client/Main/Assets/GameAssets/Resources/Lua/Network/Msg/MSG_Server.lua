local MSG_Server = {}
local Network = GameCenter.Network

function MSG_Server.RegisterMsg()
    Network.CreatRespond("MSG_Server.P2GResRegister",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Server.F2GResRegister",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Server.P2GResFightServerList",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Server.P2GResFightServer",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Server.G2FSynPlayerInfo",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Server.F2GSynPlayerInfoResult",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Server.F2PSynPlayerInfoResult",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Server.G2PSynPlayerName",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Server.G2PCheckCrossInfo",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Server.P2GCheckCrossInfoRes",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Server.G2PGMCMD",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Server.P2GGMCMDResult",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Server.G2FSynPowerAttAndFace",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Server.F2GPlayerOutCrossWorldMap",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Server.G2PConnectHeart",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Server.P2GConnectHeartRes",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Server.G2FNoticeSynRoleInfo",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Server.G2PServerNameChange",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Server.G2PServerOpentimeChange",function (msg)
        --TODO
    end)

end
return MSG_Server

