local MSG_Npc = {}
local Network = GameCenter.Network

function MSG_Npc.RegisterMsg()
    Network.CreatRespond("MSG_Npc.ResNpcFuncInfos",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Npc.ResStartGather",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Npc.ResStopGather",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Npc.ResNpcAction",function (msg)
        --TODO
    end)

end
return MSG_Npc

