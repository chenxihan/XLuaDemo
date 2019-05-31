------------------------------------------------
--作者： xihan
--日期： 2019-05-07
--文件： LuaBehaviourManager.lua
--模块： LuaBehaviourManager
--描述： Lua端LuaBehaviour管理器
------------------------------------------------

--定义模块
local LuaBehaviourManager = {
    AllLuaBehaviourList = List:New(),
    AllLuaBehaviourDic = Dictionary:New(),
    UpdateLuaBehaviourList = List:New(),
}

--给对象添加LuaBehaviour组件，并关联对应的模块
function LuaBehaviourManager:Add(trans, table)
    if self.AllLuaBehaviourDic:ContainsKey(table) then
        return
    end
    local _luaBehaviour = UnityUtils.RequireLuaBehaviour(trans);
    self.AllLuaBehaviourList:Add(_luaBehaviour);
    self.AllLuaBehaviourDic:Add(table, _luaBehaviour);

    table._ActiveSelf_ = false;

    table._OnDestroy_ = function(obj)
        if obj.OnDestroy then
            obj:OnDestroy();
        end
        self:Remove(obj);
    end

    table._OnEnable_ = function(obj)
        if obj.OnEnable then
            obj:OnEnable();
        end
        table._ActiveSelf_ = true;
    end

    table._OnDisable_ = function(obj)
        if obj.OnDisable then
            obj:OnDisable();
        end
        table._ActiveSelf_ = false;
    end

    table._Start_ = function(obj)
        if obj.Start then
            obj:Start();
        end
        if obj.Update then
            self.UpdateLuaBehaviourList:Add(obj);
        end
    end

    _luaBehaviour.AwakeDelegate = Utils.Handler(table.Awake, table, nil, true);
    _luaBehaviour.StartDelegate = Utils.Handler(table._Start_, table, nil, true);
    _luaBehaviour.OnEnableDelegate = Utils.Handler(table._OnEnable_, table, nil, true);
    _luaBehaviour.OnDisableDelegate = Utils.Handler(table._OnDisable_, table, nil, true);
    _luaBehaviour.OnDestroyDelegate = Utils.Handler(table._OnDestroy_, table, nil, true);
    return _luaBehaviour;
end

--LuaBehaviour组件销毁时，自动移除
function LuaBehaviourManager:Remove(table)
    if self.AllLuaBehaviourDic:ContainsKey(table) then
        local _luaBehaviour = self.AllLuaBehaviourDic:Get(table);
        self.AllLuaBehaviourDic:Remove(table);
        self.AllLuaBehaviourList:Remove(_luaBehaviour);
        self.UpdateLuaBehaviourList:Remove(table);
    end
end

function LuaBehaviourManager:Update(deltaTime)
    for i=1,self.UpdateLuaBehaviourList:Count() do
        if self.UpdateLuaBehaviourList[i]._ActiveSelf_ then
            self.UpdateLuaBehaviourList[i]:Update();
        end
    end
end

return LuaBehaviourManager