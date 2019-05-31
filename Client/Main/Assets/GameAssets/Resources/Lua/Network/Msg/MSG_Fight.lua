local MSG_Fight = {}
local Network = GameCenter.Network

function MSG_Fight.RegisterMsg()
    Network.CreatRespond("MSG_Fight.ResUseSkill",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Fight.ResPlayLockTrajectory",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Fight.ResPlaySimpleSkillObject",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Fight.ResPlaySkillObject",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Fight.ResPlaySelfMove",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Fight.ResPlayHitEffect",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Fight.ResObjDead",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Fight.ResHpChange",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Fight.ResRollMove",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Fight.ResUpdateFightState",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Fight.ResUseSkillError",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Fight.ResChangeAttackDirRes",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Fight.ResMonsterHpChange",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Fight.ResFlyPetCloneAttack",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Fight.ResSpecClonePlayerDead",function (msg)
        --TODO
    end)

end
return MSG_Fight

