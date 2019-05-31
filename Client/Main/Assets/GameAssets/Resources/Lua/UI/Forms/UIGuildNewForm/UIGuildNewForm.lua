------------------------------------------------
--作者： 何健
--日期： 2019-05-22
--文件： UIGuildNewForm.lua
--模块： UIGuildNewForm
--描述： 宗派界面底板
------------------------------------------------
local UIListMenu = require "UI.Components.UIListMenu.UIListMenu"
local UIGuildNewForm = {
    --UIListMenu
    ListMenu = nil,
    --UIButton
    CloseBtn = nil,
    --BagFormSubPanel 保存打开的标签
    CurPanel = 0,
    --itemModel 打开界面所用到的数据
    CurData = nil,
    TitleLabel = nil,
    BackTexture = nil
}

--继承Form函数
function UIGuildNewForm:OnRegisterEvents()
	self:RegisterEvent(UIEventDefine.UIGuildNewForm_OPEN,self.OnOpen)
	self:RegisterEvent(UIEventDefine.UIGuildNewForm_CLOSE,self.OnClose)
end

function UIGuildNewForm:OnFirstShow()
	self:FindAllComponents()
end
function UIGuildNewForm:OnHideBefore()
    self.CurPanel = GuildSubEnum.TYPE_BUILD
end
function UIGuildNewForm:OnShowAfter()
    self:LoadTextures()
end

function UIGuildNewForm:OnOpen(obj, sender)
    self.CSForm:Show(sender)
    if obj ~= nil then
        self.CurPanel = obj
    end
    self.ListMenu:RemoveAll()
    self.ListMenu:AddIcon(GuildSubEnum.TYPE_BUILD, "建筑", FunctionStartIdCode.GuildBuild)
    self.ListMenu:AddIcon(GuildSubEnum.TYPE_INFO, DataConfig.DataMessageString.Get("C_GUILD_BASE_INFO"), FunctionStartIdCode.GuildFuncTypeInfo)
    self.ListMenu:AddIcon(GuildSubEnum.TYPE_REPERTORY, DataConfig.DataMessageString.Get("C_GUILD_REPERTORY"), FunctionStartIdCode.GuildFuncTypeRepertoy)
    self.ListMenu:AddIcon(GuildSubEnum.TYPE_LIST, "列表", FunctionStartIdCode.GuildFuncTypeList)
    self.ListMenu:AddIcon(GuildSubEnum.TYPE_ACTION, DataConfig.DataMessageString.Get("C_GUILD_ACTION"), FunctionStartIdCode.GuildFuncTypeAction)
    self.ListMenu:SetSelectById(self.CurPanel)
end

--查找UI上各个控件
function UIGuildNewForm:FindAllComponents()
    local trans = self.Trans
    self.BackTexture = UIUtils.FindTex(trans, "Texture")
    local listTrans = trans:Find("Right/RightMenu")
    self.ListMenu = UIListMenu:OnFirstShow(self.CSForm, listTrans)
    self.ListMenu:ClearSelectEvent();
    self.ListMenu:AddSelectEvent(Utils.Handler(self.OnClickCallBack, self))
    self.ListMenu.IsHideIconByFunc = true

    -- self.TitleLabel = UIUtils.FindLabel(trans, "Title")

    self.CloseBtn = trans:Find("CloseBtn"):GetComponent("UIButton")
    self.CloseBtn.onClick:Clear()
    UIUtils.AddBtnEvent(self.CloseBtn, self.OnClickCloseBtn, self)
end

function UIGuildNewForm:OnClickCallBack(id, select)
    if select then
        if id == GuildSubEnum.TYPE_BUILD then
            GameCenter.PushFixEvent(UIEventDefine.UIGuildBuildBaseForm_OPEN, nil, self.CSForm)
        end
        if id == GuildSubEnum.TYPE_INFO then
            GameCenter.PushFixEvent(UIEventDefine.UIGuildForm_OPEN, nil, self.CSForm)
        end
        if id == GuildSubEnum.TYPE_REPERTORY then
            GameCenter.PushFixEvent(UIEventDefine.UIGuildRepertory_OPEN, nil, self.CSForm)
        end
        if id == GuildSubEnum.TYPE_LIST then
            GameCenter.PushFixEvent(UIEventDefine.UIGuildListForm_OPEN, nil, self.CSForm)
        end
        if id == GuildSubEnum.TYPE_ACTION then
            GameCenter.PushFixEvent(UIEventDefine.UIGuildWelfareForm_OPEN, nil, self.CSForm)
        end
    else
        if id == GuildSubEnum.TYPE_BUILD then
            GameCenter.PushFixEvent(UIEventDefine.UIGuildBuildBaseForm_CLOSE)
        end
        if id == GuildSubEnum.TYPE_INFO then
            GameCenter.PushFixEvent(UIEventDefine.UIGuildForm_CLOSE)
            self.CurData = nil
        end
        if id == GuildSubEnum.TYPE_REPERTORY then
            GameCenter.PushFixEvent(UIEventDefine.UIGuildRepertory_CLOSE)
        end
        if id == GuildSubEnum.TYPE_LIST then
            GameCenter.PushFixEvent(UIEventDefine.UIGuildListForm_CLOSE)
        end
        if id == GuildSubEnum.TYPE_ACTION then
            GameCenter.PushFixEvent(UIEventDefine.UIGuildWelfareForm_CLOSE)
        end
    end
end

function UIGuildNewForm:OnClickCloseBtn()
    self:OnClose()
end

--加载texture
function UIGuildNewForm:LoadTextures()
    self.CSForm:LoadTexture(self.BackTexture,AssetUtils.GetImageAssetPath(ImageTypeCode.UI, "bag_back"))
end
return UIGuildNewForm