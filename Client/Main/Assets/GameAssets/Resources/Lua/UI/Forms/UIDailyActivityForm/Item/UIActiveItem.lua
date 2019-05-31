------------------------------------------------
--作者： _SqL_
--日期： 2019-04-23
--文件： UIActiveItem.lua
--模块： UIActiveItem
--描述： 活跃度宝箱Item
------------------------------------------------

local UIActiveItem = {
    Trans = nil,
    -- 宝箱iD
    ID = 0,
    -- 箭头
    Flag = nil,
    -- 宝箱打开显示
    Open = nil,
    -- 宝箱关闭显示
    CloseUp = nil,
    -- 红点
    RedPoint = nil,
    -- 宝箱对应的活跃值显示
    Value = nil,
    -- 领奖按钮
    OpenBtn = nil,
    -- 宝箱对应的活跃值
    Active = nil,
}

function UIActiveItem:New(trans,id)
    local _m = Utils.DeepCopy(self)
    _m.Trans = trans
    _m.ID = id
    _m:FindAllComponents()
    _m:RegUICallback()
    _m:Show()
    return _m
end

function UIActiveItem:FindAllComponents()
    self.Open = UIUtils.FindSpr(self.Trans,"Open")
    self.CloseUp = UIUtils.FindSpr(self.Trans,"Close")
    self.RedPoint = UIUtils.FindTrans(self.Trans,"Point")
    self.Value = UIUtils.FindLabel(self.Trans,"Value")
    self.OpenBtn = self.Trans:GetComponent("UIButton")
    self.Flag = UIUtils.FindSpr(self.Trans,"Flag")
    self:Init()
end

function UIActiveItem:Init()
    local _cfg = DataConfig.DataDailyReward[self.ID]
    self.Flag.gameObject:SetActive(true)
    self.Value.text = _cfg.QNeedintegral
    self.Active = _cfg.QNeedintegral
end

-- 刷新宝箱状态
function UIActiveItem:RefreshBoxStatus()
    local _sys = GameCenter.DailyActivitySystem
    local _acitve = DataConfig.DataDailyReward[self.ID].QNeedintegral
    if _sys.CurrActive > _acitve then
        if _sys.ReceiveGiftIDList:Contains(self.ID) then
            self:SetBoxStatus(true, false)
        else
            self:SetBoxStatus(false, true)
        end
    end
end

function UIActiveItem:RegUICallback()
    UIUtils.AddBtnEvent(self.OpenBtn, self.OnOpenBoxClick, self)
end

function UIActiveItem:OnOpenBoxClick()
    if GameCenter.DailyActivitySystem.CurrActive > self.Active then
        GameCenter.DailyActivitySystem:ReqGetActiveReward(self.ID)
    else
        GameCenter.MsgPromptSystem:ShowPrompt("活跃值不够")
    end
end

-- 设置宝箱状态显示
function UIActiveItem:SetBoxStatus(open, prompt)
    self.Open.gameObject:SetActive(open)
    self.CloseUp.gameObject:SetActive(not open)
    self.RedPoint.gameObject:SetActive(prompt)
end

function UIActiveItem:Clone(go, parentTrans, id)
    local obj = UnityUtils.Clone(go,parentTrans).transform
    return self:New(obj, id)
end

function UIActiveItem:Show()
    if not self.Trans.gameObject.activeSelf then
        self.Trans.gameObject:SetActive(true)
        self:RefreshBoxStatus()
    end
end

function UIActiveItem:Close()
    self.Trans.gameObject:SetActive(false)
end

return UIActiveItem