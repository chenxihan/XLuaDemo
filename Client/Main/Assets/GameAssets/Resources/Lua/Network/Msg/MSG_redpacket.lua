local MSG_redpacket = {}
local Network = GameCenter.Network

function MSG_redpacket.RegisterMsg()
    Network.CreatRespond("MSG_redpacket.ResRedpacketList",function (msg)
        --TODO
        GameCenter.RedPacketSystem:GS2U_ResRedpacketList(msg)
    end)

    Network.CreatRespond("MSG_redpacket.ResGetRedPacketInfo",function (msg)
        --TODO
        GameCenter.RedPacketSystem:GS2U_ResGetRedPacketInfo(msg)
    end)

    Network.CreatRespond("MSG_redpacket.ResClickRedpacket",function (msg)
        --TODO
        GameCenter.RedPacketSystem:GS2U_ResClickRedpacket(msg)
    end)

    Network.CreatRespond("MSG_redpacket.ResSendRedPacket",function (msg)
        --TODO
        GameCenter.RedPacketSystem:GS2U_ResSendRedPacket(msg)
    end)

    Network.CreatRespond("MSG_redpacket.ResNewRedPacket",function (msg)
        --TODO
        GameCenter.RedPacketSystem:GS2U_ResNewRedPacket(msg)
    end)

    Network.CreatRespond("MSG_redpacket.ResMineHaveRedpacket",function (msg)
        --TODO
        GameCenter.RedPacketSystem:GS2U_ResMineHaveRedpacket(msg)
    end)

    Network.CreatRespond("MSG_redpacket.ResSendMineRechargeRedpacket",function (msg)
        --TODO
        GameCenter.RedPacketSystem:GS2U_ResSendMineRechargeRedpacket(msg)
    end)

end
return MSG_redpacket

