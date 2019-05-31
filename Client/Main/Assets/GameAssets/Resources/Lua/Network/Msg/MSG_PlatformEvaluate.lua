local MSG_PlatformEvaluate = {}
local Network = GameCenter.Network

function MSG_PlatformEvaluate.RegisterMsg()
    Network.CreatRespond("MSG_PlatformEvaluate.ResEvaluateResult",function (msg)
        --TODO
    end)

end
return MSG_PlatformEvaluate

