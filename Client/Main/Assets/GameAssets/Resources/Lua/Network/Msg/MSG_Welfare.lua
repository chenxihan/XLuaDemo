local MSG_Welfare = {}
local Network = GameCenter.Network

function MSG_Welfare.RegisterMsg()
    Network.CreatRespond("MSG_Welfare.ResOpenSignPanel",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Welfare.ResSign",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Welfare.ResOpenContinuousLoginPanel",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Welfare.ResGetContinuousLoginReward",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Welfare.ResOpenOnlineRewardPanel",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Welfare.ResGetTodayOnlineReward",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Welfare.ResOpenLevelRewardPanel",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Welfare.ResGetLevelReward",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Welfare.ResNeedRedPointTipWelfare",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Welfare.ResUpdateRRCount",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Welfare.ResRRreslult",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Welfare.ResCurSignMonth",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Welfare.ResOpenCardPanel",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Welfare.ResCardReward",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Welfare.ResActiveCard",function (msg)
        --TODO
    end)

    --打开成长基金UI返回
    Network.CreatRespond("MSG_Welfare.ResGrowthFind",function (msg)
        GameCenter.GrowthPlanSystem:GS2U_ResGrowthFind(msg)
    end)
    --请求激活成长基金结果返回
    Network.CreatRespond("MSG_Welfare.ResActiveGrowthResult",function (msg)
        GameCenter.GrowthPlanSystem:GS2U_ResActiveGrowthResult(msg)
    end)
    --请求领取成长基金结果返回
    Network.CreatRespond("MSG_Welfare.ResGetGrowthRewardResult",function (msg)
        GameCenter.GrowthPlanSystem:GS2U_ResGetGrowthRewardResult(msg)
    end)

    Network.CreatRespond("MSG_Welfare.ResGetUniversalRewardResult",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Welfare.ResUniversalRewardRedPoint",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Welfare.ResGetReturnRewardResult",function (msg)
        --TODO
    end)

    Network.CreatRespond("MSG_Welfare.SyncReturnRewardOnLine",function (msg)
        --TODO
    end)

end
return MSG_Welfare

