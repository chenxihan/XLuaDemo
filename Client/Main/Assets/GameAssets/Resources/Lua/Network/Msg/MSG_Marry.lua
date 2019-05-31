local MSG_Marry = {}
local Network = GameCenter.Network

function MSG_Marry.RegisterMsg()
    Network.CreatRespond("MSG_Marry.ResMarryInfo",function (msg)
        GameCenter.MarrySystem:ResMarryInfo(msg)
    end)

    Network.CreatRespond("MSG_Marry.ResMarryPropose",function (msg)
        GameCenter.MarrySystem:ResMarryPropose(msg)
    end)

    Network.CreatRespond("MSG_Marry.ResMateInfo",function (msg)
        GameCenter.MarrySystem:ResMateInfo(msg)
    end)

    Network.CreatRespond("MSG_Marry.ResInvite",function (msg)
        GameCenter.MarrySystem:ResInvite(msg)
    end)


    Network.CreatRespond("MSG_Marry.ResOpenPrayPanel",function (msg)
        GameCenter.MarrySystem:ResOpenPrayPanel(msg)
    end)


    Network.CreatRespond("MSG_Marry.ResOpenIntimacyPanel",function (msg)
        GameCenter.MarrySystem:ResOpenIntimacyPanel(msg)
    end)


    Network.CreatRespond("MSG_Marry.ResOpenWeddingPanel",function (msg)
        --TODO
    end)


    Network.CreatRespond("MSG_Marry.ResDivorceSuccess",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Marry.ResPeaceDivorce",function (msg)
        --TODO
    end)


    Network.CreatRespond("MSG_Marry.ResOpenChildPanel",function (msg)
        --TODO
    end)


    Network.CreatRespond("MSG_Marry.ResActiveChild",function (msg)
        --TODO
    end)

end
return MSG_Marry

