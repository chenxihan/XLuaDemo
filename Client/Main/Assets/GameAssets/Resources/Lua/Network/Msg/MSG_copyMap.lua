local MSG_copyMap = {}
local Network = GameCenter.Network

function MSG_copyMap.RegisterMsg()
    Network.CreatRespond("MSG_copyMap.ResOpenPanel",function (msg)
        --TODO
        GameCenter.CopyMapSystem:ResOpenPanel(msg);
    end)

    Network.CreatRespond("MSG_copyMap.ResZoneRewardResult",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_copyMap.ResCopymapRewardList",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_copyMap.ResCopymapReward",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_copyMap.ResCopymapCardReward",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_copyMap.ResChallengeThreeSuccess",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_copyMap.ResCloseTime",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_copyMap.ResCopymapNeedTime",function (msg)
        --TODO
        GameCenter.MapLogicSystem:OnMsgHandle(msg);
    end)

    Network.CreatRespond("MSG_copyMap.ResAncientLegendInfo",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_copyMap.ResPKKingInfo",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_copyMap.ResCampWarInfo",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_copyMap.ResCoinCloneInfo",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_copyMap.ResBaoKuTanMiInfo",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_copyMap.ResChallengeInfo",function (msg)
        --TODO
        GameCenter.MapLogicSystem:OnMsgHandle(msg);
    end)

    Network.CreatRespond("MSG_copyMap.ResChallengeEnterPanel",function (msg)
        --TODO
        GameCenter.CopyMapSystem:ResChallengeEnterPanel(msg);
    end)

    Network.CreatRespond("MSG_copyMap.ResCloneStoryValue",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_copyMap.ResCloneEnterCountChange",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_copyMap.ResCloneStateChange",function (msg)
        --TODO
        GameCenter.CopyMapSystem:ResCloneStateChange(msg);
    end)

    Network.CreatRespond("MSG_copyMap.ResSingleCloneStateChange",function (msg)
        --TODO
        GameCenter.CopyMapSystem:ResSingleCloneStateChange(msg);
    end)

    Network.CreatRespond("MSG_copyMap.ResDamageRanks",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_copyMap.ResTurkishRaidsTime",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_copyMap.ResCloneRealInfo",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_copyMap.ResEnterGuaJiCopymapTime",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_copyMap.ResGuildBossCloneInfo",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_copyMap.ResMultiplayerOneOrTwoInfo",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_copyMap.ResMultiplayerThreeInfo",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_copyMap.ResActivityCloneInfo",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_copyMap.ResCloneFightInfo",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_copyMap.ResCrossBoss1Message",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_copyMap.ResCrossLoopBossMessage",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_copyMap.ResCrossBoss2Message",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_copyMap.ResCrossBoss3Message",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_copyMap.ResBossLoopRewardInfo",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_copyMap.ResLoopBossInfo",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_copyMap.ResNoticeCopyFlush",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_copyMap.ResBeginStartBossLoop",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_copyMap.ResFlyPetCloneInfo",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_copyMap.ResEnterCopyMapInfo",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_copyMap.ResMedalEndInfo",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_copyMap.ResBossHomeLevel",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_copyMap.ResChiefTaskCopy1Message",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_copyMap.ResChiefTaskCopy2Message",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_copyMap.ResChiefTaskCopy3Message",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_copyMap.ResChiefTaskCopy4Message",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_copyMap.ResRebirthCopy01Message",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_copyMap.ResExpCloneInfo",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_copyMap.ResTeamCampWar",function (msg)
        --TODO
        GameCenter.MapLogicSystem:OnMsgHandle(msg);
    end)

    Network.CreatRespond("MSG_copyMap.ResTeamCampWarRank",function (msg)
        --TODO
        GameCenter.MapLogicSystem:OnMsgHandle(msg);
    end)

    Network.CreatRespond("MSG_copyMap.ResTeamCampWarEndInfo",function (msg)
        --TODO
        GameCenter.MapLogicSystem:OnMsgHandle(msg);
    end)

    Network.CreatRespond("MSG_copyMap.ResTeamTowerInfo",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_copyMap.ResTeamTowerRaidResult",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_copyMap.ResTeamTowerEnterPanel",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_copyMap.ResTeamTowerRewardInfo",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_copyMap.ResElementTempleEnergy",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_copyMap.ResYingLingDianBossInfo",function (msg)
        --TODO
    end)


    Network.CreatRespond("MSG_copyMap.ResChallengeEndInfo",function (msg)
        --TODO
        GameCenter.MapLogicSystem:OnMsgHandle(msg);
    end)


    Network.CreatRespond("MSG_copyMap.ResOpenStarPanel",function (msg)
        --TODO
        GameCenter.CopyMapSystem:ResOpenStarPanel(msg);
    end)


    Network.CreatRespond("MSG_copyMap.ResStartCopyInfo",function (msg)
        --TODO
        GameCenter.MapLogicSystem:OnMsgHandle(msg);
    end)


    Network.CreatRespond("MSG_copyMap.ResStartCopyResult",function (msg)
        --TODO
        GameCenter.MapLogicSystem:OnMsgHandle(msg);
    end)

end
return MSG_copyMap

