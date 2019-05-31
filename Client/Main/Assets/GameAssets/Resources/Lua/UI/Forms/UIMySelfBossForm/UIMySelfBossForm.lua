------------------------------------------------
--作者： xc
--日期： 2019-05-10
--文件： UIMySelfBossForm.lua
--模块： UIMySelfBossForm
--描述： 个人BOSS面板
------------------------------------------------
--引用
local UIEventListener = CS.UIEventListener
local NGUITools = CS.NGUITools
local UIItem = require "UI.Components.UIItem"

local UIMySelfBossForm = {
    LeftGrid = nil, --左侧列表
    LeftClone = nil, --左侧克隆体

    EnterLab = nil, --进入显示条件
    FightLab = nil, --战力
    RemainLab = nil, --剩余时间

    ItemGrid = nil, --道具列表
    ItemClone = nil, --道具克隆体

    GotoButton = nil, --进入

    SelectMapId = 0, --当前选择ID
    ReviewTime = 0, -- 剩余时间节点
    OffsetTime = 0.5, --间隔时间更新
    CurTime = 0, --当前时间
}

function UIMySelfBossForm:OnRegisterEvents()
	self:RegisterEvent(UIEventDefine.UIMySelfBossForm_OPEN, self.OnOpen)
	self:RegisterEvent(UIEventDefine.UIMySelfBossForm_CLOSE, self.OnClose)
    self:RegisterEvent(LogicEventDefine.BOSS_EVENT_MYSELF_REMAINTEAM, self.UpDateRemaintime)
end

function UIMySelfBossForm:OnOpen(obj, sender)
    self.CSForm:Show(sender)
end

function UIMySelfBossForm:OnClose(obj, sender)
    self.CSForm:Hide()
end

--注册UI上面的事件，比如点击事件等
function UIMySelfBossForm:RegUICallback()
	self.GotoButton.onClick:Clear()
	EventDelegate.Add(self.GotoButton.onClick, Utils.Handler(self.OnClickGoto, self))
end

function UIMySelfBossForm:OnFirstShow()
    self:FindAllComponents()
    self:RegUICallback()
end


function UIMySelfBossForm:OnShowBefore()
    GameCenter.Network.Send("MSG_Boss.ReqMySelfBossRemainTime")
    self:SetLeftList()
end

function UIMySelfBossForm:OnHideBefore()
end

--更新剩余时间
function UIMySelfBossForm:UpDateRemaintime(time,sender)
    self.ReviewTime = time < GameCenter.HeartSystem.ServerTime and 0 or time - GameCenter.HeartSystem.ServerTime
    self:SetReviewTime()
end

function UIMySelfBossForm:FindAllComponents()
    self.LeftGrid = UIUtils.FindGrid(self.Trans,"Left/Panel/Grid")
    self.LeftClone = UIUtils.FindGo(self.Trans,"Left/Panel/Grid/default")
    self.EnterLab = UIUtils.FindLabel(self.Trans,"Center/EnterDesc/Label")
    self.FightLab = UIUtils.FindLabel(self.Trans,"Center/Fight/Label")
    self.ItemGrid =  UIUtils.FindGrid(self.Trans,"Center/ItemGrid")
    self.ItemClone = UIUtils.FindGo(self.Trans,"Center/ItemGrid/default")
    self.GotoButton = UIUtils.FindBtn(self.Trans,"Bottom/GoTo")
    self.RemainLab = UIUtils.FindLabel(self.Trans,"Bottom/Time/Label")
end

--前往按钮
function UIMySelfBossForm:OnClickGoto()
    --发送消息
    GameCenter.CopyMapSystem:ReqSingleEnterCopyMap(self.SelectMapId);
    GameCenter.PushFixEvent(UIEventDefine.UIBossForm_CLOSE, nil, self.CSForm)
end

