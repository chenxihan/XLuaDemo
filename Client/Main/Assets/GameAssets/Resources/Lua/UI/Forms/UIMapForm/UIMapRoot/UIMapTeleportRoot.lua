------------------------------------------------
--作者： _SqL_
--日期： 2019-04-16
--文件： UIMapTeleportRoot.lua
--模块： UIMapTeleportRoot
--描述： 传送点 Root
------------------------------------------------
local UIMapCommonItem = require("UI.Forms.UIMapForm.UIMapItem.UIMapCommonItem")

local UIMapTeleportRoot = {
    Owner = nil,
    -- 当前对像的Transform
    Trans = nil,
    -- 显示Icon
    Icon = nil;
    -- 父节点Transform
    ParentNodeTrans = nil,
}

-- 初始化
function UIMapTeleportRoot:New(owner, trans)
    self.Owner = owner
    self.Trans = trans
    self:FindAllComponents()
    return self
end

function UIMapTeleportRoot:FindAllComponents()
    self.ParentNodeTrans = self.Trans:Find("All")
    self.Icon = self.Trans:Find("All/teleportres").gameObject
end

-- 载入传送点的位置
function UIMapTeleportRoot:LoadTeleportPoint(teleportInfo)
    for i = 0, self.ParentNodeTrans.childCount - 1 do
        if self.ParentNodeTrans:GetChild(i) ~= nil then
            self.ParentNodeTrans:GetChild(i).gameObject:SetActive(false)
        end
    end

    local _index = 1
    local _iter = teleportInfo
    while _iter:MoveNext() do
        local _item = nil
        local _info = _iter.Current
        if _index <= self.ParentNodeTrans.childCount then
            _item = UIMapCommonItem:New(self.ParentNodeTrans:GetChild(_index -1))
        else
            _item = UIMapCommonItem:Clone(self.Icon, self.ParentNodeTrans)
        end

        _item:SetInfo(DataConfig.DataMapsetting[ _info.Key ].Name, self.Owner:WorldPosToMapPos(_info.Pos))
        _index = _index + 1
    end
end

return UIMapTeleportRoot