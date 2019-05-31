------------------------------------------------
--作者： _SqL_
--日期： 2019-04-23
--文件： UIActivityTipsForm.lua
--模块： UIActivityTipsForm
--描述： 活动tips
------------------------------------------------
local UIItem = CS.Funcell.GameUI.Form.UIItem
local ItemBase = CS.Funcell.Code.Logic.ItemBase
local ItemModel = CS.Funcell.Code.Logic.ItemModel

local UIActivityTipsForm = {
    -- 活动ID
    ID = 0,
    -- 活动Info
    Info = nil,
    -- 活动icon 显示组件
    Icon = nil,
    -- 活动名字
    Name = nil,
    -- 活动完成的次数
    Count = nil,
    -- 打开时间Des
    OpenTime = nil,
    -- 奖品展示Des
    GiftDesc = nil,
    -- 组队条件显示
    TeamDesc = nil,
    -- 条件
    ConditionDes = nil,
    -- 活动说明
    ActivityDesc = nil,
    -- Item Trans
    RewardItem = nil,
    -- item parent
    ListPanel = nil,
    -- 前往按钮
    GoBtn = nil,
    -- 关闭按钮
    CloseBtn = nil,
    -- 动画组件
    AnimMoudle = nil,
}

function  UIActivityTipsForm:OnRegisterEvents()
    self:RegisterEvent(UIEventDefine.UIActivityTipsForm_OPEN,self.OnOpen)
    self:RegisterEvent(UIEventDefine.UIActivityTipsForm_CLOSE,self.OnClose)
end

function UIActivityTipsForm:OnFirstShow()
    self:FindAllComponents()
    self:OnRegUICallBack()
end

function UIActivityTipsForm:OnOpen(obj, sender)
    self.CSForm:Show(sender)
    self:InitForm(obj)
    self.AnimMoudle:PlayEnableAnimation()
end

function UIActivityTipsForm:OnCLose(obj, sender)
    self.CSForm:Hide()
end

function UIActivityTipsForm:FindAllComponents()
    local _trans = self.CSForm.transform
    
    self.Name = UIUtils.FindLabel(_trans, "Center/Name")
    self.Count = UIUtils.FindLabel(_trans, "Center/ActiveCount/Num")
    self.OpenTime = UIUtils.FindLabel(_trans, "Center/OpenTiem/Time")
    self.GiftDesc = UIUtils.FindLabel(_trans, "Center/ActivityGift/Content")
    self.TeamDesc = UIUtils.FindLabel(_trans, "Center/TeamDesc/Content")
    self.ConditionDes = UIUtils.FindLabel(_trans, "Center/ConditionDes/Content")
    self.ActivityDesc = UIUtils.FindLabel(_trans, "Center/Desc/Content")
    self.GoBtn = UIUtils.FindBtn(_trans, "Center/GoBtn")
    self.ListPanel = UIUtils.FindTrans(_trans, "Center/Reward/ListPanel")
    self.Item = UIUtils.FindTrans(_trans, "Center/Reward/ListPanel/Item")
    self.CloseBtn = UIUtils.FindBtn(_trans, "Center/CloseBtn")
    self.Icon = UIUtils.RequireUIIconBase(_trans:Find("Center/Icon"))

    self.AnimMoudle = UIAnimationModule(_trans)
    self.AnimMoudle:AddAlphaAnimation()
end

function UIActivityTipsForm:OnRegUICallBack()
    UIUtils.AddBtnEvent(self.GoBtn, self.OnGoBtnClick, self)
    UIUtils.AddBtnEvent(self.CloseBtn, self.OnCLose, self)
end

-- 初始化 活动相关信息
function UIActivityTipsForm:InitForm(info)
    local _cfg = DataConfig.DataDaily[info.ID]
    self.ID = info.ID
    self.Info = Utils.DeepCopy(info)
    self.Icon:UpdateIcon(_cfg.Icon)
    self.Name.text = _cfg.Name
    self.Count.text = string.format("%d/%d", self.Info.Count, _cfg.Times)
    self.OpenTime.text = _cfg.OpenTimeDes
    self.GiftDesc.text = _cfg.Production
    self.TeamDesc.text = _cfg.Team
    self.ConditionDes.text= _cfg.Conditiondes
    self.ActivityDesc.text = _cfg.Description
    self:InitReward( Utils.SplitStr(_cfg.Reward, ";"))
    self.GoBtn.gameObject:SetActive(GameCenter.DailyActivitySystem.AllActivityDic[self.ID].Open)
end

