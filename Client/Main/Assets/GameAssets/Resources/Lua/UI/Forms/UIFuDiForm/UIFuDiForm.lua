
------------------------------------------------
--作者： 王圣
--日期： 2019-05-10
--文件： UIFuDiForm.lua
--模块： UIFuDiForm
--描述： 福地Form
------------------------------------------------

-- c#类
local UIListMenu = require "UI.Components.UIListMenu.UIListMenu"
local UIFuDiForm = {
    ListMenu = nil,
    CloseBtn = nil,
    BossId = 0,
}
--分页Enum
local L_PageEnum = {
    Rank = 1,
    Boss = 2,
}
--继承Form函数
function UIFuDiForm:OnRegisterEvents()
	self:RegisterEvent(UIEventDefine.UIFuDiForm_Open,self.OnOpen)
    self:RegisterEvent(UIEventDefine.UIFuDiForm_Close,self.OnClose)
end

function UIFuDiForm:OnFirstShow()
    self:FindAllComponents()
end

function UIFuDiForm:OnShowAfter()
end

function UIFuDiForm:OnHideBefore()
    
end

function UIFuDiForm:OnOpen(obj, sender)
    self.CSForm:Show(sender)
    if sender ~= nil then
        if sender == 1 then
            if obj ~= nil then
               self.BossId = obj.BossId
               self.ListMenu:SetSelectById(obj.SubPage)
            else
               self.ListMenu:SetSelectById(L_PageEnum.Rank)
            end
        end
    else
        self.ListMenu:SetSelectById(obj)
    end
end

function UIFuDiForm:OnClicClose()
    self:OnClose()
end

function UIFuDiForm:FindAllComponents()
    local trans = self.Trans:Find("UIListMenu")
    self.ListMenu = UIListMenu:OnFirstShow(self.CSForm,trans)
    --china
    self.ListMenu:AddIcon(L_PageEnum.Rank, "称号排行", FunctionStartIdCode.FuDiRank, "moneybg_1", "moneybg_2");
    self.ListMenu:AddIcon(L_PageEnum.Boss, "福地Boss", FunctionStartIdCode.FuDiBoss, "moneybg_1", "moneybg_2");
    self.ListMenu:AddSelectEvent(Utils.Handler(self.OnMenuSelect,self))
    self.CloseBtn = self.Trans:Find("Top/Close"):GetComponent("UIButton")
    UIUtils.AddBtnEvent(self.CloseBtn, self.OnClicClose, self)
end

function UIFuDiForm:OnMenuSelect(id,b)
    if b then
        self:OpenSubForm(id)
    else
        self:CloseSubForm(id)
    end
end
function UIFuDiForm:OpenSubForm(id)
    if id == L_PageEnum.Rank then
        GameCenter.PushFixEvent(UIEventDefine.UIFuDiRankForm_Open)
    elseif id == L_PageEnum.Boss then
        if self.BossId ~= 0 then
            GameCenter.PushFixEvent(UIEventDefine.UIFuDiBossForm_Open,self.BossId)
        else
            GameCenter.PushFixEvent(UIEventDefine.UIFuDiBossForm_Open)
        end
    end
end
function UIFuDiForm:CloseSubForm(id)
    if id == L_PageEnum.Rank then
        GameCenter.PushFixEvent(UIEventDefine.UIFuDiRankForm_Close)
    elseif id == L_PageEnum.Boss then
        GameCenter.PushFixEvent(UIEventDefine.UIFuDiBossForm_Close)
    end
end
return UIFuDiForm