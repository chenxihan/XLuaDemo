------------------------------------------------
--作者： 王圣
--日期： 2019-04-30
--文件： RankAttrData.lua
--模块： RankAttrData
--描述： 排行榜属性脚本
------------------------------------------------
--引用
local RankAttrData = {
    --属性Id
    Id = 0,
    --图标Id
    IconId = 0,
    --对应打开的功能id
    FuncId = 0,
    Sort = 0,
    Name = nil,
    --己方属性值
    OwenParam = 0,
    --对方属性值
    OtherParam = 0,
}

function RankAttrData:New()
    local _m = Utils.DeepCopy(self)
    return _m
end

function RankAttrData:SetData(data)
    self.Id = data.id
    local cfg = DataConfig.DataRankCompare[data.id]
    if cfg ~= nil then
        self.IconId = cfg.Pic
        self.Name = cfg.Name
        self.FuncId = cfg.Promote
        self.Sort = cfg.Sort
    end
    self.OwenParam = data.owenValue
    self.OtherParam = data.otherValue
end
return RankAttrData