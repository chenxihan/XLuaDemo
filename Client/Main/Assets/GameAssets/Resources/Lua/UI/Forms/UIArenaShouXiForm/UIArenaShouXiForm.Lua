
--==============================--
--作者： xihan
--日期： 2019-05-20 20:20:20
--文件： UIArenaShouXiForm.lua
--模块： UIArenaShouXiForm
--描述： 首席竞技场界面
--==============================--
local UIArenaShouXiItem = require("UI.Forms.UIArenaShouXiForm.UIArenaShouXiItem")
local L_ArenaShouXiSystem = GameCenter.ArenaShouXiSystem;

local UIArenaShouXiForm = {
	--剩余次数
	RemainCountLabel = nil,
	--增加次数按钮
	AddCountBtn = nil,
	--我的战力
	MyPowerLabel = nil,
	--我的排名
	MyRankLabel = nil,
	--Item列表
	ItemList = nil,
	--奖励界面按钮
	RewardsBtn = nil,
	--商店按钮
	ShopBtn = nil,
	--战报按钮
	RecordBtn = nil,
	--排行榜按钮
	RankBtn = nil,
	--刷新按钮
	RefreshBtn = nil,
	--刷新文字
	RefreshLab = nil,
	--提示信息
	TipsLab = nil,
}

--注册事件函数, 提供给CS端调用.
function UIArenaShouXiForm:OnRegisterEvents()
	Debug.Log("Lua OnRegisterEvents");
	self:RegisterEvent(UIEventDefine.UIArenaShouXiForm_Open,self.OnOpen);
	self:RegisterEvent(UIEventDefine.UIArenaShouXiForm_Close,self.OnClose);
	GameCenter.RegFixEventHandle(LogicEventDefine.EID_EVENT_JJC_UPDATEPLAYERS, self.RefrshPlayer, self);
	GameCenter.RegFixEventHandle(LogicEventDefine.EID_EVENT_JJC_UPDATECOUNT, self.RefreshLocalPlayer, self);
end

--第一只显示函数, 提供给CS端调用.
function UIArenaShouXiForm:OnFirstShow()
	Debug.Log("Lua OnFirstShow");
	self:FindAllComponents();
end

--显示后的操作, 提供给CS端调用.
function UIArenaShouXiForm:OnShowAfter()
	Debug.Log("Lua OnShowAfter")
	self:LoadTextures();
end

--加载texture
function UIArenaShouXiForm:LoadTextures()

end

function UIArenaShouXiForm:OnOpen(obj, sender)
    self.CSForm:Show(sender)
    if obj ~= nil then
			self.CurPanel = obj[1];
			if obj[2] ~= nil then
      	self.CurData = obj[2];
      end
		end
		L_ArenaShouXiSystem:ReqOpenJJC();
end

--查找所有组件
function UIArenaShouXiForm:FindAllComponents()
	local _myTrans = self.Trans;
	self.RemainCountLabel = UIUtils.FindLabel(_myTrans, "Top/RemainCountLabel");
	self.AddCountBtn = UIUtils.FindBtn(_myTrans, "Top/AddCountBtn");
	self.MyPowerLabel = UIUtils.FindLabel(_myTrans, "Top/MyPowerLabel");
	self.MyRankLabel = UIUtils.FindLabel(_myTrans, "Top/MyRankLabel");

	self.ItemList = List:New();
	for i=1,3 do
		self.ItemList:Add(UIArenaShouXiItem:New(self, UIUtils.FindTrans(_myTrans, "Center/Item_"..i)));
		self.ItemList[i]:OnFirstShow(self.CSForm, FSkinTypeCode.Player);
	end

	self.RewardsBtn = UIUtils.FindBtn(_myTrans, "Bottom/BtnTable/RewardsBtn");
	self.ShopBtn = UIUtils.FindBtn(_myTrans, "Bottom/BtnTable/ShopBtn");
	self.RecordBtn = UIUtils.FindBtn(_myTrans, "Bottom/BtnTable/RecordBtn");
	self.RankBtn = UIUtils.FindBtn(_myTrans, "Bottom/BtnTable/RankBtn");

	self.RefreshBtn = UIUtils.FindBtn(_myTrans, "Bottom/RefreshBtn");
	self.RefreshLab = UIUtils.FindLabel(_myTrans, "Bottom/RefreshBtn/Label");
	self.TipsLab = UIUtils.FindLabel(_myTrans, "Bottom/TipsLab");

	UIUtils.AddBtnEvent(self.AddCountBtn, self.OnClickAddCallBack, self);
	UIUtils.AddBtnEvent(self.RewardsBtn, self.OnClickRewardsCallBack, self);
	UIUtils.AddBtnEvent(self.ShopBtn, self.OnClickShopCallBack, self);
	UIUtils.AddBtnEvent(self.RecordBtn, self.OnClickRecordCallBack, self);
	UIUtils.AddBtnEvent(self.RankBtn, self.OnClickRankCallBack, self);
	UIUtils.AddBtnEvent(self.RefreshBtn, self.OnClickRefreshCallBack, self);
end

--增加次数
function UIArenaShouXiForm:OnClickAddCallBack()
	L_ArenaShouXiSystem:ReqAddChance();
end

--打开奖励界面
function UIArenaShouXiForm:OnClickRewardsCallBack()
	--TODO
end

--打开商店界面
function UIArenaShouXiForm:OnClickShopCallBack()
	--TODO
end

--打开战报界面
function UIArenaShouXiForm:OnClickRecordCallBack()
	--TODO
end

--打开排行榜界面
function UIArenaShouXiForm:OnClickRankCallBack()
	--TODO
end

--刷新挑战者
function UIArenaShouXiForm:OnClickRefreshCallBack()
	L_ArenaShouXiSystem:ReqChangeTarget();
end

--刷新界面
function UIArenaShouXiForm:Refresh()
	--刷新小红点
	-- self.UIListMenu:SetRedPoint(0, GameCenter.AchievementSystem:IsRedPoint());
end

--刷新挑战玩家
function UIArenaShouXiForm:RefreshLocalPlayer()
	self.RemainCountLabel.text = string.format( "剩余次数：%s", L_ArenaShouXiSystem:GetRemainCount());
	self.MyPowerLabel.text = string.format( "我的战力：%s", L_ArenaShouXiSystem:GetScore());
	self.MyRankLabel.text = string.format( "我的排名：%s", L_ArenaShouXiSystem:GetRank());
end


--刷新挑战玩家
function UIArenaShouXiForm:RefrshPlayer()
	local _data = L_ArenaShouXiSystem:GetFightPlayers() or {};
	for i=1,3 do
		if _data[i] then
			self.ItemList[i]:SetData(_data[i]);
			self.ItemList[i]:RefreshData();
		else
			self.ItemList[i]:SetActive(false);
		end
	end
end



return UIArenaShouXiForm;