
--==============================--
--作者： xihan
--日期： 2019-05-20 20:20:20
--文件： UIAchievementForm.lua
--模块： UIAchievementForm
--描述： UIAchievementForm
--==============================--
local UIListMenu = require ("UI.Components.UIListMenu.UIListMenu");
local UITitleListView = require("UI.Components.UITitleListView.UITitleListView");
local UIAchievementBigItem = require("UI.Forms.UIAchievementForm.UIAchievementBigItem");
local UIAchievementSmallItem = require("UI.Forms.UIAchievementForm.UIAchievementSmallItem");
local UICompContainer = require("UI.Components.UICompContainer");

local L_DataAchievementType = DataConfig.DataAchievementType;

local UIAchievementForm = {
	IsInit = false,
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
	--成就界面
	BaseFormTrans = nil,
	------------------[成就界面]------------------------
	--下拉菜单
	UITitleListView = nil,
	--ScrollLeftTrans
	ScrollLeftTrans = nil,
	--ScrollRightTrans
	ScrollRightTrans = nil,
	--ScrollRight
	ScrollRight = nil,
	--成就item容器
	BigItemList = nil,
	--成就item容器
	SmallContainer = nil,
	--成就item容器
	SmallContainerByAll = nil,
	--排序的Table
	UITable = nil,
	--成就总览Transform
	AllViewTrans = nil,
	--成就总览UITable
	UITableByAll = nil,
	--成就总览Scroll
	ScrollRightByAll = nil,
	--名称
	NameLabel = nil,
	--进度条
	ProgressBar = nil,
	--进度
	ProgressLable = nil
}

--注册事件函数, 提供给CS端调用.
function UIAchievementForm:OnRegisterEvents()
	Debug.Log("Lua OnRegisterEvents");
	self:RegisterEvent(UIEventDefine.UIAchievementForm_OPEN,self.OnOpen);
	self:RegisterEvent(UIEventDefine.UIAchievementForm_CLOSE,self.OnClose);
	self:RegisterEvent(LogicEventDefine.EID_EVENT_UPDATE_ACHFORM, self.Refresh);
end

--Load函数, 提供给CS端调用.
function UIAchievementForm:OnLoad()
	Debug.Log("Lua OnLoad");
end

--第一只显示函数, 提供给CS端调用.
function UIAchievementForm:OnFirstShow()
	Debug.Log("Lua OnFirstShow");
	self:FindAllComponents();
	self:RegUICallback();

	--设置上一个大菜单自动收回
	self.UITitleListView:SetAudoShrink(true);
	--设置默认节点，切换大节点时，显示默认的界面
	self.UITitleListView:SetDefaultNode({0})
	--开始时默认选中总览
	self.UITitleListView:SelectNode({0});

	self.IsInit = true;
end

--绑定UI组件的回调函数
function UIAchievementForm:RegUICallback()

end

--显示之前的操作, 提供给CS端调用.
function UIAchievementForm:OnShowBefore()
	Debug.Log("Lua OnShowBefore")
end

--显示后的操作, 提供给CS端调用.
function UIAchievementForm:OnShowAfter()
	Debug.Log("Lua OnShowAfter")
	self:LoadTextures();
	if self.IsInit then
		self.UITitleListView:RefreshAllNode();
	end
end

--隐藏之前的操作, 提供给CS端调用.
function UIAchievementForm:OnHideBefore()
	Debug.Log("Lua OnHideBefore");
end

--隐藏之后的操作, 提供给CS端调用.
function UIAchievementForm:OnHideAfter()
	Debug.Log("Lua OnHideAfter");
end

--卸载事件的操作, 提供给CS端调用.
function UIAchievementForm:OnUnRegisterEvents()
	Debug.Log("Lua OnUnRegisterEvents");
end

--UnLoad的操作, 提供给CS端调用.
function UIAchievementForm:OnUnload()
	Debug.Log("Lua OnUnload");
end

--窗体卸载的操作, 提供给CS端调用.
function UIAchievementForm:OnFormDestroy()
	Debug.Log("Lua OnFormDestroy");
end

