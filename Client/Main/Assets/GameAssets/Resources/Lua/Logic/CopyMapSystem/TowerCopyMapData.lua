------------------------------------------------
--作者： 杨全福
--日期： 2019-04-19
--文件： TowerCopyMapData.lua
--模块： TowerCopyMapData
--描述： 爬塔副本数据
------------------------------------------------

local CopyMapBaseData = require("Logic.CopyMapSystem.CopyMapBaseData")

--构造函数
local TowerCopyMapData = {
    --当前关数(正在挑战的关卡，默认值1)
    CurLevel = 1,
}

function TowerCopyMapData:New(cfgData)
    local _n = Utils.DeepCopy(self);
    local _mn = setmetatable(_n, {__index = CopyMapBaseData:New(cfgData)});
    return _mn;
end

--解析基础数据
function TowerCopyMapData:ParseBaseMsg(msg)
end

--解析副本数据
function TowerCopyMapData:ParseMsg(msg)
    self.CurLevel = msg.overLevel;
    if self.CurLevel == nil or self.CurLevel < 1 then
        self.CurLevel = 1;
    end
    GameCenter.PlayerShiHaiSystem:RefreshRedPointData();
end

--副本中通关
function TowerCopyMapData:OnFinishLevel(level)
    self.CurLevel = level;
    GameCenter.PlayerShiHaiSystem:RefreshRedPointData();
end

return TowerCopyMapData