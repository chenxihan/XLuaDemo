------------------------------------------------
--作者： _SqL_
--日期： 2019-05-27
--文件： UIPlayerPropertyRoot.lua
--模块： UIPlayerPropertyRoot
--描述： 玩家属性Root
------------------------------------------------
local PlayerPropetry = CS.Funcell.Code.Logic.PlayerPropetry

local UIPlayerPropertyRoot = {
    Owner = nil,
    Trans = nil,
    ListPanel = nil,                            -- 属性Item 父节点
    PropertyItem = nil,                         -- 属性Item trans
    ScrollViewTrans = nil,                      -- 滑动组件Trans
}

function UIPlayerPropertyRoot:New(owner, trans)
    self.Owner = owner
    self.Trans = trans
    self:FindAllComponents()
    return self
end

function UIPlayerPropertyRoot:FindAllComponents()
    self.ListPanel = UIUtils.FindTrans(self.Trans, "PropertyList/Grid")
    self.PropertyItem = UIUtils.FindTrans(self.Trans, "PropertyList/Grid/Item")
    self.ScrollViewTrans = UIUtils.FindTrans(self.Trans, "PropertyList")
end

-- 刷新角色属性信息
function UIPlayerPropertyRoot:RefreshPlayerProperty(attrList)
    for i = 0, self.ListPanel.childCount - 1 do
        self.ListPanel:GetChild(i).gameObject:SetActive(false)
    end
    local _index = 0
    for i = 1, #attrList do
        if attrList[i].Show then
            local _go = nil
            if _index < self.ListPanel.childCount then
                _go = self.ListPanel:GetChild(_index)
            else
                _go = UnityUtils.Clone(self.PropertyItem.gameObject, self.ListPanel).transform
            end
            self:SetPropertyValue(_go, attrList[i].Name, attrList[i].Value)
            _index  = _index + 1
        end
    end
    UnityUtils.GridResetPosition(self.ListPanel)
    UnityUtils.ScrollResetPosition(self.ScrollViewTrans)
end


-- 设置属性值
function UIPlayerPropertyRoot:SetPropertyValue(trans, name, value)
    trans.gameObject:SetActive(true)
    trans:GetComponent("UILabel").text = name
    UIUtils.FindLabel(trans, "Value").text = tostring(value)
end

return UIPlayerPropertyRoot