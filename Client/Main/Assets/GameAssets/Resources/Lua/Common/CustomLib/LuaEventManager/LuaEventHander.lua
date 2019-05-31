------------------------------------------------
--作者：gzg
--日期：2019-05-07
--文件：LuaEventHander.lua
--模块：LuaEventHander
--描述：事件句柄的定义
------------------------------------------------
--事件句柄定义
local LuaEventHander={
    --事件ID
    EventID = nil,
    --事件返回的委托
    EventRet = nil,
    --函数调用者
    Caller = nil,
    --函数
    Func = nil,
    --形成的事件句柄
    Handler = nil;
};

--新的事件Handler
function LuaEventHander:New(id, func, caller)
    local _m = Utils.DeepCopy(self);
    _m.EventID = id;
    _m.Caller = caller;
    _m.Func = func;
    if caller == nil then
        _m.Handler = func;
    else
        _m.Handler = Utils.Handler(func,caller);
    end
    return _m;
end

return LuaEventHander;