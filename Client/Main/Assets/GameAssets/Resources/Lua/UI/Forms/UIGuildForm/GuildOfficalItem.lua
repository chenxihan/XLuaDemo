------------------------------------------------
--作者： 何健
--日期： 2019-05-23
--文件： GuildOfficalItem.lua
--模块： GuildOfficalItem
--描述： 宗派成员权限管理界面成员列表子项
------------------------------------------------
local L_PlayerLevel = require "UI.Components.UIPlayerLevelLabel"
local GuildOfficalItem = {
    Trans = nil,
    Go = nil,
    --名字
    NameLabel = nil,
    --等级
    LevelLabel = nil,
    --贡献
    ContributeLabel = nil,
    --职位
    OfficalLabel = nil,
    Icon = nil,
    --选择框
    CheckBoxBtn = nil,
    CheckBoxBtnGo = nil,
    CheckBoxSelectGo = nil,
    Data = nil,
    CurOffical = GuildOfficalEnum.Chairman
}

--创建一个新的对象
function GuildOfficalItem:OnFirstShow(trans)
    local _m = Utils.DeepCopy(self)
    _m.Trans = trans
    _m.Go = trans.gameObject
    _m:FindAllComponents()
    return _m
end

--克隆一个对象
function GuildOfficalItem:Clone()
    return self:OnFirstShow(UnityUtils.Clone(self.Go).transform)
end

--查找控件
function GuildOfficalItem:FindAllComponents()
    self.NameLabel = UIUtils.FindLabel(self.Trans, "List/NameLabel")
    self.ContributeLabel = UIUtils.FindLabel(self.Trans, "List/ContributeLabel")
    self.OfficalLabel = UIUtils.FindLabel(self.Trans, "List/OfficalLabel")
    self.Icon = UIUtils.FindSpr(self.Trans, "Icon")
    self.CheckBoxBtn = UIUtils.FindBtn(self.Trans, "Select")
    self.CheckBoxBtnGo = UIUtils.FindGo(self.Trans, "Select")
    self.CheckBoxSelectGo = UIUtils.FindGo(self.Trans, "Select/Sprite")
    self.LevelLabel = L_PlayerLevel:OnFirstShow(UIUtils.FindTrans(self.Trans, "List/LvLabel"))

    UIUtils.AddBtnEvent(self.CheckBoxBtn, self.OnSelect, self)
end

function GuildOfficalItem:OnUpdateItem(info, offical)
    if info == nil then
        Debug.LogError("DATA ERROR GuildOfficalItem:OnUpdateItem()")
    end
    self.CurOffical = offical
    self.Data = info
    self.NameLabel.text = info.name
    self.Icon.spriteName = string.format("head_%d", info.career)
    self.LevelLabel:SetLevel(info.lv)
    if offical == GuildOfficalEnum.Student then
        self.ContributeLabel.text = GameCenter.GuildSystem:OnGetOnlineStateStr(info.lastOffTime)
    else
        self.ContributeLabel.text = tostring(info.contribute)
    end
    self.OfficalLabel.text = GameCenter.GuildSystem:OnGetOfficalString(info.rank)
    local rank = GameCenter.GuildSystem.Rank
    if ((rank > offical and offical ~= -1) or (rank == offical and offical == GuildOfficalEnum.Chairman)) then
        if (info.rank == offical) then
            self.CheckBoxSelectGo:SetActive(true)
        else
            self.CheckBoxSelectGo:SetActive(false)
        end
        if (info.roleId == GameCenter.GameSceneSystem:GetLocalPlayerID()) then
            self.CheckBoxBtnGo:SetActive(false)
        else
            self.CheckBoxBtnGo:SetActive(true)
        end
    elseif(offical == -1) then
        local g = DataConfig.DataGuildOfficial[rank]
        if g ~= nil then
            self.CheckBoxBtnGo:SetActive(g.CanKick == 1)
        end
        self.CheckBoxSelectGo:SetActive(false)
    else
        self.CheckBoxBtnGo:SetActive(false)
    end
end

function GuildOfficalItem:OnSelect()
    if not self.CheckBoxSelectGo.activeSelf then
        if self.CurOffical == -1 then
            GameCenter.MsgPromptSystem:ShowMsgBox(DataConfig.DataMessageString.Get("C_GUILD_KICKGUILDCOMFIRM"),
            DataConfig.DataMessageString.Get("C_MSGBOX_CANCEL"),
            DataConfig.DataMessageString.Get("C_MSGBOX_OK"), function (x)
                if (x == MsgBoxResultCode.Button2) then
                    GameCenter.Network.Send("MSG_Guild.ReqKickOutGuild", {roleId = self.Data.roleId})
                    self.CheckBoxSelectGo:SetActive(true)
                end
            end)
        elseif(self.CurOffical == GuildOfficalEnum.Chairman) then
            GameCenter.MsgPromptSystem:ShowMsgBox(DataConfig.DataMessageString.Get("C_GUILD_GUILDOFFICAL_MSGCOMLEDER"), function (x)
                if (x == MsgBoxResultCode.Button2) then
                    GameCenter.Network.Send("MSG_Guild.ReqSetRank", {roleId = self.Data.roleId, rank = GuildOfficalEnum.Chairman})
                end
            end)
        else
            GameCenter.Network.Send("MSG_Guild.ReqSetRank", {roleId = self.Data.roleId, rank = self.CurOffical})
        end
    end
end
return GuildOfficalItem