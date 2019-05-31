------------------------------------------------
--作者： 王圣
--日期： 2019-04-30
--文件： RankCompareData.lua
--模块： RankCompareData
--描述： 排行榜属性对比数据脚本
------------------------------------------------
--引用
local AttrData = require "Logic.Rank.ItemData.RankAttrData"
local RankCompareData = {
    Name = nil,
    Power = 0,
    Level = 0,
    AttrList = List:New()
}

function RankCompareData:New()
    local _m = Utils.DeepCopy(self)
    return _m
end

--设置
function RankCompareData:SetData(msg)
    self.Name = msg.name
    self.Power = msg.power
    self.Level = msg.level
    self.AttrList:Clear()
    for i = 1, #msg.attrs do
        local attr = AttrData:New()
        attr:SetData(msg.attrs[i])
        self.AttrList:Add(attr)
    end
    self.AttrList:Sort(function(a,b) 
        return a.Sort<b.Sort
     end )
end
return RankCompareData