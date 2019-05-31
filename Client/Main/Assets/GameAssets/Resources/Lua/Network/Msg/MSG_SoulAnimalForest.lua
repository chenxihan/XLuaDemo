local MSG_SoulAnimalForest = {}
local Network = GameCenter.Network

function MSG_SoulAnimalForest.RegisterMsg()
    Network.CreatRespond("MSG_SoulAnimalForest.ResSoulAnimalForestLocalPanel",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_SoulAnimalForest.ResSoulAnimalForestLocalRefreshInfo",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_SoulAnimalForest.ResSoulAnimalForestLocalBossRefreshTip",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_SoulAnimalForest.ResSoulAnimalForestCrossPanel",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_SoulAnimalForest.ResSoulAnimalForestCrossRefreshInfo",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_SoulAnimalForest.ResFollowSoulAnimalForestCrossBoss",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_SoulAnimalForest.P2GResSoulAnimalForestCrossBossRefreshTip",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_SoulAnimalForest.ResSoulAnimalForestCrossBossRefreshTip",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_SoulAnimalForest.P2FResSoulAnimalForestBossInfo",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_SoulAnimalForest.P2FResCloneMonsterDie",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_SoulAnimalForest.P2FUpdateOneSoulAnimalForestBossInfo",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_SoulAnimalForest.F2PUpdateOneSoulAnimalForestBossInfo",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_SoulAnimalForest.F2PSoulAnimalCloneOpen",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_SoulAnimalForest.ResCrossSoulAnimalForestBossKiller",function (msg)
        --TODO
    end)

end
return MSG_SoulAnimalForest

