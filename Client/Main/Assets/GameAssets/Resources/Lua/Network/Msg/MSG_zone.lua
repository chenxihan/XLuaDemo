local MSG_zone = {}
local Network = GameCenter.Network

function MSG_zone.RegisterMsg()

    Network.CreatRespond("MSG_zone.ResEnterZone",function (msg)
        --TODO
    end)


    Network.CreatRespond("MSG_zone.P2GResEnterZone",function (msg)
        --TODO
    end)


    Network.CreatRespond("MSG_zone.ResTeamEnterZoneISOK",function (msg)
        --TODO
    end)


    Network.CreatRespond("MSG_zone.ResTeamAcceptEnterZone",function (msg)
        --TODO
    end)


    Network.CreatRespond("MSG_zone.ResEnterZoneTeamInfo",function (msg)
        --TODO
    end)


    Network.CreatRespond("MSG_zone.P2GResCrossZoneReadyZone",function (msg)
        --TODO
    end)


    Network.CreatRespond("MSG_zone.ResEnterCrossZoneReady",function (msg)
        --TODO
    end)


    Network.CreatRespond("MSG_zone.ResTeamEnterZoneFailure",function (msg)
        --TODO
    end)


    Network.CreatRespond("MSG_zone.ResMatchFailure",function (msg)
        --TODO
    end)


    Network.CreatRespond("MSG_zone.P2GEnterOutlandWar",function (msg)
        --TODO
    end)


    Network.CreatRespond("MSG_zone.ResCloneStep",function (msg)
        --TODO
    end)


    Network.CreatRespond("MSG_zone.ResBuyEnterCloneTimes",function (msg)
        --TODO
    end)


    Network.CreatRespond("MSG_zone.ResBravePeakRecord",function (msg)
        --TODO
        GameCenter.MapLogicSystem:OnMsgHandle(msg);
    end)


    Network.CreatRespond("MSG_zone.ResBravePeakSuccessOneFloorNotice",function (msg)
        --TODO
        GameCenter.MapLogicSystem:OnMsgHandle(msg);
    end)


    Network.CreatRespond("MSG_zone.ResBravePeakResultPanl",function (msg)
        --TODO
        GameCenter.MapLogicSystem:OnMsgHandle(msg);
    end)

end
return MSG_zone

