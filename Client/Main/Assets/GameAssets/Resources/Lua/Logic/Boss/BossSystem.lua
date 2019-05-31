------------------------------------------------
--作者： xc
--日期： 2019-05-10
--文件： BossSystem.lua
--模块： BossSystem
--描述： BOSS系统
------------------------------------------------

local BossSystem = {
    BossPersonal = Dictionary:New(), --存的配置表数据K是Layer
    MySelfBossRefshTime = 0,  --个人BOSS剩余刷新时间

    WorldBossInfoDic = Dictionary:New(),        --世界BOSS信息字典，key = 配置表id，value = {BossCfg, RefreshTime, IsFollow}
    LayerBossIDDic = Dictionary:New(),          --层数和bossID字典，key = 层数，value = bossID
    WorldBossRankRewardCount = 0,               --世界BOSS 排行 奖励已使用次数
    WorldBossRankRewardMaxCount = 0,            --世界BOSS 排行 奖励最大次数
    WorldBossEnterRewardCount = 0,              --世界BOSS 参与 奖励已使用次数
    WorldBossEnterRewardMaxCount = 0,           --世界BOSS 参与 奖励最大次数
    StartCountDown = false,                     --世界BOSS刷新开始
    CurSelectBossID = 0,
}

function BossSystem:Initialize()
    self:InitConfig()
    self:InitWorldBossInfo()
end


function BossSystem:UnInitialize()
    self.BossPersonal:Clear()
    self.StartCountDown = false
    self.CurSelectBossID = 0
    self.WorldBossInfoDic:Clear()
    self.LayerBossIDDic:Clear()
end

--################世界BOSS开始#################
function BossSystem:InitWorldBossInfo()
    for k,v in pairs(DataConfig.DataBossnewWorld) do
        if not self.LayerBossIDDic:ContainsKey(v.Mapnum) then
            local _bossIDList = List:New()
            _bossIDList:Add(k)
            self.LayerBossIDDic:Add(v.Mapnum, _bossIDList)
        else
            local _bossIDList = self.LayerBossIDDic[v.Mapnum]
            if not _bossIDList:Contains(k) then
                _bossIDList:Add(k)
            end
        end
        if not self.WorldBossInfoDic:ContainsKey(k) then
            local _bossInfo = {BossCfg = v}
            self.WorldBossInfoDic:Add(k, _bossInfo)
        end
    end
    self.LayerBossIDDic:SortKey(function(a, b) return a < b end)
    self.LayerBossIDDic:Foreach(function(key, value)
        value:Sort(function(a, b) return a < b end)
    end)
    local _countStr = DataConfig.DataGlobal[1517]
    if _countStr then
        local _countList = Utils.SplitStr(_countStr.Params, "_")
        self.WorldBossRankRewardMaxCount = tonumber(_countList[1])
        self.WorldBossEnterRewardMaxCount = tonumber(_countList[2])
    end
end

--请求所有BOSS信息
function BossSystem:ReqAllWorldBossInfo()
    GameCenter.Network.Send("MSG_Boss.ReqOpenDreamBoss")
end

function BossSystem:ResAllWorldBossInfo(result)
    if result then
        local _bossList = result.bossList
        if _bossList then
            for i=1, #_bossList do
                if self.WorldBossInfoDic:ContainsKey(_bossList[i].bossId) then
                    local _bossInfo = self.WorldBossInfoDic[_bossList[i].bossId]
                    _bossInfo.RefreshTime = _bossList[i].refreshTime
                    _bossInfo.IsFollow = _bossList[i].isFollowed
                end
            end
        end
        self.WorldBossRankRewardCount = result.remainRankCount
        self.WorldBossEnterRewardCount = result.remainEnterCount
        self.StartCountDown = true
        GameCenter.PushFixEvent(LogicEventDefine.EID_EVENT_NEWWORLDBOSS_REFRESHTIME)
    end
end

--请求BOSS击杀信息
function BossSystem:ReqBossKilledInfo(bossID)
    GameCenter.Network.Send("MSG_Boss.ReqBossKilledInfo", {bossId = bossID, bossType = 1})
end

function BossSystem:ResBossKilledInfo(result)
    GameCenter.PushFixEvent(LogicEventDefine.EID_EVENT_NEWWORLDBOSS_KILLRECORD, result)
end

--请求关注BOSS。follow = 请求方式，true：进行关注，false：取消关注
function BossSystem:ReqFollowBoss(bossID, isFollow)
    --协议中：1：进行关注，2：取消关注
    local _followType = isFollow and 1 or 2
    GameCenter.Network.Send("MSG_Boss.ReqFollowBoss", {bossId = bossID, type = _followType, bossType = 1})
end

function BossSystem:ResFollowBoss(result)
    if result and result.isSuccess then
        if self.WorldBossInfoDic:ContainsKey(result.bossId) then
            self.WorldBossInfoDic[result.bossId].IsFollow = result.type == 1
            GameCenter.PushFixEvent(LogicEventDefine.EID_EVENT_NEWWORLDBOSS_FOLLOW)
        end
    end
end

