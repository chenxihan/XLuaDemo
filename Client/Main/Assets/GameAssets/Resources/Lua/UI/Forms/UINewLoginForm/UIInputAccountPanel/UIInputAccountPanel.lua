------------------------------------------------
--作者： gzg
--日期： 2019-04-18
--文件： UIInputAccountPanel.lua
--模块： UIInputAccountPanel
--描述： 输入账号游戏的Panel,
------------------------------------------------

local UIInputAccountPanel = {

    --窗体
    Form = nil,
    --当前Panel的Trans
    Trans = nil,
    --账号输入 UIInput
    AccountInput = nil,
    --密码输入 UIInput 
    PasswordInput = nil,
    --进入游戏的按钮 UIButton
    EnterGameBtn = nil,



};

--面板初始化
function UIInputAccountPanel:Initialize(owner,trans)
    self.Form = owner;
    self.Trans = trans;
    self:FindAllComponents();
    self:RegUICallback();
    return self;
end

--面板展示
function UIInputAccountPanel:Show()   
    self.Trans.gameObject:SetActive(true);
    UIInputAccountPanel:Refresh(); 
end

--面板隐藏
function UIInputAccountPanel:Hide()
    self.Trans.gameObject:SetActive(false);
end

--查找所有列表
function UIInputAccountPanel:FindAllComponents()
    local _myTrans = self.Trans;
    self.AccountInput =  _myTrans:Find(""):GetComponent("UIInput");
    self.PasswordInput = _myTrans:Find(""):GetComponent("UIInput");
    self.EnterGameBtn = _myTrans:Find(""):GetComponent("UIButton");

    self:RegUICallback();
end

--绑定UI按钮的回调操作
function UIInputAccountPanel:RegUICallback()
    self.EnterGameBtn.onClick:Clear();
    EventDelegate.Add(self.EnterGameBtn.onClick, Utils.Handler(self.OnEnterGameBtnClick,self));
end


--刷新UI界面
function UIInputAccountPanel:Refresh(obj, sender)
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

--点击登录按钮,登录到Login服务器
function UIInputAccountPanel:OnEnterGameBtnClick()

    --self.Form:OnLoginStatus(LoginStatus.__CastFrom("CallSDK"));

    --如果是sdk登录
    Debug.Log(" " .. CS.Funcell.Launcher.SDK.SDKBridge.SDKPlatform .. "  " ..  CS.Funcell.Launcher.SDK.SDKPlatform.Normal);
    if (GameCenter.UpdateSystem.IsSDKLogin()) then
        GameCenter.SDKSystem:Login();
        return;
    end

   --登录到Login服务器
   local _account = self.AccountInput.value;
   if (_account == "") then
       Debug.Log("请输入账号");
       self.AccountInput.gameObject:SetActive(true);
       return;
   end  
   self:RecordAccount(_account);
   GameCenter.ServerListSystem.DownloadServerList();
   self:Hide();
   self.Form:ShowMessage("...");
end

function UIInputAccountPanel:RecordAccount(value)
    CS.UnityEngine.PlayerPrefs.SetString("account", value); 
    CS.Funcell.Code.Base.AppData.AccountID = value;
end

function UIInputAccountPanel:GetLocalAccount()
    return CS.UnityEngine.PlayerPrefs.GetString("account","");
end

return UIInputAccountPanel;