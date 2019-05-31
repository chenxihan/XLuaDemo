------------------------------------------------
--作者： 何健
--日期： 2019-04-22
--文件： UIAttributeComponent.lua
--模块： UIAttributeComponent
--描述： 装备TIPS上单个属性组件
------------------------------------------------
local L_BattlePropTools = CS.Funcell.Code.Logic.BattlePropTools
local UIAttributeComponent ={
    Trans = nil,
    Go = nil,
    ValueLabel = nil,
    Data = nil
}

function UIAttributeComponent:New(trans)
    local _m = Utils.DeepCopy(self)
    _m.Trans = trans
    _m.GO = trans.gameObject
    _m:FindAllComponents()
    return _m
end

--查找组件
function UIAttributeComponent:FindAllComponents()
    self.ValueLabel = self.Trans:GetComponent("UILabel")
end

--克隆一个对象
function UIAttributeComponent:Clone()
    local _go = GameObject.Instantiate(self.GO)
    local _trans = _go.transform
    _trans.parent = self.Trans.parent
    UnityUtils.ResetTransform(_trans)
    return UIAttributeComponent:New( _trans)
end

--设置Active
function UIAttributeComponent:SetActive(active)
    self.GO:SetActive(active)
end

--设置数据或者配置文件
function UIAttributeComponent:SetData(dat)
    self.Data = dat
    self:RefreshData()
end

function UIAttributeComponent:RefreshData()
    if(self.Data ~= nil) then
        self.ValueLabel.text = string.format( "%s:%s", L_BattlePropTools.GetBattlePropName(AllBattleProp.__CastFrom(self.Data.ID)),
        L_BattlePropTools.GetBattleValueText(self.Data.ID, self.Data.Value))
    else
        Debug.LogError("数据是空,UIAttributeComponent:RefreshData");
    end
end
--设置名字
function UIAttributeComponent:SetName(name)
    self.GO.name = name;
end

function UIAttributeComponent:OnSetValueShow()
    if(self.Data ~= nil) then
        self.ValueLabel.text = string.format( "%s:%s%", L_BattlePropTools.GetBattlePropName(AllBattleProp.__CastFrom(self.Data.ID)),
        L_BattlePropTools.GetBattleValueText(self.Data.ID, self.Data.Value))
    else
        Debug.LogError("数据是空,UIAttributeComponent:OnSetValueShow");
    end
end

function UIAttributeComponent:OnSetColor(labelColor)
        self.ValueLabel.color = labelColor
end

return UIAttributeComponent