------------------------------------------------
--作者：gzg
--日期：2019-03-25
--文件：Global.lua
--模块：Global
--描述：Lua的一些其他的公共模块存储地方。
------------------------------------------------

--//定义全局变量

--CS端引用
CS = CS
--类
Object = CS.UnityEngine.Object
Camera = CS.UnityEngine.Camera
GameObject = CS.UnityEngine.GameObject
Light = CS.UnityEngine.Light
Material = CS.UnityEngine.Material
Texture = CS.UnityEngine.Texture
-- Vector3 = CS.UnityEngine.Vector3
-- Vector2 = CS.UnityEngine.Vector2
-- Quaternion = CS.UnityEngine.Quaternion
Rect = CS.UnityEngine.Rect
UIEventListener = CS.UIEventListener
--枚举
UIEventDefine = CS.Funcell.Plugins.Common.UIEventDefine
EventConstDefine = CS.Funcell.Core.Base.EventConstDefine


-- collectgarbage("collect")
-- local _c1 = collectgarbage("count")*1024;
LogicEventDefine = CS.Funcell.Code.Global.LogicEventDefine
-- collectgarbage("collect")
-- print("888888888888888  ",collectgarbage("count")*1024-_c1);


WelfareDefine = CS.Funcell.Code.Logic.WelfareDefine
ImageTypeCode = CS.Funcell.Core.Asset.ImageTypeCode
FunctionStartIdCode = CS.Funcell.Cfg.Data.FunctionStartIdCode
MsgBoxResultCode = CS.Funcell.Code.Logic.MsgBoxResultCode
RechargeFormDefine = CS.Funcell.Code.Logic.RechargeFormDefine
ItemType = CS.Funcell.Code.Global.ItemType
ItemTypeCode = CS.Funcell.Code.Global.ItemTypeCode
ItemBigType = CS.Funcell.Code.Global.ItemBigType
ItemOpertion = CS.Funcell.Code.Global.ItemOpertion
ContainerType = CS.Funcell.Code.Global.ContainerType
BagCategoryType = CS.Funcell.Code.Global.BagCategoryType
ButtonType = CS.Funcell.Code.Global.ButtonType
EquipButtonType = CS.Funcell.Code.Global.EquipButtonType
QualityCode = CS.Funcell.Code.Global.QualityCode
ItemTipsLocation = CS.Funcell.Code.Global.ItemTipsLocation
ShenwuStoneDefine = CS.Funcell.Code.Global.ShenwuStoneDefine
ObjListType = CS.Funcell.GameUI.Form.ObjListType
MapIconResType = CS.Funcell.GameUI.Form.MapIconResType
EquipmentType = CS.Funcell.Code.Global.EquipmentType
EventDelegate = CS.EventDelegate
AssetUtils = CS.Funcell.Core.Asset.AssetUtils
UIFormRegion = CS.Funcell.Plugins.Common.UIFormRegion;
FriendType = CS.Funcell.Code.Global.FriendType
SocialType = CS.Funcell.Code.Global.SocialType
SocialityFormSubPanel = CS.Funcell.Code.Global.SocialityFormSubPanel

ItemModel = CS.Funcell.Code.Logic.ItemModel
-- Color = CS.UnityEngine.Color
RoleVEquipTool = CS.Funcell.Code.Logic.RoleVEquipTool
FSkinPartCode = CS.Funcell.Core.Asset.FSkinPartCode
Time = CS.UnityEngine.Time
--CommonUtils = CS.Funcell.Code.Logic.CommonUtils
TaskType = CS.Funcell.Code.Logic.TaskType
TaskBeHaviorType = CS.Funcell.Code.Logic.TaskBeHaviorType
FSkinTypeCode = CS.Funcell.Code.Logic.FSkinTypeCode
LayerUtils = CS.Funcell.Core.Asset.LayerUtils
ModelTypeCode = CS.Funcell.Core.Asset.ModelTypeCode
AllBattleProp =  CS.Funcell.Code.Global.AllBattleProp
Occupation =  CS.Funcell.Code.Global.Occupation
MainFuncUpdateType = CS.Funcell.Code.Logic.MainFuncUpdateType
MainFormSubPanel = CS.Funcell.Code.Global.MainFormSubPanel
MainLeftSubPanel = CS.Funcell.Code.Global.MainLeftSubPanel
GuideTriggerType = CS.Funcell.Code.Logic.GuideTriggerType
CopyMainFormSubPanel = CS.Funcell.Code.Global.CopyMainFormSubPanel
PromptNewFunctionType = CS.Funcell.Code.Logic.PromptNewFunctionType
UIUtility = CS.Funcell.Plugins.Common.UIUtility
UIAnimationModule = CS.Funcell.Plugins.Common.UIAnimationModule
GameSettingKeyCode = CS.Funcell.Code.Logic.GameSettingKeyCode;
NoticeType = CS.Funcell.Code.Logic.NoticeType;


--时间相关函数
Time = require("Common.CustomLib.Utility.Time");
--==Utility==--
--数学函数
require("Common.CustomLib.Utility.Math");
--Vector2
Vector2 = require("Common.CustomLib.Utility.Vector2")
--Vector3
Vector3 = require("Common.CustomLib.Utility.Vector3")
--Vector4
Vector4 = require("Common.CustomLib.Utility.Vector4")
--Quaternion
Quaternion = require("Common.CustomLib.Utility.Quaternion")
--Color
Color = require("Common.CustomLib.Utility.Color")
--lua端对UnityEnging.Debug的封装
Debug = require("Common.CustomLib.Utility.Debug");
--Unity对象操作的函数模块
UnityUtils = require("Common.CustomLib.Utility.UnityUtils");
--UI对象的操作函数模块
UIUtils = require("Common.CustomLib.Utility.UIUtils");
--功能函数模块
Utils = require("Common.CustomLib.Utility.Utils");
--常用的工具类--这里集合一些通用的逻辑方法.
CommonUtils = require("Logic.Base.CommonUtils.CommonUtils")

--==Collections==--
--列表
List = require("Common.CustomLib.Collections.List");
--字典
Dictionary = require("Common.CustomLib.Collections.Dictionary");

--==LuaEventManager==--
--事件管理器
LuaEventManager = require("Common.CustomLib.LuaEventManager.LuaEventManager");

--委托管理
LuaDelegateManager = require("Common.CustomLib.LuaDelegateManager.LuaDelegateManager")

--==KeyCodeSystem==--
--键盘快捷键监听系统
KeyCodeSystem = require("Common.CustomLib.KeyCodeSystem");

--==LuaBehaviourManager==--
--LuaBehaviour管理类
LuaBehaviourManager = require("Common.CustomLib.LuaBehaviourManager.LuaBehaviourManager")

--==ExternalLib==--
--Profiler性能处理器
Profiler = require("Common.ExternalLib.Profiler");
--Memory
Memory = require("Common.ExternalLib.Memory");


--==其他全局定义==--
--枚举定义 (UIEventDefine要在加载该脚本前获取)
UILuaEventDefine = require("UI.Base.UILuaEventDefine");
LogicLuaEventDefine = require("Global.LogicLuaEventDefine");
--配置模块
AppConfig = require("Config.AppConfig");
--配置数据
DataConfig = require("Config.DataConfig");
--文字配置(自动生成的，所有配置表的文字对应该表)

collectgarbage("collect")
local _c1 = collectgarbage("count")*1024;
StringDefines = DataConfig.Load("StringDefines")
collectgarbage("collect")
-- print("888888888888888  ",collectgarbage("count")*1024-_c1);

--游戏中心
GameCenter = require("Global.GameCenter");







