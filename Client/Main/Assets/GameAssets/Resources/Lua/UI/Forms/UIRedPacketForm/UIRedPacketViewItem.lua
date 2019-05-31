------------------------------------------------
--作者： 何健
--日期： 2019-05-28
--文件： UIRedPacketViewItem.lua
--模块： UIRedPacketViewItem
--描述： 查看红包界面，抢红包的玩家列表子项
------------------------------------------------

local UIRedPacketViewItem = {
    Trans = nil,
    Go = nil,
    --玩家名字
    NameLabel = nil,
    --数量
    NumLabel = nil,
}

--创建一个新的对象
function UIRedPacketViewItem:OnFirstShow(trans)
    local _m = Utils.DeepCopy(self)
    _m.Trans = trans
    _m.Go = trans.gameObject
    _m.NameLabel = UIUtils.FindLabel(_m.Trans, "Name")
    _m.NumLabel = UIUtils.FindLabel(_m.Trans, "Num")
    return _m
end

--克隆一个
function UIRedPacketViewItem:Clone()
    local _go = UnityUtils.Clone(self.Go)
    return self:OnFirstShow(_go.transform)
end

function UIRedPacketViewItem:SetData(info)
    self.NameLabel.text = info.RoleName
    self.NumLabel.text = info.Rpvalue
end
return UIRedPacketViewItem