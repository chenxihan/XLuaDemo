------------------------------------------------
--作者： 何健
--日期： 2019-05-23
--文件： GuildInterActivePanel.lua
--模块： GuildInterActivePanel
--描述： 宗派成员交互按钮列表界面
------------------------------------------------

local GuildInterActivePanel = {
    Trans = nil,
    Go = nil,
    --私聊按钮
    ChatBtnGo = nil,
    --加为好友
    AddFriendBtnGo = nil,
    --踢出宗派
    KickBtnGo = nil,
    --退出宗派
    QuickBtnGo = nil,
    --查看
    LookInfoBtnGo = nil,
    --组队
    TeamBtnGo = nil,
    Tabel = nil,
    --背景图片
    BgSpr = nil,
    --单个按钮的高度，用于计算背景高度
    BtnHeight = 0,
    --玩家信息
    Data = nil,
    --操作按钮列表，存放的按钮GameObject
    BtnList = List:New()
}

--创建一个新的对象
function GuildInterActivePanel:OnFirstShow(trans)
    local _m = Utils.DeepCopy(self)
    _m.Trans = trans
    _m.Go = trans.gameObject
    _m:FindAllComponents()
    return _m
end

 --查找UI上各个控件
function GuildInterActivePanel:FindAllComponents()
    self.Tabel = UIUtils.FindTable(self.Trans, "Table")
    self.BgSpr = UIUtils.FindSpr(self.Trans, "Bg")

    local _btn = UIUtils.FindBtn(self.Trans, "Table/Btn1")
    UIUtils.AddBtnEvent(_btn, self.OnChatClick, self)
    self.ChatBtnGo = UIUtils.FindGo(self.Trans, "Table/Btn1")
    self.BtnList:Add(self.ChatBtnGo)
    _btn = UIUtils.FindBtn(self.Trans, "Table/Btn2")
    UIUtils.AddBtnEvent(_btn, self.OnAddFriendClick, self)
    self.AddFriendBtnGo = UIUtils.FindGo(self.Trans, "Table/Btn2")
    self.BtnList:Add(self.AddFriendBtnGo)
    _btn = UIUtils.FindBtn(self.Trans, "Table/Btn4")
    UIUtils.AddBtnEvent(_btn, self.OnKickClick, self)
    self.KickBtnGo = UIUtils.FindGo(self.Trans, "Table/Btn4")
    self.BtnList:Add(self.KickBtnGo)
    _btn = UIUtils.FindBtn(self.Trans, "Table/Btn5")
    UIUtils.AddBtnEvent(_btn, self.OnQuickClick, self)
    self.QuickBtnGo = UIUtils.FindGo(self.Trans, "Table/Btn5")
    self.BtnList:Add(self.QuickBtnGo)
    _btn = UIUtils.FindBtn(self.Trans, "Table/Btn6")
    UIUtils.AddBtnEvent(_btn, self.OnLookInfoBtnClick, self)
    self.LookInfoBtnGo = UIUtils.FindGo(self.Trans, "Table/Btn6")
    self.BtnList:Add(self.LookInfoBtnGo)
    _btn = UIUtils.FindBtn(self.Trans, "Table/Btn7")
    UIUtils.AddBtnEvent(_btn, self.OnTeamBtnClick, self)
    self.TeamBtnGo = UIUtils.FindGo(self.Trans, "Table/Btn7")
    self.BtnList:Add(self.TeamBtnGo)

    self.BtnHeight = UIUtils.FindSpr(self.Trans, "Table/Btn1").height
    _btn = UIUtils.FindBtn(self.Trans, "Box")
    UIUtils.AddBtnEvent(_btn, self.OnBack, self)
end

function GuildInterActivePanel:Open()
    self.Go:SetActive(true)
end
function GuildInterActivePanel:Close()
    self.Go:SetActive(false)
end

