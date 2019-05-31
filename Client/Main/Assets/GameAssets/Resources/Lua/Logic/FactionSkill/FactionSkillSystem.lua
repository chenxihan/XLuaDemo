
------------------------------------------------
--作者： _SqL_
--日期： 2019-05-08
--文件： FactionSkillSystem.lua
--模块： FactionSkillSystem
--描述： 宗派技能系统
------------------------------------------------

local FactionSkillSystem = {
    -- 是否打开界面
    OpenForm = false,
    -- 是否刷新宗派技能信息
    Refresh = false,
    -- 技能列表
    SkillList = List:New(),
    -- 技能的 最大等级
    SkillMaxLvDic = Dictionary:New(),                   -- 技能的最大等级
}

function FactionSkillSystem:Initialize()
    for k, v in pairs(DataConfig.DataGuildCollege) do
        if v.NextLevelID == 0 then
            self.SkillMaxLvDic[v.Type] = v.Level
        end
    end
end

function FactionSkillSystem:UnInitialize()
    self.SkillList:Clear()
    self.SkillMaxLvDic:Clear()
end

-- 获取技能的最大等级
function FactionSkillSystem:GetSkillMaxLv(id)
    return self.SkillMaxLvDic[id]
end

-- 获取技能的id
function FactionSkillSystem:GetSkillIdByType(t)
    for i = 1, #self.SkillList do
        local _cfg = DataConfig.DataGuildCollege[self.SkillList[i]]
        if _cfg.Type == t then
            return _cfg.Id
        end
    end
end

-- 获取技能列表
function FactionSkillSystem:GetSkillList()
    return self.SkillList
end

-- 检测是有否有可升级的技能   
function FactionSkillSystem:CheckUpgreadSkill()
    local _guildMoney = GameCenter.GuildSystem.GuildInfo.guildMoney
    for i = 1, #self.SkillList do
        local _cfg = DataConfig.DataGuildCollege[self.SkillList[i]]
        local _value = tonumber(Utils.SplitStr(_cfg.LearningConsumption,"_")[2])
        if _value < _guildMoney then
            return true
        end
    end
    return false
end

-- 宗派技能列表返回
function FactionSkillSystem:GS2U_ResFactionSkills(msg)
    if msg.skills then
        self.SkillList:Clear()
        for i = 1, #msg.skills do
            self.SkillList:Add(msg.skills[i])
        end
        table.sort( self.SkillList, function(a, b)
            return a < b
        end)
    end
    if self.OpenForm then
        GameCenter.PushFixEvent(UIEventDefine.UIFactionSkillForm_OPEN)
        self.OpenForm = false
    end
    if self.Refresh then
        GameCenter.PushFixEvent(LogicEventDefine.EID_EVENT_REFRESH_FACTIONSKILLS)
        GameCenter.PushFixEvent(LogicEventDefine.EID_EVENT_REFRESH_FACTIONSKILLINFO)
        self.Refresh = false
    end
end

-- 研究技能  (id=0 一键研究)
function FactionSkillSystem:ReqStudyFactionSkill(id)
    self.Refresh = true
    local _req = {}
    _req.id = id
    GameCenter.Network.Send("MSG_Guild.ReqLearnSkill", _req)
end

-- 请求技能列表
function FactionSkillSystem:ReqFactionSkilList()
    self.OpenForm = true
    GameCenter.Network.Send("MSG_Guild.ReqPlayerLearnSkills",{})
end

return FactionSkillSystem