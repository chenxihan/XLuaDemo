------------------------------------------------
--作者： 何健
--日期： 2019-05-23
--文件： GuildOfficalPanel.lua
--模块： GuildOfficalPanel
--描述： 宗派成员权限管理界面
------------------------------------------------
local L_GuildOfficalItem = require "UI.Forms.UIGuildForm.GuildOfficalItem"
local GuildOfficalPanel = {
    Trans = nil,
    Go = nil,
    MemberItem = nil,
    MemberTabel = nil,
    MemberTabelTrans = nil,
    MemberScroll = nil,
    BtnDic = Dictionary:New(),
    ContributeTipsGo = nil,
    StateTipsGo = nil,
    CurType = 1,
}

--创建一个新的对象
function GuildOfficalPanel:OnFirstShow(trans)
    local _m = Utils.DeepCopy(self)
    _m.Trans = trans
    _m.Go = trans.gameObject
    _m:FindAllComponents()
    return _m
end

--查找控件
function GuildOfficalPanel:FindAllComponents()
    local _scrollTrans = UIUtils.FindTrans(self.Trans, "Scroll")
    for i = 1, _scrollTrans.childCount do
        local _btnTrans = _scrollTrans:GetChild(i - 1)
        local _btn = _btnTrans:GetComponent("UIButton")
        UIUtils.AddBtnEvent(_btn, self.OnLeaderClick, self)
        self.BtnDic:Add(tonumber(_btnTrans.name), _btn)
    end
    self.StateTipsGo = UIUtils.FindGo(self.Trans, "List/StateLabel")
    self.ContributeTipsGo = UIUtils.FindGo(self.Trans, "List/NumLabel")
    self.MemberItem = L_GuildOfficalItem:OnFirstShow(UIUtils.FindTrans(self.Trans, "ListScroll/Container/UIItem"))
    self.MemberTabel = UIUtils.FindTable(self.Trans, "ListScroll/Container")
    self.MemberTabelTrans = UIUtils.FindTrans(self.Trans, "ListScroll/Container")
    self.MemberScroll = UIUtils.FindScrollView(self.Trans, "ListScroll")

    local _closeBtn = UIUtils.FindBtn(self.Trans, "Box")
    UIUtils.AddBtnEvent(_closeBtn, self.Close, self)
end

function GuildOfficalPanel:Open()
    self.CurType = GuildOfficalEnum.Chairman
    self.Go:SetActive(true)
    self.ContributeTipsGo:SetActive(true)
    self.StateTipsGo:SetActive(false)
    self:OnUpdateItem()
end

function GuildOfficalPanel:Close()
    self.Go:SetActive(false)
end
--职位按钮点击
function GuildOfficalPanel:OnLeaderClick()
    for k, v in pairs(self.BtnDic) do
        if v == CS.UIButton.current then
            v.isEnabled = false
            self.CurType = k
        else
            v.isEnabled = true
        end
    end
    if self.CurType == GuildOfficalEnum.Student then
        self.ContributeTipsGo:SetActive(false)
        self.StateTipsGo:SetActive(true)
    else
        self.ContributeTipsGo:SetActive(true)
        self.StateTipsGo:SetActive(false)
    end
    self:OnRefruseMemberList()
end

function GuildOfficalPanel:OnUpdateItem()
    if not self.Go.activeSelf then
        return
    end
    for k, v in pairs(self.BtnDic) do
        if k == self.CurType then
            v.isEnabled = false
        else
            v.isEnabled = true
        end
    end
    self:OnRefruseMemberList()
end

function GuildOfficalPanel:OnRefruseMemberList()
    local _info = GameCenter.GuildSystem.GuildMemberList
    for i = 0, self.MemberTabelTrans.childCount - 1 do
        local go = self.MemberTabelTrans:GetChild(i).gameObject
        go:SetActive(false)
    end

    for i = 0, _info.Count - 1 do
        local go = nil;
        if i >= self.MemberTabelTrans.childCount then
            go = self.MemberItem:Clone()
        else
            go = L_GuildOfficalItem:OnFirstShow(self.MemberTabelTrans:GetChild(i))
        end
        if go ~= nil then
            go:OnUpdateItem(_info[i], self.CurType)
            go.Go:SetActive(true)
        else
            go.Go:SetActive(false)
        end
    end

    self.MemberTabel.repositionNow = true
    self.MemberScroll:ResetPosition()
end

return GuildOfficalPanel