------------------------------------------------
--作者： dhq
--日期： 2019-05-16
--文件： UIHouseAttrItem.lua
--模块： UIHouseAttrItem
--描述： 婚姻仙居的升级属性
------------------------------------------------

local UIHouseAttrItem = {
    --root
    RootGo = nil,
    Trans = nil,
    --Info = nil,
    -- 属性加成
    AddrLabel = nil,
    -- 升级加成
    UpLabel = nil,
}

function UIHouseAttrItem:New(go)
    local _result = Utils.DeepCopy(self);
    _result.RootGo = go;
    _result.Trans = go.transform;
    _result:OnFirstShow();
    return _result
end

function UIHouseAttrItem:OnFirstShow()
    self.AddrLabel = UIUtils.FindLabel(self.Trans, "Label");
    self.UpLabel = UIUtils.FindLabel(self.Trans, "Up/Label");
end

--刷新
function UIHouseAttrItem:Refresh(prop, num)
    --self.Info = info;
    -- if self.Info ~= nil then
    --     -- 攻击 40
    --     self.AddrLabel.text = string.format("%s %s", self.Info.Addr, self.Info.AddrNum)
    --     -- 500
    --     self.UpLabel.text = string.format("%s", self.Info.UpValue)
    -- end
    -- 攻击 40
    self.AddrLabel.text = string.format("%s %s", prop, num)
    -- 500
    self.UpLabel.text = string.format("%s", num)
end

return UIHouseAttrItem