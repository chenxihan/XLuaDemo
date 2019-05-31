local MSG_CityWar = {}
local Network = GameCenter.Network

function MSG_CityWar.RegisterMsg()
    Network.CreatRespond("MSG_CityWar.ResOpenCityUiRes",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_CityWar.ResCityPostOptRes",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_CityWar.ResScanPrivilegeRes",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_CityWar.ResCityAwardRes",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_CityWar.ResOpenCityMapListRes",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_CityWar.ResCityReportRes",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_CityWar.ResCanPostOptRes",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_CityWar.ResSignUpRes",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_CityWar.ResCityWarInfo",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_CityWar.ResKingCityWarInfo",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_CityWar.ResUpdataCityPost",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_CityWar.ResCityWarOverReport",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_CityWar.ResAllReportRes",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_CityWar.ResAddNewReport",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_CityWar.ResGetMaxLevelCityRes",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_CityWar.ResBattleTimeRemain",function (msg)
        --TODO
    end)

end
return MSG_CityWar

