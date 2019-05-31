------------------------------------------------
--作者： _SqL_
--日期： 2019-05-07
--文件： UISkillInfoRoot.lua
--模块： UISkillInfoRoot
--描述： 宗派技能信息Root
------------------------------------------------

local UISkillInfoRoot = {
    Owner = nil,
    Trans = nil,
    -- 修炼按钮
    XiuLianBtn = nil,
    -- 一键修炼
    YiJianXiuLianBtn = nil,
    -- 技能Icon
    SkillIcon = nil,
    -- 技能名字
    SkillName = nil,
    -- 技能等级
    SkillLv = nil,
    -- 升级所需资源数量
    UpgradeRes = nil,
    -- 当前拥有数量
    HaveRes = nil,
    HelpBtn = nil,
    ListPanel = nil,
    SkillShowItem = nil,
    -- 技能id 对应配置表
    ID = -1,
}

function  UISkillInfoRoot:New(owner, trans)
    self.Owner = owner
    self.Trans = trans
    self:FindAllComponents()
    self:RegUICallback()
    return self
end


function UISkillInfoRoot:FindAllComponents()
    self.XiuLianBtn = UIUtils.FindBtn(self.Trans, "XiuLianBtn")
    self.YiJianXiuLianBtn = UIUtils.FindBtn(self.Trans, "YiJianXiuLianBtn")
    self.SkillIcon = UIUtils.FindTrans(self.Trans, "Info/Icon")
    self.SkillName = UIUtils.FindLabel(self.Trans, "Info/Name")
    self.SkillLv = UIUtils.FindLabel(self.Trans, "Info/Lv")
    self.UpgradeRes = UIUtils.FindLabel(self.Trans, "Res/UpgradeRes/Value")
    self.HaveRes = UIUtils.FindLabel(self.Trans, "Res/HaveRes/Value")
    self.HelpBtn = UIUtils.FindBtn(self.Trans, "Res/HaveRes/HelpBtn")
    self.ListPanel = UIUtils.FindTrans(self.Trans, "SkillShow/ListPanel")
    self.SkillShowItem = UIUtils.FindTrans(self.Trans, "SkillShow/ListPanel/Item")
end

function UISkillInfoRoot:RefreshData(id)
    local _cfg = DataConfig.DataGuildCollege[id]
    if not _cfg then
        Debug.LogError("DataGuildCollege not contains key = ", id)
        return
    end
    self.ID = id
    self.SkillName.text = _cfg.Name
    self.SkillLv.text = string.format( "Lv  %d/%d", _cfg.Level, GameCenter.FactionSkillSystem:GetSkillMaxLv(_cfg.Type))
    self.UpgradeRes.text = Utils.SplitStr(_cfg.LearningConsumption,"_")[2]
    if GameCenter.GuildSystem.GuildInfo then
        self.HaveRes.text = tostring(GameCenter.GuildSystem.GuildInfo.guildMoney)
    end
    local _icon = UIUtils.RequireUIIconBase(self.SkillIcon)
    _icon:UpdateIcon(_cfg.ICON)
    self:SetProperty(id)
end

function UISkillInfoRoot:SetProperty(id)
    local _skillCfg = DataConfig.DataGuildCollege[id]
    local _s = Utils.SplitStr(_skillCfg.Value,"_")
    local _propertyCfg = DataConfig.DataAttributeAdd[tonumber(_s[1])]
    if _skillCfg.NextLevelID == 0 then
        UIUtils.FindLabel(self.SkillShowItem,"NextValue").text = DataConfig.DataMessageString.Get("C_GUILD_LEVELMAX")
    else
        local _next = DataConfig.DataGuildCollege[_skillCfg.NextLevelID].Value
        UIUtils.FindLabel(self.SkillShowItem,"NextValue").text = Utils.SplitStr(_next,"_")[2]
    end
    UIUtils.FindLabel(self.SkillShowItem,"Name").text = _propertyCfg.Name
    UIUtils.FindLabel(self.SkillShowItem,"CurrValue").text = _s[2]
end

function UISkillInfoRoot:OnStudyBtnClick()
    local _value = tonumber(Utils.SplitStr(DataConfig.DataGuildCollege[self.ID].LearningConsumption,"_")[2])
    if _value < GameCenter.GuildSystem.GuildInfo.guildMoney then
        GameCenter.FactionSkillSystem:ReqStudyFactionSkill(self.ID)
    else
        GameCenter.MsgPromptSystem:ShowPrompt("工会贡献值不够")
    end
end

function UISkillInfoRoot:OnOneKeyStudyBtnClick()
    if GameCenter.FactionSkillSystem:CheckUpgreadSkill() then
        GameCenter.FactionSkillSystem:ReqStudyFactionSkill(0)
    else
        GameCenter.MsgPromptSystem:ShowPrompt("工会贡献值不够") 
    end
end

function UISkillInfoRoot:RegUICallback()
    UIUtils.AddBtnEvent(self.XiuLianBtn, self.OnStudyBtnClick, self)
    UIUtils.AddBtnEvent(self.YiJianXiuLianBtn, self.OnOneKeyStudyBtnClick, self)
end

function UISkillInfoRoot:OnOpen(obj, sender)
    self.CSForm:Show(sender)
end

function UISkillInfoRoot:OnClose(obj, sender)
    self.CSForm:Hide()
end

function UISkillInfoRoot:Clone(obj, parent)
    local _go = GameObject.Instantiate(obj).transform
    if parent then
        _go:SetParent(parent)
    end
    UnityUtils.ResetTransform(_go)
    return _go
end

return UISkillInfoRoot