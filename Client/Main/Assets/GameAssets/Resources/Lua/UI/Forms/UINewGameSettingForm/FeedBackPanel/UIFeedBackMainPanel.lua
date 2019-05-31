------------------------------------------------
--作者： gzg
--日期： 2019-05-13
--文件： UIFeedBackMainPanel.lua
--模块： UIFeedBackMainPanel
--描述： 玩家反馈的面板
------------------------------------------------
local UIFeedBackInputPanel = require("UI.Forms.UINewGameSettingForm.FeedBackPanel.UIFeedBackInputPanel");
local UIFeedBackListPanel = require("UI.Forms.UINewGameSettingForm.FeedBackPanel.UIFeedBackListPanel");

--定义反馈的面板
local UIFeedBackMainPanel = {
    --是否显示
    IsVisibled = false,
    --所在窗体
    OwnerForm = nil,
    --自身的Transform
    Trans = nil,
    --提交反馈
    DoFeedBackBtn = nil,
    --打开反馈信息
    FeedBackListBtn = nil,
    --上传日志按钮
    UploadLogBtn = nil,
 

    --提交反馈面板
    DoFeedBackPanel = nil,
    --展示反馈信息面板
    FeedBackListPanel = nil,
      --关闭按钮
      CloseBtn = nil,
};

function UIFeedBackMainPanel:Initialize(owner,trans)
    self.OwnerForm = owner;
    self.Trans = trans;
    self:FindAllComponents();
    self:RegUICallback();
    return self;
end

function UIFeedBackMainPanel:Show()
    self.IsVisibled = true;    
    self.Trans.gameObject:SetActive(true);
    self:Refresh();
end

function UIFeedBackMainPanel:Hide()
    self.IsVisibled = false;
    self.Trans.gameObject:SetActive(false);
end


--查找所有组件
function UIFeedBackMainPanel:FindAllComponents()
    local _myTrans = self.Trans;
    self.DoFeedBackBtn =  UIUtils.FindBtn(_myTrans,"Content/Top/DoFeedBackBtn");
    self.FeedBackListBtn =  UIUtils.FindBtn(_myTrans,"Content/Top/FeedBackListBtn");
    self.UploadLogBtn =  UIUtils.FindBtn(_myTrans,"Content/Top/UploadLogBtn");    

    local _tmpTrans =  UIUtils.FindTrans(_myTrans,"Content/Content/DoFeedBackPanel");
    self.DoFeedBackPanel = UIFeedBackInputPanel:Initialize(self,_tmpTrans);

    _tmpTrans =  UIUtils.FindTrans(_myTrans,"Content/Content/FeedBackListPanel");
    self.FeedBackListPanel = UIFeedBackListPanel:Initialize(self,_tmpTrans);
    self.CloseBtn = UIUtils.FindBtn(_myTrans,"Top/CloseBtn");
end

--绑定UI组件的回调函数
function UIFeedBackMainPanel:RegUICallback()
   UIUtils.AddBtnEvent(self.DoFeedBackBtn,self.OnClickDoFeedBackBtn,self);
   UIUtils.AddBtnEvent(self.FeedBackListBtn,self.OnClickFeedBackListBtn,self);
   UIUtils.AddBtnEvent(self.UploadLogBtn,self.OnClickUploadLogBtn,self);
   UIUtils.AddBtnEvent(self.CloseBtn,self.OnClickCloseBtn,self);
end

function UIFeedBackMainPanel:Refresh()
    self:ShowInputPanel();    
end

function UIFeedBackMainPanel:RefreshListPanel()
   if self.FeedBackListPanel.IsVisibled then 
        self.FeedBackListPanel:Refresh();
   end
end

function UIFeedBackMainPanel:ShowInputPanel()
    self.DoFeedBackPanel:Show();
    self.FeedBackListPanel:Hide();
end

function UIFeedBackMainPanel:ShowListPanel()
    self.DoFeedBackPanel:Hide();
    self.FeedBackListPanel:Show();
end



function UIFeedBackMainPanel:OnClickDoFeedBackBtn()
    self:ShowInputPanel();
end

function UIFeedBackMainPanel:OnClickFeedBackListBtn()
    self:ShowListPanel();
end

function UIFeedBackMainPanel:OnClickUploadLogBtn() 
    local pid = tostring(GameCenter.GameSceneSystem:GetLocalPlayerID());     
    if GameCenter.SDKSystem ~= nil then
        --UI_EVENT_OPEN_UPLOAD_LOG_FORM
        GameCenter.SDKSystem:PushFixEvent(301001, pid);
    else
        Debug.LogError("GameCenter.SDKSystem == nil");
    end
end

function UIFeedBackMainPanel:OnClickCloseBtn()
   self.OwnerForm:ShowSettingPanel();
end
return UIFeedBackMainPanel;