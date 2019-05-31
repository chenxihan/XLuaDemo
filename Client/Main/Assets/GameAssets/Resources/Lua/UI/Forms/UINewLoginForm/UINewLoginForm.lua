------------------------------------------------
--作者： gzg
--日期： 2019-04-18
--文件： UINewLoginForm.lua
--模块： UINewLoginForm
--描述： 新的游戏登陆窗体
------------------------------------------------
local UIEnterGamePanel = require("UI.Forms.UINewLoginForm.UIEnterGamePanel.UIEnterGamePanel");
local UIInputAccountPanel = require("UI.Forms.UINewLoginForm.UIInputAccountPanel.UIInputAccountPanel");

local UINewLoginForm = {

    --Logo图片 UITexture
    TexLogoTexture = nil,
    --背景特效的节点 Transform
    VfxNodeTrans = nil,
    --游戏分级的标识 UITexture
    LevelTagTexture = nil,

    --提示消息的GameObject
    MsgContainerGO = nil,
    --提示消息的Label
    MsgLabel = nil,        

    --输入账号的面板
    InputAccountPanel= nil,
    --进入游戏的面板
    EnterGamePanel = nil,


};

--继承Form函数
function UINewLoginForm:OnRegisterEvents()
    self:RegisterEvent(UIEventDefine.UINEWLOGINFORM_OPEN,self.OnOpen);
    self:RegisterEvent(UIEventDefine.UINEWLOGINFORM_CLOSE,self.OnClose);
    
    self:RegisterEvent(LogicEventDefine.EID_EVENT_LOGIN_HIDE_BTNS,self.OnHideBtns);
    self:RegisterEvent(LogicEventDefine.EID_EVENT_LOGIN_SHOW_BTNS,self.OnShowBtns);
    self:RegisterEvent(LogicEventDefine.EID_EVENT_LOGIN_STATUS,self.OnLoginStatus);
    self:RegisterEvent(LogicEventDefine.EID_EVENT_LOGINFORM_PLAYVFX,self.OnPlayVfx);
    self:RegisterEvent(LogicEventDefine.EID_EVENT_LOGINFORM_STOPYVFX,self.OnStopVfx);
    self:RegisterEvent(LogicEventDefine.EID_EVENT_LOGINFORM_CAMERAMOVE,self.OnCameraAction);
    self:RegisterEvent(LogicEventDefine.EID_EVENT_LOGIN_BOOK_OPEN_ANIM,self.OnOpenBookAnim);
    self:RegisterEvent(LogicEventDefine.EID_EVENT_LOGIN_BOOK_CLOSE_ANIM,self.OnCloseBookAnim);

    self:RegisterEvent(LogicEventDefine.EID_EVENT_UIENTERGAMEFORM_REFRESH,self.RefreshEnterGameForm);
end

function UINewLoginForm:OnFirstShow()
    self:FindAllComponents();
    self:RegUICallback();
end

function UINewLoginForm:OnShowBefore()

end

function UINewLoginForm:OnShowAfter()
    self.InputAccountPanel.Show();
end

function UINewLoginForm:OnHideBefore()
    self.EnterGamePanel:Hide();
    self.InputAccountPanel:Hide();
end

--查找所有列表
function UINewLoginForm:FindAllComponents()
    local _myTrans = self.Trans;
    self.TexLogoTexture = _myTrans:Find(""):GetComponent("UITexture");
    self.VfxNodeTrans = _myTrans:Find("");
    self.LevelTagTexture = _myTrans:Find(""):GetComponent("UITexture");

    self.MsgContainerGO = _myTrans:Find("").gameObject;
    self.MsgLabel = _myTrans:Find(""):GetComponent("UILabel");
  
    self.InputAccountPanel = UIInputAccountPanel:Initialize(self,_myTrans:Find(""));
    self.EnterGamePanel = UIEnterGamePanel:Initialize(self,_myTrans:Find(""));
   
    self:RegUICallback();
end

--绑定UI按钮的回调操作
function UINewLoginForm:RegUICallback()

end

function UINewLoginForm:ShowMessage(msg)

end

function UINewLoginForm:OnHideBtns(object,sender)
    
end

function UINewLoginForm:OnShowBtns(object,sender)
    
end

function UINewLoginForm:OnLoginStatus(object,sender)
    
end

function UINewLoginForm:OnPlayVfx(object,sender)
    
end

function UINewLoginForm:OnStopVfx(object,sender)
    
end

function UINewLoginForm:OnCameraAction(object,sender)
    
end

function UINewLoginForm:OnOpenBookAnim(object,sender)
    
end

function UINewLoginForm:OnCloseBookAnim(object,sender)
    
end

function UINewLoginForm:OnCloseBookAnim(object,sender)
    
end

function UINewLoginForm:RefreshEnterGameForm(object,sender)
    
end

return UINewLoginForm;
