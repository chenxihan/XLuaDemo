local MSG_Equip = {}
local Network = GameCenter.Network

function MSG_Equip.RegisterMsg()

    Network.CreatRespond("MSG_Equip.ResEquipStrength",function (msg)
        GameCenter.LianQiForgeSystem:GS2U_ResEquipStrength(msg)
    end)


    Network.CreatRespond("MSG_Equip.ResEquipStrengthUpLevel",function (msg)
        GameCenter.LianQiForgeSystem:GS2U_ResEquipStrengthUpLevel(msg)
    end)


    Network.CreatRespond("MSG_Equip.ResEquipMinStar",function (msg)
        --TODO
    end)


    Network.CreatRespond("MSG_Equip.ResEquipedInfos",function (msg)
        --TODO
    end)


    Network.CreatRespond("MSG_Equip.ResEquipWearSuccess",function (msg)
        --TODO
    end)


    Network.CreatRespond("MSG_Equip.ResEquipWearFailed",function (msg)
        --TODO
    end)


    Network.CreatRespond("MSG_Equip.ResEquipUnWearSuccess",function (msg)
        --TODO
    end)


    Network.CreatRespond("MSG_Equip.ResEquipUnWearFailed",function (msg)
        --TODO
    end)


    Network.CreatRespond("MSG_Equip.ResEquipSell",function (msg)
        --TODO
    end)


    Network.CreatRespond("MSG_Equip.ResEquipChange",function (msg)
        --TODO
    end)


    Network.CreatRespond("MSG_Equip.ResEquipResolveSet",function (msg)
        --TODO
    end)


    Network.CreatRespond("MSG_Equip.ResEquipGodTried",function (msg)
        --TODO
    end)


    Network.CreatRespond("MSG_Equip.ResOpenGodTried",function (msg)
        --TODO
    end)


    Network.CreatRespond("MSG_Equip.ResEquipSyn",function (msg)
        --TODO
    end)


    Network.CreatRespond("MSG_Equip.ResEquipSuit",function (msg)
        --TODO
    end)


    Network.CreatRespond("MSG_Equip.ResEquipSuitStoneSyn",function (msg)
        --TODO
    end)


    Network.CreatRespond("MSG_Equip.ResEquipSynSplit",function (msg)
        --TODO
    end)


    Network.CreatRespond("MSG_Equip.ResSoulBeastEquipSyn",function (msg)
        --TODO
    end)


    Network.CreatRespond("MSG_Equip.ResActivateCast",function (msg)
        --TODO
    end)


    Network.CreatRespond("MSG_Equip.ResEquipCast",function (msg)
        --TODO
    end)


    Network.CreatRespond("MSG_Equip.ResSyncEquipCast",function (msg)
        --TODO
    end)

end
return MSG_Equip

