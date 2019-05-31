------------------------------------------------
--作者： gzg
--日期： 2019-03-25
--文件： UIBaseForm.lua
--模块： UIBaseForm
--描述： 定义Form的基础类, 用于在gameObject上挂载Lua脚本
------------------------------------------------

------:::模块定义:::-----------
local UIBaseForm = {}

------:::模块内成员变量定义:::-----------
--设置__index为模块,
UIBaseForm.__index = UIBaseForm

--=======定义静态方法,用于绑定卸载LuaForm的操作========

--绑定
function UIBaseForm.BindCSForm(form, gobj)
	--把UIBaseForm设置为form的父类
	setmetatable(form, UIBaseForm);
	--获取UILuaForm的脚本
	local _csForm = gobj:GetComponent("UILuaForm");
	form.CSForm = _csForm;
	form._ActiveSelf_ = _csForm.IsVisible;

	form._OnShowAfter_ = function(obj)
        if obj.OnShowAfter then
            obj:OnShowAfter();
        end
        form._ActiveSelf_ = true;
	end

	form._OnHideBefore_ = function(obj)
		if obj.OnHideBefore then
			return not (obj:OnHideBefore() == false);
        end
		form._ActiveSelf_ = false;
		return true;
	end

	--绑定回调处理函数给CS的窗体
	_csForm.UIRegisterEvent = Utils.Handler(form.OnRegisterEvents, form, nil, true);
	_csForm.UILoadEvent = Utils.Handler(form.OnLoad, form, nil, true);
	_csForm.UIFirstShowEvent = Utils.Handler(form.OnFirstShow, form, nil, true);
	_csForm.UIShowBefore = Utils.Handler(form.OnShowBefore, form, nil, true);
	_csForm.UIShowAfter = Utils.Handler(form._OnShowAfter_, form, nil, true);
	_csForm.UIHideBeforeEvent = Utils.Handler(form._OnHideBefore_, form, nil, true);
	_csForm.UIHideAfterEvent = Utils.Handler(form.OnHideAfter, form, nil, true);
	_csForm.UIUnRegisterEvent = Utils.Handler(form.OnUnRegisterEvents, form, nil, true);
	_csForm.UIUnLoadEvent = Utils.Handler(form.OnUnload, form, nil, true);
	_csForm.UIFormDestroyEvent = function()
		local _formName = form.Name;
		--Debug.LogError("UIFormDestroyEvent!!!:::" .. _formName);
		if form.OnFormDestroy ~= nil  then
			form:OnFormDestroy();
		end
		if GameCenter.UIFormManager ~= nil then
			 GameCenter.UIFormManager:DestroyForm(_formName);
		end
	end	
end

--解绑定
function UIBaseForm.UnBindCSForm(form)
	local _csForm = form.CSForm
	_csForm:ClearAllEvent()
	_csForm:SetHasEverShowed(false)
end

--=======定义Lua端调用CSForm的一些函数封装========

--注册消息
function UIBaseForm:RegisterEvent(eid, func, caller)
	--Debug.LogError("UIBaseForm:RegisterEvent");
	if eid == nil then
		Debug.LogError("UIBaseForm:RegisterEvent(eid=nil)");
		return;
	end
	if func == nil then
		Debug.LogError(string.format("UIBaseForm:RegisterEvent(eid=%s,func=nil)",tostring(eid)));
		return;
	end
	if self.CSForm ~= nil then
		if caller == nil then
			self.CSForm:RegisterEvent(eid, Utils.Handler(func,self));
		else
			self.CSForm:RegisterEvent(eid, Utils.Handler(func,caller));
		end
	else
		Debug.LogError("self.CSForm == nil");
	end
end

--设置Texture
function UIBaseForm:LoadTexture(uiTex,type,name,cbFunc,caller)
	if uiTex == nil or type == nil or name == nil or name == "" then 
		Debug.LogError("UIBaseForm:LoadTexture param is invalid!");
		return; 
	end
	if self.CSForm == nil then 
		Debug.LogError("self.CSForm == nil!");
		return;
	end
	if caller == nil then
		self.CSForm:LoadTexture(uiTex,type,name,cbFunc and Utils.Handler(cbFunc,self));
	else
		self.CSForm:LoadTexture(uiTex,type,name,cbFunc and Utils.Handler(cbFunc,caller));
	end
end


--由子类调用的打开窗体函数
function UIBaseForm:OnOpen(object,sender)
	if self.CSForm ~= nil then
		self.CSForm:OnOpen(object,sender);
	end
end

--由子类调用的关闭窗体函数
function UIBaseForm:OnClose(object,sender)
	if self.CSForm ~= nil then
		self.CSForm:OnClose(object,sender);
	end
end
return UIBaseForm

