------------------------------------------------
--作者： 何健
--日期： 2019-05-27
--文件： UIGuildDonateItem.lua
--模块： UIGuildDonateItem
--描述： 宗派捐献界面一个单独的捐献项
------------------------------------------------
local L_ItemBase = CS.Funcell.Code.Logic.ItemBase
local UIGuildDonateItem = {
    Trans = nil,
    BtnSpr = nil,
    IconTexture = nil,
    BackTexture = nil,
    Data = nil,
}

function UIGuildDonateItem:OnFirstShow(trans, info)
    local _m = Utils.DeepCopy(self)
    _m.Trans = trans
    _m.Data = info
    _m:FindAllComponents()
    return _m
end

function UIGuildDonateItem:FindAllComponents()
    self.IconTexture = UIUtils.FindTex(self.Trans, "Texture")
    self.BackTexture = UIUtils.FindTex(self.Trans, "Textureback")
    GameCenter.TextureManager:LoadTexture(AssetUtils.GetImageAssetPath(ImageTypeCode.UI, "tex_banghuiback"), Utils.Handler(self.LoadTexFinish1,self))
    GameCenter.TextureManager:LoadTexture(AssetUtils.GetImageAssetPath(ImageTypeCode.UI, "tex_modleback_bg"), Utils.Handler(self.LoadTexFinish2,self))
    self.BtnSpr = UIUtils.FindSpr(self.Trans, "1")
    local _btn  = UIUtils.FindBtn(self.Trans, "1")
    UIUtils.AddBtnEvent(_btn, self.OnDonateBtnClick, self)
    local _cost = Utils.SplitStr(self.Data.CoinType, "_")
    if #_cost == 2 then
        local _icon = UIUtils.RequireUIIconBase(UIUtils.FindTrans(self.Trans, "1/Sprite"))
        _icon:UpdateIcon(L_ItemBase.GetItemIcon(tonumber(_cost[1])))
        local _label = UIUtils.FindLabel(self.Trans, "1/Label")
        _label.text = _cost[2]
    end
    _cost = Utils.SplitStr(self.Data.GuildGet, "_")
    local _own = Utils.SplitStr(self.Data.OwnGet, "_")
    local _guildValue = Utils.SplitStr(self.Data.TechnologyGet, "_")
    local _level = GameCenter.GuildSystem.GuildInfo.lv
    if _level <= #_cost and _level <= #_own and _level <= #_guildValue and _level > 0 then

        local label1 = UIUtils.FindLabel(self.Trans, "GuildBuildCost/Label")
        local label2 = UIUtils.FindLabel(self.Trans, "GuildCoin/Label")
        local label3 = UIUtils.FindLabel(self.Trans, "GuildSkillPoint/Label")

        local buildCostIcon = UIUtils.RequireUIIconBase(UIUtils.FindTrans(self.Trans, "GuildBuildCost"))
        local guildCoinIcon = UIUtils.RequireUIIconBase(UIUtils.FindTrans(self.Trans, "GuildCoin"))
        local skillPointIcon = UIUtils.RequireUIIconBase(UIUtils.FindTrans(self.Trans, "GuildSkillPoint"))
        buildCostIcon:UpdateIcon(865)
        guildCoinIcon:UpdateIcon(864)
        skillPointIcon:UpdateIcon(866)

        label1.text = _cost[_level]
        label2.text = _own[_level]
        label3.text = _guildValue[_level]
    end
end
function UIGuildDonateItem:LoadTexFinish1(tex)
    if tex.Texture == nil then
        return
    end
    self.IconTexture.mainTexture = tex.Texture
end
function UIGuildDonateItem:LoadTexFinish2(tex)
    if tex.Texture == nil then
        return
    end
    self.BackTexture.mainTexture = tex.Texture
end

--设置按钮是否置灰
function UIGuildDonateItem:OnSetBtnGray(isGray)
    self.BtnSpr.IsGray = isGray
end

--捐献按钮点击
function UIGuildDonateItem:OnDonateBtnClick()
    if self.Data ~= nil then
        GameCenter.Network.Send("MSG_Guild.ReqDonate", {donateId = self.Data.Id})
    end
end
return UIGuildDonateItem