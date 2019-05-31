------------------------------------------------
--作者：何健
--日期：2019-05-29
--文件：LuaDelegateHander.lua
--模块：LuaDelegateHander
--描述：委托句柄的定义
------------------------------------------------
--委托句柄定义
local LuaDelegateHander={
    --引用计数
    Ref = 0,
    --函数调用者
    Caller = nil,
    --函数
    Func = nil,
    --形成的事件句柄
    Handler = nil;
};

--新的事件Handler
function LuaDelegateHander:New(func, caller)
    local _m = Utils.DeepCopy(self);
    _m.Caller = caller;
    _m.Func = func;
    _m.Ref = 1;
    if caller == nil then
        _m.Handler = func;
    else
        _m.Handler = Utils.Handler(func,caller);
    end
    return _m;
end

----引用计数加一
function LuaDelegateHander:IncRef()
    self.Ref = self.Ref + 1
end

--引用计数减一
function LuaDelegateHander:DecRef()
    self.Ref = self.Ref - 1
end

return LuaDelegateHander;