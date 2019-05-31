------------------------------------------------
--作者： dhq
--日期： 2019-05-16
--文件： UIHousePreviewAttrItem.lua
--模块： UIHousePreviewAttrItem
--描述： 婚姻仙居预览属性值
------------------------------------------------

local UIHousePreviewAttrItem = {
    --root
    RootGo = nil,
    Trans = nil,
    -- 属性
    PropLabel = nil,
    -- 属性值
    NumLabel = nil,
}

function UIHousePreviewAttrItem:New(go)
    local _result = Utils.DeepCopy(self);
    _result.RootGo = go;
    _result.Trans = go.transform;
    _result:OnFirstShow();
    return _result
end

function UIHousePreviewAttrItem:OnFirstShow()
    self.PropLabel = UIUtils.FindLabel(self.Trans, "Prop");
    self.NumLabel = UIUtils.FindLabel(self.Trans, "Num");
end

--刷新
function UIHousePreviewAttrItem:Refresh(prop, num)
    if prop ~= nil and num ~= nil then
        -- 攻击
        self.PropLabel.text = string.format("%s  ", prop)
        -- 500
        self.NumLabel.text = num
    end
end

return UIHousePreviewAttrItem