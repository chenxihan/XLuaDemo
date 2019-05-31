------------------------------------------------
--作者： gzg
--日期： 2019-05-15
--文件： LogicLuaEventDefine.lua
--模块： LogicLuaEventDefine
--描述： 逻辑的lua事件定义
------------------------------------------------
--逻辑的lua事件的基础ID
local L_BASE_ID = 700000

local LogicLuaEventDefine = {

    --玩家反馈列表改变的事件
    EID_FEEDBACK_LIST_CHANGED = 1,
    --刷新挑战副本
    EID_EVENT_UPDATE_TIAOZHANFUBEN = 2,
    --刷新星级副本界面
    EID_REFRESH_STARCOPY_PANEL = 3,
};

for k, v in pairs(LogicLuaEventDefine) do
    LogicLuaEventDefine[k] = v + L_BASE_ID;
end

return LogicLuaEventDefine;