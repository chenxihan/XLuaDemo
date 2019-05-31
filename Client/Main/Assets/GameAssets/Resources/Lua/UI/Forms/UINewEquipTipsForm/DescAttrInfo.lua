------------------------------------------------
--作者： 何健
--日期： 2019-04-22
--文件： DescAttrInfo.lua
--模块： DescAttrInfo
--描述： 装备TIPS上单个属性数据模型
------------------------------------------------

local DescAttrInfo = {
    ID = nil,
    Value = nil
}

function DescAttrInfo:New(id, value)
    local _m = Utils.DeepCopy(self)
    _m.ID = id
    _m.Value = value
    return _m
end
return DescAttrInfo