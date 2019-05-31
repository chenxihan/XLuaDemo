--作者： xc
--日期： 2019-04-17
--文件： NatureBaseDrugData.lua
--模块： NatureBaseDrugData
--描述： 造化吃药通用数据
------------------------------------------------
--引用
local BaseAttrData = require "Logic.Nature.NatureBaseAttrData"

local NatureBaseDrugData = {
    ItemID = 0,--道具ID
    Level = 0,--等级
    PeiyangAtt = nil, --培养属性百分比增长
    LeveLimit = 0, --最大吃多少个升级
    EatNum = 0, --吃了多少个
    AttrList = nil, --属性列表值储存NatureBaseAttrData
    Position = 0, --位置信息
}
NatureBaseDrugData.__index = NatureBaseDrugData

function NatureBaseDrugData:New(info,eatnum)
    local _M = Utils.DeepCopy(self)
    _M.AttrList = List:New()
    _M.Position = info.Position
    _M.ItemId = info.ItemId
    _M:UpDateAttrData(info)
    return _M
end

--设置属性
function NatureBaseDrugData:UpDateAttrData(info)
    local _cs = {';','_'}
    local _attr = Utils.SplitStrByTableS(info.Attribute,_cs)
    self.AttrList:Clear()
    for i=1,#_attr do
        local _data = BaseAttrData:New(_attr[i][1],_attr[i][2],0)
        self.AttrList:Add(_data)
    end
    self.LeveLimit = info.LeveLimit
    local _attr = Utils.SplitStr(info.PeiyangAtt,"_")
    self.PeiyangAtt = {tonumber(_attr[1]),tonumber(_attr[2])}
    self.Level = info.Level
end

return NatureBaseDrugData