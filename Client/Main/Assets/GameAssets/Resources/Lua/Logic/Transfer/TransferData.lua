
------------------------------------------------
--作者： xc
--日期： 2019-04-11
--文件： TransferData.lua
--模块： TransferData
--描述： 转职数据
------------------------------------------------

local TransferData = {
    CfgId = 0,
    NextCfgId = 0,
    CurTransLv = 0,
    CanTransfer = false,
    IsMaxTransfer = false,
    IsAccessTask = false,
    Cfg = nil,
    NextCfg = nil,
}

TransferData.__index = TransferData

function TransferData:New()
    local _M = Utils.DeepCopy(self)
    _M:SetData()
    return _M
end

function TransferData:SetData()
    local _p = GameCenter.GameSceneSystem:GetLocalPlayer()
    if _p then
        local _occ = Utils.GetEnumNumber(tostring(_p.Occ))
        self.CfgId = (_occ + 1) * 1000 + _p.GradeLevel
        self.Cfg = DataConfig.DataChangejob[self.CfgId]
        if self.Cfg then
            if _p.Level >= _p.GradeLevel then
                self.NextCfgId = (_occ + 1) * 1000 + self.Cfg.LevelCap;
                self.NextCfg = DataConfig.DataChangejob[self.NextCfgId]
                if self.NextCfg and _p.Level >= self.NextCfg.Level then
                    local _task = GameCenter.TaskManager:GetTransferTask()
                    if _task then
                        local _genderCfg = DataConfig.DataTaskGender[_task.Data.Id]
                        if _genderCfg then
                            self.IsAccessTask = true
                            if _genderCfg.PostTaskId == 0 then
                                self.CanTransfer = true
                            else
                                self.CanTransfer = false
                            end
                        end
                    else
                        self.CanTransfer = false
                        self.IsAccessTask = false
                    end
                    self.CurTransLv = self.Cfg.Level
                end
            elseif self.Cfg.LevelCap == 999 then
                self.IsMaxTransfer = true
            else
                self.NextCfgId = 0
                self.NextCfg = nil
                self.CanTransfer = false
            end
        end
    end
end

return TransferData