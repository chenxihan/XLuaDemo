------------------------------------------------
--作者： dhq
--日期： 2019-05-13
--文件： TitleData.lua
--模块： TitleData
--描述： 称号的数据类
------------------------------------------------

local TitleData =
{
    TitleName = nil,
    --称号图片的名字
    TexName = nil,
    --达成需要的亲密度
    IntimateAll = nil,
    --称号获得进度
    CurPercent = nil,
}

function TitleData:New(cfg)
    local _m = Utils.DeepCopy(self)
    local _cfg = cfg
    _m.TitleName = _cfg.TitleName
    _m.TexName = string.format( "tex_chenghao_%s", _cfg.TitleId )
    _m.IntimateAll = _cfg.NeedValue
    local _intimate = 0
    if GameCenter.MarrySystem.MarryData.IntimacyValue ~= nil then
        _intimate = GameCenter.MarrySystem.MarryData.IntimacyValue
    end
    if _m.IntimateAll ~= 0 then
        _m.CurPercent = _intimate / _m.IntimateAll
    else
        _m.CurPercent = 0
    end
    return _m
end

return TitleData