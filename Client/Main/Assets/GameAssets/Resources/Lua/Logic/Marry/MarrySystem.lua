------------------------------------------------
--作者： dhq
--日期： 2019-05-5
--文件： MarrySystem.lua
--模块： MarrySystem
--描述： 婚姻系统
------------------------------------------------
local MarryEnum = require("Logic.Marry.MarryEnum")
local MarryData = require("Logic.Marry.MarryData")

--//模块定义
local MarrySystem =
{
    --婚姻称号
    Title = nil,
    --婚姻类型
    MarryType = MarryEnum.MarryTypeEnum.Normal,
    --亲密度奖励领取状态
    IntimacyState = MarryEnum.IntimacyStateEnum,
    --仙居数据的类型分类
    HouseDataTypeEnum = MarryEnum.HouseTypeEnum,
    --婚姻的数据
    MarryData = nil,
}

--//成员函数定义
--初始化
function MarrySystem:Initialize()
    self.MarryData = MarryData:New()
    local _marryType = self.MarryType
end

--反初始化
function MarrySystem:UnInitialize()
    self.MarryData = nil
end

--更新心跳
function MarrySystem:Update()

end

--上线返回需要的数据
function MarrySystem:ResMarryInfo(msg)
    if msg ~= nil then
        self.MarryData:UpdateNetData(msg)
        self.MarryData:InitData()
    end
end

--配偶的外观信息
function MarrySystem:ResMateInfo(msg)
    self.MarryData.PartnerMateInfo:UpdateNetData(msg)
end

--返回已经邀请过的玩家id
function MarrySystem:ResInvite(msg)
    local _playerIdList = msg.playerIds
end

--返回祈福数据
function MarrySystem:ResOpenPrayPanel(msg)
    -- --祈福经验
    -- msg.prayExp
    -- --祈福购买次数
    -- msg.canBuy
    -- --祈福请求购买次数
    -- msg.canBorrow
    -- --免费购买次数
	-- msg.freeBuy
end

--亲密度奖励领取状态的列表
function MarrySystem:ResOpenIntimacyPanel(msg)
    if msg ~= nil and msg.stateList ~= nil then
        local _statesList = msg.stateList
        for _index = 1, #_statesList do
            local _state = _statesList[_index]
            if #self.MarryData.IntimacyDataList >= _index then
                -- 更新奖励的领取状态
                self.MarryData.IntimacyDataList[_index].Status = _state
            end
        end
    end
end

--请求结婚
function MarrySystem:ReqGetMarried()
    GameCenter.Network.Send("MSG_Marry.ReqGetMarried", {type = self.MarryType, partnerId = self.MarryData.PartnerId})
end

--处理求婚消息
function MarrySystem:ReqDealMarryPropose()
    GameCenter.Network.Send("MSG_Marry.ReqDealMarryPropose", {isAgree = true})
end

--请求配偶外观信息
function MarrySystem:ReqMateInfo()
    GameCenter.Network.Send("MSG_Marry.ReqMateInfo", {})
end

--预约婚宴
function MarrySystem:ReqSelectWedding()
    --timeStart是时间段
    GameCenter.Network.Send("MSG_Marry.ReqSelectWedding", {timeStart = 1})
end

--邀请玩家参加婚宴
function MarrySystem:ReqInvite()
    GameCenter.Network.Send("MSG_Marry.ReqInvite", {timeStart = 1})
end

--邀请玩家参加婚宴
function MarrySystem:ReqSendGift()
    --playerIds邀请玩家的ID
    GameCenter.Network.Send("MSG_Marry.ReqSendGift", {playerIds = 1})
end

--请求亲密度领取状态的获取
function MarrySystem:ReqOpenIntimacyPanel()
    GameCenter.Network.Send("MSG_Marry.ReqOpenIntimacyPanel", {})
end

--是否有伴侣了
function MarrySystem:HasPartner()
    if self.MarryData.PartnerId == nil then
        return false
    end
    if self.MarryData.PartnerId > 0 then
        return true
    end
    return false
end

--结婚的前置条件是否达成
function MarrySystem:IsCompletePrecondition()
    local _canMarray = false
    -- 1. 双方等级大于配置等级
    local _isLevelAllAttain = false
    -- 2. 双方互为异性（是否异性，1为是，0为否，具体配置控制）
    local _isDifGender = false
    -- 3. 双双均为单身
    local _isAllSingleDog = false
    -- 4. 双方均在线
    local _isAllOnLine = false
    -- 配置的等级
    local _cfgLevel = 0
    local _player = GameCenter.GameSceneSystem:GetLocalPlayer()
        if _player then
            if _player.Level > _cfgLevel then 
                _isLevelAllAttain = true
            end
        end
    if _isLevelAllAttain and _isDifGender and _isAllSingleDog and _isAllOnLine then
        _canMarray = true
    end
    return _canMarray
end

return MarrySystem