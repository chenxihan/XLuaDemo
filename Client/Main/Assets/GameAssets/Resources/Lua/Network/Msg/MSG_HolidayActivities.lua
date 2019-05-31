local MSG_HolidayActivities = {}
local Network = GameCenter.Network

function MSG_HolidayActivities.RegisterMsg()
    Network.CreatRespond("MSG_HolidayActivities.ResHolidayActivityList",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_HolidayActivities.ResHolidayActivityRedDot",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_HolidayActivities.ResSyncHonorActivityInfo",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_HolidayActivities.ResHonorActivityReward",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_HolidayActivities.ResSyncSubmitActivityInfo",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_HolidayActivities.ResSubmitMaterials",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_HolidayActivities.ResGetSererReward",function (msg)
        --TODO
    end)

end
return MSG_HolidayActivities

