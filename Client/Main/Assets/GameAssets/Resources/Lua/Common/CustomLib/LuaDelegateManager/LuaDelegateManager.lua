------------------------------------------------
--作者： 何健
--日期： 2019-05-29
--文件： LuaDelegateManager.lua
--模块： LuaDelegateManager
--描述： Lua端委托管理器
------------------------------------------------
local L_DelegateHander = require("Common.CustomLib.LuaDelegateManager.LuaDelegateHander")
local LuaDelegateManager = {
    -- 委托列表
    DelegateList = List:New(),
}

function LuaDelegateManager.Add(delegateClass, delegateName, func, caller)
    local _hander = LuaDelegateManager.FindOrCreate(func, caller)
    if delegateClass[delegateName] == nil then
        delegateClass[delegateName] = _hander.Handler
    else
        delegateClass[delegateName] = delegateClass[delegateName] + _hander.Handler
    end
    return  _hander.Handler
end

function LuaDelegateManager.Remove(delegateClass, delegateName, func, caller)
    local _hander, _index = LuaDelegateManager.Find(func, caller)
    if _hander ~= nil then
        _hander:DecRef()
        if delegateClass[delegateName] ~= nil then
            delegateClass[delegateName] = delegateClass[delegateName] - _hander.Handler
        end
        if _hander.Ref == 0 then
            LuaDelegateManager.DelegateList:RemoveAt(_index)
        end
        return _hander.Handler
    end
end

function LuaDelegateManager.FindOrCreate(func, caller)
    local _hander = nil
    for i = 1, #LuaDelegateManager.DelegateList do
        if LuaDelegateManager.DelegateList[i].Func == func and LuaDelegateManager.DelegateList[i].Caller == caller then
            _hander = LuaDelegateManager.DelegateList[i]
            _hander:IncRef()
        end
    end
    if _hander == nil then 
        _hander = L_DelegateHander:New(func, caller)
        LuaDelegateManager.DelegateList:Add(_hander)
    end
    return _hander
end

function LuaDelegateManager.Find(func, caller)
    for i = 1, #LuaDelegateManager.DelegateList do
        if LuaDelegateManager.DelegateList[i].Func == func and LuaDelegateManager.DelegateList[i].Caller == caller then
            return LuaDelegateManager.DelegateList[i], i
        end
    end
end
return LuaDelegateManager