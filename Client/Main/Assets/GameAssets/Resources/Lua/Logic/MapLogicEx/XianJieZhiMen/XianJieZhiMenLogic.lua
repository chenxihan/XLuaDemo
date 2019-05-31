------------------------------------------------
--作者： 杨全福
--日期： 2019-04-15
--文件： XianJieZhiMenLogic.lua
--模块： XianJieZhiMenLogic
--描述： 仙界之门副本逻辑
------------------------------------------------

local XianJieZhiMenLogic = {
    Parent = nil
}

function XianJieZhiMenLogic:OnEnterScene(parent)
    self.Parent = parent
end

function XianJieZhiMenLogic:OnLeaveScene()
end

return XianJieZhiMenLogic