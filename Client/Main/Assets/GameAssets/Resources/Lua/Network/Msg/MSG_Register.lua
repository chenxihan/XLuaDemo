local MSG_Register = {}
local Network = GameCenter.Network

function MSG_Register.RegisterMsg()
    Network.CreatRespond("MSG_Register.ResLoginGameFailed",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Register.ResLoginGameSuccess",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Register.ResPlayerMapInfo",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Register.ResSubstitute",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Register.ResCreateRoleFailed",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Register.ResDeleteRoleSuccess",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Register.ResQuit",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Register.ResRegainRoleResult",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Register.ResSelectCharacterFailed",function (msg)
        --TODO
    end)

end
return MSG_Register

