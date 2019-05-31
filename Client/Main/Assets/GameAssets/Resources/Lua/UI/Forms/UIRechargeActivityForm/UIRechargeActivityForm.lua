------------------------------------------------
--作者： xihan
--日期： 2019-04-26
--文件： UIRechargeActivityForm.lua
--模块： UIRechargeActivityForm
--描述： 充值活动窗体
------------------------------------------------

--模块定义
local RechargeActivity = {
	--关闭按钮 UIButton
	CloseBtn = nil,
	--背景贴图 UITexture
	BgTexture = nil,
	--当前打开的界面 枚举：RechargeFormDefine.RechargeForm
	Form = RechargeFormDefine.RechargeForm,
	--TouZiForm的参数 --object
	TabForm = nil,
  --UIListMenu
	UIListMenu = nil,
	--UIMoneyForm
	MoenyForm = nil
}

--继承Form函数
function RechargeActivity:OnRegisterEvents()
	self:RegisterEvent(UIEventDefine.UIRechargeActivityForm_OPEN, self.OnOpen);
	self:RegisterEvent(UIEventDefine.UIRechargeActivityForm_CLOSE,self.OnClose);
end

function RechargeActivity:OnFirstShow()
	self:FindAllComponents();
	--注册UI上面的事件，比如点击事件等
	UIUtils.AddBtnEvent(self.CloseBtn, self.OnClickCloseBtn, self)
	-- MoenyForm.SetMoneyList(new int[] { (int)ItemTypeCode.CourageValue, (int)ItemTypeCode.BindMoney, (int)ItemTypeCode.Gold, (int)ItemTypeCode.BindGold, (int)ItemTypeCode.Exp });
	self.MoenyForm:SetMoneyList({13, 2, 3, 4, 8})
	self.CSForm:SetFullScreen(false)
	self.CSForm:AddAlphaAnimation()
	self.CSForm:SetFullScreen(true)
	self.CSForm:SetMustShowMainCamera(true)
end

function RechargeActivity:OnShowBefore()
	GameCenter.RechargeSystem:ReqOpenDayGiftPannel();
end

function RechargeActivity:OnShowAfter()
	self.CSForm:LoadTexture(self.BgTexture, AssetUtils.GetImageAssetPath(ImageTypeCode.UI, "tex_vip_back"));
end

function RechargeActivity:OnHideBefore()
	self.UIListMenu:SetSelectByIndex(-1)
end

--事件触发打开界面
function RechargeActivity:OnOpen(obj, sender)
	self.CSForm:Show(sender)
	self.Form = 0
	if obj then
		if UnityUtils.GetType(obj) == "object[]" then
			if obj.Length == 2 then
				self.Form = obj[0];
				self.TabForm = obj[1];
			end
		else
			self.Form = obj
		end
	end
	self.UIListMenu:SetSelectById(self.Form)
end

--点击界面上关闭按钮
function RechargeActivity:OnClickCloseBtn()
	self:OnClose(nil, nil)
end

