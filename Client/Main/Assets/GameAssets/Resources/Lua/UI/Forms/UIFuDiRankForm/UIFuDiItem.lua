
------------------------------------------------
--作者： 王圣
--日期： 2019-05-10
--文件： UIFuDiItem.lua
--模块： UIFuDiItem
--描述： 福地Item
------------------------------------------------

-- c#类
local UIFuDiItem = {
    Trans = nil,
    Btn = nil,
    Select = nil,
    NameLabel = nil,
    GuildNameLabel = nil,
}

function UIFuDiItem:New(trans)
    if trans == nil then
        return
    end
    local _m = Utils.DeepCopy(self)
    _m.Trans = trans
    _m.Select = trans:Find("Select")
    _m.Btn = trans:GetComponent("UIButton")
    _m.NameLabel = trans:Find("Name"):GetComponent("UILabel")
    _m.GuildNameLabel = trans:Find("GuildName"):GetComponent("UILabel")
    return _m
end
return UIFuDiItem