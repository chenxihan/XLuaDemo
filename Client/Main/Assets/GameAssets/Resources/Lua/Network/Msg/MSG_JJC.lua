local MSG_JJC = {}
local Network = GameCenter.Network

function MSG_JJC.RegisterMsg()
    Network.CreatRespond("MSG_JJC.ResOpenJJCresult",function (msg)
        GameCenter.ArenaShouXiSystem:ResOpenJJCresult(msg);
    end)

    Network.CreatRespond("MSG_JJC.ResUpdateChance",function (msg)
        GameCenter.ArenaShouXiSystem:ResUpdateChance(msg);
    end)

    Network.CreatRespond("MSG_JJC.ResUpdatePlayers",function (msg)
        GameCenter.ArenaShouXiSystem:ResUpdatePlayers(msg);
    end)

    Network.CreatRespond("MSG_JJC.ResYesterdayRank",function (msg)
        GameCenter.ArenaShouXiSystem:ResYesterdayRank(msg);
    end)

    Network.CreatRespond("MSG_JJC.ResReports",function (msg)
        GameCenter.ArenaShouXiSystem:ResReports(msg);
    end)

    Network.CreatRespond("MSG_JJC.ResJJCTargetID",function (msg)
        GameCenter.ArenaShouXiSystem:ResJJCTargetID(msg);
    end)

    Network.CreatRespond("MSG_JJC.ResJJCBattleReport",function (msg)
        GameCenter.ArenaShouXiSystem:ResJJCBattleReport(msg);
    end)

    Network.CreatRespond("MSG_JJC.ResOnlineJJCInfo",function (msg)
        GameCenter.ArenaShouXiSystem:ResOnlineJJCInfo(msg);
    end)

    Network.CreatRespond("MSG_JJC.ResStartBattleRes",function (msg)
        GameCenter.ArenaShouXiSystem:ResStartBattleRes(msg);
    end)

end
return MSG_JJC

