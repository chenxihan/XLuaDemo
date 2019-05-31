local MSG_Crossjjc = {}
local Network = GameCenter.Network

function MSG_Crossjjc.RegisterMsg()
    Network.CreatRespond("MSG_Crossjjc.ResOpenCrossJJcRes",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Crossjjc.ResTellCrossJJCRewards",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Crossjjc.ResCrossJJCFightRes",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Crossjjc.G2PcrossWaitWar",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Crossjjc.P2GfaildEnterCrossJJC",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Crossjjc.F2PCrossJJcFightRes",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Crossjjc.P2GCrossJJcFightRes",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Crossjjc.G2FJJcSurrender",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Crossjjc.ResUpdateCrossJJCTime",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Crossjjc.P2GCrossJJCRankChange",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Crossjjc.P2GUpdateCrossJJCTime",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Crossjjc.ResCrossJJcRanksRes",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Crossjjc.ResCrossJJcReportRes",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Crossjjc.GS2PSCrossJJcCancelEnter",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Crossjjc.G2PSynAllCrossJJC",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Crossjjc.G2PGetCrossRankInfo",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Crossjjc.P2GCrossRankInfoRes",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Crossjjc.P2GCrossRewardRankInfo",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Crossjjc.P2GCrossJJCCleanAllScore",function (msg)
        --TODO
    end)

end
return MSG_Crossjjc

