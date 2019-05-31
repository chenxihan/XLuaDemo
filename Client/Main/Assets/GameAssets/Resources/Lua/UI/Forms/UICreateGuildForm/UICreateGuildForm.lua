------------------------------------------------
--作者： 何健
--日期： 2019-05-20
--文件： UICreateGuildForm.lua
--模块： UICreateGuildForm
--描述： 宗派加入及创建界面
------------------------------------------------

local UIGuildListPanel = require "UI.Forms.UIGuildListForm.UIGuildListPanel"
local UICreateGuildPanel = require "UI.Forms.UICreateGuildForm.UICreateGuildPanel"

local UICreateGuildForm = {
    CloseBtn = nil,
    CreateBtn = nil,
    FastJoinBtn = nil,
    JoinPanel = nil,
    CreatePanel = nil,
}

--继承Form函数
function UICreateGuildForm:OnRegisterEvents()
	self:RegisterEvent(UIEventDefine.UICreateGuildForm_OPEN,self.OnOpen)
    self:RegisterEvent(UIEventDefine.UICreateGuildForm_CLOSE,self.OnClose)
    self:RegisterEvent(LogicEventDefine.EID_EVENT_GUILD_CREATEGUILD_RECOMMENDGUILDLIST_UPDATE, self.OnUpdateRecommendList)
end

function UICreateGuildForm:OnFirstShow()
    self:FindAllComponents()
    self.CSForm:AddAlphaAnimation()
end
function UICreateGuildForm:OnHideBefore()
    GameCenter.GuildSystem.IsCreateFormOpen = false
end
function UICreateGuildForm:OnShowAfter()
--    self:LoadTextures()
    GameCenter.GuildSystem.IsCreateFormOpen = true
    GameCenter.Network.Send("MSG_Guild.ReqRecommendGuild", {type = 1})
    self.CreatePanel:Close()
    self.JoinPanel:Open()
end

--查找UI上各个控件
function UICreateGuildForm:FindAllComponents()
    local trans = self.Trans
    self.CreateBtn = UIUtils.FindBtn(trans, "Bottom/CreateBtn")
    UIUtils.AddBtnEvent(self.CreateBtn, self.OnClickCreateGuildBtn, self)
    self.FastJoinBtn = UIUtils.FindBtn(trans, "Bottom/FastJoin")
    UIUtils.AddBtnEvent(self.FastJoinBtn, self.OnClickFastJoinBtn, self)
    self.CloseBtn = UIUtils.FindBtn(trans, "CloseBtn")
    UIUtils.AddBtnEvent(self.CloseBtn, self.OnClickCloseBtn, self)

    self.JoinPanel = UIGuildListPanel:OnFirstShow(UIUtils.FindTrans(trans, "Center/JoinPanel"))
    self.CreatePanel = UICreateGuildPanel:OnFirstShow(UIUtils.FindTrans(trans, "Center/CreatePanel"))
end

--关闭
function UICreateGuildForm:OnClickCloseBtn()
    self:OnClose()
end

--快速加入
function UICreateGuildForm:OnClickFastJoinBtn()
    local _idList = List:New()
    local _list = GameCenter.GuildSystem.GuildRecommentList
    for i = 0, _list.Count - 1 do
        _idList:Add(_list[i].guildId)
    end
    if  #_idList > 0 then
        GameCenter.GuildSystem:ReqJoinGuildByList(_idList)
    else
        GameCenter.MsgPromptSystem:ShowPrompt("当前服务器没有宗派")
    end
end

--创建
function UICreateGuildForm:OnClickCreateGuildBtn()
    self.CreatePanel:Open()
end

function UICreateGuildForm:OnUpdateRecommendList(obj, sender)
    self.JoinPanel:OnRefruseGuildList()
end
return UICreateGuildForm