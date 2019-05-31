local MSG_Achievement = {}
local Network = GameCenter.Network

function MSG_Achievement.RegisterMsg()
    Network.CreatRespond("MSG_Achievement.ResAchievementInfo",function (msg)
        --TODO
        Debug.LogTableGreen(msg,"MSG_Achievement.ResAchievementInfo")
        GameCenter.AchievementSystem:ResAchievementInfo(msg);
    end)

    Network.CreatRespond("MSG_Achievement.ResGetAchievement",function (msg)
        --TODO
        Debug.LogTableGreen(msg,"MSG_Achievement.ResGetAchievement")
        GameCenter.AchievementSystem:ResGetAchievement(msg);
    end)

    Network.CreatRespond("MSG_Achievement.ResUpdateAchivement",function (msg)
        --TODO
        Debug.LogTableGreen(msg,"MSG_Achievement.ResUpdateAchivement");
        GameCenter.AchievementSystem:ResUpdateAchivement(msg);
    end)

end
return MSG_Achievement

