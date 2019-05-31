local MSG_Marriage = {}
local Network = GameCenter.Network

function MSG_Marriage.RegisterMsg()
    Network.CreatRespond("MSG_Marriage.ResMarriageInfo",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Marriage.ResMarriagePropose",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Marriage.ResWhisperInfo",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Marriage.ResIntimacyChange",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Marriage.ResRingLevelChange",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Marriage.ResCoupleSkillChange",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Marriage.ResCoupleAttributeChange",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Marriage.ResAddWhisperInfo",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Marriage.ResMateInfo",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Marriage.ResPeaceDivorce",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Marriage.ResDivorceSuccess",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Marriage.ResWeddingState",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Marriage.ResUpIntimacyLv",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Marriage.ResZodiacInfo",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Marriage.ResUnderwayWeddingList",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Marriage.ResHoldWedding",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Marriage.ResGoWedding",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Marriage.ResCloneStart",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Marriage.ResNpcBossTiShi",function (msg)
        --TODO
    end)

end
return MSG_Marriage

