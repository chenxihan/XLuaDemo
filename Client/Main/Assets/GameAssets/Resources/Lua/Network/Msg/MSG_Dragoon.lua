local MSG_Dragoon = {}
local Network = GameCenter.Network

function MSG_Dragoon.RegisterMsg()
    Network.CreatRespond("MSG_Dragoon.ResDragoonList",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Dragoon.ResActiveDragoonSuccess",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Dragoon.ResActiveDragoonFailed",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Dragoon.ResUpDragoonSuccess",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Dragoon.ResUpDragoonFailed",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Dragoon.ResUseDragoonSuccess",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Dragoon.ResUseDragoonFailed",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Dragoon.ResUpDragoonSkillResult",function (msg)
        --TODO
    end)

end
return MSG_Dragoon

