------------------------------------------------
--作者： xc
--日期： 2019-04-18
--文件： NatureModelData.lua
--模块： NatureModelData
--描述： 造化面板模型数据
------------------------------------------------
--引用

------------------------------------------------
local NatureBaseModelData = {
    Modelid = 0, --配置表模型id
    IsActive = false, --模型是否激活
    Stage = 0, --几阶的模型
    Name = nil, --模型名字
}

NatureBaseModelData.__index = NatureBaseModelData

function NatureBaseModelData:New(natureatt)
    local _M = Utils.DeepCopy(self)
    _M.Modelid = natureatt.ModelID
    _M.IsActive = false
    _M.Stage = natureatt.Id
    _M.Name = natureatt.Name
    return _M
end

return NatureBaseModelData