--计算背景长度
function GuildInterActivePanel:ResetBGSize()
    local height = 0
    for i = 1, #self.BtnList do
        if self.BtnList[i].activeSelf then
            height = height + self.BtnHeight
        end
    end
    height = height + self.BtnHeight

    self.BgSpr.height = height
end

--更新界面按钮
function GuildInterActivePanel:OnUpdateItem(role)
    self.Data = role
    if self.Data == nil then
        Debug.LogError("GuildInterActivePanel role data is nil")
    end
    if self.Data.roleId == GameCenter.GameSceneSystem:GetLocalPlayerID() then
        self.ChatBtnGo:SetActive(false)
        self.AddFriendBtnGo:SetActive(false)
        self.KickBtnGo:SetActive(false)
        self.QuickBtnGo:SetActive(true)
    else
        self.ChatBtnGo:SetActive(true)
        self.AddFriendBtnGo:SetActive(true)
        local item = DataConfig.DataGuildOfficial[GameCenter.GuildSystem.Rank]
        if item ~= nil then
            if (item.CanKick == 1) then
                self.KickBtnGo:SetActive(true)
            else
                self.KickBtnGo:SetActive(false)
            end
        else
            self.KickBtnGo:SetActive(false)
        end

        self.QuickBtnGo:SetActive(false)
    end
    self.Tabel.repositionNow = true
    self:ResetBGSize()
end

--私聊点击事件
function GuildInterActivePanel:OnChatClick()
    GameCenter.ChatPrivateSystem:ChatToPlayer(self.Data.roleId, self.Data.name, self.Data.career, self.Data.lv)
    self:OnBack()
end

--加好友点击事件
function GuildInterActivePanel:OnAddFriendClick()
    GameCenter.FriendSystem:AddRelation(FriendType.Friend, self.Data.roleId)
    self:OnBack()
end


-- 踢出帮会点击事件
function GuildInterActivePanel:OnKickClick()
    GameCenter.MsgPromptSystem:ShowMsgBox(DataConfig.DataMessageString.Get("C_GUILD_KICKGUILDCOMFIRM"),
        DataConfig.DataMessageString.Get("C_MSGBOX_CANCEL"),
        DataConfig.DataMessageString.Get("C_MSGBOX_OK"), function (x)
            if (x == MsgBoxResultCode.Button2) then
                GameCenter.Network.Send("MSG_Guild.ReqKickOutGuild", {roleId = self.Data.roleId})
            end
        end)

    self:OnBack()
end

--退出帮会点击事件
function GuildInterActivePanel:OnQuickClick()
    local glbal = DataConfig.DataGlobal[1235]
    if glbal ~= nil then
        GameCenter.MsgPromptSystem:ShowMsgBox(UIUtils.CSFormat(DataConfig.DataMessageString.Get("C_GUILD_EXITGUILDCOMFIRM"), glbal.Params),
        DataConfig.DataMessageString.Get("C_MSGBOX_CANCEL"),
        DataConfig.DataMessageString.Get("C_MSGBOX_OK"), function (x)
            if (x == MsgBoxResultCode.Button2) then
                GameCenter.Network.Send("MSG_Guild.ReqQuitGuild",{})
            end
        end)
        self:OnBack()
    end
end

function GuildInterActivePanel:OnLookInfoBtnClick()
    GameCenter.MainFunctionSystem:DoFunctionCallBack(FunctionStartIdCode.LookOtherPlayer, self.Data.roleId)
    self:OnBack()
end

function GuildInterActivePanel:OnTeamBtnClick()
    GameCenter.MainFunctionSystem:DoFunctionCallBack(FunctionStartIdCode.InviteTeam, self.Data.roleId)
    self:OnBack()
end

function GuildInterActivePanel:OnBack()
    GameCenter.PushFixEvent(LogicEventDefine.EID_EVENT_GUILD_INTERACTIVEPANEL_CLOSE)
end
return GuildInterActivePanel