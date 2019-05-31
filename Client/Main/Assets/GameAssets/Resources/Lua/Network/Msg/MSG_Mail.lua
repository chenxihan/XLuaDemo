local MSG_Mail = {}
local Network = GameCenter.Network

function MSG_Mail.RegisterMsg()
    Network.CreatRespond("MSG_Mail.ResReadMail",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Mail.ResReceiveSingleMailAttach",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Mail.ResMailInfoList",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Mail.ResNewMail",function (msg)
        --TODO
    end)

end
return MSG_Mail

