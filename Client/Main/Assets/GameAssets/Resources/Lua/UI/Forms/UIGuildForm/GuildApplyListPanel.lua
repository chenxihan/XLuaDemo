------------------------------------------------
--作者： 何健
--日期： 2019-05-24
--文件： GuildApplyListPanel.lua
--模块： GuildApplyListPanel
--描述： 宗派申请列表界面
------------------------------------------------
local L_ApplyItem = require "UI.Forms.UIGuildForm.GuildApplyItem"
local GuildApplyListPanel = {
    Trans = nil,
    Go = nil,
    PlayerItem = nil,
    PlayerTable = nil,
    PlayerTableTrans = nil,
    PlayerScroll = nil,
    --设置按钮
    SettingBtnGo = nil,
}

--创建一个新的对象
function GuildApplyListPanel:OnFirstShow(trans)
    local _m = Utils.DeepCopy(self)
    _m.Trans = trans
    _m.Go = trans.gameObject
    _m:FindAllComponents()
    return _m
end

--查找控件
function GuildApplyListPanel:FindAllComponents()
    self.PlayerItem = L_ApplyItem:OnFirstShow(UIUtils.FindTrans(self.Trans, "ListScroll/Container/UIItem"))
    self.PlayerTable = UIUtils.FindTable(self.Trans, "ListScroll/Container")
    self.PlayerTableTrans = UIUtils.FindTrans(self.Trans, "ListScroll/Container")
    self.PlayerScroll = UIUtils.FindScrollView(self.Trans, "ListScroll")
    self.SettingBtnGo = UIUtils.FindGo(self.Trans, "SettingBtn")
    local _btn = UIUtils.FindBtn(self.Trans, "AgreeAllBtn")
    UIUtils.AddBtnEvent(_btn, self.OnAgreeAllBtnClick, self)
    _btn = UIUtils.FindBtn(self.Trans, "RefuseAllBtn")
    UIUtils.AddBtnEvent(_btn, self.OnRefuseAllBtnClick, self)
    _btn = UIUtils.FindBtn(self.Trans, "SettingBtn")
    UIUtils.AddBtnEvent(_btn, self.OnClickSettingBtn, self)
    local _closeBtn = UIUtils.FindBtn(self.Trans, "Back")
    UIUtils.AddBtnEvent(_closeBtn, self.Close, self)
end

function GuildApplyListPanel:Open()
    self.Go:SetActive(true)
    self:OnUpdateForm()
    GameCenter.Network.Send("MSG_Guild.ReqReceivedApply", {})
    self.SettingBtnGo:SetActive(DataConfig.DataGuildOfficial[GameCenter.GuildSystem.Rank].CanAlter == 1)
end

function GuildApplyListPanel:Close()
    self.Go:SetActive(false)
end

--打开设置界面
function GuildApplyListPanel:OnClickSettingBtn()
    GameCenter.PushFixEvent(LogicEventDefine.EID_EVENT_GUILD_OPENSETPANEL)
end

--全部拒绝
function GuildApplyListPanel:OnRefuseAllBtnClick()
    local _req = {}
    local _temp = {}
    local _list = GameCenter.GuildSystem:OnGetApplyIdList()
    for i = 0, _list.Count - 1 do
        table.insert(_temp, _list[i])
    end

    if #_temp > 0 then
        _req.roleId = _temp
        _req.agree = false
        GameCenter.Network.Send("MSG_Guild.ReqDealApplyInfo", _req)
    end
end

--全部同意
function GuildApplyListPanel:OnAgreeAllBtnClick()
    local _req = {}
    local _temp = {}
    local _list = GameCenter.GuildSystem:OnGetApplyIdList()
    for i = 0, _list.Count - 1 do
        table.insert(_temp, _list[i])
    end

    if #_temp > 0 then
        _req.roleId = _temp
        _req.agree = true
        GameCenter.Network.Send("MSG_Guild.ReqDealApplyInfo", _req)
    end
end

--刷新列表
function GuildApplyListPanel:OnUpdateForm()
    for i = 0, self.PlayerTableTrans.childCount - 1 do
        self.PlayerTableTrans:GetChild(i).gameObject:SetActive(false)
    end

    local _info = GameCenter.GuildSystem.GuildApplyList;
    for i = 0, _info.Count - 1 do
        local _go = nil
        if (i >= self.PlayerTableTrans.childCount) then
            _go = self.PlayerItem:Clone()
        else
            _go = L_ApplyItem:OnFirstShow(self.PlayerTableTrans:GetChild(i))
        end

        if _go ~= nil then
            _go:SetData(_info[i])
            _go.Go:SetActive(true)
        end
    end
    self.PlayerTable.repositionNow = true
    self.PlayerScroll:ResetPosition()
end
return GuildApplyListPanel