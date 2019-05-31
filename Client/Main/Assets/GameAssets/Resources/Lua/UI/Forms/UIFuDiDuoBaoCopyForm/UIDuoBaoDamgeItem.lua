
------------------------------------------------
--作者： 王圣
--日期： 2019-05-18
--文件： UIDuoBaoDamgeItem.lua
--模块： UIDuoBaoDamgeItem
--描述： 福地夺宝伤害排名
------------------------------------------------

-- c#类
local UIDuoBaoDamgeItem = {
    Trans = nil,
    NameLabel = nil,
    DamgeLabel = nil,
}

function UIDuoBaoDamgeItem:New(trans)
    if trans == nil then
        return
    end
    local _m = Utils.DeepCopy(self)
    _m.Trans = trans
    _m.NameLabel = UIUtils.RequireUILabel(trans)
    _m.DamgeLabel = UIUtils.RequireUILabel(trans:Find("Damge"))
    return _m
end
return UIDuoBaoDamgeItem