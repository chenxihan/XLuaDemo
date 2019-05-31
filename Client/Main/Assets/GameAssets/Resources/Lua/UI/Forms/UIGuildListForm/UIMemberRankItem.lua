------------------------------------------------
--作者： 何健
--日期： 2019-05-14
--文件： UIMemberRankItem.lua
--模块： UIMemberRankItem
--描述： 宗派个人排行子控件
------------------------------------------------
local UIMemberListItem = require "UI.Forms.UIGuildListForm.UIMemberListItem"

local UIMemberRankItem = {
    Trans = nil,
    Go = nil,
    Texture = nil,
    TitleLabel = nil,
    MemberList = List:New()
}

--创建一个新的对象
function UIMemberRankItem:OnFirstShow(trans)
    local _m = Utils.DeepCopy(self)
    _m.Trans = trans
    _m.Go = trans.gameObject
    _m:FindAllComponents()
    return _m
 end

 --查找UI上各个控件
 function UIMemberRankItem:FindAllComponents()
    self.Texture = UIUtils.FindTex(self.Trans, "Title/Texture")
    self.TitleLabel = UIUtils.FindLabel(self.Trans, "Title/TipsLabel")
    for i = 1, 6 do
        local _trans = UIUtils.FindTrans(self.Trans, string.format( "List%d", i))
        if _trans ~= nil then
            self.MemberList:Add(UIMemberListItem:OnFirstShow(_trans))
        end
    end
 end

 function UIMemberRankItem:OnUpdateItem(infoList, config)
    if config ~= nil then
        self.TitleLabel.text = string.format("价值%d+战力", config.TitleFighting)
        GameCenter.TextureManager:LoadTexture(AssetUtils.GetImageAssetPath(ImageTypeCode.UI, string.format("tex_chenghao_%d", config.ShowPic)), Utils.Handler(self.LoadTexFinish,self))
    end
    for i = 1, #self.MemberList do
        if infoList[i] ~= nil then
            self.MemberList[i].Go:SetActive(true)
            self.MemberList[i]:OnUpdateItem(infoList[i], true)
        else
            self.MemberList[i].Go:SetActive(false)
        end
    end
 end

 function UIMemberRankItem:LoadTexFinish(tex)
    if tex.Texture == nil then
        return
    end
    self.Texture.mainTexture = tex.Texture
end
return UIMemberRankItem