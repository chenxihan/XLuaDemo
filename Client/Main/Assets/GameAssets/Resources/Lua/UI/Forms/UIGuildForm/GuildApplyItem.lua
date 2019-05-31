------------------------------------------------
--作者： 何健
--日期： 2019-05-24
--文件： GuildApplyItem.lua
--模块： GuildApplyItem
--描述： 宗派申请列表子项
------------------------------------------------
local L_PlayerLevel = require "UI.Components.UIPlayerLevelLabel"
local GuildApplyItem = {
    Trans = nil,
    Go = nil,
    --玩家名字
    NameLabel = nil,
    --等级
    Lvlabel = nil,
    --战力
    FightingLabel = nil,
    --头像
    IconSpr = nil,
    Data = nil
}

--创建一个新的对象
function GuildApplyItem:OnFirstShow(trans)
    local _m = Utils.DeepCopy(self)
    _m.Trans = trans
    _m.Go = trans.gameObject
    _m:FindAllComponents()
    return _m
end

--克隆一个
function GuildApplyItem:Clone()
    local _go = UnityUtils.Clone(self.Go)
    return self:OnFirstShow(_go.transform)
end

 --查找UI上各个控件
function GuildApplyItem:FindAllComponents()
    self.NameLabel = UIUtils.FindLabel(self.Trans, "List/NameLabel")
    self.FightingLabel = UIUtils.FindLabel(self.Trans, "List/FightLabel")
    self.IconSpr = UIUtils.FindSpr(self.Trans, "Icon")
    self.Lvlabel = L_PlayerLevel:OnFirstShow(UIUtils.FindTrans(self.Trans, "List/LvLabel"))
    local _btn = UIUtils.FindBtn(self.Trans, "AgreeBtn")
    UIUtils.AddBtnEvent(_btn, self.OnAgree, self)
    _btn = UIUtils.FindBtn(self.Trans, "RefuseBtn")
    UIUtils.AddBtnEvent(_btn, self.OnRefuse, self)
end

function GuildApplyItem:SetData(info)
    self.Data = info
    self.NameLabel.text = info.name
    self.IconSpr.spriteName = string.format( "head_%d",info.career)--CommonUtils.GetPlayerHeaderSpriteName(info.lv, info.career);
    self.Lvlabel:SetLevel(info.lv)
    self.FightingLabel.text = tostring(info.fighting)
end

--同意
function GuildApplyItem:OnAgree()
    local _req = {}
    local _temp = {}
    table.insert(_temp, self.Data.roleId)

    if #_temp > 0 then
        _req.roleId = _temp
        _req.agree = true
        GameCenter.Network.Send("MSG_Guild.ReqDealApplyInfo", _req)
    end
end

--拒绝
function GuildApplyItem:OnRefuse()
    local _req = {}
    local _temp = {}
    table.insert(_temp, self.Data.roleId)

    if #_temp > 0 then
        _req.roleId = _temp
        _req.agree = false
        GameCenter.Network.Send("MSG_Guild.ReqDealApplyInfo", _req)
    end
end
return GuildApplyItem