------------------------------------------------
--作者： 何健
--日期： 2019-05-13
--文件： UIGuildRankRewardItem.lua
--模块： UIGuildRankRewardItem
--描述： 宗派列表排行列表子项
------------------------------------------------

local FightUtils = require "Logic.Base.FightUtils.FightUtils"

local UIGuildRankRewardItem = {
    Trans = nil,
    Go = nil,
    TipsLabel = nil,
    RankLabel = nil,
    Texture = nil
}

--创建一个新的对象
function UIGuildRankRewardItem:OnFirstShow(trans)
    local _m = Utils.DeepCopy(self)
    _m.Trans = trans
    _m.Go = trans.gameObject
    _m:FindAllComponents()
    return _m
 end

 --查找UI上各个控件
 function UIGuildRankRewardItem:FindAllComponents()
    self.TipsLabel = UIUtils.FindLabel(self.Trans, "TipsLabel")
    self.RankLabel = UIUtils.FindLabel(self.Trans, "RankLabel")
    self.Texture = UIUtils.FindTex(self.Trans, "Texture")
 end

 function UIGuildRankRewardItem:Clone(Go, parent)
    local childTrans = GameObject.Instantiate(Go).transform
    childTrans.parent = parent
    UnityUtils.ResetTransform(childTrans)
    return self:OnFirstShow(childTrans)
 end

  --更新物品
  function UIGuildRankRewardItem:OnUpdateItem(info, rankMin, rankMax)
    if info == nil then
        Debug.LogError("加载错误，数据为空")
        return
    end
    if rankMin == rankMax then
        self.RankLabel.text = string.format("宗内排名第%d", rankMin)
    elseif rankMin < rankMax then
        self.RankLabel.text = string.format("宗内排名第%d-%d", rankMin, rankMax)
    end

    GameCenter.TextureManager:LoadTexture(AssetUtils.GetImageAssetPath(ImageTypeCode.UI, string.format("tex_chenghao_%d", info.ShowPic)), Utils.Handler(self.LoadTexFinish,self))
    self.TipsLabel.text = string.format("价值%d+战力", info.TitleFighting)
end

 function UIGuildRankRewardItem:LoadTexFinish(tex)
    if tex.Texture == nil then
        return
    end
    self.Texture.mainTexture = tex.Texture
end
return UIGuildRankRewardItem