function UIAchievementForm:OnOpen(obj, sender)
    self.CSForm:Show(sender)
    if obj ~= nil then
		self.CurPanel = obj[1];
		if obj[2] ~= nil then
            self.CurData = obj[2];
        end
	end
	self.CurPanel = self.CurPanel or 0;
    self.UIListMenu:RemoveAll();
	self.UIListMenu:AddIcon(0, "成就", FunctionStartIdCode.Achievement, "moneybg_1", nil, "moneybg_2");
	self.UIListMenu:SetSelectById(self.CurPanel);
	if self.CurPanel == 0 then
		self:Refresh();
	end
end

--查找所有组件
function UIAchievementForm:FindAllComponents()
	local _myTrans = self.Trans;
	self.BackTexture = UIUtils.FindTex(_myTrans, "BgTexture");
	self.UIListMenu = UIListMenu:OnFirstShow(self.CSForm, _myTrans:Find("UIListMenu"));
	self.UIListMenu:ClearSelectEvent();
    self.UIListMenu:AddSelectEvent(Utils.Handler(self.OnClickListMenuCallBack, self));
	self.UIListMenu.IsHideIconByFunc = true;

	self.TitleLabel = UIUtils.FindLabel(_myTrans, "Title");
	UIUtils.AddBtnEvent(UIUtils.FindBtn(_myTrans,"CloseBtn"), function () self:OnClose(); end)


	------------------------[Achievement]---------------------------

	self.NameLabel = UIUtils.FindLabel(_myTrans, "Base/AllView/AllAchieveVaule/Name");
	self.ProgressBar = UIUtils.FindProgressBar(_myTrans, "Base/AllView/AllAchieveVaule/Progress");
	self.ProgressLable = UIUtils.FindLabel(_myTrans, "Base/AllView/AllAchieveVaule/Progress/Label");

	self.BaseFormTrans = UIUtils.FindGo(_myTrans, "Base");
	self.ScrollLeftTrans = UIUtils.FindTrans(_myTrans, "Base/ScrollLeft");
	local _itemGobj1 = UIUtils.FindGo(_myTrans, "Base/ScrollLeft/Item1");
	local _itemGobj2 = UIUtils.FindGo(_myTrans, "Base/ScrollLeft/Item2");

	self.UITitleListView = UITitleListView:New(self.ScrollLeftTrans, {_itemGobj1, _itemGobj2},GameCenter.AchievementSystem:GetDataTypeDic(),
	Utils.Handler(self.OnCreatFinshedCallBack,self), Utils.Handler(self.OnClickItemCallBack,self), Utils.Handler(self.OnSetTitleListCallBack,self))
	self.UITitleListView:SetIgnoreKeys({0});
	self.UITitleListView:Init();
	--右侧通用的成就Item界面
	self.ScrollRightTrans = UIUtils.FindTrans(_myTrans, "Base/ScrollRight");
	self.ScrollRight = self.ScrollRightTrans:GetComponent("UIScrollView")
	local _tblTrans = UIUtils.FindTrans(_myTrans,"Base/ScrollRight/Table");
	self.UITable = _tblTrans:GetComponent("UITable");
	local _c = UICompContainer:New();
    for i = 0, _tblTrans.childCount - 1 do
        _c:AddNewComponent(UIAchievementSmallItem:New(self, _tblTrans:GetChild(i)));
    end
    _c:SetTemplate();
	self.SmallContainer = _c;

	--成就总览_上
	self.AllViewTrans = UIUtils.FindTrans(_myTrans, "Base/AllView");
	self.BigItemList = List:New();
	local _gridTrans = UIUtils.FindTrans(_myTrans,"Base/AllView/Items");
	for i = 0, _gridTrans.childCount - 1 do
		self.BigItemList:Add(UIAchievementBigItem:New(self, _gridTrans:GetChild(i)));
    end

	--成就总览_下
	_c = UICompContainer:New();
	self.ScrollRightByAll = UIUtils.FindTrans(_myTrans,"Base/AllView/ScrollBottom"):GetComponent("UIScrollView");
	local _TableTransByAll = UIUtils.FindTrans(_myTrans,"Base/AllView/ScrollBottom/Table");
	self.UITableByAll = _TableTransByAll:GetComponent("UITable");
	for i = 0, _TableTransByAll.childCount - 1 do
        _c:AddNewComponent(UIAchievementSmallItem:New(self, _TableTransByAll:GetChild(i)));
    end
    _c:SetTemplate();
	self.SmallContainerByAll = _c;
end

