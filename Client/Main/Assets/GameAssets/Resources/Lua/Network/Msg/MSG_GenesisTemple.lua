local MSG_GenesisTemple = {}
local Network = GameCenter.Network

function MSG_GenesisTemple.RegisterMsg()
    Network.CreatRespond("MSG_GenesisTemple.ResGenesisTemplePanel",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_GenesisTemple.ResGenesisTempleTopList",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_GenesisTemple.ResSubmitGenesisStone",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_GenesisTemple.ResGenesisScorePanel",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_GenesisTemple.G2PSubmitCloneOverInfo",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_GenesisTemple.P2GSubmitCloneOverInfo",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_GenesisTemple.G2PChangeRoleName",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_GenesisTemple.ResWorldLevelInfo",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_GenesisTemple.ResGenesisTempleCloneInfo",function (msg)
        --TODO
    end)

end
return MSG_GenesisTemple

