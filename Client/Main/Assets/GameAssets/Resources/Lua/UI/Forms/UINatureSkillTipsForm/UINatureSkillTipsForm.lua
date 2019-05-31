--作者： xc
--日期： 2019-04-16
--文件： UINatureSkillTipsForm.lua
--模块： UINatureSkillTipsForm
--描述： 造化面板技能TIPS面板
------------------------------------------------


local UINatureSkillTipsForm = {
    SkillData = nil , -- 技能数据
    CloseBtnButton = nil, --关闭按钮
    BoxCloseButton = nil, --底板关闭
    StateGo = nil, --激活状态
    IconSpr = nil,  --技能图片
    NameLab = nil, --技能名字
    DesLab = nil , -- 技能描述
    NeedLevelLab = nil, --需要等级
}


function UINatureSkillTipsForm:OnRegisterEvents()
	self:RegisterEvent(UIEventDefine.UINatureSkillTipsForm_OPEN, self.OnOpen)
	self:RegisterEvent(UIEventDefine.UINatureSkillTipsForm_CLOSE,self.OnClose)
end

function UINatureSkillTipsForm:OnOpen(skill, sender)
    self.CSForm:Show(sender)
    self.SkillData = skill
    self:RefreshSkill()
end

function UINatureSkillTipsForm:OnClose(obj, sender)
    self.CSForm:Hide()
end

--注册UI上面的事件，比如点击事件等
function UINatureSkillTipsForm:RegUICallback()
	self.CloseBtnButton.onClick:Clear();
	EventDelegate.Add(self.CloseBtnButton.onClick, Utils.Handler(self.CloseBtn, self))
	self.BoxCloseButton.onClick:Clear();
	EventDelegate.Add(self.BoxCloseButton.onClick, Utils.Handler(self.CloseBtn, self))
end

function UINatureSkillTipsForm:CloseBtn()
    self:OnClose(nil)
end

function UINatureSkillTipsForm:OnFirstShow()
    self:FindAllComponents()
    self:RegUICallback()
end

function UINatureSkillTipsForm:FindAllComponents()
    self.CloseBtnButton = UnityUtils.RequireComponent(self.Trans:Find("Skill/CloseBtn"),"UIButton")
    self.BoxCloseButton=  UnityUtils.RequireComponent(self.Trans:Find("Box"),"UIButton")
    self.StateGo = self.Trans:Find("Skill/StateLabel").gameObject
    self.IconSpr = UnityUtils.RequireComponent(self.Trans:Find("Skill/IconBack/Icon"),"Funcell.GameUI.Form.UIIconBase")
    self.NameLab = UnityUtils.RequireComponent(self.Trans:Find("Skill/NameLabel"),"UILabel")
    self.DesLab = UnityUtils.RequireComponent(self.Trans:Find("Skill/DesLabel"),"UILabel")
    self.NeedLevelLab = UnityUtils.RequireComponent(self.Trans:Find("Skill/NeedLv"),"UILabel")
end

--刷新技能信息
function UINatureSkillTipsForm:RefreshSkill()
    self.StateGo:SetActive(not self.SkillData.IsActive)
    if self.SkillData.SkillInfo then
        self.IconSpr:UpdateIcon(self.SkillData.SkillInfo.Icon)
        self.NameLab.text = self.SkillData.SkillInfo.Name
        self.DesLab.text = self.SkillData.SkillInfo.Desc
    end
    if self.SkillData.IsActive then
        self.NeedLevelLab.gameObject:SetActive(false)
        self.IconSpr.IsGray = false
    else
        local _needlevelstr = DataConfig.DataMessageString.Get("MOUNTEXFORM_ZIDONGJIHUO")
        _needlevelstr = UIUtils.CSFormat(_needlevelstr,self.SkillData.NeedLevel)
        self.NeedLevelLab.text = _needlevelstr
        self.NeedLevelLab.gameObject:SetActive(true)
        self.IconSpr.IsGray = true
    end

end

return UINatureSkillTipsForm