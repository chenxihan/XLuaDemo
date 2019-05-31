local MSG_Buff = {}
local Network = GameCenter.Network

function MSG_Buff.RegisterMsg()
    Network.CreatRespond("MSG_Buff.ResBuffs",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Buff.ResAddBuff",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Buff.ResRemoveBuff",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Buff.ResUpdateBuff",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Buff.ResHpAddOrDec",function (msg)
        --TODO
    end)

end
return MSG_Buff