--BOSS信息刷新
function BossSystem:ResBossRefreshInfo(result)
    if result and result.bossRefreshList then
        local _newBossInfoList = result.bossRefreshList
        for i=1, #_newBossInfoList do
            if self.WorldBossInfoDic:ContainsKey(_newBossInfoList[i].bossId) then
                self.WorldBossInfoDic[_newBossInfoList[i].bossId].RefreshTime = _newBossInfoList[i].refreshTime
                self.WorldBossInfoDic[_newBossInfoList[i].bossId].IsFollow = _newBossInfoList[i].isFollowed
            end
        end
        self.StartCountDown = true
    end
end

--关注的世界boss刷新提前一分钟提示
function BossSystem:ResBossRefreshTip(result)
    local _bossCfg = DataConfig.DataBossnewWorld[result.bossId]
    if _bossCfg then
        -- local _mapID = _bossCfg.CloneMap
        -- local _posList = Utils.SplitStr(_bossCfg.Pos, "_")
        -- local _posX = tonumber(_posList[1])
        -- local _posY = tonumber(_posList[2])
        Debug.LogError("PushEvent, bossID = ", result.bossId)
        GameCenter.PushFixEvent(UIEventDefine.UIBossInfoTips_OPEN, {result.bossId, _bossCfg.CloneMap, result.bossId})
    end
end

--同步伤害排行信息
function BossSystem:ResSynHarmRank(result)
    local _rankList = List:New()
    if result.rank then
        for i=1, #result.rank do
            _rankList:Add(result.rank[i])
        end
    end
    -- local _myRankInfo = {}
    -- _myRankInfo.top = result.myRank
    -- _myRankInfo.name = GameCenter.GameSceneSystem:GetLocalPlayer().Name
    -- _myRankInfo.harm = result.myHarm
    -- _rankList:Add(_myRankInfo)
    _rankList:Sort(function(a, b)
        return a.top < b.top
    end)
    GameCenter.PushFixEvent(UIEventDefine.UINewWorldBossHarmRankForm_OPEN, _rankList)
end
--################世界BOSS结束#################

--返回个人BOSS刷新时间
function BossSystem:ResMySelfBossRemainTime(msg)
    self.MySelfBossRefshTime = msg.remaintime
    GameCenter.PushFixEvent(LogicEventDefine.BOSS_EVENT_MYSELF_REMAINTEAM,self.MySelfBossRefshTime)
end

--初始化个人BOSS配置表
function BossSystem:InitConfig()
    for k, v in pairs(DataConfig.DataBossnewPersonal) do
        if not self.BossPersonal:ContainsKey(v.Layer) then
            local _list = List:New()
            _list:Add(v)
            self.BossPersonal:Add(v.Layer, _list)
        else
            self.BossPersonal[v.Layer]:Add(v)
        end
    end
    self.BossPersonal:SortKey(
        function(a,b)
            return a < b
        end
    )
    for k, v in pairs(self.BossPersonal) do
        v:Sort(
            function(a,b)
                return a.Monsterid < b.Monsterid
            end
        )
    end
end

--获得重生时间通过BOSSID
function BossSystem:GetBossReviewTimeByIs(layer,bossid)
    if self.BossPersonal:ContainsKey(layer) then
        local _info = self.BossPersonal[layer]:Find(
            function(code)
                return code.Monsterid == bossid
            end
        )
        if _info then
            return _info.ReviveTime
        end
    end
    return 0
end

--获得重生时间通过BOSSID
function BossSystem:GetBossPos(monsterid,layer)
    if self.BossPersonal:ContainsKey(layer) then
        local _info = self.BossPersonal[layer]:Find(
            function(code)
                return code.Monsterid == monsterid
            end
        )
        if _info then
            return _info.Pos
        end
    end
    return nil
end

--解析字符串得到坐标
function BossSystem:AnalysisPos(str)
    if str then
        local _attr = Utils.SplitStr(str,'_')
        if #_attr == 2 then
            return tonumber(_attr[1]),tonumber(_attr[2])
        end
    end
end

--解析字符串得到道具
function BossSystem:AnalysisItem(str)
    if str then
        local _attr = Utils.SplitStr(str,';')
        local _list = List:New()
        for i=1,#_attr do
            _list:Add(tonumber(_attr[i]))
        end
        return _list
    end
    return nil
end

function BossSystem:GetMonsterNameByCfgName(cfgName)
    return string.match(cfgName, ".+%f[(]")
end

function BossSystem:GetMonsterLvByCfgName(cfgName)
    return string.match(cfgName, "%d+")
end

--更新
function BossSystem:Update(dt)
    if self.StartCountDown then
        for k, v in pairs(self.WorldBossInfoDic) do
            if v.RefreshTime then
                if self.WorldBossInfoDic[k].RefreshTime > 0 then
                    self.WorldBossInfoDic[k].RefreshTime = self.WorldBossInfoDic[k].RefreshTime - dt
                elseif self.WorldBossInfoDic[k].RefreshTime < 0 then
                    self.WorldBossInfoDic[k].RefreshTime = 0
                end
            end
        end
    end
end

return BossSystem