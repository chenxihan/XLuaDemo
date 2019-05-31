------------------------------------------------
--作者： _SqL_
--日期： 2019-04-16
--文件： UIMapCommonItem.lua
--模块： UIMapCommonItem
--描述： 地图怪 item
------------------------------------------------

local UIMapCommonItem = {
    -- Name Label
    NameLabel = nil,
    -- 当前对象的 Transform
    Trans = nil;
}

function UIMapCommonItem:New(trans)
    local _m = Utils.DeepCopy(self)
    _m.Trans = trans
    _m:FindAllComponents()
    _m:Show()
    return _m
end

function UIMapCommonItem:FindAllComponents()
    local _nameTrans = self.Trans:Find("name")
    if _nameTrans ~= nil then
        self.NameLabel = _nameTrans:GetComponent("UILabel")
    end
end

function UIMapCommonItem:SetInfo(name, position)
    if self.NameLabel~= nil and name then
        self.NameLabel.text = name
    end
    if position then
        self.Trans.localPosition = position
    end
    self.Trans.localScale = Vector3.one
end

function UIMapCommonItem:Clone(go, parentTrans)
    local obj = UnityUtils.Clone(go, parentTrans).transform
    return self:New(obj)
end

function UIMapCommonItem:Show()
    if not self.Trans.gameObject.activeSelf then
        self.Trans.gameObject:SetActive(true)
    end
end

function UIMapCommonItem:Close()
    self.Trans.gameObject:SetActive(false)
end

return UIMapCommonItem