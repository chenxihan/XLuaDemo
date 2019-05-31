------------------------------------------------
--作者： _SqL_
--日期： 2019-04-22
--文件： UIActiveRoot.lua
--模块： UIActiveRoot
--描述： 活跃度Root
------------------------------------------------
local UIActiveItem = require "UI.Forms.UIDailyActivityForm.Item.UIActiveItem"

local UIActiveRoot = {
    -- Owner
    Owner = nil,
    -- Trans
    Trans = nil,
    -- 宝箱item 父对象
    ListPanel = nil,
    -- 宝箱item
    BoxItem = nil,
    -- 活跃度 进度显示
    ProcessTex = nil,
    -- 宝箱的默认位置 ui上面设置为最后位置 其余宝箱跟据 根据默认位置计算
    DefaultItemPos = nil,
    -- 宝箱列表
    ActiveItemList = List:New(),
}

function UIActiveRoot:New(owner, trans)
    self.Owner = owner
    self.Trans = trans
    self:FindAllComponents()
    self:Close()
    return self
end

function UIActiveRoot:FindAllComponents()
    self.ListPanel = UIUtils.FindTrans(self.Trans, "ListPanel")
    self.BoxItem = UIUtils.FindTrans(self.Trans, "ListPanel/Item")
    self.ProcessTex = UIUtils.FindTex(self.Trans, "Activity/Process")
    if not self.DefaultItemPos then
        self.DefaultItemPos = Vector3(self.ListPanel:GetChild( self.ListPanel.childCount - 1).localPosition)
    end
    self:SetGift()
end

function UIActiveRoot:RegUICallback()

end

-- 设置宝箱
function UIActiveRoot:SetGift()
    local _index = 0
    local _giftCount = GameCenter.DailyActivitySystem.GiftCount
    self.ActiveItemList:Clear()
    for k, v in pairs(DataConfig.DataDailyReward) do
        local _item = nil
        if _index < self.ListPanel.childCount then
            _item = UIActiveItem:New(self.ListPanel:GetChild(_index), k)
        else
            _item = UIActiveItem:Clone(self.BoxItem.gameObject, self.ListPanel, k)
        end
        self.ActiveItemList:Add(_item)
        _index = _index + 1
        local _x = self.DefaultItemPos.x - (self.ProcessTex.width / _giftCount) * (_giftCount - _index)
        UnityUtils.SetLocalPosition(_item.Trans, _x, self.DefaultItemPos.y, self.DefaultItemPos.z)
    end
end

-- 刷星活跃值
function UIActiveRoot:RefreshActive()
    local _system = GameCenter.DailyActivitySystem
    local _giftCount = _system.GiftCount
    local _active = tonumber(DataConfig.DataDailyReward[1].QNeedintegral)

    -- 考虑到曲线增长方式 计算当前活跃度处于那个阶段
    local _index = 1
    for k, v in pairs(DataConfig.DataDailyReward) do
        if tonumber(v.QNeedintegral) < _system.CurrActive then
            _index = _index + 1
            _active = tonumber(DataConfig.DataDailyReward[k + 1].QNeedintegral)
        end 
    end
    local _value = (_index - 1) * (1 / _giftCount) + (_system.CurrActive / _active) / _giftCount
    self.ProcessTex.fillAmount = _value
    for i = 1, self.ActiveItemList:Count() do
        self.ActiveItemList[i]:RefreshBoxStatus()
    end
end

function UIActiveRoot:Show()
    if not self.Trans.gameObject.activeSelf then
        self.Trans.gameObject:SetActive(true)
    end
    self:RefreshActive()
end

function UIActiveRoot:Close()
    self.Trans.gameObject:SetActive(false)
end

return UIActiveRoot