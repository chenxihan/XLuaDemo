------------------------------------------------
--作者： gzg
--日期： 2019-04-11
--文件： UIUtils.lua
--模块： UIUtils
--描述： 处理UI的一些常用函数
------------------------------------------------
local UIUtils = {};
local UIUtility = CS.Funcell.Plugins.Common.UIUtility;

local L_GetSize = UIUtility.GetSize;
local L_GetSizeX = UIUtility.GetSizeX;
local L_GetSizeY = UIUtility.GetSizeY;
local L_RequireUIPanel = UIUtility.RequireUIPanel;
local L_RequireUILabel =  UIUtility.RequireUILabel;
local L_RequireUISprite = UIUtility.RequireUISprite;
local L_RequireUIButton = UIUtility.RequireUIButton;
local L_RequireUITexture = UIUtility.RequireUITexture;
local L_RequireUISlider = UIUtility.RequireUISlider;
local L_RequireUIScrollView = UIUtility.RequireUIScrollView;
local L_RequireUITable = UIUtility.RequireUITable;
local L_RequireUIGrid = UIUtility.RequireUIGrid;
local L_RequireUIItem = UIUtility.RequireUIItem;
local L_RequireUIListMenu = UIUtility.RequireUIListMenu;
local L_RequireUIRoleSkinCompoent = UIUtility.RequireUIRoleSkinCompoent;
local L_RequireUIIcon = UIUtility.RequireUIIcon;
local L_RequireUIIconBase = UIUtility.RequireUIIconBase;
local L_RequireUIToggle = UIUtility.RequireUIToggle;
local L_RequireSpringPanel = UIUtility.RequireSpringPanel;
local L_RequireEquipmentItem = UIUtility.RequireEquipmentItem;
local L_SetColor = UIUtility.SetColor;

--lua端调用c#的string.Format函数
function UIUtils.CSFormat(original,...)
    return UIUtility.Format(original,...);
end

--添加按钮事件
function UIUtils.AddBtnEvent(btn, method, caller, data)
	btn.onClick:Clear();
    EventDelegate.Add(btn.onClick, Utils.Handler(method, caller, data));
end

--添加改变事件--适合所有带有onChange事件的UI组件
function UIUtils.AddOnChangeEvent(uiComp, method, caller, data)
	uiComp.onChange:Clear();
    EventDelegate.Add(uiComp.onChange, Utils.Handler(method, caller, data));
end

--获取控件size
function UIUtils.GetSize(trans)
	return L_GetSize(trans);
end
--获取控件size.x
function UIUtils.GetSizeX(trans)
	return L_GetSizeX(trans);
end
--获取控件size.y
function UIUtils.GetSizeY(trans)
	return L_GetSizeY(trans);
end

--查找组件
function UIUtils.FindCom(trans, path, type)
	return trans:Find(path):GetComponent(type);
end

--查找trans
function UIUtils.FindTrans(trans,path)
	return trans:Find(path);
end

--查找gameobject
function UIUtils.FindGo(trans,path)
	return trans:Find(path).gameObject;
end

--查找button
function UIUtils.FindBtn(trans,path)
	return trans:Find(path):GetComponent("UIButton");
end

--查找Panel
function UIUtils.FindPanel(trans,path)
	return trans:Find(path):GetComponent("UIPanel");
end

--查找label
function UIUtils.FindLabel(trans,path)
	return trans:Find(path):GetComponent("UILabel");
end

--查找texture
function UIUtils.FindTex(trans,path)
	return trans:Find(path):GetComponent("UITexture");
end

--查找sprite
function UIUtils.FindSpr(trans,path)
	return trans:Find(path):GetComponent("UISprite");
end

--查找widget
function UIUtils.FindWid(trans,path)
	return trans:Find(path):GetComponent("UIWidget");
end

--查找grid
function UIUtils.FindGrid(trans,path)
	return trans:Find(path):GetComponent("UIGrid");
end

--查找table
function UIUtils.FindTable(trans,path)
	return trans:Find(path):GetComponent("UITable");
end

