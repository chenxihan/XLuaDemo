------------------------------------------------
--作者： 王圣
--日期： 2019-04-28
--文件： RankItemGetComponent.lua
--模块： RankItemGetComponent
--描述： 排行榜行名Item组件
------------------------------------------------

-- c#类
local RankItemGetComponent = {
    RoleId = 0,
    Trans = nil,
    --label
    RankLabel = nil,
    NameLabel = nil,
    GuildLabel = nil,
    PointLabel = nil,
    --sprite
    IconSpr = nil,
    SelectSpr = nil,
    --btn
    SelectBtn = nil,
    --bool
    IsSelect = false,
}

function RankItemGetComponent:New(trans, roleId)
    if trans == nil then
        return
    end
    local _m = Utils.DeepCopy(self)
    _m.Trans = trans
    _m.RoleId = roleId
    _m.RankLabel = UIUtils.RequireUILabel(trans:Find("Rank"))
    _m.NameLabel = UIUtils.RequireUILabel(trans:Find("Name"))
    _m.GuildLabel = UIUtils.RequireUILabel(trans:Find("Guild"))
    _m.PointLabel = UIUtils.RequireUILabel(trans:Find("Point"))
    _m.IconSpr = UIUtils.RequireUISprite(trans:Find("Head"))
    _m.SelectSpr = trans:Find("Select"):GetComponent("UISprite")
    _m.SelectSpr.gameObject:SetActive(false)
    _m.SelectBtn = trans:GetComponent("UIButton")
    return _m
end


function RankItemGetComponent:PraseData(data)
    self.RankLabel.text = data.Rank
    self.NameLabel.text = data.Name
    self.GuildLabel.text = data.GuildName
    self.PointLabel.text = data.Point
    self.IconSpr.spriteName = CommonUtils.GetPlayerHeaderSpriteName(data.Level,data.Career)
end

function RankItemGetComponent:UnSelect()
    self.SelectSpr.gameObject:SetActive(false)
end

return RankItemGetComponent
