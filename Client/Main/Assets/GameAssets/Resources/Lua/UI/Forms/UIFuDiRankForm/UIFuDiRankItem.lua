
------------------------------------------------
--作者： 王圣
--日期： 2019-05-10
--文件： UIFuDiRankItem.lua
--模块： UIFuDiRankItem
--描述： 福地排行Item
------------------------------------------------

-- c#类
local UIFuDiRankItem = {
    Trans = nil,
    RankLabel = nil,
    NameLabel = nil,
    LevelLabel = nil,
    FightLabel = nil,
}

function UIFuDiRankItem:New(trans)
    if trans == nil then
        return
    end
    local _m = Utils.DeepCopy(self)
    _m.Trans = trans
    _m.RankLabel = trans:Find("Rank"):GetComponent("UILabel")
    _m.NameLabel = trans:Find("Name"):GetComponent("UILabel")
    _m.LevelLabel = trans:Find("Level"):GetComponent("UILabel")
    _m.FightLabel = trans:Find("Fightpoint"):GetComponent("UILabel")
    return _m
end

function UIFuDiRankItem:SetData(data)
    self.RankLabel.text = tostring(data.Rank)
    self.LevelLabel.text = tostring(data.Level)
    self.FightLabel.text = tostring(data.FightPoint)
    self.NameLabel.text = data.Name
end
return UIFuDiRankItem