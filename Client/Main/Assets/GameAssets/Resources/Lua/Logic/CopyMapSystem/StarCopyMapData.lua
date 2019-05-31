------------------------------------------------
--作者： 杨全福
--日期： 2019-04-19
--文件： StarCopyMapData.lua
--模块： StarCopyMapData
--描述： 星级副本数据，根据星级获得奖励
------------------------------------------------

local CopyMapBaseData = require("Logic.CopyMapSystem.CopyMapBaseData")

--构造函数
local StarCopyMapData = {
    --当前星级，0表示未通关，大于0表示星级
    CurStar = 0,
    --是否可以免费扫荡
    CanFreeSweep = false,
}


function StarCopyMapData:New(cfgData)
    local _n  = Utils.DeepCopy(self);
    local _mn = setmetatable(_n, {__index = CopyMapBaseData:New(cfgData)});
    return _mn;
end

--解析基础数据
function StarCopyMapData:ParseBaseMsg(msg)
end

--解析副本数据
function StarCopyMapData:ParseMsg(msg)
    self.CurStar = msg.starNum;
    self.CanFreeSweep = msg.canFreeSweep;
end

return StarCopyMapData