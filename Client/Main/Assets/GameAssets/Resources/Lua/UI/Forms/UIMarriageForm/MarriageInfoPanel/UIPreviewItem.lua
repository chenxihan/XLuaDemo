------------------------------------------------
--作者： dhq
--日期： 2019-05-16
--文件： UIPreviewItem.lua
--模块： UIPreviewItem
--描述： 称号预览Item类
------------------------------------------------

--排名item
local UIPreviewItem = {
    --root
    RootGo = nil,
    Trans = nil,
    Parent = nil,
    -- 称号名字(这个暂时没有用到了)
    AppellationLabel = nil,
    -- 称号图片
    TitleTex = nil,
    -- 达成条件的描述
    CondLabel = nil,
    -- 进度条
    ProgressF = nil,
    -- 进度百分比
    ProLabel = nil,
}

function UIPreviewItem:New(go, parent)
    local _result = Utils.DeepCopy(self);
    _result.RootGo = go;
    _result.Parent = parent;
    _result.Trans = go.transform;
    _result:OnFirstShow();
    return _result
end

function UIPreviewItem:OnFirstShow()
    self.TitleTex = UIUtils.FindTex(self.Trans, "TitleTex")
    self.AppellationLabel = UIUtils.FindLabel(self.Trans, "Appellation/Label");
    self.CondLabel = UIUtils.FindLabel(self.Trans, "Cond/Label");
    self.ProgressF = UIUtils.FindProgressBar(self.Trans, "ProgressF");
    self.ProLabel = UIUtils.FindLabel(self.Trans, "ProgressF/Label");
end

--刷新
function UIPreviewItem:Refresh(info)
    self.Info = info;
    if self.Info ~= nil then
        self.AppellationLabel.text = tostring(info.TitleName);
        -- 获取到父节点的的CSForm
        local _parentCSForm = self.Parent.Parent.Parent.CSForm;
        -- 加载图片
        _parentCSForm:LoadTexture(self.TitleTex, AssetUtils.GetImageAssetPath(ImageTypeCode.UI, self.Info.TexName))
        if GameCenter.MarrySystem.MarryData ~= nil then
            local _section = GameCenter.MarrySystem.MarryData.HouseDegree
            local _lv = GameCenter.MarrySystem.MarryData.HouseLevel
            local _intimate = GameCenter.MarrySystem.MarryData.IntimacyValue
            ----仙居达到2阶3级;亲密度:100/300
            self.CondLabel.text = string.format("仙居达到%s阶%s级;亲密度:%s/%s",_section, _lv, _intimate, self.Info.IntimateAll)
            local _val = 0
            if self.Info.CurPercent > 0.001 then
                _val = self.Info.CurPercent
            end
            self.ProgressF.value = _val
            local percentage = self.Info.CurPercent * 100
            self.ProLabel.text = string.format( "%.0f%%", percentage)
        end
    end
end

return UIPreviewItem