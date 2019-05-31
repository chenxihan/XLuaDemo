------------------------------------------------
--作者： gzg
--日期： 2019-03-25
--文件： UIFormManager.lua
--模块： UIFormManager
--描述： Lua端窗体管理器
------------------------------------------------
--引用
local UIBaseForm = require("UI.Base.UIBaseForm")

--定义模块
local UIFormManager = {
	AllForms = {},
	UpdateForms = {},
	RenewForms = {}
}

--增加重新加载的界面
function UIFormManager:AddRenewForm(name)
	self.RenewForms[name] = true
end

--是否需要重新加载
function UIFormManager:IsRenew(name)
	return not(not self.RenewForms[name])
end

--创建ui对应的lua控制脚本
function UIFormManager:CreateLuaUIScript(name, gobj)
	-- if AppConfig.IsDestroyOnClose then
	-- 	self:DestroyForm(name)
	-- end
	self:CreateForm(name, gobj)
	if self.RenewForms[name] then
		self.RenewForms[name] = nil
	end
end

--创建某个窗体
function UIFormManager:CreateForm(name, gobj)
	if self.AllForms[name] then
		error(string.format("已经存在该ui脚本 name = %s ", name))
	end
	local _form = require(string.format("UI.Forms.%s.%s", name, name))

	_form.Name = name
	_form.GO = gobj
	_form.Trans = gobj.transform

	self.AllForms[name] = _form
	--当需要Update的窗体,放置到UpdateForms中.
	if _form.Update then
		self.UpdateForms[name] = _form
	end
	UIBaseForm.BindCSForm(_form, gobj)
end

--卸载某个窗体
function UIFormManager:DestroyForm(name)
	if self.AllForms[name] then
		local _form = self.AllForms[name]
		--从集合中删除
		self.AllForms[name] = nil
		if self.UpdateForms[name] then
			self.UpdateForms[name] = nil
		end
		--解绑定CS窗体
		UIBaseForm.UnBindCSForm(_form)
		--卸载窗体Lua脚本
		Utils.RemoveRequiredByName(string.format("UI.Forms.%s.%s", name, name))
	end
end

--窗体更新
function UIFormManager:Update(deltaTime)
	--判断更新容器是否为空,然后再循环对所有的窗体进行更新处理
	if next(self.UpdateForms) ~= nil then
		for _, v in pairs(self.UpdateForms) do
			if v._ActiveSelf_ then
				v:Update(deltaTime)
			end
		end
	end
end

return UIFormManager

