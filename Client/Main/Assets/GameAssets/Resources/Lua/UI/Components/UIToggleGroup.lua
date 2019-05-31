------------------------------------------------
--作者： gzg
--日期： 2019-04-9
--文件： UIToggleGroup.lua
--模块： UIToggleGroup
--描述： 点选开关组件的Group
--[[
    对象的GameObjectTree的形状:    
    --ParentNode
              --Item_01
              --Item_02
              --Item_03
              --Item_04

    备注:其中Item_xx节点需要添加UIToggle组件.
]]--
------------------------------------------------

local UIToggleGroup={
   Owner = nil,
   Trans = nil,
   GroupID = 0,
   Toggles = Dictionary:New(),
   SwitchProps = nil,
};

--构造对象
function UIToggleGroup:New(owner,trans,groupID,switchProps)
    local _m = Utils.DeepCopy(self);
    _m.Owner = owner;
    _m.Trans = trans;
    _m.GroupID = groupID;
    _m.SwitchProps = switchProps;
    _m:FindAllComponents();    
    return _m;
end

--查找所有组件
function UIToggleGroup:FindAllComponents()
    local _trans = self.Trans;
    for i = 0, _trans.childCount-1 do
        local _c = _trans:GetChild(i);        
        local _toggle = _c:GetComponent("UIToggle");
        if _toggle ~= nil then                    
            _toggle.group = self.GroupID;
            UIUtils.AddOnChangeEvent(_toggle,self.OnToggleChanged,self,_toggle);            
            local _flag = tonumber(string.sub(_c.name,-2));
            self.Toggles[_toggle] = _flag;            
        end
    end
end

--刷新当前组件
function UIToggleGroup:Refresh()
    for k,v in pairs(self.Toggles) do
        local _prop = self.SwitchProps[v];
        if _prop ~= nil then
            k.value = _prop.Get();
        end
    end
end

--开关组件被改变时的处理
function UIToggleGroup:OnToggleChanged(toggle)    
    if self.SwitchProps ~= nil  then
        local _flag = self.Toggles[toggle];
        local _prop = self.SwitchProps[_flag];        
        if _prop ~= nil then            
            _prop.Set(toggle.value);
        end
    else        
        if self.Owner ~= nil and self.Owner.OnToggleChanged ~= nil then            
            self.Owner.OnToggleChanged(toggle);
        end
    end
end

return UIToggleGroup;