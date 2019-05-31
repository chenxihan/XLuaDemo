local MSG_Login = {}
local Network = GameCenter.Network

function MSG_Login.RegisterMsg()
    Network.CreatRespond("MSG_Login.ResLoginFailed",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Login.ResLoginSuccess",function (msg)
        --TODO
    end)

end
return MSG_Login

