local MSG_Boss = {}
local Network = GameCenter.Network

function MSG_Boss.RegisterMsg()
    Network.CreatRespond("MSG_Boss.ResOpenDreamBoss",function (msg)
        GameCenter.BossSystem:ResAllWorldBossInfo(msg)
    end)

    Network.CreatRespond("MSG_Boss.ResBossKilledInfo",function (msg)
        GameCenter.BossSystem:ResBossKilledInfo(msg)
    end)

    Network.CreatRespond("MSG_Boss.ResFollowBoss",function (msg)
        GameCenter.BossSystem:ResFollowBoss(msg)
    end)

    Network.CreatRespond("MSG_Boss.ResBossRefreshInfo",function (msg)
        GameCenter.BossSystem:ResBossRefreshInfo(msg)
    end)

    Network.CreatRespond("MSG_Boss.ResBossRefreshTip",function (msg)
        GameCenter.BossSystem:ResBossRefreshTip(msg)
    end)

    Network.CreatRespond("MSG_Boss.ResOpenPersonalBossPanel",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Boss.ResGodsRemainsPanel",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Boss.ResGodsRemainsRefreshInfo",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Boss.ResGodsRemainsTimeTick30",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Boss.ResGodsRemainsEndTime",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Boss.ResGodsRemainsBossValue",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Boss.ResGodsRemainsBossRefreshTip",function (msg)
        --TODO
    end)


    Network.CreatRespond("MSG_Boss.ResMySelfBossRemainTime",function (msg)
        GameCenter.BossSystem:ResMySelfBossRemainTime(msg)
    end)


    Network.CreatRespond("MSG_Boss.ResMySelfBossCopyInfo",function (msg)
        GameCenter.MapLogicSystem:OnMsgHandle(msg)
    end)


    Network.CreatRespond("MSG_Boss.ResMySelfBossStage",function (msg)
        GameCenter.MapLogicSystem:OnMsgHandle(msg)
    end)


    Network.CreatRespond("MSG_Boss.ResSynHarmRank",function (msg)
        GameCenter.BossSystem:ResSynHarmRank(msg)
    end)


    Network.CreatRespond("MSG_Boss.ResMySelfBossItemInfo",function (msg)
        GameCenter.MapLogicSystem:OnMsgHandle(msg)
    end)

end
return MSG_Boss

