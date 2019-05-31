local MSG_CrossCampWar = {}
local Network = GameCenter.Network

function MSG_CrossCampWar.RegisterMsg()
    Network.CreatRespond("MSG_CrossCampWar.ResCrossCampWarInfo",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_CrossCampWar.ResCrossCampwarMidHarmlist",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_CrossCampWar.ResOutlandCloneInfo",function (msg)
        --TODO
    end)

end
return MSG_CrossCampWar

