------------------------------------------------
--作者： gzg
--日期： 2019-03-25
--文件： UILuaEventDefine.lua
--模块： UILuaEventDefine
--描述： 事件定义窗口(非c#定义的窗体事件),事件的起始是从50000 + EventConstDefine.EVENT_UI_BASE_ID开始
------------------------------------------------

local L_BASE_ID = EventConstDefine.EVENT_UI_BASE_ID

--模块定义
local UILuaEventDefine = {
    --消息窗体定义
    UIMessageBoxForm_OPEN = 50100 + L_BASE_ID,
    UIMessageBoxForm_CLOSE = 50109 + L_BASE_ID,


}

--这里把Event中Key和Value进行翻转,并保存到_temp中.
local _temp={}
for k, v in pairs(UILuaEventDefine) do
    _temp[v] = k
end

--判断是否有某个事件
function UILuaEventDefine.HasEvent(eID)
    return not(not _temp[eID])
end

return UILuaEventDefine