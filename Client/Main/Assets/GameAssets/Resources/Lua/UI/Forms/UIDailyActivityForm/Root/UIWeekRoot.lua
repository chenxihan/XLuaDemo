------------------------------------------------
--作者： _SqL_
--日期： 2019-04-22
--文件： UIWeekRoot.lua
--模块： UIWeekRoot
--描述： 周历Root
------------------------------------------------
local UIWeekItem = require "UI.Forms.UIDailyActivityForm.Item.UIWeeklItem"

local UIWeekRoot = {
    -- Owner
    Owner = nil,
    -- Trans
    Trans = nil,
    Item = nil,
    ListPanel = nil,
    AnimModule = nil,
}

function UIWeekRoot:New(owner, trans)
    self.Owner = owner
    self.Trans = trans
    self:FindAllComponents()
    self:Close()
    return self
end

function UIWeekRoot:FindAllComponents()
    self.Item = UIUtils.FindTrans(self.Trans, "ListPanel/Item")
    self.ListPanel = UIUtils.FindTrans(self.Trans,"ListPanel")
    self.AnimModule = UIAnimationModule(self.Trans)
    self.AnimModule:AddAlphaAnimation()
end

function UIWeekRoot:RegUICallback()

end

function UIWeekRoot:RefreshWeekActivity()
    local _index = 1
    local _temp = 0
    local _isWhile = true
    local _week = tonumber(os.date("%w", os.time()) )                              -- 0 ~ 6 星期日 ~ 星期六
    while _isWhile do
        for i = 1, 7 do
            local _id = i * 100 + _index
            local _cfg = DataConfig.DataActiveWeek[_id]
            if _cfg == nil then
                _isWhile = false
                break
            end
            local _item = nil
            if _temp < self.ListPanel.childCount then
                _item = UIWeekItem:New(self.ListPanel:GetChild(_temp), _cfg.Id)
            else
                _item = UIWeekItem:Clone(self.Item.gameObject, self.ListPanel, _cfg.Id)
            end
            _item:RefreshWeekly(_week)
            _temp = _temp + 1
        end
        _index = _index + 1
    end
    UnityUtils.GridResetPosition(self.ListPanel)
end

function UIWeekRoot:Show()
    if not self.Trans.gameObject.activeSelf then
        self.Trans.gameObject:SetActive(true)
        self:RefreshWeekActivity()
        self.AnimModule:PlayEnableAnimation()
    end
end

function UIWeekRoot:Close()
    self.Trans.gameObject:SetActive(false)
end

return UIWeekRoot