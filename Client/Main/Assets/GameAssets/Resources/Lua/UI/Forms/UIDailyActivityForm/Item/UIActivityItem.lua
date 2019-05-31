------------------------------------------------
--作者： _SqL_
--日期： 2019-04-22
--文件： UIActivityItem.lua
--模块： UIActivityItem
--描述： 日常活动Item
------------------------------------------------
local OpenUI = require "UI.Forms.UIActivityTipsForm.UIActivityTipsForm".OpenUI
local Navigate = require "UI.Forms.UIActivityTipsForm.UIActivityTipsForm".Navigate

local UIActivityItem = {
    -- Trans
    Trans = nil,
    -- Icon
    Icon = nil,
    -- 活动名字
    Name = nil,
    -- 活动次数
    ActivityCount = nil,
    -- 加入按钮
    JoinBtn = nil,
    -- 活跃值
    ActiveValue = nil,
    -- 活动ID
    ID = nil,
    -- 活动信息
    Info = nil,
    -- 详细按钮
    DetailBtn = nil,
    -- 已完成 显示
    FinishedSpr = nil,
    -- 开启条件
    OpenCondition = nil,
}

function UIActivityItem:New(trans, info)
    local _m = Utils.DeepCopy(self)
    _m.Trans = trans
    _m.ID = info.ID
    _m.Info = info
    _m:FindAllComponents()
    _m:RegUICallback()
    _m:Show()
    return _m
end

function UIActivityItem:FindAllComponents()
    self.Icon = UIUtils.RequireUIIconBase(UIUtils.FindTrans(self.Trans,"Icon"))
    self.Name = UIUtils.FindLabel(self.Trans,"Name")
    self.JoinBtn = UIUtils.FindBtn(self.Trans,"JoinBtn")
    self.ActiveValue = UIUtils.FindLabel(self.Trans,"Active/Value")
    self.ActivityCount = UIUtils.FindLabel(self.Trans,"Count/Value")
    self.DetailBtn = self.Trans:GetComponent("UIButton")
    self.FinishedSpr = UIUtils.FindSpr(self.Trans, "Finished")
    self.OpenCondition = UIUtils.FindLabel(self.Trans, "OpenCondition")
    self.FinishedSpr.gameObject:SetActive(false)
    self.OpenCondition.gameObject:SetActive(false)
end

-- 刷新活动信息
function UIActivityItem:RefreshInfo()
    local _cfg = DataConfig.DataDaily[self.ID]
    self.Name.text = _cfg.Name
    self.ActiveValue.text = string.format( "%d/%d", self.Info.CurrActive, _cfg.MaxValue)
    self.ActivityCount.text = string.format( "%d/%d", self.Info.Count, _cfg.Times)
    self.Icon:UpdateIcon(_cfg.Icon)
    self:UpdateActivityStatus(_cfg)
end

-- 更新活动状态
function UIActivityItem:UpdateActivityStatus(cfg)
    local _roleLv = GameCenter.GameSceneSystem:GetLocalPlayer().PropMoudle.Level
    if self.Info.Complete then
        self.JoinBtn.gameObject:SetActive(false)
        self.FinishedSpr.gameObject:SetActive(true)
    end
    if self.Info.Open then
        self.JoinBtn.gameObject:SetActive(true)
    else
        self.JoinBtn.gameObject:SetActive(false)
        self.OpenCondition.gameObject:SetActive(true)
        self.OpenCondition.text = cfg.Conditiondes
    end
end

function UIActivityItem:RegUICallback()
    UIUtils.AddBtnEvent(self.JoinBtn, self.OnJoinBtnClick, self)
    UIUtils.AddBtnEvent(self.DetailBtn, self.OnDetailBtnClick, self)
end

-- 参加活动
function UIActivityItem:OnJoinBtnClick()
    GameCenter.PushFixEvent(UIEventDefine.UIDailyActivityForm_CLOSE)
    if self.Info.Enable then
        local _cfg = DataConfig.DataDaily[self.ID]
        if _cfg.OpenType == 2 or _cfg.OpenType == 3 then
            Navigate(_cfg.NpcId)
        elseif _cfg.OpenType == 1 then
            OpenUI(_cfg)
        end
    end
end

-- 打开活动详情界面 UIActivityTipsForm
function UIActivityItem:OnDetailBtnClick()
    if self.Info.Complete then
        GameCenter.MsgPromptSystem:ShowPrompt("今日已完成")
        return
    end
    GameCenter.PushFixEvent(UIEventDefine.UIActivityTipsForm_OPEN, self.Info)
end

function UIActivityItem:Clone(go, parentTrans, id)
    local obj = UnityUtils.Clone(go,parentTrans).transform
    return self:New(obj, id)
end

function UIActivityItem:Show()
    if not self.Trans.gameObject.activeSelf then
        self.Trans.gameObject:SetActive(true)
    end
end

function UIActivityItem:Close()
    self.Trans.gameObject:SetActive(false)
end

return UIActivityItem