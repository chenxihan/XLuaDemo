------------------------------------------------
--作者：gzg
--日期：2019-05-07
--文件：LuaEventHander.lua
--模块：LuaEventHander
--描述：事件处理系统
------------------------------------------------
local LuaEventHander = require("Common.CustomLib.LuaEventManager.LuaEventHander");
local CSGameCenter = CS.Funcell.Code.Center.GameCenter;

--事件管理器
local LuaEventManager = {
    EventList = List:New()
}

--注册事件函数
function LuaEventManager.RegFixEventHandle(id, func, caller)
    local idx = LuaEventManager.FindLuaEventHander(id,func,caller);
    if idx < 0 then
        local eh = LuaEventHander:New(id,func,caller);        
        eh.EventRet = CSGameCenter.RegFixEventHandle(eh.EventID, eh.Handler);
        LuaEventManager.EventList.Add(eh);
    end
end

--触发事件
function LuaEventManager.PushFixEvent(id,  obj, sender)
    CSGameCenter.PushFixEvent(id, obj, sender);
end

--卸载事件函数
function LuaEventManager.UnRegFixEventHandle(id, func, caller)
   local idx = LuaEventManager.FindLuaEventHander(id,func,caller);
   if idx > 0 then
       local eh = LuaEventManager.EventList[idx];
       if eh ~= nil then
            CSGameCenter.UnRegFixEventHandle(eh.EventID, eh.EventRet);
       end
       LuaEventManager.EventList:RemoveAt(idx);
   end
end

--查找事件函数
function LuaEventManager.FindLuaEventHander(id, func, caller)
    local es = LuaEventManager.EventList; 
    for i = 1, es:Count() do
        if(es[i].EventID == id  and es[i].Func == func and es[i].Caller == caller) then
            return i;
        end
    end
    return -1;
end

--清理所有的Lua端的事件函数
function LuaEventManager.ClearAllLuaEvents()
    local es = LuaEventManager.EventList; 
    for i = 1, es:Count() do       
       CSGameCenter.UnRegFixEventHandle(es[i].EventID, es[i].EventRet);
    end
    LuaEventManager.EventList:Clear();
end

return LuaEventManager;
