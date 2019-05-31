------------------------------------------------
--作者： _SqL_
--日期： 2019-04-16
--文件： UIMapGoldMonsterRoot.lua
--模块： UIMapGoldMonsterRoot
--描述： 地图黄金怪 Root
------------------------------------------------
local UIMapCommonItem = require("UI.Forms.UIMapForm.UIMapItem.UIMapCommonItem")

local UIMapGoldMonsterRoot = {
    Owner = nil,
    -- 当前对像的Transform
    Trans = nil,
    -- 怪物显示Icon
    MonsterIcon = nil;
    -- 怪物Icon 父节点Transform
    ParentNodeTrans = nil,
}

-- 初始化
function UIMapGoldMonsterRoot:New(owner,trans)
    self.Owner = owner
    self.Trans = trans
    self:FindAllComponents()
    return self
end

function UIMapGoldMonsterRoot:FindAllComponents()
    self.ParentNodeTrans = self.Trans:Find("All")
    self.MonsterIcon = self.Trans:Find("All/huangJingRes").gameObject
end

-- 载入黄金刷怪点的位置
function UIMapGoldMonsterRoot:LoadGoldMonster(mapId)
    for i = 0, self.ParentNodeTrans.childCount - 1 do
        if self.ParentNodeTrans:GetChild(i) ~= nil then
            self.ParentNodeTrans:GetChild(i).gameObject:SetActive(false)
        end
    end

    local _index = 0
    for k, v in pairs(DataConfig.DataBetterPlace) do
        if v.MapID == mapId then
            local _item = nil
            if _index < self.ParentNodeTrans.childCount then
                _item = UIMapCommonItem:New(self.ParentNodeTrans:GetChild(_index))
            else
                _item = UIMapCommonItem:Clone(self.MonsterIcon, self.ParentNodeTrans)
            end
            local _posArray = Utils.SplitStr(v.Coordinate, "_")
            local _worldPos = Vector3(tonumber(_posArray[1]),0,tonumber(_posArray[2]))
            _item:SetInfo("[" .. v.Name .. "]", self.Owner:WorldPosToMapPos(_worldPos))
            _index = _index + 1
        end
    end
end

return UIMapGoldMonsterRoot