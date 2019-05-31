
------------------------------------------------
--作者： 王圣
--日期： 2019-05-15
--文件： FuDiBossData.lua
--模块： FuDiBossData
--描述： 福地boss数据
------------------------------------------------
--引用
local FuDiBossData = {}

local Data = {
    Id = 0,
    --1 是首领 2-4是精英怪 5-8 是护卫
    Type = 0,
    Sort = 0,    
    IconId = 0,
    --积分
    Integral = 0,
    Name = nil,
    --是否关注
    IsAttention = false,
    --0表示还活着，大于0表示复活倒计时
    BornTime = 0,
    ItemIdList = List:New()
}

function FuDiBossData:New(cfg)
    if cfg == nil then
        return nil
    end 
    local _m = Utils.DeepCopy(self)
    _m.Id = cfg.Id
    _m.Type = cfg.Group
    _m.Sort = cfg.Sort
    local monsterCfg = DataConfig.DataMonster[cfg.MonsterID]
    if monsterCfg ~= nil then
        _m.Name = monsterCfg.Name
        _m.IconId = monsterCfg.Icon
    end
    local retList = List:New()
    local levelList = List:New()
    local strList = Utils.SplitStr(cfg.Reward,';')
    for i = 1, #strList do
        local min = 0
        local max = 0
        local list = Utils.SplitStr(strList[i],'_')
        if i-1>=1 and i-1 <= #levelList then
            min = levelList[i-1]
            max = tonumber(list[1])
        else
            levelList:Add(tonumber(list[1]))
            min = 0
            max = tonumber(list[1])
        end
        if GameCenter.WorldLevelSystem.CurWorldLevel>=min and GameCenter.WorldLevelSystem.CurWorldLevel<=max then
            retList = list
            break
        end
    end
    _m.ItemIdList:Clear()
    for i = 2,#retList do
        _m.ItemIdList:Add(tonumber(retList[i]))
    end
    return _m
end

function FuDiBossData:SetData(msg)
    self.Id = msg.monsterModelId
    self.BornTime = msg.resurgenceTime
    local cfg = DataConfig.DataGuildBattleBoss[self.Id]
    if cfg == nil then
        return
    end
    local monsterCfg = DataConfig.DataMonster[cfg.MonsterID]
    if monsterCfg ~= nil then
        self.Name = monsterCfg.Name
        self.IconId = monsterCfg.Icon
    end
end
return FuDiBossData