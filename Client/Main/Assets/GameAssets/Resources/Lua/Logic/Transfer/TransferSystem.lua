
------------------------------------------------
--作者： xc
--日期： 2019-04-11
--文件： TransferSystem.lua
--模块： TransferSystem
--描述： 转职系统类
------------------------------------------------
--引用
local TransferDataDb = require "Logic.Transfer.TransferData"

local TransferSystem = {
    TransferData = nil, --转职数据
    SelectTag = 0 --点选目标顺序
}


function TransferSystem:Initialize()
    self.TransferData = TransferDataDb:New()
end

function TransferSystem:UnInitialize()
    
end

function TransferSystem:IsMatchTransferNotValue()
    local _lp = GameCenter.GameSceneSystem:GetLocalPlayer()
    if not _lp then
        return false
    end
    return self:IsMatchTransfer(_lp.PropMoudle)
end

function TransferSystem:IsMatchTransfer(prop)
    if not prop then
        return false
    end
    local _curLevel = prop.Level
    local _levelCfg = DataConfig.DataCharacters[_curLevel]
    if _levelCfg then
        for k,v in pairs(DataConfig.DataChangejob) do
            if prop.Level >= v.LevelCap and prop.GradeLevel < v.LevelCap and v.GenderClass<3  then
                return true
            end
        end
    end
    return false
end
--得到模型ID
function TransferSystem:GetModelCfgId(occ, gradeLv)
	if gradeLv == 0 then
		return 0
	end
	local _cfgId =(occ + 1) * 1000 + gradeLv
	local _cfg = DataConfig.DataChangejob[_cfgId]
	if(not _cfg) then
		return 0
	end
	return _cfg.ModelID
end 

function TransferSystem:OpenTransferUI()
    GameCenter.PushFixEvent(UIEventDefine.UITransferForm_OPEN)
end

function TransferSystem:SetData()
    self.TransferData:SetData()
end

return TransferSystem