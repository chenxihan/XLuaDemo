local MSG_Title = {}
local Network = GameCenter.Network

function MSG_Title.RegisterMsg()
    Network.CreatRespond("MSG_Title.ResTitleInfo",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Title.ResCanActiveTitle",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Title.ResActiveTitleResult",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Title.ResUseTitle",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Title.ResOnlinePicTitles",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Title.ResAddPicTitles",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Title.ResDeletePicTitles",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Title.ResUsePicTitles",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Title.ResBroadcastPicTitles",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Title.ResTitleRuneInfo",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Title.ResTitleRuneFail",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Title.ResUpGodhead",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Title.ResUseGodHead",function (msg)
        --TODO
    end)

end
return MSG_Title

