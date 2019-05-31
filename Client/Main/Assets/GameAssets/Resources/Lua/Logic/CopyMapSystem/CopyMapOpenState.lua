------------------------------------------------
--作者： 杨全福
--日期： 2019-05-8
--文件： CopyMapOpenState.lua
--模块： CopyMapOpenState
--描述： 副本开启状态数据
------------------------------------------------
local socket = require "socket";

--构造函数
local CopyMapOpenState = {
    --int 副本ID
    CopyID = 0,
    --当前状态
    CurState = CopyMapStateEnum.NotOpen,
    --剩余时间,根据当前状态决定意义
    --0未开启为下次开启的倒计时
    --1等待进入倒计时
    --2当前战斗倒计时
    RemainTime = 0.0,
    --同步数据的时间，用于计算具体剩余时间
    SyncTime = 0.0,
}

function CopyMapOpenState:New()
    local _m = Utils.DeepCopy(self);
    _m.CopyID = 0;
    _m.CurState = CopyMapStateEnum.NotOpen;
    _m.RemainTime = 0.0;
    _m.SyncTime = 0.0;
    return _m
end

--获取具体的剩余时间
function CopyMapOpenState:GetReaminTime()
    return self.RemainTime - (Time.GetRealtimeSinceStartup() - self.SyncTime);
end

--解析数据
function CopyMapOpenState:ParseMsg(msg)
    self.CopyID = msg.cloneType;
    self.CloneState = msg.cloneState;
    self.RemainTime = msg.cloneValue;
    self.SyncTime = Time.GetRealtimeSinceStartup();
end

return CopyMapOpenState