local MSG_Gm = {}
local Network = GameCenter.Network

function MSG_Gm.RegisterMsg()
    Network.CreatRespond("MSG_Gm.GmCommandClientToServer",function (msg)
        --TODO
    end)

end
return MSG_Gm

