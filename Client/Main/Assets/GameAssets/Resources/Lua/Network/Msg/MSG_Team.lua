local MSG_Team = {}
local Network = GameCenter.Network

function MSG_Team.RegisterMsg()

    Network.CreatRespond("MSG_Team.ResTeamInfo",function (msg)
        --TODO
    end)


    Network.CreatRespond("MSG_Team.ResUpdateTeamMemberInfo",function (msg)
        --TODO
    end)


    Network.CreatRespond("MSG_Team.ResFreedomList",function (msg)
        --TODO
    end)


    Network.CreatRespond("MSG_Team.ResInviteInfo",function (msg)
        --TODO
    end)


    Network.CreatRespond("MSG_Team.ResApplyList",function (msg)
        --TODO
    end)


    Network.CreatRespond("MSG_Team.ResAddApplyer",function (msg)
        --TODO
    end)


    Network.CreatRespond("MSG_Team.ResWaitList",function (msg)
        --TODO
    end)


    Network.CreatRespond("MSG_Team.ResDeleteTeamMember",function (msg)
        --TODO
    end)


    Network.CreatRespond("MSG_Team.ResCallAllMemberRes",function (msg)
        --TODO
    end)


    Network.CreatRespond("MSG_Team.ResMatchAll",function (msg)
        --TODO
    end)


    Network.CreatRespond("MSG_Team.ResUpdateHPAndMapKey",function (msg)
        --TODO
    end)


    Network.CreatRespond("MSG_Team.ResTeamLeaderOpenState",function (msg)
        --TODO
    end)

end
return MSG_Team

