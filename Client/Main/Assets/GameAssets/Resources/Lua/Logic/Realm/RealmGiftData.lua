
------------------------------------------------
--作者： _SqL_
--日期： 2019-05-23
--文件： RealmGiftData.lua
--模块： RealmGiftData
--描述： 境界礼包数据
------------------------------------------------
local RealmGiftData = {
    ID = 0,
    Sort = nil,                             -- 排序使用 优先级高 > 优先级低
    ShowTime = nil,                         -- 礼包在界面显示的时间
    CdTime = nil,                           -- 倒计时完毕 下个礼包显示等待的时间
}

function RealmGiftData:New(id)
    local _m = Utils.DeepCopy(self)
    _m.ID = id
    _m:RefreshData(id)
    return _m
end

-- 刷新数据
function RealmGiftData:RefreshData(id)
    local _cfg = DataConfig.DataStatePackage[id]
    if not _cfg then
        Debug.LogError("DataStatePackage not contains key = ", id)
        return
    end
    self.ShowTime = _cfg.ShowTime * 60
    self.CdTime = _cfg.CdTime * 60
    self.Sort = _cfg.Level
end

return RealmGiftData