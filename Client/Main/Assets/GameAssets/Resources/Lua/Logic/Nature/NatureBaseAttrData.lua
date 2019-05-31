--作者： xc
--日期： 2019-04-17
--文件： NatureBaseAttrData.lua
--模块： NatureBaseAttrData
--描述： 造化属性显示通用数据
------------------------------------------------
--引用

local NatureBaseAttrData = {
    AttrID = 0,-- 属性ID
    Attr = 0,--当前属性
    AddAttr = 0, --升级属性
    AttrMin = 0, --最小值给神兵用的
}
NatureBaseAttrData.__index = NatureBaseAttrData

function NatureBaseAttrData:New(attrid,attr,addattr)
    local _M = Utils.DeepCopy(self)
    _M.AttrID = attrid
    _M.Attr = attr
    _M.AddAttr = addattr
    _M.AttrMin = attr
    return _M
end

return NatureBaseAttrData