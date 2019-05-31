local MSG_ShiHai = {}
local Network = GameCenter.Network

function MSG_ShiHai.RegisterMsg()
    Network.CreatRespond("MSG_ShiHai.ResShiHaiData",function (msg)
        --TODO
        GameCenter.PlayerShiHaiSystem:ResShiHaiData(msg);
    end)

end
return MSG_ShiHai

