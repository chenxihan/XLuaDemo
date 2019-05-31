local MSG_Player = {}
local Network = GameCenter.Network

function MSG_Player.RegisterMsg()
    Network.CreatRespond("MSG_Player.ResPlayerOnLineAttribute",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Player.ResPlayerAttributeChange",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Player.ResPlayerBaseInfo",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Player.ResChangeJobResult",function (msg)
        GameCenter.TransferSystemMsg:GS2U_ResChangeJobResult(msg)
    end)

    Network.CreatRespond("MSG_Player.ResAddHatred",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Player.ResDelHatred",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Player.ResLevelChange",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Player.ResPracticeInfo",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Player.ResPracticeSetDo",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Player.ResPracticeGetResult",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Player.ResAccunonlinetime",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Player.ResUpdataExpRate",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Player.ResUpdataPkValue",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Player.ResUpdataPkStateResult",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Player.ResCleanHatred",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Player.ResPlayerFightPointChange",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Player.ResLookOtherPlayerResult",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Player.ResFightOrUnFight",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Player.ResMainUIGuideID",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Player.ResPlayerTodayData",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Player.ResUseActiveCode",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Player.ResChangeRoleNameResult",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Player.ResMaxHpChange",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Player.ResClientToChoiceBirthGroup",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Player.ResNotUpLevel",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Player.ResChangeJobTips",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Player.ResCourageList",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Player.ResPeakLevelPanel",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Player.ResChangeJobPanel",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Player.ResActiveFateStar",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Player.ResPlayerGenderNotice",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Player.ResUpgradeBlood",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Player.ResOpenBloodPannel",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Player.ResPlayerCareerChange",function (msg)
        --TODO
    end)

end
return MSG_Player

