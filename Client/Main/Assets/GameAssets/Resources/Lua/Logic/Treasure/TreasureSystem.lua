------------------------------------------------
--作者： 陈宇
--日期： 2019-05-29
--文件： TreasureSystem.lua
--模块： TreasureSystem
--描述： 法宝系统
------------------------------------------------

local TreasureSystem = {
    UnlockProgress = 0,         --神器解锁进度
    UnlockRemainCount = 0,      --今日解锁剩余次数

}

function TreasureSystem:Initialize()
    
end

function TreasureSystem:UnInitialize()
    
end

--请求增加解锁进度
function TreasureSystem:ReqAddUnlockProgress(addNum)
    Debug.LogError("ReqAddUnlockProgress")
    GameCenter.Network.Send("MSG_Treasure.ReqAddUnlockProgress", {addProgress = addNum})
end

--解锁进度返回
function TreasureSystem:ResTreasureUnlockInfo(result)
    Debug.LogError("ResTreasureUnlockInfo")

end

--请求解封神器
function TreasureSystem:ReqUnlockTreasure()
    Debug.LogError("ReqUnlockTreasure")
    GameCenter.Network.Send("MSG_Treasure.ReqUnlockTreasure")
end

--请求法宝列表
function TreasureSystem:ReqTreasureInfoList()
    Debug.LogError("ReqTreasureInfoList")
    GameCenter.Network.Send("MSG_Treasure.ReqTreasureInfoList")
end

--法宝列表返回
function TreasureSystem:ResTreasureInfoList()
    Debug.LogError("ResTreasureInfoList")

end

--请求法宝升阶（返回ResTreasureInfo）
function TreasureSystem:ReqTreasureUpgrade()
    Debug.LogError("ReqTreasureUpgrade")
    GameCenter.Network.Send("MSG_Treasure.ReqTreasureUpgrade")
end

--请求法宝解封（返回ResTreasureInfo）
function TreasureSystem:ReqTreasureActive()
    Debug.LogError("ReqTreasureActive")
    GameCenter.Network.Send("MSG_Treasure.ReqTreasureActive")
end

--请求提升法魂完整度（返回ResTreasureInfo）
function TreasureSystem:ReqUpTreasureSoul()
    Debug.LogError("ReqUpTreasureSoul")
    GameCenter.Network.Send("MSG_Treasure.ReqUpTreasureSoul")
end

--刷新单个法宝信息
function TreasureSystem:ResTreasureInfo()
    Debug.LogError("ResTreasureInfo")

end

--请求穿戴法宝
function TreasureSystem:ReqWearTreasure()
    Debug.LogError("ReqWearTreasure")
    GameCenter.Network.Send("MSG_Treasure.ReqWearTreasure")
end

--穿戴法宝返回
function TreasureSystem:ResWearTreasure()
    Debug.LogError("ResWearTreasure")

end

return TreasureSystem