------------------------------------------------
--作者： _SqL_
--日期： 2019-05-07
--文件： UIFactionSkillForm.lua
--模块： UIFactionSkillForm
--描述： 宗派技能Form
------------------------------------------------
local UISkillRoot = require "UI.Forms.UIFactionSkillForm.Root.UISkillRoot"
local UISkillInfoRoot = require "UI.Forms.UIFactionSkillForm.Root.UISkillInfoRoot"

local UIFactionSkillForm = {
    CloseBtn = nil,
    BackTex = nil,
    -- 技能列表root
    SkillRoot = nil,
    -- 技能信息root
    SkillInfoRoot = nil,
    AnimModule = nil,
}

function UIFactionSkillForm:OnRegisterEvents()
    self:RegisterEvent(UIEventDefine.UIFactionSkillForm_OPEN, self.OnOpen)
    self:RegisterEvent(UIEventDefine.UIFactionSkillForm_CLOSE,self.OnClose)
    self:RegisterEvent(LogicEventDefine.EID_EVENT_REFRESH_FACTIONSKILLS,self.RefreshFactionSkils)
    self:RegisterEvent(LogicEventDefine.EID_EVENT_REFRESH_FACTIONSKILLINFO,self.RefreshSkillInfo)
end

function UIFactionSkillForm:OnFirstShow()
    self:FindAllComponents()
    self:RegUICallback()
end

function UIFactionSkillForm:FindAllComponents()
    local _trans = self.CSForm.transform
    self.AnimModule = UIAnimationModule(_trans)
    self.AnimModule:AddAlphaAnimation()
    self.CloseBtn = UIUtils.FindBtn(_trans, "Top/CloseButton")
    local _skillRoot = UIUtils.FindTrans(_trans, "Left/SkillRoot")
    self.SkillRoot = UISkillRoot:New(self, _skillRoot)
    local _skillInfoTRoot = UIUtils.FindTrans(_trans, "Righ/SkillInfoRoot")
    self.SkillInfoRoot = UISkillInfoRoot:New(self, _skillInfoTRoot)
end

function UIFactionSkillForm:RegUICallback()
    UIUtils.AddBtnEvent(self.CloseBtn, self.OnClose, self)
end

function UIFactionSkillForm:RefreshFactionSkils(obj, sender)
    self.SkillRoot:RefreshSkillList()
end

function UIFactionSkillForm:RefreshSkillInfo(obj, sender)
    if obj then
        self.SkillInfoRoot:RefreshData(obj)
    end
end

function UIFactionSkillForm:OnOpen(obj, sender)
    self.CSForm:Show(sender)
    self.SkillRoot:RefreshSkillList()
    self.AnimModule:PlayEnableAnimation()
end

function UIFactionSkillForm:OnClose(obj, sender)
    self.CSForm:Hide()
end

return UIFactionSkillForm