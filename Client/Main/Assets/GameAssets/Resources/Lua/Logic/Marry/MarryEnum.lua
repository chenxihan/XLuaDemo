
local MarryEnum =
{
    -- 举办的婚姻类型
    MarryTypeEnum =
    {
        -- 普通
        Normal  = 1,
        -- 奢想
        Comfort = 2,
        -- 豪华
        Deluxe  = 3,
    },

    -- 亲密度奖励领取状态
    IntimacyStateEnum =
    {
        --领取
        Receiving = 1,
        --已领取
        Received = 2,
        --未达成
        UnReceive = 3,
    },

    --仙居数据的类型分类
    HouseTypeEnum =
    {
        --升级
        Upgrade = 1,
        --突破
        Overfulfil = 2,
        --预览
        Preview = 3,
    }
}

return MarryEnum