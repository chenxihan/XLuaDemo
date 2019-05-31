local MSG_Task = {}
local Network = GameCenter.Network

function MSG_Task.RegisterMsg()
    Network.CreatRespond("MSG_Task.ResTaskList",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Task.ResTaskFinish",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Task.ResMainTaskChange",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Task.ResDailyTaskChang",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Task.ResConquerTaskChang",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Task.ResMainTaskOver",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Task.ResBranchTaskChang",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Task.ResGenderTaskChange",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Task.ResTaskIsFinish",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Task.ResGuideTaskChange",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Task.ResBorderTaskChange",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Task.ResBattleFieldTaskChange",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Task.ResEscortTaskChange",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Task.ResTaskDelete",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Task.ResBattleTaskNextFreshTime",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Task.ResLoopTaskChange",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Task.ResTaskNotice",function (msg)
        --TODO
    end)

end
return MSG_Task

