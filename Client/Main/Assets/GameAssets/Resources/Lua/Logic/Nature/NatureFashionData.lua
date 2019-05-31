--作者： xc
--日期： 2019-04-24
--文件： NatureFashionData.lua
--模块： NatureFashionData
--描述： 造化化形通用数据
------------------------------------------------
local BaseAttrData = require "Logic.Nature.NatureBaseAttrData"

local NatureFashionData = {
    ModelId = 0,--模型ID也是配置表ID
    Name = nil, --名字
    Item = 0, --激活和升级所需模型ID
    AttrList = nil, --属性存储的NatureBaseAttrData
    Level = nil, --等级
    NeedItemNum = 0,--激活或者升星所需道具数量
    Icon = 0, --列表显示的icon
    IsActive = false, --是否激活
    MaxLevel = 0,-- 最大等级
    Fight = 0, --战斗力
    IsRed = false, --是否有红点
    NeedItemList = nil, --道具列表用于升级后设置所需道具
}
NatureFashionData.__index = NatureFashionData

function NatureFashionData:New(info)
    local _M = Utils.DeepCopy(self)
    _M.ModelId = info.Id
    _M.Name = info.Name
    _M.Item = info.ActiveItem
    _M.Level = 0
    _M.NeedItemNum = 0
    _M.Icon = info.Icon
    _M.AttrList = List:New()
    _M.IsActive = false
    _M.MaxLevel = 0
    _M.Fight = 0
    _M.IsRed = false
    local _cs = {';','_'}
    _M.NeedItemList = Utils.SplitStrByTableS(info.StarItemnum,_cs)
    _M:UpDateAttrData(info)
    return _M
end

--设置属性
function NatureFashionData:UpDateAttrData(info)   
    self.MaxLevel = self.NeedItemList[#self.NeedItemList][2]
    local _cs = {';','_'}
    local _attr = Utils.SplitStrByTableS(info.RentAtt,_cs)
    self.AttrList:Clear()
    for i=1,#_attr do
        local _ismax = self.Level >= self.MaxLevel
        local _addattr = _ismax and 0 or _attr[i][3]
        local _attrvalue = 0
        local _pir = 0
        if self.IsActive then
            _pir = self.Level == 0 and 1 or self.Level
            _attrvalue = _attr[i][2]
        else
            _pir = 0
        end
        local _data = BaseAttrData:New(_attr[i][1],_attrvalue + _pir * _addattr,_addattr)
        self.AttrList:Add(_data)
        self:UpDateNeedItem()
    end
end

--更新所需道具
function NatureFashionData:UpDateNeedItem()
    if self.IsActive then
        for i=1,#self.NeedItemList do
            if self.NeedItemList[i][1] == self.Level then
                self.NeedItemNum = self.NeedItemList[i][2]
                break
            end
        end
    else
        self.NeedItemNum = self.NeedItemList[1][2]
    end
end


return NatureFashionData