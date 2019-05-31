local MSG_Hook = {}
local Network = GameCenter.Network

function MSG_Hook.RegisterMsg()
    Network.CreatRespond("MSG_Hook.ResHookSetInfo",function (msg)
        GameCenter.OfflineOnHookSystem:GS2U_ResHookSetInfo(msg)
    end)

    Network.CreatRespond("MSG_Hook.ResOfflineHookResult",function (msg)
        GameCenter.OfflineOnHookSystem:GS2U_ResOfflineHookResult(msg)
    end)

    --以下三个消息，在C#端处理，因为涉及到角色状态机，新增了打坐状态
    Network.CreatRespond("MSG_Hook.ResStartSitDown",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Hook.ResSyncExpAdd",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Hook.ResEndSitDown",function (msg)
        --TODO
    end)

end
return MSG_Hook

