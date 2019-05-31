local MSG_Gem = {}
local Network = GameCenter.Network

function MSG_Gem.RegisterMsg()
    Network.CreatRespond("MSG_Gem.ResGemInfo",function (msg)
        GameCenter.LianQiGemSystem:GS2U_ResGemInfo(msg)
    end)

    Network.CreatRespond("MSG_Gem.ResInlay",function (msg)
        GameCenter.LianQiGemSystem:GS2U_ResInlay(msg)
    end)

    Network.CreatRespond("MSG_Gem.ResQuickRefineGem",function (msg)
        GameCenter.LianQiGemSystem:GS2U_ResQuickRefineGem(msg)
    end)

    Network.CreatRespond("MSG_Gem.ResAutoRefineGem",function (msg)
        GameCenter.LianQiGemSystem:GS2U_ResAutoRefineGem(msg)
    end)

end
return MSG_Gem

