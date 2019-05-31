local MSG_UpdateReward = {}
local Network = GameCenter.Network

function MSG_UpdateReward.RegisterMsg()
    Network.CreatRespond("MSG_UpdateReward.ResGetUpdateRewardResult",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_UpdateReward.ResUpdateReward",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_UpdateReward.ResGetCommentReward",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_UpdateReward.SyncCommentReward",function (msg)
        --TODO
    end)

end
return MSG_UpdateReward

