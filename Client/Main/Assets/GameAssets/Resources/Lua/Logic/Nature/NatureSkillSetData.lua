------------------------------------------------
--作者： xc
--日期： 2019-04-16
--文件： NatureSkillSetData.lua
--模块： NatureSkillSetData
--描述： 造化面板技能数据
------------------------------------------------
--引用

------------------------------------------------
local NatureSkillSetData = {
    SkillInfo = nil, --配置表技能数据
    IsActive = false, --技能是否激活
    NeedLevel = 0, --技能激活等级
}

NatureSkillSetData.__index = NatureSkillSetData

function NatureSkillSetData:New(natureatt)
    local _M = Utils.DeepCopy(self)
    _M.SkillInfo = DataConfig.DataSkill[natureatt.Skill]
    if not _M.SkillInfo then
        Debug.LogError("NatureSkill  is is nil!!!!!!!!!!!!!!!!",natureatt.Skill)
    end
    _M.IsActive = false
    _M.NeedLevel = natureatt.Id
    return _M
end

return NatureSkillSetData