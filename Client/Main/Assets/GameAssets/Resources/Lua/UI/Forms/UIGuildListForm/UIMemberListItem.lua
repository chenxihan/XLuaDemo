------------------------------------------------
--作者： 何健
--日期： 2019-05-14
--文件： UIMemberRankItem.lua
--模块： UIMemberRankItem
--描述： 宗派个人排行子控件
------------------------------------------------

local UIMemberListItem = {
    Trans = nil,
    Go = nil,
    --名字
    NameLabel = nil,
    --排名
    RankLabel = nil,
    --等级
    LevelLabel = nil,
    --称号描述
    TitleLabel = nil,
    --战力
    FightLabel = nil
}

--创建一个新的对象
function UIMemberListItem:OnFirstShow(trans)
    local _m = Utils.DeepCopy(self)
    _m.Trans = trans
    _m.Go = trans.gameObject
    _m:FindAllComponents()
    return _m
 end

 --查找UI上各个控件
 function UIMemberListItem:FindAllComponents()
    self.NameLabel = UIUtils.FindLabel(self.Trans, "NameLabel")
    self.RankLabel = UIUtils.FindLabel(self.Trans, "RankLabel")
    self.LevelLabel = UIUtils.FindLabel(self.Trans, "LevelLabel")
    self.FightLabel = UIUtils.FindLabel(self.Trans, "PowerLabel")
    self.TitleLabel = UIUtils.FindLabel(self.Trans, "TitleLabel")
 end

  --更新物品
  function UIMemberListItem:OnUpdateItem(info, isTitle)
    if info == nil then
        Debug.LogError("加载错误，数据为空")
        return
    end
    self.NameLabel.text = info.name
    self.RankLabel.text = tostring(info.RankNum)
    self.FightLabel.text = tostring(info.fighting)
    self.LevelLabel.text = string.format( "Lv.%d", info.lv)
    if not isTitle then
        self.TitleLabel.text = "排名前10拥有称谓"
    else
        self.TitleLabel.text = ""
    end
 end
return  UIMemberListItem