--查找toggle
function UIUtils.FindToggle(trans,path)
	return trans:Find(path):GetComponent("UIToggle");
end

--查找ScrollView
function UIUtils.FindScrollView(trans, path)
	return trans:Find(path):GetComponent("UIScrollView")
end

--查找进度条
function UIUtils.FindProgressBar(trans, path)
	return trans:Find(path):GetComponent("UIProgressBar");
end

--查找可调节的进度条
function UIUtils.FindSlider(trans, path)
	return trans:Find(path):GetComponent("UISlider");
end

--查找Input 组件
function UIUtils.FindInput(trans, path)
	return trans:Find(path):GetComponent("UIInput")
end

--查找TweenPosition组件
function UIUtils.FindTweenPosition(trans, path)
	return trans:Find(path):GetComponent("TweenPosition")
end

--增加 UIPanel 组件
function UIUtils.RequireUIPanel(trans)
	return L_RequireUIPanel(trans);
end

--增加 UILabel 组件
function UIUtils.RequireUILabel(trans)
    return L_RequireUILabel(trans);
end

--增加 UISprite 组件
function UIUtils.RequireUISprite(trans)
    return L_RequireUISprite(trans);
end

--增加 UIButton 组件
function UIUtils.RequireUIButton(trans)
    return L_RequireUIButton(trans);
end

--增加 UITexture 组件
function UIUtils.RequireUITexture(trans)
    return L_RequireUITexture(trans);
end

--增加 UISlider 组件
function UIUtils.RequireUISlider(trans)
    return L_RequireUISlider(trans);
end

--增加 UIScrollView 组件
function UIUtils.RequireUIScrollView(trans)
    return L_RequireUIScrollView(trans);
end

--增加 UITable 组件
function UIUtils.RequireUITable(trans)
    return L_RequireUITable(trans);
end

--增加 UIGrid 组件
function UIUtils.RequireUIGrid(trans)
    return L_RequireUIGrid(trans);
end

--增加 UIItem 组件
function UIUtils.RequireUIItem(trans)
    return L_RequireUIItem(trans);
end

--增加 UIListMenu 组件
function UIUtils.RequireUIListMenu(trans)
    return L_RequireUIListMenu(trans);
end

--增加 UIRoleSkinCompoent 组件
function UIUtils.RequireUIRoleSkinCompoent(trans)
    return L_RequireUIRoleSkinCompoent(trans);
end

--增加 UIIcon 组件
function UIUtils.RequireUIIcon(trans)
    return L_RequireUIIcon(trans);
end

--增加 UIIconBase 组件
function UIUtils.RequireUIIconBase(trans)
    return L_RequireUIIconBase(trans);
end

--增加 UIToggle 组件
function UIUtils.RequireUIToggle(trans)
    return L_RequireUIToggle(trans);
end

--增加 SpringPanel 组件
function UIUtils.RequireSpringPanel(trans)
    return L_RequireSpringPanel(trans);
end

-- 增加 UIEquipmentItem 组件
function UIUtils.RequireEquipmentItem(trans)
	return L_RequireEquipmentItem(trans);
end

--设置颜色(UILable、UITexture、UISprite)
function UIUtils.SetColor(obj, r, g, b, a)
	L_SetColor(obj, r, g, b, a);
end

--设置白色
function UIUtils.SetWhite(obj)
	L_SetColor(obj, 1, 1, 1, 1);
end

--设置灰色
function UIUtils.SetGray(obj)
	L_SetColor(obj, 0.5, 0.5, 0.5, 1);
end

--设置红色
function UIUtils.SetRed(obj)
	L_SetColor(obj, 1, 0, 0, 1);
end

--设置绿色
function UIUtils.SetGreen(obj)
	L_SetColor(obj, 0, 1, 0, 1);
end

--设置蓝色
function UIUtils.SetBlue(obj)
	L_SetColor(obj, 0, 0, 1, 1);
end

--设置黄色
function UIUtils.SetYellow(obj)
	L_SetColor(obj, 1, 0.92, 0.016, 1);
end

return UIUtils;