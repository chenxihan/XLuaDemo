--作者： xc
--日期： 2019-04-17
--文件： NatureBaseItemData.lua
--模块： NatureBaseItemData
--描述： 造化道具显示通用数据
------------------------------------------------
--引用

local NatureBaseItemData = {
    ItemID = 0,-- 道具ID
    ItemExp = 0,--使用道具提升的经验,有些系统没有这个东西不用读取,有些是表述道具的数量
}
NatureBaseItemData.__index = NatureBaseItemData

function NatureBaseItemData:New(itemid,exp)
    local _M = Utils.DeepCopy(self)
    _M.ItemID = itemid
    _M.ItemExp = exp
    return _M
end

return NatureBaseItemData