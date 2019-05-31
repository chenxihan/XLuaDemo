------------------------------------------------
--作者： 何健
--日期： 2019-05-13
--文件： UIGuildListItem.lua
--模块： UIGuildListItem
--描述： 宗派列表排行列表子项
------------------------------------------------

local UIGuildListItem = {
    Trans = nil,
    Go = nil,
    --宗派名字
    NameLabel = nil,
    --宗派排名
    RankLabel = nil,
    --宗主名字
    LeaderLabel = nil,
    --成员数量
    NumLabel = nil,
    --宗派战力
    FightLabel = nil,
    --申请加入按钮
    EnterBtn = nil,
    DataInfo = nil,
}

--创建一个新的对象
function UIGuildListItem:OnFirstShow(trans)
    local _m = Utils.DeepCopy(self)
    _m.Trans = trans
    _m.Go = trans.gameObject
    _m:FindAllComponents()
    return _m
 end

 --查找UI上各个控件
 function UIGuildListItem:FindAllComponents()
    self.NameLabel = UIUtils.FindLabel(self.Trans, "List/NameLabel")
    self.RankLabel = UIUtils.FindLabel(self.Trans, "List/RankLabel")
    self.LeaderLabel = UIUtils.FindLabel(self.Trans, "List/LeaderLabel")
    self.NumLabel = UIUtils.FindLabel(self.Trans, "List/NumLabel")
    self.FightLabel = UIUtils.FindLabel(self.Trans, "List/PowerLabel")

    local _trans = UIUtils.FindTrans(self.Trans, "EnterBtn")
    if _trans ~= nil then
        self.EnterBtn = UIUtils.FindBtn(self.Trans, "EnterBtn")
        UIUtils.AddBtnEvent(self.EnterBtn, self.OnEnterBtnClick, self)
    end
 end

 --更新物品
 function UIGuildListItem:OnUpdateItem(info)
    if info == nil then
        Debug.LogError("加载错误，数据为空")
        return
    end
    self.DataInfo = info
    self.NameLabel.text = info.name
    self.RankLabel.text = tostring(info.RankNum)
    self.FightLabel.text = tostring(info.fighting)
    self.LeaderLabel.text = info.leaderName

    local guildConfig = DataConfig.DataGuildUp[10000 + info.lv]
    if guildConfig ~= nil then
        self.NumLabel.text = string.format("%d/%d", info.memberNum, guildConfig.BaseNum)
    else
        self.NumLabel.text = ""
    end
 end

function UIGuildListItem:OnEnterBtnClick()
    GameCenter.Network.Send("MSG_Guild.ReqJoinGuild", {guildId = self.DataInfo.guildId})
end
return UIGuildListItem