--查找UI上各个控件
function RechargeActivity:FindAllComponents()
	-- local _t1 = os.clock()
	self.UIListMenu = UIUtils.RequireUIListMenu(self.Trans:Find("UIListMenu"))
	if not self.UIListMenu.IsInit then
		self.UIListMenu:OnFirstShow(self.CSForm);
		self.UIListMenu:AddIcon(0, DataConfig.DataMessageString.Get("RECHARGE"), FunctionStartIdCode.RechargeForm)
		self.UIListMenu:AddIcon(1, DataConfig.DataMessageString.Get("RECHARGE_ACTIVITY_DAYILY"), FunctionStartIdCode.RechargeDayGift)
		self.UIListMenu:AddIcon(2, DataConfig.DataMessageString.Get("C_RECHARGE_TOUZI"), FunctionStartIdCode.TouZi)
		self.UIListMenu:AddIcon(3, DataConfig.DataMessageString.Get("RECHARGE_GROWTH_PLAN"), FunctionStartIdCode.GrowthPlan)
		self.UIListMenu:AddIcon(4, DataConfig.DataMessageString.Get("C_UI_WELFARE_MONTHCARD"), FunctionStartIdCode.WelfareMonthCard)
		self.UIListMenu:AddIcon(5, DataConfig.DataMessageString.Get("PLAYER_XIAOFEITEQUNA"), FunctionStartIdCode.PlayerLevel)
    end
	self.UIListMenu:AddSelectEvent(Utils.Handler(self.OnMenuSelect, self));
	self.UIListMenu.IsHideIconByFunc = true;
	self.MoenyForm = UnityUtils.RequireComponent(self.Trans:Find("UIMoneyForm"), "Funcell.GameUI.Form.UIMoneyForm");
	self.CloseBtn = self.Trans:Find("Top/CloseBtn"):GetComponent("UIButton")
	-- Debug.LogError("Lua self.CloseBtn.name", self.CloseBtn.gameObject.name)
	self.BgTexture = self.Trans:Find("Center/Texture"):GetComponent("UITexture");
	
	self.BgTexture.gameObject:SetActive(true)
	self.a = self.BgTexture:GetComponent("UISprite");
	self.b = self.BgTexture:GetComponent("UIScrollView");
	self.c = self.BgTexture:GetComponent("UIGrid");
	self.d = self.BgTexture:GetComponent("UILabel");
	-- local _t2 = os.clock()
	-- Debug.LogError("Lua RechargeActivity FindAllComponents =",(_t2 - _t1) * 1000, "/ms")
end

function RechargeActivity:OnMenuSelect(id, b)--int id, bool b
	self.Form = id;
	if b then
		self:OpenSubForm(id);
	else
		self:CloseSubForm(id);
	end
end

function RechargeActivity:OpenSubForm(id)--int id
	if id == 0 then --case (int)RechargeFormDefine.RechargeForm:
		GameCenter.PushFixEvent(UIEventDefine.UIRechargeForm_OPEN, nil, self.CSForm)
	elseif id == 1 then --case (int)RechargeFormDefine.RechargeDayGift:
		GameCenter.PushFixEvent(UIEventDefine.UIRechargeDayGiftForm_OPEN, nil, self.CSForm)
	elseif id == 2 then --case (int)RechargeFormDefine.RechargeDiamond:
		GameCenter.PushFixEvent(UIEventDefine.UITouZiForm_OPEN, self.TabForm, self.CSForm)
	elseif id == 3 then --case (int)RechargeFormDefine.RechargeGrowthPlan:
		GameCenter.PushFixEvent(UIEventDefine.UIGrowthPlanForm_OPEN, nil, self.CSForm)
	elseif id == 4 then --case (int)RechargeFormDefine.Welfare_MonthCard:
		GameCenter.PushFixEvent(UIEventDefine.UIWelfareMonthCardForm_OPEN, nil, self.CSForm)
	elseif id == 5 then --case (int)RechargeFormDefine.VIP:
		GameCenter.PushFixEvent(UIEventDefine.UIPlayerVIPLevelForm_OPEN, nil, self.CSForm)
	end
end

function RechargeActivity:CloseSubForm(id)--int ids
	if id == 0 then--case (int)RechargeFormDefine.RechargeForm:
		GameCenter.PushFixEvent(UIEventDefine.UIRechargeForm_CLOSE)
	elseif id == 1 then--case (int)RechargeFormDefine.RechargeDayGift:
		GameCenter.PushFixEvent(UIEventDefine.UIRechargeDayGiftForm_CLOSE)
	elseif id == 2 then--case (int)RechargeFormDefine.RechargeDiamond:
		GameCenter.PushFixEvent(UIEventDefine.UITouZiForm_CLOSE)
	elseif id == 3 then--case (int)RechargeFormDefine.RechargeGrowthPlan:
		GameCenter.PushFixEvent(UIEventDefine.UIGrowthPlanForm_CLOSE)
	elseif id == 4 then--case (int)RechargeFormDefine.Welfare_MonthCard:
		GameCenter.PushFixEvent(UIEventDefine.UIWelfareMonthCardForm_CLOSE)
	elseif id == 5 then--case (int)RechargeFormDefine.VIP:
		GameCenter.PushFixEvent(UIEventDefine.UIPlayerVIPLevelForm_CLOSE)
	end
end

return RechargeActivity