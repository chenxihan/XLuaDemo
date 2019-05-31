------------------------------------------------
--作者： _SqL_
--日期： 2019-05-27
--文件： UIPlayerPropertyData.lua
--模块： UIPlayerPropertyData
--描述： 属性
------------------------------------------------
local UIPlayerPropertyData = {
    Sort = 0,                 -- 排序序号
    PropertyID = 0,           -- 属性id 对应属性表
    Value = 0,                -- 属性值
    Name = nil,                 -- 属性名字
    Show = false,               -- 是否显示
}

function UIPlayerPropertyData:New(info)
    local _m = Utils.DeepCopy(self)
    _m.PropertyID = info.type
    _m.Value = info.value
    _m:RefreshData()
    return _m
end

function UIPlayerPropertyData:RefreshData()
    local _cfg = DataConfig.DataAttributeAdd[self.PropertyID]
    if _cfg then
        self.Name = _cfg.Name
        self.Sort = _cfg.Sorting
        self.Show = _cfg.Hidden == 1
    else
        Debug.LogError("DataAttributeAdd not contains key = ", self.PropertyID)
    end
end

return UIPlayerPropertyData