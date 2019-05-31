
------------------------------------------------
--作者： 王圣
--日期： 2019-05-14
--文件： FuDiBoxItem.lua
--模块： FuDiBoxItem
--描述： 福地宝箱Item
------------------------------------------------

-- c#类
local FuDiBoxItem = {
    Score = 0,
    Trans = nil,
    Btn = nil,
    LockSpr = nil,
    OpenSpr = nil,
    RedPointSpr = nil,
    TweenPos = nil,
}

function FuDiBoxItem:New(trans, score)
    if trans == nil then
        return
    end
    local _m = Utils.DeepCopy(self)
    _m.Score = score
    _m.Trans = trans
    _m.LockSpr = UIUtils.RequireUIIconBase(trans:Find("Close"))
    _m.OpenSpr = UIUtils.RequireUIIconBase(trans:Find("Open"))
    _m.RedPointSpr = trans:Find("RedPoint")
    _m.Btn = trans:GetComponent("UIButton")
    _m.TweenPos = _m.LockSpr:GetComponent("TweenPosition")
    _m.TweenPos.enabled = false
    return _m
end

function FuDiBoxItem:ReSet()
    self.OpenSpr.gameObject:SetActive(false)
    self.RedPointSpr.gameObject:SetActive(false)
    self:StopShake()
end
--开始摇动
function FuDiBoxItem:StartShake()
    self.TweenPos.enabled = true
end
--停止摇动
function FuDiBoxItem:StopShake()
    self.TweenPos.enabled = false
end
return FuDiBoxItem