------------------------------------------------
--作者： 杨全福
--日期： 2019-04-19
--文件： CopyMapBaseData.lua
--模块： CopyMapBaseData
--描述： 副本基础数据
------------------------------------------------

--构造函数
local CopyMapBaseData = {
    --int 副本ID
    CopyID = 0,
    --副本配置
    CopyCfg = nil,
    --需求任务是否完成
    TaskFinish = false,
    --需求等级是否完成
    LevelFinish = false,
    --bool 是否开启
    IsOpen = false,
    --int 当前购买次数
    CurBuyCount = 0,
    --float cd时间
    CDTime = 0,
    --float 同步cd的时间
    CDSyncTime = 0,
}

function CopyMapBaseData:New(cfgData)
    local _m = Utils.DeepCopy(self);
    _m.CopyID = cfgData.Id;
    _m.CopyCfg = cfgData;
    _m.IsOpen = false;
    _m.CurBuyCount = 0;
    _m.CDTime = 0;
    _m.CDSyncTime = 0;
    return _m;
end

return CopyMapBaseData;