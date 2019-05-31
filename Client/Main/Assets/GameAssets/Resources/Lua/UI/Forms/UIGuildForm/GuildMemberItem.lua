------------------------------------------------
--作者： 何健
--日期： 2019-05-23
--文件： GuildMemberItem.lua
--模块： GuildMemberItem
--描述： 宗派成员列表子项
------------------------------------------------
local L_PlayerLevel = require "UI.Components.UIPlayerLevelLabel"
local GuildMemberItem = {
    Trans = nil,
    Go = nil,
    --玩家名字
    NameLabel = nil,
    --在线状态
    StateLabel = nil,
    --等级
    Lvlabel = nil,
    --个人贡献
    ContributeLabel = nil,
    --战力
    FightingLabel = nil,
    --职位
    OfficalLabel = nil,
    --头像
    IconSpr = nil,
    --列表点击按钮
    Btn = nil,
    CallBack = nil,
    Data = nil
}

--创建一个新的对象
function GuildMemberItem:OnFirstShow(trans)
    local _m = Utils.DeepCopy(self)
    _m.Trans = trans
    _m.Go = trans.gameObject
    _m:FindAllComponents()
    return _m
end

--克隆一个
function GuildMemberItem:Clone()
    local _go = UnityUtils.Clone(self.Go)
    return self:OnFirstShow(_go.transform)
end

 --查找UI上各个控件
function GuildMemberItem:FindAllComponents()
    self.NameLabel = UIUtils.FindLabel(self.Trans, "List/NameLabel")
    self.StateLabel = UIUtils.FindLabel(self.Trans, "List/StateLabel")
    self.ContributeLabel = UIUtils.FindLabel(self.Trans, "List/ContributeLabel")
    self.FightingLabel = UIUtils.FindLabel(self.Trans, "List/FightLabel")
    self.OfficalLabel = UIUtils.FindLabel(self.Trans, "List/OfficalLabel")
    self.IconSpr = UIUtils.FindSpr(self.Trans, "Icon")
    self.Lvlabel = L_PlayerLevel:OnFirstShow(UIUtils.FindTrans(self.Trans, "List/LvLabel"))
    self.Btn = UIUtils.FindBtn(self.Trans, "List")
    UIUtils.AddBtnEvent(self.Btn, self.OnSelect, self)
end

function GuildMemberItem:SetData(info)
    self.Data = info
    self.NameLabel.text = info.name
    self.IconSpr.spriteName = string.format( "head_%d",info.career)--CommonUtils.GetPlayerHeaderSpriteName(info.lv, info.career);
    self.Lvlabel:SetLevel(info.lv)
    self.FightingLabel.text = tostring(info.fighting)
    self.ContributeLabel.text = tostring(info.contribute)
    self.OfficalLabel.text = GameCenter.GuildSystem:OnGetOfficalString(info.rank)
    self.StateLabel.text = GameCenter.GuildSystem:OnGetOnlineStateStr(info.lastOffTime)
end

function GuildMemberItem:OnSelect()
    if self.CallBack ~= nil then
        self.CallBack(self)
    end
end

function GuildMemberItem:OnSetIsEnable(isShow)
    self.Btn.isEnabled = isShow
end
return GuildMemberItem