local MSG_GuildActivity = {}
local Network = GameCenter.Network

function MSG_GuildActivity.RegisterMsg()
    Network.CreatRespond("MSG_GuildActivity.ResOpenRankPanel",function (msg)
        --TODO
        GameCenter.FuDiSystem:ResOpenRankPanel(msg)
    end)


    Network.CreatRespond("MSG_GuildActivity.ResOpenAllBossPanel",function (msg)
        --TODO
        GameCenter.FuDiSystem:ResOpenAllBossPanel(msg)
    end)


    Network.CreatRespond("MSG_GuildActivity.ResDayScoreReward",function (msg)
        --TODO
        --GameCenter.FuDiSystem:r
    end)


    Network.CreatRespond("MSG_GuildActivity.ResOpenDetailBossPanel",function (msg)
        --TODO
        GameCenter.FuDiSystem:ResOpenDetailBossPanel(msg)
    end)


    Network.CreatRespond("MSG_GuildActivity.ResUpdateMonsterResurgenceTime",function (msg)
        --TODO
        GameCenter.FuDiSystem:ResUpdateMonsterResurgenceTime(msg)
    end)


    Network.CreatRespond("MSG_GuildActivity.ResAttentionMonster",function (msg)
        --TODO
        GameCenter.FuDiSystem:ResAttentionMonster(msg)
    end)


    Network.CreatRespond("MSG_GuildActivity.ResAttentionMonsterRefresh",function (msg)
        --TODO
        GameCenter.FuDiSystem:ResAttentionMonsterRefresh(msg)
    end)


    Network.CreatRespond("MSG_GuildActivity.ResSynAnger",function (msg)
        --TODO
        GameCenter.FuDiSystem:ResSynAnger(msg)
    end)


    Network.CreatRespond("MSG_GuildActivity.ResSynMonster",function (msg)
        --TODO
        GameCenter.FuDiSystem:ResSynMonster(msg)
    end)


    Network.CreatRespond("MSG_GuildActivity.ResSynHarmRank",function (msg)
        --TODO
        GameCenter.FuDiSystem:ResSynHarmRank(msg)
    end)


    Network.CreatRespond("MSG_GuildActivity.ResSnatchPanel",function (msg)
        --TODO
        GameCenter.FuDiSystem:ResSnatchPanel(msg)
    end)

end
return MSG_GuildActivity

