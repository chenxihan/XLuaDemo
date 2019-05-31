
--==============================--
--作者： xihan
--日期： 2019-05-20 20:20:20
--文件： UIArenaForm.lua
--模块： UIArenaForm
--描述： 竞技场底板界面
--==============================--
local UIListMenu = require ("UI.Components.UIListMenu.UIListMenu");

local L_DataAchievementType = DataConfig.DataAchievementType;

local UIArenaForm = {
	--UIListMenu
    UIListMenu = nil,
    --UIButton
    CloseBtn = nil,
    --保存打开的标签
    CurPanel = 0,
    --打开界面所用到的数据
	CurData = nil,
	--title
	TitleLabel = nil,
	--背景
	BackTexture = nil,
}

--注册事件函数, 提供给CS端调用.
function UIArenaForm:OnRegisterEvents()
	Debug.Log("Lua OnRegisterEvents");
	self:RegisterEvent(UIEventDefine.UIArenaForm_Open,self.OnOpen);
	self:RegisterEvent(UIEventDefine.UIArenaForm_Close,self.OnClose);
	-- self:RegisterEvent(LogicEventDefine.EID_EVENT_UPDATE_ACHFORM, self.Refresh);
end

--Load函数, 提供给CS端调用.
function UIArenaForm:OnLoad()
	Debug.Log("Lua OnLoad");
end

--第一只显示函数, 提供给CS端调用.
function UIArenaForm:OnFirstShow()
	Debug.Log("Lua OnFirstShow");
	self:FindAllComponents();
	self:RegUICallback();
end

--绑定UI组件的回调函数
function UIArenaForm:RegUICallback()

end

--显示之前的操作, 提供给CS端调用.
function UIArenaForm:OnShowBefore()
	Debug.Log("Lua OnShowBefore")
end

--显示后的操作, 提供给CS端调用.
function UIArenaForm:OnShowAfter()
	Debug.Log("Lua OnShowAfter")
	self:LoadTextures();
end

--隐藏之前的操作, 提供给CS端调用.
function UIArenaForm:OnHideBefore()
	Debug.Log("Lua OnHideBefore");
end

--隐藏之后的操作, 提供给CS端调用.
function UIArenaForm:OnHideAfter()
	Debug.Log("Lua OnHideAfter");
end

--卸载事件的操作, 提供给CS端调用.
function UIArenaForm:OnUnRegisterEvents()
	Debug.Log("Lua OnUnRegisterEvents");
end

--UnLoad的操作, 提供给CS端调用.
function UIArenaForm:OnUnload()
	Debug.Log("Lua OnUnload");
end

--窗体卸载的操作, 提供给CS端调用.
function UIArenaForm:OnFormDestroy()
	Debug.Log("Lua OnFormDestroy");
end

function UIArenaForm:OnOpen(obj, sender)
    self.CSForm:Show(sender)
    if obj ~= nil then
		self.CurPanel = obj[1];
		if obj[2] ~= nil then
            self.CurData = obj[2];
        end
	end
	self.CurPanel = self.CurPanel or 0;
    self.UIListMenu:RemoveAll();
	self.UIListMenu:AddIcon(0, "PVP", FunctionStartIdCode.ArenaShouXi, "moneybg_1", nil, "moneybg_2");
	self.UIListMenu:SetSelectById(self.CurPanel);
end

--查找所有组件
function UIArenaForm:FindAllComponents()
	local _myTrans = self.Trans;
	self.BackTexture = UIUtils.FindTex(_myTrans, "BgTexture");
	self.UIListMenu = UIListMenu:OnFirstShow(self.CSForm, _myTrans:Find("UIListMenu"));
	self.UIListMenu:ClearSelectEvent();
    self.UIListMenu:AddSelectEvent(Utils.Handler(self.OnClickListMenuCallBack, self));
	self.UIListMenu.IsHideIconByFunc = true;

	self.TitleLabel = UIUtils.FindLabel(_myTrans, "Title");
	UIUtils.AddBtnEvent(UIUtils.FindBtn(_myTrans,"CloseBtn"), function () self:OnClose(); end)
end

--点击listMenu的响应
function UIArenaForm:OnClickListMenuCallBack(id, select)
    if select then
        if id == 0 then
            self.TitleLabel.text = "PVP";
			GameCenter.PushFixEvent(UIEventDefine.UIArenaShouXiForm_Open)
			self.UIListMenu:SetRedPoint(0, GameCenter.ArenaShouXiSystem:IsRedPoint());
		end
    else
        if id == 0 then
			GameCenter.PushFixEvent(UIEventDefine.UIArenaShouXiForm_Close)
        end
    end
end

--加载texture
function UIArenaForm:LoadTextures()
    self.CSForm:LoadTexture(self.BackTexture,AssetUtils.GetImageAssetPath(ImageTypeCode.UI, "bag_back"))
end

--刷新界面
function UIArenaForm:Refresh()
	--刷新小红点
	self.UIListMenu:SetRedPoint(0, GameCenter.AchievementSystem:IsRedPoint());
end

return UIArenaForm;