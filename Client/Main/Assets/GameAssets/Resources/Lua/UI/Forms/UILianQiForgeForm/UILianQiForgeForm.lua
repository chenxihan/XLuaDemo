--作者： cy
--日期： 2019-04-26
--文件： UILianQiForgeForm.lua
--模块： UILianQiForgeForm
--描述： 炼器功能一级分页：锻造面板
------------------------------------------------

local UILianQiForgeForm = {
    UIListMenu = nil,--列表
    Form = LianQiForgeSubEnum.Begin, --分页类型
}

function UILianQiForgeForm:OnRegisterEvents()
    self:RegisterEvent(UIEventDefine.UILianQiForgeForm_OPEN, self.OnOpen)
    self:RegisterEvent(UIEventDefine.UILianQiForgeForm_CLOSE, self.OnClose)
end

function UILianQiForgeForm:OnOpen(obj, sender)
    self.CSForm:Show(sender)
    if obj and obj <= LianQiForgeSubEnum.Count then
        self.Form = obj
    end
    self.UIListMenu:SetSelectById(self.Form)
end

function UILianQiForgeForm:OnClose(obj,sender)
    self.CSForm:Hide()
end

function UILianQiForgeForm:RegUICallback()
    
end

function UILianQiForgeForm:OnFirstShow()
    self:FindAllComponents()
    self:RegUICallback()
end

function UILianQiForgeForm:OnHideBefore()

end

function UILianQiForgeForm:OnClickCloseBtn()
    self:OnClose(nil, nil)
end

function UILianQiForgeForm:FindAllComponents()
    self.UIListMenu = UnityUtils.RequireComponent(self.Trans:Find("UIListMenu"), "Funcell.GameUI.Form.UIListMenu")
    self.UIListMenu:OnFirstShow(self.CSForm)
    self.UIListMenu:AddIcon(LianQiForgeSubEnum.Strength, DataConfig.DataMessageString.Get("LIANQI_FORGE_STRENGTH"), FunctionStartIdCode.LianQiForgeStrength)
    self.UIListMenu:AddSelectEvent(Utils.Handler(self.OnMenuSelect,self))
    self.UIListMenu.IsHideIconByFunc = true
end

function UILianQiForgeForm:OnMenuSelect(id, open)
    self.Form = id
    if open then
        self:OpenSubForm(id)
    else
        self:CloseSubForm(id)
    end
end

function UILianQiForgeForm:OpenSubForm(id)
    if id == LianQiForgeSubEnum.Strength then
        --装备强化
        GameCenter.PushFixEvent(UIEventDefine.UILianQiForgeStrengthForm_OPEN, nil, self.CSForm)
    end
end

function UILianQiForgeForm:CloseSubForm(id)
    if id == LianQiForgeSubEnum.Strength then
        --装备强化
        GameCenter.PushFixEvent(UIEventDefine.UILianQiForgeStrengthForm_CLOSE, nil, self.CSForm)
    end
end

return UILianQiForgeForm