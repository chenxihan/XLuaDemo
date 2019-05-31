local MSG_Cloak = {}
local Network = GameCenter.Network

function MSG_Cloak.RegisterMsg()
    Network.CreatRespond("MSG_Cloak.ResCloakInfo",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Cloak.ResCloakUpItemInfo",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Cloak.ResCloakUp",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Cloak.ResChangeWearCloak",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Cloak.ResOpenCloakSkillPanel",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Cloak.ResCloakSkillUp",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Cloak.ResRuneInfo",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Cloak.ResRuneStarUp",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Cloak.ResRuneLayerUp",function (msg)
        --TODO
    end)

end
return MSG_Cloak

