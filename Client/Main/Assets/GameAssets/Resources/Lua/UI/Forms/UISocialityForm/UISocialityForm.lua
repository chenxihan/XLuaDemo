------------------------------------------------
--作者： _SqL_
--日期： 2019-04-23
--文件： UISocialityForm.lua
--模块： UISocialityForm
--描述： 社交底板
------------------------------------------------
local UIListMenu = require "UI.Components.UIListMenu.UIListMenu"

local UISocialityForm = {
   CloseBtn = nil,
   BackGroundTex = nil,
   ListMenu = nil,
   TitleName = nil,
   AnimModule = nil,
}

function  UISocialityForm:OnRegisterEvents()
    self:RegisterEvent(UIEventDefine.UISocialityForm_OPEN,self.OnOpen)
    self:RegisterEvent(UIEventDefine.UISocialityForm_CLOSE,self.OnClose)
    self:RegisterEvent(LogicEventDefine.EID_EVENT_SOCIALITYREDPOINT,self.UpdateMenuRedPoint)
end

function UISocialityForm:OnFirstShow()
    self:FindAllComponents()
    self:OnRegUICallBack()
end

function UISocialityForm:FindAllComponents()
    local _trans = self.CSForm.transform

    self.AnimModule = UIAnimationModule(_trans)
    self.AnimModule:AddAlphaAnimation()
    self.CloseBtn = UIUtils.FindBtn(_trans, "Right/closeButton")
    self.TitleName = UIUtils.FindLabel(_trans, "Top/FormName/Label")
    self.BackGroundTex = UIUtils.FindTex(_trans, "Center/BG")

    local _listTrans = UIUtils.FindTrans(_trans, "Right/UIListMenu")
    self.ListMenu = UIListMenu:OnFirstShow(self.CSForm, _listTrans)
    self.ListMenu:AddIcon(SocialityFormSubPanel.Friend, DataConfig.DataMessageString.Get("SOCIAL_FRIEND"), FunctionStartIdCode.Friend)
    self.ListMenu:AddIcon(SocialityFormSubPanel.Mail, DataConfig.DataMessageString.Get("C_UI_SOCIALITY_MAIL"), FunctionStartIdCode.Mail)
end

function UISocialityForm:OnRegUICallBack()
    UIUtils.AddBtnEvent(self.CloseBtn, self.OnCLose, self)
    self.ListMenu:ClearSelectEvent()
    self.ListMenu:AddSelectEvent(Utils.Handler(self.OnSelectCallBack, self))
end

function UISocialityForm:OnSelectCallBack(id, selected)
    if selected then
        if id == SocialityFormSubPanel.Friend then
            self.TitleName.text = DataConfig.DataMessageString.Get("SOCIAL_FRIEND")
            GameCenter.PushFixEvent(UIEventDefine.UIFriendForm_OPEN, nil, self.CSForm)
        elseif id == SocialityFormSubPanel.Mail then
            self.TitleName.text = DataConfig.DataMessageString.Get("C_UI_SOCIALITY_MAIL")
            GameCenter.PushFixEvent(UIEventDefine.UIMailForm_OPEN, nil, self.CSForm)
            GameCenter.PushFixEvent(UIEventDefine.UICHATPRIVATEFORM_CLOSE)
        end
    else
        if id == SocialityFormSubPanel.Friend then
            GameCenter.PushFixEvent(UIEventDefine.UIFriendForm_CLOSE)
        elseif id == SocialityFormSubPanel.Mail then
            GameCenter.PushFixEvent(UIEventDefine.UIMailForm_CLOSE)
        end
    end
end

function UISocialityForm:UpdateMenuRedPoint(obj, sender)
    local _isSocialMainRedPoint = false
    if GameCenter.MailSystem:CheckHasUnreadMail() then
        _isSocialMainRedPoint = true
        self.ListMenu:SetRedPoint(SocialityFormSubPanel.Mail, true)
    end 
    GameCenter.MainFunctionSystem:SetAlertFlag(FunctionStartIdCode.Sociality, _isSocialMainRedPoint)
end

function UISocialityForm:LoadBgTex()
    self.CSForm:LoadTexture(self.BackGroundTex, AssetUtils.GetImageAssetPath(ImageTypeCode.UI, "bag_back"))
end

function UISocialityForm:OnOpen(obj, sender)
    self.CSForm:Show(sender)
    self:LoadBgTex()
    if obj then
        self.ListMenu:SetSelectById(obj)
    end
    self:UpdateMenuRedPoint(nil)
    --播放开启动画
    self.AnimModule:PlayEnableAnimation()
end

function UISocialityForm:OnCLose(obj, sender)
    self.CSForm:Hide()
    GameCenter.PushFixEvent(UIEventDefine.UICHATPRIVATEFORM_CLOSE)
end

return UISocialityForm