-- 初始化奖励展示
function UIActivityTipsForm:InitReward(items)
    local _index = 0
    for i = 0, self.ListPanel.childCount - 1 do
        self.ListPanel:GetChild(i).gameObject:SetActive(false)
    end
    for k, v in pairs(items) do
        local _itemID = tonumber(v)
        if DataConfig.DataItem[_itemID] == nil then
            if DataConfig.DataPeopleSoul[_itemID] ~= nil then
                self:InitItem(_index, _itemID, true)
            end
        else
            self:InitItem(_index, _itemID, false)
        end
        _index = _index + 1
    end
    UnityUtils.GridResetPosition(self.ListPanel)
end

-- 初始化item
function UIActivityTipsForm:InitItem(index, itemId, isSoul)
    local _item = nil
    local _soulTrans = nil
    if index < self.ListPanel.childCount then
        if isSoul then
            _soulTrans = self.ListPanel:GetChild(index)
        else
            _item = UIUtils.RequireUIItem(self.ListPanel:GetChild(index))
        end
        self.ListPanel:GetChild(index).gameObject:SetActive(true)
    else
        if isSoul then
            _soulTrans = self:Clone(self.Item)

        else
            _item = UIUtils.RequireUIItem(self:Clone(self.Item))
        end
    end
    if _item then
        _item.gameObject:SetActive(true)
        _item:InitializationWithIdAndNum( ItemModel(itemId), 0, false, false)
    elseif _soulTrans then
        _soulTrans.gameObject:SetActive(true)
        self.InitSoulInfo(_soulTrans)
    end
end

-- 初始化灵魂信息
function UIActivityTipsForm:InitSoulInfo(soulTrans)
    local _cfg = DataConfig.DataPeopleSoul[self.ID]
    local _icon = UIUtils.RequireUIItem(soulTrans:Find("Icon"))
    local _name = UIUtils.FindLabel(soulTrans, "Num")
    local _qualitySpr = UIUtils.FindSpr(soulTrans, "Quality")
    local _btn = soulTrans:GetComponent("UIButton")
    _icon:UpdateIcon(_cfg.Icon)
    _name.text = _cfg.Name
    _qualitySpr.spriteName = ItemBase.GetQualitySpriteName(_cfg.Color)
    UIUtils.AddBtnEvent(_btn, self.OnSoulItemBtnClink, self, {cfg = _cfg})
end

function UIActivityTipsForm:OnSoulItemBtnClink(data)
    GameCenter.PeopleSoulSyste:ShowTips(data.cfg, false)
end

-- 前往回掉
function UIActivityTipsForm:OnGoBtnClick()
    self:OnClose()
    GameCenter.PushFixEvent(UIEventDefine.UIDailyActivityForm_CLOSE)
    local _cfg = DataConfig.DataDaily[self.ID]
    if _cfg.OpenType == 2 or _cfg.OpenType == 3 then
        self:Navigate(_cfg.NpcID)
    elseif _cfg.OpenType == 1 then
        self:OpenUI(_cfg)
    end
end

-- 寻路 
function UIActivityTipsForm:Navigate(npcID)
    local _p = GameCenter.GameSceneSystem:GetLocalPlayer()
    if _p ~= nil then
        local _strs = Utils.SplitStr(npcID, ";")
        for i = 1, _strs:Count() do
            local _npcID = Utils.SplitStr(_strs[i])[3]
            if _npcID then
                self:OnCLose()
                GameCenter.PathSearchSystem:SearchPathToNpcTalk(_npcID)
            end
        end
    end
end

-- open UI  or 参加活动
function UIActivityTipsForm:OpenUI(cfg)
    if cfg.OpenUI ~= 0 then
        if cfg.CloneID == 0 then
            GameCenter.MainFunctionSystem:DoFunctionCallBack(cfg.OpenUI, nil)
        else
            if GameCenter.TeamSystem:IsTeamExist() then
                -- GameCenter.MainFunctionSystem:DoFunctionCallBack(cfg.OpenUI, cfg.CloneID)
                GameCenter.DailyActivitySystem:ReqJoinActivity(cfg.Id)
            else
                if cfg.FoundTeam == "0" then
                    -- GameCenter.MainFunctionSystem:DoFunctionCallBack(cfg.OpenUI, cfg.CloneID)
                    GameCenter.DailyActivitySystem:ReqJoinActivity(cfg.Id)
                else
                    GameCenter.MainFunctionSystem:DoFunctionCallBack(cfg.OpenUI, cfg.FoundTeam)
                end
            end
        end
    end
end

function UIActivityTipsForm:Clone(go)
    return UnityUtils.Clone(go).transform
end

return UIActivityTipsForm