local MSG_GodBook = {}
local Network = GameCenter.Network

function MSG_GodBook.RegisterMsg()
    Network.CreatRespond("MSG_GodBook.ResBookInfo",function (msg)
        GameCenter.GodBookSystem:GS2U_ResBookInfo(msg)
    end)

    Network.CreatRespond("MSG_GodBook.ResGetReward",function (msg)
        GameCenter.GodBookSystem:GS2U_ResGetReward(msg)
    end)

    Network.CreatRespond("MSG_GodBook.ResUpdateCondition",function (msg)
        GameCenter.GodBookSystem:GS2U_ResUpdateCondition(msg)
    end)

end
return MSG_GodBook

