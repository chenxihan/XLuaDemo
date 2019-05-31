local MSG_Guild = {}
local Network = GameCenter.Network

function MSG_Guild.RegisterMsg()
    Network.CreatRespond("MSG_Guild.ResCreateGuild",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Guild.ResPlayerInviteList",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Guild.ResJoinGuild",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Guild.ResImpeach",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Guild.ResInvitePlayer",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Guild.ResQuitGuild",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Guild.ResDealInviteInfo",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Guild.ResReceivedApply",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Guild.ResPlayerJoinGuild",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Guild.ResFindGuild",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Guild.ResRecommendGuild",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Guild.ResGuildLogList",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Guild.ResPlayerGuildRankChange",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Guild.ResGuildDonateCount",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Guild.ResUpBuildingSucces",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Guild.ResGuildStudySkill",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Guild.ResLearnSkill",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Guild.ResGuildMemeberList",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Guild.ResGuildImpeachPanel",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Guild.ResEnterGuild",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Guild.ResPlayerGuildBaseInfo",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Guild.ResBuldingLevel",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Guild.ResGuildPlayerLearnSkills",function (msg)
        GameCenter.FactionSkillSystem:GS2U_ResFactionSkills(msg)
    end)

    Network.CreatRespond("MSG_Guild.ResCurrStudySkills",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Guild.ResSendQuestions",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Guild.ResAnswerList",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Guild.ResOverQuestions",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Guild.ResMonsterInvasion",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Guild.ResMonsterDamage",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Guild.ResGuildBossWarPanel",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Guild.ResOpenGuildBossWar",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Guild.ResGuildBossWarDone",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Guild.ResEnterGuildBossWar",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Guild.ResGuildBossWarIsOpen",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Guild.ResGuildWarPanel",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Guild.ResGuildWarPersonal",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Guild.ResGuildWarRank",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Guild.ResKingTemple",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Guild.ResVictoryReward",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Guild.ResMasterReceive",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Guild.ResGuildWarRepotr",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Guild.ResGuildWarEnd",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Guild.ResGuildWarExp",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Guild.ResChangeGuild",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Guild.ResSendPlayerPoint",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Guild.ResGuildActiveNotice",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Guild.ResGuildMapBossHp",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Guild.ResGuildInvasionEnd",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Guild.ResGuildEmailNotice",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Guild.ResGuildSendEmailNotice",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Guild.ResInitDoubleKillAndAssist",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Guild.ResAddDoubleKillAndAssist",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Guild.ResGuildWarRedPrompt",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Guild.ResOpenaAuctionPanel",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Guild.ResAuctionRecord",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Guild.ResAuctionItem",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Guild.ResGuildAuctionHint",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Guild.ResGuildStoreHouse",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Guild.ResGuildStroeHoudeLog",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Guild.ResGuildStoreHouseOperation",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Guild.ResReceiveItem",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Guild.ResOpenGuildInfo",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Guild.ResKingRedPrompt",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Guild.ResMonsterIntrusionInfo",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Guild.ResMonsterIntrusionEnd",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Guild.ResMonsterIntrusionBegin",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Guild.ResPlayerVoiceCommander",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Guild.ResAllVoiceCommander",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Guild.ResSynVoiceMode",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Guild.ResCallUpVoicer",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Guild.ResAddInvite",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Guild.ResGuildHeroMemberInfo",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Guild.ResGuildCopy",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Guild.ResHanLinInfo",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Guild.ResUpHanLinAttaibuteSuccess",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Guild.ResSearchGuildResult",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Guild.ResBuildingvalue",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Guild.ResGuildCopyHarmInfo",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Guild.ResGuildWorshipRemainCount",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Guild.ResSendConveneNum",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Guild.ResConveneMsg",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Guild.ResTreasureTreeSuccess",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Guild.ResGuildBonfireGain",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Guild.ResGuildBonfireIsStart",function (msg)
        --TODO
    end)


    Network.CreatRespond("MSG_Guild.ResGetGuildStoreCleanCondition",function (msg)
        --TODO
    end)


    Network.CreatRespond("MSG_Guild.ResGuildActiveBabyInfo",function (msg)
        --TODO
    end)

end
return MSG_Guild

