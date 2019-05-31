------------------------------------------------
--作者： cy
--日期： 2019-05-22
--文件： UINewWorldBossCopyForm.lua
--模块： UINewWorldBossCopyForm
--描述： 个人BOSS副本左侧界面数据
------------------------------------------------

local UINewWorldBossCopyForm = {
    CloneGo = nil,
    CloneRoot = nil,
    CloneRootGrid = nil,
    CloneRootScrollView = nil,
    CurLayer = 0,                       --当前所在地图对应的世界BOSS层数
    RefreshTimeOffset = 0.5,            --刷新的时间间隔
    CurTime = 0,                        --用于计算时间间隔
    StartRefreshTime = false,
}

function UINewWorldBossCopyForm:OnRegisterEvents()
	self:RegisterEvent(UIEventDefine.UINewWorldBossCopyForm_OPEN,self.OnOpen)
    self:RegisterEvent(UIEventDefine.UINewWorldBossCopyForm_CLOSE,self.OnClose)
end

--打开
function UINewWorldBossCopyForm:OnOpen(obj, sender)
    local _curMapID = GameCenter.GameSceneSystem.ActivedScene.MapId
    GameCenter.BossSystem.WorldBossInfoDic:ForeachCanBreak(function(key, value)
        if value.BossCfg.CloneMap == _curMapID then
            self.CurLayer = value.BossCfg.Mapnum
            return "break"
        end
    end)
    self.CSForm:Show(sender)
end

--关闭
function UINewWorldBossCopyForm:OnClose(obj,sender)
    self.CSForm:Hide()
    self.StartRefreshTime = false
end

function UINewWorldBossCopyForm:OnFirstShow()
    self:FindAllComponents()
    self:RegUICallback()
end

function UINewWorldBossCopyForm:OnShowBefore()
    
end

function UINewWorldBossCopyForm:OnShowAfter()
    self:SetCloneList()
    self.StartRefreshTime = true
end

--注册UI上面的事件，比如点击事件等
function UINewWorldBossCopyForm:RegUICallback()
end

function UINewWorldBossCopyForm:BossOnClick(go)
    local _bossID = UIEventListener.Get(go).parameter
    local _bossCfg = DataConfig.DataBossnewWorld[_bossID]
    if _bossCfg then
        local _posList = Utils.SplitStr(_bossCfg.Pos, "_")
        local _pos = Vector2(tonumber(_posList[1]),tonumber(_posList[2]))
        GameCenter.PathSearchSystem:SearchPathToPosBoss(true, _pos, _bossID)
    end
end

--查找组件
function UINewWorldBossCopyForm:FindAllComponents()
    self.CloneGo = UIUtils.FindGo(self.Trans, "Left/Offset/Clone")
    self.CloneRoot = UIUtils.FindTrans(self.Trans, "Left/Offset/CloneRoot")
    self.CloneRootGrid = self.CloneRoot:GetComponent("UIGrid")
    self.CloneRootScrollView = self.CloneRoot:GetComponent("UIScrollView")
end

function UINewWorldBossCopyForm:SetCloneList()
    local _bossIDList = GameCenter.BossSystem.LayerBossIDDic[self.CurLayer]
    if _bossIDList then
        for i=1, #_bossIDList do
            local _go
            if i - 1 < self.CloneRoot.childCount then
                _go = self.CloneRoot:GetChild(i - 1).gameObject
            else
                _go = UnityUtils.Clone(self.CloneGo, self.CloneRoot)
            end
            local _monsterCfg = DataConfig.DataMonster[_bossIDList[i]]
            if _monsterCfg then
                local _nameLab = UIUtils.FindLabel(_go.transform, "Name")
                local _levelLab = UIUtils.FindLabel(_go.transform, "Level")
                _nameLab.text = _monsterCfg.Name
                _levelLab.text = string.format( "Lv.%d", _monsterCfg.Level)
            end
            local _timeLab = UIUtils.FindLabel(_go.transform, "Time")
            self:SetRefreshTime(_timeLab, _bossIDList[i])
            UIEventListener.Get(_go).parameter = _bossIDList[i]
            UIEventListener.Get(_go).onClick = Utils.Handler(self.BossOnClick, self)
            _go:SetActive(true)
        end
    end
end

function UINewWorldBossCopyForm:SetRefreshTime(timeLab, bossID)
    if GameCenter.BossSystem.WorldBossInfoDic:ContainsKey(bossID) then
        local _refreshTime = GameCenter.BossSystem.WorldBossInfoDic[bossID].RefreshTime
        if _refreshTime then
            if _refreshTime <= 0 then
                timeLab.text = DataConfig.DataMessageString.Get("NEWWORLDBOSS_ALIVE")
                timeLab.color = Color.green
            else
                local d, h, m, s = Time.SplitTime(math.floor( _refreshTime ))
                -- local _secound = math.FormatNumber(_refreshTime % 60)
                -- local _minute = math.FormatNumber((_refreshTime // 60) % 60)
                -- local _hour = math.FormatNumber((_refreshTime // 3600) % 60)
                timeLab.text = string.format( "%02d:%02d:%02d", h, m, s)
                timeLab.color = Color.red
            end
        end
    end
end

function UINewWorldBossCopyForm:RefreshLeftListTime()
    for i=0, self.CloneRoot.childCount - 1 do
        local _go = self.CloneRoot:GetChild(i).gameObject
        if _go.activeSelf then
            local _bossID = UIEventListener.Get(_go).parameter
            local _timeLab = UIUtils.FindLabel(_go.transform, "Time")
            self:SetRefreshTime(_timeLab, _bossID)
        end
    end
end

function UINewWorldBossCopyForm:Update(dt)
    if self.StartRefreshTime then
        if self.CurTime > self.RefreshTimeOffset then
            self:RefreshLeftListTime()
        else
            self.CurTime = self.CurTime + dt
        end
    end
end

return UINewWorldBossCopyForm
