------------------------------------------------
--作者： 王圣
--日期： 2019-04-26
--文件： RankItemData.lua
--模块： RankItemData
--描述： 排行榜item数据
------------------------------------------------
--引用
local RankItemData = {
    --排名
    Rank = 0,
    RoleId = 0,
    Level = 0,
    --职业
    Career = 0,
    --被赞美次数
    PraiseCount = 0,
    --vip
    VipLv = 0,
    Name = nil,
    --帮派名字
    GuildName = nil,
    Point = nil,
    --是否在线
    IsOnline = false,
}

function RankItemData:New(info)
    local _m = Utils.DeepCopy(self)
    _m.Rank = info.rank
    _m.RoleId = info.roleId
    _m.Level = info.level
    _m.Name = info.roleName
    _m.GuildName = info.guildName
    _m.Career = info.career
    _m.Point = info.rankData
    _m.PraiseCount = info.beWorshipedNum
    _m.IsOnline = info.isOnline
    _m.VipLv = info.viplevel
    return _m
end

function RankItemData:SetData(info)
    self.Rank = info.rank
    self.RoleId = info.roleId
    self.Level = info.level
    self.Name = info.roleName
    self.GuildName = info.guildName
    self.Career = info.career
    self.Point = info.rankData
    self.PraiseCount = info.beWorshipedNum
    self.IsOnline = info.isOnline
    self.VipLv = info.viplevel
end
return RankItemData