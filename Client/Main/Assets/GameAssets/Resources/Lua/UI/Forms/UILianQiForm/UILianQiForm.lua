--作者： cy
--日期： 2019-04-26
--文件： UILianQiForm.lua
--模块： UILianQiForm
--描述： 炼器功能主面板
------------------------------------------------

local UIListMenu = require "UI.Components.UIListMenu.UIListMenu"

local UILianQiForm = {
    AnimModule = nil,
    UIListMenu = nil,--列表
    Form = LianQiSubEnum.Begin, --分页类型
    TabForm = 1, --子分页类型
    CloseBtn = nil,--关闭按钮
    BgTexture = nil,
}

function UILianQiForm:OnRegisterEvents()
    self:RegisterEvent(UIEventDefine.UILianQiForm_OPEN, self.OnOpen)
    self:RegisterEvent(UIEventDefine.UILianQiForm_CLOSE, self.OnClose)
end

function UILianQiForm:OnOpen(obj, sender)
    self.CSForm:Show(sender)
    self.Form = -1
    if obj then
        if type(obj) == "table" then
            if #obj == 2 then
                self.Form = obj[1]
                self.TabForm = obj[2]
            end
        else
            self.Form = obj
        end
    end
    if self.Form == -1 then
        for i = LianQiSubEnum.Begin, LianQiSubEnum.Count do
            local alertFlag = GameCenter.MainFunctionSystem:GetAlertFlag(i)
            if alertFlag then
                self.Form = i
                break
            end
        end
    end
    if self.Form == -1 then
        self.Form = LianQiSubEnum.Begin
    end
    self.UIListMenu:SetSelectById(self.Form)
end

function UILianQiForm:OnClose(obj,sender)
    self.CSForm:Hide()
end

function UILianQiForm:RegUICallback()
	self.CloseBtn.onClick:Clear();
	EventDelegate.Add(self.CloseBtn.onClick, Utils.Handler(self.OnClickCloseBtn, self))
end

function UILianQiForm:OnFirstShow()
    self:FindAllComponents()
    self:RegUICallback()
end

function UILianQiForm:OnHideBefore()

end

function UILianQiForm:OnShowAfter()
    self.CSForm:LoadTexture(self.BgTexture, AssetUtils.GetImageAssetPath(ImageTypeCode.UI, "bag_back"))
end

function UILianQiForm:OnClickCloseBtn()
    self:OnClose(nil, nil)
end

function UILianQiForm:FindAllComponents()
    self.BgTexture = UIUtils.FindTex(self.Trans, "BgTexture")
    self.UIListMenu = UIListMenu:OnFirstShow(self.CSForm, self.Trans:Find("UIListMenu"))--UnityUtils.RequireComponent(self.Trans:Find("UIListMenu"), "Funcell.GameUI.Form.UIListMenu")
    --self.UIListMenu:OnFirstShow(self.CSForm)
    self.UIListMenu:AddIcon(LianQiSubEnum.Forge, DataConfig.DataMessageString.Get("LIANQI_FORGE"), FunctionStartIdCode.LianQiForge, "bag_1", nil, "bag_2")
    self.UIListMenu:AddIcon(LianQiSubEnum.Gem, DataConfig.DataMessageString.Get("LIANQI_GEM"), FunctionStartIdCode.LianQiGem, "bag_1", nil, "bag_2")
    self.UIListMenu:AddSelectEvent(Utils.Handler(self.OnMenuSelect,self))
    self.UIListMenu.IsHideIconByFunc = true
    self.CloseBtn = UIUtils.FindBtn(self.Trans,"CloseBtn")
    --创建动画模块
    self.AnimModule = UIAnimationModule(self.Trans)
    --添加一个动画
    self.AnimModule:AddAlphaAnimation()
end

function UILianQiForm:OnMenuSelect(id, open)
    self.Form = id
    if open then
        self:OpenSubForm(id)
    else
        self:CloseSubForm(id)
    end
end

function UILianQiForm:OpenSubForm(id)
    if id == LianQiSubEnum.Forge then
        --锻造
        GameCenter.PushFixEvent(UIEventDefine.UILianQiForgeForm_OPEN, self.TabForm, self.CSForm)
    elseif id == LianQiSubEnum.Gem then
        --宝石
        GameCenter.PushFixEvent(UIEventDefine.UILianQiGemForm_OPEN, self.TabForm, self.CSForm)
    end
end

function UILianQiForm:CloseSubForm(id)
    if id == LianQiSubEnum.Forge then
        --锻造
        GameCenter.PushFixEvent(UIEventDefine.UILianQiForgeForm_CLOSE, self.TabForm, self.CSForm)
    elseif id == LianQiSubEnum.Gem then
        --宝石
        GameCenter.PushFixEvent(UIEventDefine.UILianQiGemForm_CLOSE, self.TabForm, self.CSForm)
    end
end

return UILianQiForm