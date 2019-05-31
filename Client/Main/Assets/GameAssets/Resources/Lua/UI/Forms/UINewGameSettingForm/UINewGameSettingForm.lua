------------------------------------------------
--作者： gzg
--日期： 2019-05-07
--文件： UINewGameSettingForm.lua
--模块： UINewGameSettingForm
--描述： 游戏设置的窗体
------------------------------------------------
local UISettingPanel = require("UI.Forms.UINewGameSettingForm.SettingPanel.UISettingPanel");
local UIFeedBackMainPanel = require("UI.Forms.UINewGameSettingForm.FeedBackPanel.UIFeedBackMainPanel");

local UINewGameSettingForm = {
	--反馈
	FeedBackPanel = nil,
	--设置
	SettingPanel = nil,	
	--背景板
	BgTexture = nil,
};


--注册事件函数, 提供给CS端调用.
function UINewGameSettingForm:OnRegisterEvents()
	self:RegisterEvent(UIEventDefine.UIGameSettingForm_OPEN, self.OnOpen);
    self:RegisterEvent(UIEventDefine.UIGameSettingForm_CLOSE, self.OnClose);
	self:RegisterEvent(LogicEventDefine.EID_EVENT_UPDATEGAMESETTING_FORM, self.OnFormUpdate);
	self:RegisterEvent(LogicLuaEventDefine.EID_FEEDBACK_LIST_CHANGED, self.OnFeedBackListChanged);
	
end

--第一只显示函数, 提供给CS端调用.
function UINewGameSettingForm:OnFirstShow()
	self:FindAllComponents();	
end

--显示后的操作, 提供给CS端调用.
function UINewGameSettingForm:OnShowAfter()
	self:LoadTexture(self.BgTexture,ImageTypeCode.UI,"bag_secon");
	self:ShowSettingPanel();
end

--隐藏之后的操作, 提供给CS端调用.
function UINewGameSettingForm:OnHideAfter()
	self.FeedBackPanel:Hide();
	self.SettingPanel:Hide();
end

--查找所有组件
function UINewGameSettingForm:FindAllComponents()
	local _myTrans = self.Trans;
	self.BgTexture = UIUtils.FindTex(_myTrans,"BGContainer/BackTex");
	self.SettingPanel = UISettingPanel:Initialize(self,_myTrans:Find("SettingPanel"));
	self.FeedBackPanel = UIFeedBackMainPanel:Initialize(self,_myTrans:Find("FeedBackPanel"));
	
end

--展示反馈界面
function UINewGameSettingForm:ShowFeedBackPanel()
	self.FeedBackPanel:Show();
	self.SettingPanel:Hide();
end
--展示设置界面
function UINewGameSettingForm:ShowSettingPanel()
	self.FeedBackPanel:Hide();
	self.SettingPanel:Show();
end

--界面刷新
function UINewGameSettingForm:OnFormUpdate()

end

--反馈列表改变
function UINewGameSettingForm:OnFeedBackListChanged()
	if self.CSForm.IsVisible  and self.FeedBackPanel.IsVisible then
		self.FeedBackPanel:RefreshListPanel();
	end
end
return UINewGameSettingForm;