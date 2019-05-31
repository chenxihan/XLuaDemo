local MSG_TowerDefense = {}
local Network = GameCenter.Network

function MSG_TowerDefense.RegisterMsg()
    Network.CreatRespond("MSG_TowerDefense.ResCreateTDBuild",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_TowerDefense.ResUpdateTDBuild",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_TowerDefense.ResDeleteTDBuild",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_TowerDefense.ResBirthBossInTDWar",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_TowerDefense.ResBeginBirthMonster",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_TowerDefense.ResPeopleSoulHuntingCarInfo",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_TowerDefense.ResMapBuildInfo",function (msg)
        --TODO
    end)

end
return MSG_TowerDefense

