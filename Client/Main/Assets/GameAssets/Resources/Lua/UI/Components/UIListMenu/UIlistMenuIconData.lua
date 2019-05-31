------------------------------------------------
--作者： 何健
--日期： 2019-04-15
--文件： UIlistMenuIconData.lua
--模块： UIlistMenuIconData
--描述： 列表菜单中单个子项的数据类
------------------------------------------------
local UIlistMenuIconData ={
    ID = 0,
    Text = nil,
    FuncID = FunctionStartIdCode.MainFuncRoot,
    FuncInfo = nil,
    ShowRedPoint = false,
    NormalSpr = nil,
    SelectSpr = nil,
    SelectSpr2 = nil,
}

function UIlistMenuIconData:New()
    local _m = Utils.DeepCopy(self)
    return _m
end
return UIlistMenuIconData