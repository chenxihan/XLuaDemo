local MSG_CrossResourceWar = {}
local Network = GameCenter.Network

function MSG_CrossResourceWar.RegisterMsg()
    Network.CreatRespond("MSG_CrossResourceWar.P2GResBaoMing",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_CrossResourceWar.ResRWBaoMingState",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_CrossResourceWar.P2GRWChangeStateToAllServer",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_CrossResourceWar.ResCrossRWarCloneInfo",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_CrossResourceWar.ResCrossRWarPlayerkillinfo",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_CrossResourceWar.ResCrossRWSecondToBegin",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_CrossResourceWar.ResCrossRWarAllPlayerinfo",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_CrossResourceWar.ResCrossRWShowEnd",function (msg)
        --TODO
    end)

end
return MSG_CrossResourceWar

