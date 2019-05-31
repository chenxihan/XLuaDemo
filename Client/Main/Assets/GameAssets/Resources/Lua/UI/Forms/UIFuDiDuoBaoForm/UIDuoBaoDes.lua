
------------------------------------------------
--作者： 王圣
--日期： 2019-05-17
--文件： UIDuoBaoDes.lua
--模块： UIDuoBaoDes
--描述： 福地夺宝描述
------------------------------------------------

-- c#类
local UIDuoBaoDes = {
    Trans = nil,
    Select = nil,
    DesLabel = nil,
}

function UIDuoBaoDes:New(trans)
    if trans == nil then
        return
    end
    local _m = Utils.DeepCopy(self)
    _m.Trans = trans
    _m.Select = trans:Find("Select")
    _m.Select.gameObject:SetActive(false)
    _m.DesLabel = UIUtils.RequireUILabel(trans:Find("Des"))
    return _m
end
return UIDuoBaoDes