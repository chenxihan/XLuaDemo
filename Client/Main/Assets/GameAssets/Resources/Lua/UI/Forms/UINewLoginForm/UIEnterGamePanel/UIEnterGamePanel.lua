------------------------------------------------
--作者： gzg
--日期： 2019-04-18
--文件： UIEnterGamePanel.lua
--模块： UIEnterGamePanel
--描述： 进入游戏的Panel,
------------------------------------------------

--进入游戏的窗体
local UIEnterGamePanel = {
    --窗体
    Form = nil,
    --当前Panel的Trans
    Trans = nil,
    --服务器状态 UILabel
    StatusLabel = nil,
    --状态Icon UISprite
    StatusIcon  = nil,
    --当前服务器名 UILabel
    ServerNameLabel = nil,

    --健康游戏公告 UILabel
    ZhonggaoGO = nil,    

    --版号的内容
    BanHaoGO = nil,
    --下部的背景 UITexture 
    BottomBGTexture = nil,


    --切换服务器按钮 UIButton
    ChangeServerBtn = nil,
    --进入游戏按钮 UIButton
    EnterGameBtn = nil,
    --返回登陆 UIButton
    ReturnLoginBtn = nil,
    --这个是打开登录公告的按钮 UIButton
    OpenNoticeBtn = nil,
    --绑定账号的按钮 UIButton 
    BindAccountBtn = nil,

    --当前服务器数据
    CurrentServerData = nil,
};

--面板初始化
function UIEnterGamePanel:Initialize(owner,trans)
    self.Form = owner;
    self.Trans = trans;
    self:FindAllComponents();
    self:RegUICallback();
    return self;
end

--面板展示
function UIEnterGamePanel:Show()
    GameCenter.PushFixEvent(LogicEventDefine.EID_EVENT_LOGINFORM_PLAYVFX);
    self.CSForm:LoadTexture(self.BottomBGTexture, AssetUtils.GetImageAssetPath(ImageTypeCode.UI, "tex_Denglu"));
    UIEnterGamePanel:Refresh(); 
end

--面板隐藏
function UIEnterGamePanel:Hide()

end

--查找所有列表
function UIEnterGamePanel:FindAllComponents()
    local _myTrans = self.Trans;
    self.StatusLabel = _myTrans:Find(""):GetComponent("UILabel");
    self.StatusIcon = _myTrans:Find(""):GetComponent("UISprite");
    self.ServerNameLabel = _myTrans:Find(""):GetComponent("UILabel");
    self.ZhonggaoGO = _myTrans:Find("").gameObject;    
    self.BanHaoGO = _myTrans:Find("").gameObject;
    self.BottomBGTexture = _myTrans:Find(""):GetComponent("UITexture");

    self.ChangeServerBtn = _myTrans:Find(""):GetComponent("UIButton");
    self.EnterGameBtn = _myTrans:Find(""):GetComponent("UIButton");
    self.ReturnLoginBtn = _myTrans:Find(""):GetComponent("UIButton");
    self.OpenNoticeBtn = _myTrans:Find(""):GetComponent("UIButton");
    self.BindAccountBtn = _myTrans:Find(""):GetComponent("UIButton");

    self:RegUICallback();
end

--绑定UI按钮的回调操作
function UIEnterGamePanel:RegUICallback()  
    self.ChangeServerBtn.onClick:Clear();
    EventDelegate.Add(self.ChangeServerBtn.onClick, Utils.Handler(self.OnChangeServerBtnClick,self));

    self.EnterGameBtn.onClick:Clear();
    EventDelegate.Add(self.EnterGameBtn.onClick, Utils.Handler(self.OnEnterGameBtnClick,self));

    self.ReturnLoginBtn.onClick:Clear();
    EventDelegate.Add(self.ReturnLoginBtn.onClick, Utils.Handler(self.OnReturnLoginBtnClick,self));

    self.OpenNoticeBtn.onClick:Clear();
    EventDelegate.Add(self.OpenNoticeBtn.onClick, Utils.Handler(self.OnOpenNoticeBtnClick,self));

    self.BindAccountBtn.onClick:Clear();
    EventDelegate.Add(self.BindAccountBtn.onClick, Utils.Handler(self.OnBindAccountBtnClick,self));
end


--刷新UI界面
function UIEnterGamePanel:Refresh(obj, sender)
    self.CurrentServerData = GameCenter.ServerListSystem.GetCurrentServer();
    local _sDat = self.CurrentServerData;
    self.ServerNameLabel.text = _sDat.Name;
    self.StatusLabel.text = ""
    self.StatusIcon.spriteName = "";

    --if (LanguageConstDefine.CH != LanguageSystem.Lang) then
        self.ZhonggaoGO:SetActive(false);
        self.BanHaoGO:SetActive(false);
    --end
end

--改变服务器的按钮,打开服务器列表
function UIEnterGamePanel:OnChangeServerBtnClick()
    GameCenter.PushFixEvent(UIEventDefine.UISERVERLISTFORM_OPEN);
end

--进入游戏
function UIEnterGamePanel:OnEnterGameBtnClick()
    --非白名单用户并且服务器是维护状态，弹出维护提示
    if ( not GameCenter.LoginSystem.IsWhiteUser and self.CurrentServerData.IsMaintainServer) then

        Debug.Log("Not white User or service is being maintained");
        GameCenter.MsgPromptSystem:ShowMsgBox(DataConfig.DataMessageString.Get("C_LOGIN_SERVER_MAINTAIN"), DataConfig.DataMessageString.Get("C_MSGBOX_OK"));
        return;
    end

    --非白名单用户并且服务器是隐藏状态，弹出提示
    if (not GameCenter.LoginSystem.IsWhiteUser and self.CurrentServerData.IsHideServer) then    
        GameCenter.MsgPromptSystem:ShowMsgBox(DataConfig.DataMessageString.Get("C_LOGIN_SERVER_NOT_FOUND"),DataConfig.DataMessageString.Get("C_MSGBOX_OK"));
        return;
    end

    GameCenter.SDKSystem:SetServerInfo(tostring(self.CurrentServerData.ServerId), self.CurrentServerData.Name);
    GameCenter.LoginSystem:ConnectGameServer(self.CurrentServerData.ServerId);
end

--返回登录--切换账号
function UIEnterGamePanel:OnReturnLoginBtnClick()
    if (not not GameCenter.LoginSystem.LogoutFunc) then

        GameCenter.LoginSystem:OnLogout(
            function()        
                GameCenter.GameSceneSystem.ReturnToLogin();
            end
        );
    
    else
    
        GameCenter.SDKSystem:SDKLogout();
        GameCenter.GameSceneSystem:ReturnToLogin();
    end
end

--打开公告
function UIEnterGamePanel:OnOpenNoticeBtnClick()
    GameCenter.PushFixEvent(UIEventDefine.UI_LOGIN_NOTICE_OPEN, CS.Funcell.Code.Logic.NoticeType.Login);
end

--绑定账号按钮
function UIEnterGamePanel:OnBindAccountBtnClick()

end


return UIEnterGamePanel;