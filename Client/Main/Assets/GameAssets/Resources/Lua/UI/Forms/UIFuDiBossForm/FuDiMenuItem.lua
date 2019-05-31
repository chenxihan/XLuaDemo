
------------------------------------------------
--作者： 王圣
--日期： 2019-05-14
--文件： FuDiMenuItem.lua
--模块： FuDiMenuItem
--描述： 福地菜单Item
------------------------------------------------

-- c#类
local FuDiMenuItem = {
    MenuType = 0,
    Trans = nil,
    Btn = nil,
    Select = nil,
}

function FuDiMenuItem:New(trans, type)
    if trans == nil then
        return
    end
    local _m = Utils.DeepCopy(self)
    _m.MenuType = type
    _m.Trans = trans
    _m.Select = trans:Find("Select")
    _m.Btn = trans:GetComponent("UIButton")
    return _m
end
return FuDiMenuItem