--设置左侧列表选项
function UIMySelfBossForm:SetLeftList()
    local _dic = GameCenter.BossSystem.BossPersonal
    local _listobj = NGUITools.AddChilds(self.LeftGrid.gameObject,self.LeftClone,_dic:Count())
    local _index = 0
    _dic:Foreach(
        function(k,v)
            local _go = _listobj[_index]
            local _info = v[1]
            local _name = UIUtils.FindLabel(_go.transform,"Name")
            local _stage = UIUtils.FindLabel(_go.transform,"Stage")
            _name.text = UIUtils.CSFormat(DataConfig.DataMessageString.Get("BOSS_MYSELF_LAYER"),_info.Layer)
            _stage.text = UIUtils.CSFormat(DataConfig.DataMessageString.Get("MOUNT_GROWUP_LAYER"),_info.Layer)
            local _uitoggle = _go.transform:GetComponent("UIToggle")
            UIEventListener.Get(_go).parameter = _info
            UIEventListener.Get(_go).onClick = Utils.Handler( self.OnClickLeftBtn,self)
            if _index == 0 then
                _uitoggle:Set(true)
                self:OnClickLeftBtn(_go)
            else
                _uitoggle:Set(false)
            end
            _index = _index + 1
        end)
    self.LeftGrid:Reposition()
end

--点击左侧列表
function UIMySelfBossForm:OnClickLeftBtn(go)
    local _info = UIEventListener.Get(go).parameter
    self.SelectMapId = _info.Mapsid
    self.EnterLab.text = UIUtils.CSFormat(DataConfig.DataMessageString.Get("BOSS_MYSELF_ENTERLEVEL"),_info.EnterLevel)
    self.FightLab.text = tostring(_info.Power)
    self:SetItem(_info.Drop)
end

--设置显示道具
function UIMySelfBossForm:SetItem(str)
    local _itemList = GameCenter.BossSystem:AnalysisItem(str)
    local _listobj = NGUITools.AddChilds(self.ItemGrid.gameObject,self.ItemClone,#_itemList)
    for i=1,#_itemList do
        local _go = _listobj[i-1]
        local _itemid = _itemList[i]
        local _item = UIItem:New(_go.transform)
        _item.IsShowTips = true
        _item:InItWithCfgid(_itemid, 1,true,true)
    end
    self.ItemGrid:Reposition()
end

--设置剩余时间
function UIMySelfBossForm:SetReviewTime()
    local t1, t2 = math.modf(self.ReviewTime % 60)
    local _secound =  t1
    local _minute = math.FormatNumber((self.ReviewTime // 60) % 60)
    local _hour =  math.FormatNumber((self.ReviewTime // 3600) % 60)
    local _day =  math.FormatNumber((self.ReviewTime // 43200))
    if _day > 0 then --有天数
        local _messagestr = DataConfig.DataMessageString.Get("BOSS_MYSELF_DAYHOUR")
        _messagestr = UIUtils.CSFormat(_messagestr,_day,_hour,_minute)
        self.RemainLab.text = _messagestr
    elseif self.ReviewTime <= 0 then --没有刷新时间
        self.RemainLab.text = DataConfig.DataMessageString.Get("BOSS_MYSELF_NOTTIME")
    else
        local _messagestr = DataConfig.DataMessageString.Get("BOSS_MYSELF_HOURMINUTE")
        _messagestr = UIUtils.CSFormat(_messagestr,_hour,_minute,_secound)
        self.RemainLab.text = _messagestr
    end
end


function UIMySelfBossForm:Update(dt)
    if self.ReviewTime >= 0 then
        if self.CurTime >= self.OffsetTime  then
            self.ReviewTime = GameCenter.BossSystem.MySelfBossRefshTime < GameCenter.HeartSystem.ServerTime and 0 or GameCenter.BossSystem.MySelfBossRefshTime - GameCenter.HeartSystem.ServerTime 
            self:SetReviewTime()
        else
            self.CurTime = self.CurTime + dt
        end
    end
end

return UIMySelfBossForm