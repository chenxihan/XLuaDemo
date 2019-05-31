------------------------------------------------
--作者： 何健
--日期： 2019-05-17
--文件： UIActiveBabyRankItem.lua
--模块： UIActiveBabyRankItem
--描述： 活跃宝贝排行子控件
------------------------------------------------
local ItemBase = CS.Funcell.Code.Logic.ItemBase

local UIActiveBabyRankItem = {
    Trans = nil,
    Go = nil,
    RankLabel = nil,
    --活跃度
    ActiveNumLabel = nil,
    --玩家名字
    PlayerNameLabel = nil,
}

--创建一个新的对象
function UIActiveBabyRankItem:OnFirstShow(trans)
    local _m = Utils.DeepCopy(self)
    _m.Trans = trans
    _m.Go = trans.gameObject
    _m:FindAllComponents()
    return _m
 end
 --创建一个新的对象
function UIActiveBabyRankItem:New(go)
    local _m = Utils.DeepCopy(self)
    _m.Trans = go.transform
    _m.Go = go
    _m:FindAllComponents()
    return _m
 end

 --克隆一个对象
function UIActiveBabyRankItem:Clone()
    local _trans = UnityUtils.Clone(self.Go)
    return UIActiveBabyRankItem:New(_trans)
end

 --查找UI上各个控件
function UIActiveBabyRankItem:FindAllComponents()
    self.ActiveNumLabel = UIUtils.FindLabel(self.Trans, "NumLabel")
    self.PlayerNameLabel = UIUtils.FindLabel(self.Trans, "PlayerNameLabel")
    self.RankLabel = UIUtils.FindLabel(self.Trans, "RankLabel")
end

  --更新物品
function UIActiveBabyRankItem:OnUpdateItem(rank, name, num)
    self.RankLabel.text = tostring(rank)
    self.PlayerNameLabel.text = name
    self.ActiveNumLabel.text = tostring(num)
end
return  UIActiveBabyRankItem