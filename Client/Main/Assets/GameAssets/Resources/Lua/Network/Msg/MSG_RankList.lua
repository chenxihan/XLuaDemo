local MSG_RankList = {}
local Network = GameCenter.Network

function MSG_RankList.RegisterMsg()
    Network.CreatRespond("MSG_RankList.ResRankInfo",function (msg)
        --TODO
        GameCenter.RankSystem:GS2U_ResRankInfo(msg)
    end)

    Network.CreatRespond("MSG_RankList.ResRankPlayerImageInfo",function (msg)
        --TODO
        GameCenter.RankSystem:GS2U_ResRankPlayerImageInfo(msg)
    end)

    Network.CreatRespond("MSG_RankList.ResWorship",function (msg)
        --TODO
        GameCenter.RankSystem:GS2U_ResWorship(msg)
    end)

    Network.CreatRespond("MSG_RankList.ResRankRedPointTip",function (msg)
        --TODO
        GameCenter.RankSystem:GS2U_ResRankRedPointTip(msg)
    end)


    Network.CreatRespond("MSG_RankList.ResRankCompareData",function (msg)
        --TODO
        GameCenter.RankSystem:GS2U_ResRankCompareData(msg)
    end)

end
return MSG_RankList

