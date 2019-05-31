------------------------------------------------
--作者： _SqL_
--日期： 2019-05-09
--文件： UIGiftPackageForm.lua
--模块： UIGiftPackageForm
--描述： 境界礼包 窗体
------------------------------------------------

local UIGiftPackageForm = {
    CloseBtn = nil,
    -- item trans
    Item = nil,
    -- item Parent
    ListPanel = nil,
    -- Buy Btn
    BuyBtn = nil,
    -- 价钱
    Price = nil,
    -- 礼包名字
    Name = nil,
    -- Time label
    Time = nil,
    -- 漂亮Girl Tex
    BeautifulGirlTex = nil,
    -- 动画
    AnimModel = nil,
    -- 背景
    BgTex = nil,
    -- 显示礼包按钮相关数据
    GiftBtnInfo = nil,
    -- 刷新前的时间
    FontUpdateTime = 0,
}

function  UIGiftPackageForm:OnRegisterEvents()
    self:RegisterEvent(UIEventDefine.UIGiftPackageForm_OPEN, self.OnOpen)
    self:RegisterEvent(UIEventDefine.UIGiftPackageForm_CLOSE,self.OnClose)
end

function UIGiftPackageForm:OnFirstShow()
    self:FindAllComponents()
    self:OnRegUICallBack()
end

function UIGiftPackageForm:Update()
    if self.GiftBtnInfo and self.GiftBtnInfo.RemainTime > 0 then
        if self.GiftBtnInfo.RemainTime ~= self.FontUpdateTime then
            -- Debug.LogError(self.GiftBtnInfo.RemainTime)
            self.Time.text = Time.FormatTimeHMS(math.Round(self.GiftBtnInfo.RemainTime))
        end
    end
end

function UIGiftPackageForm:OnHideBefore()
    for i = 0, self.ListPanel.childCount - 1 do
        self.ListPanel:GetChild(i).gameObject:SetActive(false)
    end
end

function UIGiftPackageForm:FindAllComponents()
    local _trans = self.CSForm.transform
    self.AnimModel = UIAnimationModule(_trans)
    self.AnimModel:AddAlphaAnimation()

    self.CloseBtn = UIUtils.FindBtn(_trans, "Top/CloseBtn")
    self.Item = UIUtils.FindTrans(_trans, "Right/ListPanel/Item")
    self.ListPanel = UIUtils.FindTrans(_trans, "Right/ListPanel")
    self.BuyBtn = UIUtils.FindBtn(_trans, "Right/BuyBtn")
    self.Price = UIUtils.FindLabel(_trans, "Right/BuyBtn/Price")
    self.Time = UIUtils.FindLabel(_trans, "Left/CountDown/Value")
    self.BgTex = UIUtils.FindTex(_trans, "Center/Back")
    self.Name = UIUtils.FindLabel(_trans, "Right/PackageDesc")
    self.BeautifulGirlTex = UIUtils.FindTex(_trans, "Left/BeautifulGirlTex")
end

function UIGiftPackageForm:Init()
    local _id = GameCenter.RealmSystem:GetCurrGiftId()
    local _cfg  = DataConfig.DataStatePackage[_id]
    if not _cfg then
        Debug.LogError("DataStatePackage not contains key = ", _id)
        return
    end
    if _cfg.Type == PurchaseTypeEnum.Money then
        self.Price.text = string.format("%d元购买", _cfg.Cost)
    elseif _cfg.Type == PurchaseTypeEnum.YuanBao then
        self.Price.text = string.format("%d元宝购买", _cfg.Cost)
    elseif _cfg.Type == PurchaseTypeEnum.BangYuan then
        self.Price.text = string.format("%d绑元购买", _cfg.Cost)
    end
    self.Name.text = _cfg.Name
    if _cfg.BgPic and _cfg.BgPic ~= "" then
        self.CSForm:LoadTexture(self.BeautifulGirlTex, AssetUtils.GetImageAssetPath(ImageTypeCode.UI, _cfg.BgPic))
    end
    self:InitReward(_cfg.Reward)
end

-- 初始化奖品
function UIGiftPackageForm:InitReward(str)
    local _index = 0
    local _items = Utils.SplitStr(str, ";")
    for i = 1, #_items do
        if _index < self.ListPanel.childCount then
            self:SetItem(self.ListPanel:GetChild(_index), _items[i])
        else
            local _go = UnityUtils.Clone(self.Item.gameObject, self.ListPanel)
            self:SetItem(_go.transform, _items[i])
        end
        _index = _index + 1
    end
    UnityUtils.GridResetPosition(self.ListPanel)
end

-- 设置奖励物品Item
function UIGiftPackageForm:SetItem(itemTrans, str)
    local _item = UIUtils.RequireUIItem(itemTrans)
    local _data = Utils.SplitStr(str, "_")
    _item:InitializationWithIdAndNum(ItemModel(tonumber(_data[1])), tonumber(_data[2]), false, false)
end

function UIGiftPackageForm:LoadBgTex()
    self.CSForm:LoadTexture(self.BgTex, AssetUtils.GetImageAssetPath(ImageTypeCode.UI, "bag_storebg"))
end

function UIGiftPackageForm:OnRegUICallBack()
    UIUtils.AddBtnEvent(self.CloseBtn, self.OnClose, self)
end

function UIGiftPackageForm:OnOpen(obj, sender)
    self.CSForm:Show(sender)
    if obj then
        self.GiftBtnInfo = obj
    end
    self:LoadBgTex()
    self:Init()
    self.AnimModel:PlayEnableAnimation()
end

function UIGiftPackageForm:OnCLose(obj, sender)
    self.CSForm:Hide()
end

return UIGiftPackageForm