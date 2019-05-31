------------------------------------------------
--作者： gzg
--日期： 2019-04-11
--文件： UnityUtils.lua
--模块： UnityUtils
--描述： 操纵Unity对象的一些公共函数
------------------------------------------------

local CSLuaUnityUtility = CS.LuaUnityUtility;
local L_SetParent = CSLuaUnityUtility.SetParent;
local L_SetParentAndReset = CSLuaUnityUtility.SetParentAndReset;
local L_ResetTransform = CSLuaUnityUtility.ResetTransform;
local L_Clone = UIUtility.Clone;
local L_GetObjct2Int = CSLuaUnityUtility.GetObjct2Int;
local L_GetObjct2Byte = CSLuaUnityUtility.GetObjct2Byte;
local L_RequireComponent = CSLuaUnityUtility.RequireComponent;
local L_RequireLuaBehaviour = CSLuaUnityUtility.RequireLuaBehaviour;

local L_SetLocalPosition = CSLuaUnityUtility.SetLocalPosition;
local L_SetLocalPositionY = CSLuaUnityUtility.SetLocalPositionY;
local L_SetLocalRotation = CSLuaUnityUtility.SetLocalRotation;
local L_SetLocalEulerAngles = CSLuaUnityUtility.SetLocalEulerAngles;
local L_SetLocalScale = CSLuaUnityUtility.SetLocalScale;
local L_SetPosition = CSLuaUnityUtility.SetPosition;
local L_SetRotation = CSLuaUnityUtility.SetRotation;
local L_SetAulerAngles = CSLuaUnityUtility.SetAulerAngles;
local L_SetForward = CSLuaUnityUtility.SetForward;
local L_SetUp = CSLuaUnityUtility.SetUp;
local L_SetRight = CSLuaUnityUtility.SetRight;
local L_SetTweenPositionFrom = CSLuaUnityUtility.SetTweenPositionFrom;
local L_SetTweenPositionTo = CSLuaUnityUtility.SetTweenPositionTo;

local UnityUtils = {}

--设置父物体
function UnityUtils.SetParent(child, parent)
    L_SetParent(child, parent);
end

--设置父物体并重置Transform
function UnityUtils.SetParentAndReset(child, parent)
    L_SetParentAndReset(child, parent);
end

--把Transform的本地位置,大小和角度都复位为0
function UnityUtils.ResetTransform(trans)
    L_ResetTransform(trans)
end

--克隆 gameObject [,parent]
function UnityUtils.Clone(gameObject, parent)
    if parent then
        return L_Clone(gameObject, parent)
    else
        return L_Clone(gameObject)
    end
end

--是否使用宏USE_NEW_CFG
function UnityUtils.USE_NEW_CFG()
    return CSLuaUnityUtility.USE_NEW_CFG()
end

--c#的获取类型
function UnityUtils.GetType(obj)
    return CSLuaUnityUtility.GetType(obj)
end

--object类型转int类型，枚举类型转int可以用此函数
function UnityUtils.GetObjct2Int(obj)
    return L_GetObjct2Int(obj)
end

--object类型转byte类型，枚举类型转byte可以用此函数
function UnityUtils.GetObjct2Byte(obj)
    return L_GetObjct2Byte(obj)
end

--根据类型名增加组件（strType：空间名+类名）
function UnityUtils.RequireComponent(trans,strType)
    return L_RequireComponent(trans,strType)
end

--增加 LuaBehaviour 组件
function UnityUtils.RequireLuaBehaviour(trans)
    return L_RequireLuaBehaviour(trans)
end

--------------------------------------[对Transform的操作]------------------------------------------------
--设置Transform的localPosition
function UnityUtils.SetLocalPosition(trans, x, y, z)
    L_SetLocalPosition(trans, x, y, z)
end

--设置Transform的localPositionY
function UnityUtils.SetLocalPositionY(trans, y)
    L_SetLocalPositionY(trans, y)
end

--设置Transform的Localrotation
function UnityUtils.SetLocalRotation(trans, x, y, z, w)
    L_SetLocalRotation(trans, x, y, z, w)
end
--设置Transform的LocalEulerAngles
function UnityUtils.SetLocalEulerAngles(trans, x, y, z)
    L_SetLocalEulerAngles(trans, x, y, z)
end
--设置Transform的localScale
function UnityUtils.SetLocalScale(trans, x, y, z)
    L_SetLocalScale(trans, x, y, z)
end

--设置Transform的position
function UnityUtils.SetPosition(trans, x, y, z)
    L_SetPosition(trans, x, y, z)
end
--设置Transform的rotation
function UnityUtils.SetRotation(trans, x, y, z, w)
    L_SetRotation(trans, x, y, z, w)
end
--设置Transform的eulerAngles
function UnityUtils.SetAulerAngles(trans, x, y, z)
    L_SetAulerAngles(trans, x, y, z)
end

--设置Transform的forward
function UnityUtils.SetForward(trans, x, y, z)
    L_SetForward(trans, x, y, z)
end
--设置Transform的up
function UnityUtils.SetUp(trans, x, y, z)
    L_SetUp(trans, x, y, z)
end
--设置Transform的right
function UnityUtils.SetRight(trans, x, y, z)
    L_SetRight(trans, x, y, z)
end

--设置TweenPosition的from
function UnityUtils.SetTweenPositionFrom(trans, x, y, z)
    L_SetTweenPositionFrom(trans, x, y, z)
end

--设置TweenPosition的to
function UnityUtils.SetTweenPositionTo(trans, x, y, z)
    L_SetTweenPositionTo(trans, x, y, z)
end

-- 调用组件函数
-- 调用UIScrollView.ResetPosition()
function UnityUtils.ScrollResetPosition(trans)
    CSLuaUnityUtility.ScrollResetPosition(trans)
end

-- 调用UIGrid.Reposition()
function UnityUtils.GridResetPosition(trans)
    CSLuaUnityUtility.GridResetPosition(trans)
end

return UnityUtils