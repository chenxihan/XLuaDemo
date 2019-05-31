------------------------------------------------
--作者： _SqL_
--日期： 2019-04-30
--文件： UIPlayerInfoRoot.lua
--模块： UIPlayerInfoRoot
--描述： PlayerInfo Root
------------------------------------------------

local UIPlayerInfoRoot = {
    Owner = nil,
    Trans = nil,
    Name = nil,                             -- 名字
    Lv = nil,                               -- 等级
    Power = nil,                            -- 战斗力
    Lover = nil,                            -- 伴侣
    Faction = nil,                          -- 宗派 公会 或者。。。 
    Career = nil,                           -- 职业
    PlayerId = nil,                         -- 角色id
    PlayerHead = nil,                       -- 头像显示组件
    PlayerInfo = nil,                       -- 角色信息
}

function  UIPlayerInfoRoot:New(owner, trans)
    self.Owner = owner
    self.Trans = trans
    self:FindAllComponents()
    return self
end

function UIPlayerInfoRoot:FindAllComponents()
    self.Name = UIUtils.FindLabel(self.Trans, "Left/Name")
    self.Lv = UIUtils.FindLabel(self.Trans, "Left/Level")
    self.PlayerId = UIUtils.FindLabel(self.Trans, "Left/ID")
    self.Power = UIUtils.FindLabel(self.Trans, "Right/Power")
    self.Faction = UIUtils.FindLabel(self.Trans, "Right/Faction")
    self.Career = UIUtils.FindLabel(self.Trans, "Right/Career")
    self.Lover = UIUtils.FindLabel(self.Trans, "Right/Lover")

    local _head = UIUtils.FindTrans(self.Trans, "HeadBack/UIPlayerHead")
    self.PlayerHead = UnityUtils.RequireComponent(_head, "Funcell.GameUI.Form.UIPlayerHead")
end

function UIPlayerInfoRoot:SetPalyerInfo(info)
    if info then
        self.Lv.text = info.Lv
        self.Name.text = info.Name
        self.Lover.text = info.Lover
        self.Faction.text = info.Faction
        self.Power = tostring(info.Power)
        self.PlayerId = tostring(info.PlayerId)

        local _carrerStr = tostring(info.Career)
        self.Career.text = Utils.GetEnumString(_carrerStr)
        self.PlayerHead:SetInfo(true, info.PlayerId, Utils.GetEnumNumber(_carrerStr), info.Lv)
    else
        Debug.LogError("Info = nil")
    end
end

function UIPlayerInfoRoot:OnOpen()
    self.Trans.gameObject:SetActive(true)
end

function UIPlayerInfoRoot:OnCLose()
    self.Trans.gameObject:SetActive(false)
end

return UIPlayerInfoRoot