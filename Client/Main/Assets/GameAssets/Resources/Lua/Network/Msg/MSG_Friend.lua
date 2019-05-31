local MSG_Friend = {}
local Network = GameCenter.Network

function MSG_Friend.RegisterMsg()
    Network.CreatRespond("MSG_Friend.ResFriendList",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Friend.ResAddFriendSuccess",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Friend.ResDeleteRelationSuccess",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Friend.ResDimSelectList",function (msg)
        --TODO
    end)

end
return MSG_Friend

