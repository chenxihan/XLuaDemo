
--==============================--
--作者： gzg
--日期： 2019-04-19 06:19:18
--文件： UISampleForm.lua
--模块： UISampleForm
--描述： UISampleForm,用于窗体创建的示例类,在创建窗体的时候,可以把以下代码直接复制过去.(可选)
--==============================--


local UISampleForm = {}

--注册事件函数, 提供给CS端调用.
function UISampleForm:OnRegisterEvents()
	Debug.Log("Lua OnRegisterEvents")
end

--Load函数, 提供给CS端调用.
function UISampleForm:OnLoad()
	Debug.Log("Lua OnLoad")
end

--第一只显示函数, 提供给CS端调用.
function UISampleForm:OnFirstShow()
	Debug.Log("Lua OnFirstShow");
	self:FindAllComponents();
	self:RegUICallback();
end

--显示之前的操作, 提供给CS端调用.
function UISampleForm:OnShowBefore()
	Debug.Log("Lua OnShowBefore")
end

--显示后的操作, 提供给CS端调用.
function UISampleForm:OnShowAfter()
	Debug.Log("Lua OnShowAfter")
end

--隐藏之前的操作, 提供给CS端调用.
function UISampleForm:OnHideBefore()
	Debug.Log("Lua OnHideBefore")
end

--隐藏之后的操作, 提供给CS端调用.
function UISampleForm:OnHideAfter()
	Debug.Log("Lua OnHideAfter")
end

--卸载事件的操作, 提供给CS端调用.
function UISampleForm:OnUnRegisterEvents()
	Debug.Log("Lua OnUnRegisterEvents")
end

--UnLoad的操作, 提供给CS端调用.
function UISampleForm:OnUnload()
	Debug.Log("Lua OnUnload")	
end

--窗体卸载的操作, 提供给CS端调用.
function UISampleForm:OnFormDestroy()
	Debug.Log("Lua OnFormDestroy")
end

--查找所有组件
function UISampleForm:FindAllComponents()
    local _myTrans = self.Trans;
end

--绑定UI组件的回调函数
function UISampleForm:RegUICallback()  
   
end

return UISampleForm;