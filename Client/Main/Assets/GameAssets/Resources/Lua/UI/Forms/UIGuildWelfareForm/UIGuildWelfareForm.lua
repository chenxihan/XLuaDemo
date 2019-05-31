------------------------------------------------
--作者： 何健
--日期： 2019-05-15
--文件： UIGuildWelfareForm.lua
--模块： UIGuildWelfareForm
--描述： 宗派活动界面
------------------------------------------------
local UIGuildWelfareItem = require "UI.Forms.UIGuildWelfareForm.UIGuildWelfareItem"
local UIGuildActiveBabyPanel = require "UI.Forms.UIGuildWelfareForm.UIGuildActiveBabyPanel"

local UIGuildWelfareForm = {
    ScrollView = nil,
    Grid = nil,
    GridTrans = nil,
    ItemGo = nil,
    ActiveBabyPanel = nil,
}
--继承Form函数
function UIGuildWelfareForm:OnRegisterEvents()
	self:RegisterEvent(UIEventDefine.UIGuildWelfareForm_OPEN,self.OnOpen)
	self:RegisterEvent(UIEventDefine.UIGuildWelfareForm_CLOSE,self.OnClose)
	self:RegisterEvent(LogicEventDefine.EID_EVENT_GUILD_ACTIVEBABY_OPEN,self.ActiveBabyFormOpen)
	self:RegisterEvent(LogicEventDefine.EID_EVENT_GUILD_ACTIVEBABY_RESULT,self.ActiveBabyFormUpdate)
end

function UIGuildWelfareForm:OnFirstShow()
    self:FindAllComponents()
    self.CSForm:AddAlphaAnimation()
end
function UIGuildWelfareForm:OnHideBefore()
end
function UIGuildWelfareForm:OnShowAfter()
    self:OnRefreshForm()
    self.ActiveBabyPanel:Close()
end

--查找UI上各个控件
function UIGuildWelfareForm:FindAllComponents()
    self.ScrollView = UIUtils.FindScrollView(self.Trans, "Center/Scroll")
    self.GridTrans = UIUtils.FindTrans(self.Trans, "Center/Scroll/Grid")
    self.Grid = UIUtils.FindGrid(self.Trans, "Center/Scroll/Grid")
    self.ItemGo = UIUtils.FindGo(self.Trans, "Center/Scroll/Grid/Item")

    self.ActiveBabyPanel = UIGuildActiveBabyPanel:OnFirstShow(UIUtils.FindTrans(self.Trans, "ActiveBabyPanel"))
end

--打开活跃宝贝界面
function UIGuildWelfareForm:ActiveBabyFormOpen(obj, sender)
    self.ActiveBabyPanel:Open()
end

--活跃宝贝活动数据加载
function UIGuildWelfareForm:ActiveBabyFormUpdate(obj, sender)
    self.ActiveBabyPanel:OnUpdateForm()
end

--设置界面数据
function UIGuildWelfareForm:OnRefreshForm()
    for i = 0, self.GridTrans.childCount - 1 do
        local _go = self.GridTrans:GetChild(i)
        _go.gameObject:SetActive(false)
    end

    local _index = 1
    local _go = nil
    for _,v in pairs(DataConfig.DataGuildWelfare) do
        if _index > self.GridTrans.childCount then
            _go = _go:Clone()
            _go.Trans.name = tostring(_index)
        else
            _go = UIGuildWelfareItem:OnFirstShow(self.GridTrans:GetChild(_index - 1))
        end
        _go:OnUpdateItem(v)
        _go.Go:SetActive(true)
        _index = _index + 1
    end
    self.Grid.repositionNow = true
    self.ScrollView:ResetPosition()
end
return UIGuildWelfareForm