--点击listMenu的响应
function UIAchievementForm:OnClickListMenuCallBack(id, select)
    if select then
        if id == 0 then
            self.TitleLabel.text = "成就";
			self.BaseFormTrans.gameObject:SetActive(true);
			self.UIListMenu:SetRedPoint(0, GameCenter.AchievementSystem:IsRedPoint());
		end
    else
        if id == 0 then
			self.BaseFormTrans.gameObject:SetActive(false);
        end
    end
end

--刷新成就总览数据
function UIAchievementForm:RefreshAchievementDataByAll(item)
	--总览当前中成就值
	local _allCount = GameCenter.AchievementSystem:GetFinishAcievementCount();
	self.ProgressBar.value = _allCount/12000;
	self.ProgressLable.text = string.format( "(%s/%s)",_allCount,12000);

	local  _curData = item.Data;
	local _dataAchievementType = DataConfig.DataAchievementType;
	--总览_上
	for i=1,#_dataAchievementType do
		self.BigItemList[i]:SetData(_dataAchievementType[i]);
		self.BigItemList[i]:RefreshData();
	end
	-- Debug.LogTable(_curData,"MMMMMMMMMMM")
	--总览_下
	self.SmallContainerByAll:EnQueueAll();
	-- Debug.LogTable(_curData,"_curData")
	for _,v in pairs(_curData) do
		for _,vv in pairs(v) do
			self.SmallContainerByAll:DeQueue(vv);
		end
	end
	self.SmallContainerByAll:RefreshAllUIData();

	self.UITableByAll.repositionNow = true;
	self.ScrollRightByAll:ResetPosition();
end

--点击菜单后的响应
function UIAchievementForm:OnClickItemCallBack(item, isSelect)
	-- Debug.LogTable(item);
	-- Debug.Log(isSelect);
	if item.Layer == 1 then
		local _isAll = item.Key == 0 and isSelect;
		self.AllViewTrans.gameObject:SetActive(_isAll);
		self.ScrollRightTrans.gameObject:SetActive(not _isAll);
		if _isAll then
			self:RefreshAchievementDataByAll(item);
		end
	else
		local  _curData = item.Data;
		self.SmallContainer:EnQueueAll();
		for _,v in ipairs(_curData) do
			self.SmallContainer:DeQueue(v);
		end
		self.SmallContainer:RefreshAllUIData();
		self.UITable.repositionNow = true;
		-- self.ScrollRight:ResetPosition();
	end

	item.SelectGO:SetActive(isSelect);
end

--设置菜单
function UIAchievementForm:OnSetTitleListCallBack(item)
	-- Debug.LogTable(item.KeyQueue,"==============")
	if item.Layer == 1 then
		item.RedPointGO:SetActive(GameCenter.AchievementSystem:IsRedPointByType(item.Key));
	else
		item.RedPointGO:SetActive(GameCenter.AchievementSystem:IsRedPointById(item.Key));
	end
end

--创建完成后的初始化
function UIAchievementForm:OnCreatFinshedCallBack(item)
	-- Debug.LogTable(item);
	local _myTrans = item.Trans;
	item.NameLable = UIUtils.FindLabel(_myTrans, "Name");
	item.SelectGO = UIUtils.FindGo(_myTrans, "Select");
	item.RedPointGO = UIUtils.FindGo(_myTrans, "RedPoint");
	if item.Layer == 1 then
		local _dataAchievementType = L_DataAchievementType[item.Key];
		item.NameLable.text = _dataAchievementType.Name;
		--item.RedPointGO:SetActive(GameCenter.AchievementSystem:IsRedPointByType(item.Key));
	elseif item.Layer == 2 then
		item.NameLable.text = item.Data[1].DataAchievementItem.BigTypeName;
		--item.RedPointGO:SetActive(GameCenter.AchievementSystem:IsRedPointById(item.Key));
	end
	item.SelectGO:SetActive(false);
end

--加载texture
function UIAchievementForm:LoadTextures()
    self.CSForm:LoadTexture(self.BackTexture,AssetUtils.GetImageAssetPath(ImageTypeCode.UI, "bag_back"))
end

--刷新界面
function UIAchievementForm:Refresh()
	--刷新所有节点
	self.UITitleListView:RefreshAllNode();
	--刷新当前显示数据
	self.UITitleListView:RefreshSelectInfo();
	--刷新小红点
	self.UIListMenu:SetRedPoint(0, GameCenter.AchievementSystem:IsRedPoint());
end

return UIAchievementForm;