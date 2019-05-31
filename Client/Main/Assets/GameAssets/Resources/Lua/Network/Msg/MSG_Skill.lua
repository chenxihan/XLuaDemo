local MSG_Skill = {}
local Network = GameCenter.Network

function MSG_Skill.RegisterMsg()
    Network.CreatRespond("MSG_Skill.ResSkillList",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Skill.ResSkillCellUpdate",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Skill.ResUpSkill",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Skill.ResAddSkill",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Skill.ResOnSkill",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Skill.ResAllMedal",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Skill.ResUnlockMedal",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Skill.ResOnlineMedal",function (msg)
        --TODO
    end)

end
return MSG_Skill

