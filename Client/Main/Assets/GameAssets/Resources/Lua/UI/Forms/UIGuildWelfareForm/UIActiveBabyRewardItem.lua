------------------------------------------------
--作者： 何健
--日期： 2019-05-17
--文件： UIActiveBabyRewardItem.lua
--模块： UIActiveBabyRewardItem
--描述： 活跃宝贝奖励子控件
------------------------------------------------
local ItemBase = CS.Funcell.Code.Logic.ItemBase

local UIActiveBabyRewardItem = {
    Trans = nil,
    Go = nil,
    --物品名字
    ItemNameLabel = nil,
    --玩家名字
    PlayerNameLabel = nil,
    Icon = nil,
}

--创建一个新的对象
function UIActiveBabyRewardItem:OnFirstShow(trans)
    local _m = Utils.DeepCopy(self)
    _m.Trans = trans
    _m.Go = trans.gameObject
    _m:FindAllComponents()
    return _m
 end
 --创建一个新的对象
function UIActiveBabyRewardItem:New(go)
    local _m = Utils.DeepCopy(self)
    _m.Trans = go.transform
    _m.Go = go
    _m:FindAllComponents()
    return _m
 end

 --克隆一个对象
function UIActiveBabyRewardItem:Clone()
    local _trans = UnityUtils.Clone(self.Go)
    return UIActiveBabyRewardItem:New(_trans)
end

 --查找UI上各个控件
function UIActiveBabyRewardItem:FindAllComponents()
    self.ItemNameLabel = UIUtils.FindLabel(self.Trans, "ItemNameLabel")
    self.PlayerNameLabel = UIUtils.FindLabel(self.Trans, "PlayerNameLabel")
    self.Icon = UnityUtils.RequireComponent(UIUtils.FindTrans(self.Trans, "Icon"), "Funcell.GameUI.Form.UIIconBase")
end

  --更新物品
function UIActiveBabyRewardItem:OnUpdateItem(id, name)
    local _item = ItemBase.CreateItemBase(id)
    if _item ~= nil then
        if _item.ItemInfo ~= nil then
            self.Icon:UpdateIcon(_item.ItemInfo.Icon)
            self.ItemNameLabel.text = _item.Name
        end
    end
    self.PlayerNameLabel.text = name
end
return  UIActiveBabyRewardItem