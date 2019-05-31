------------------------------------------------
--作者： 何健
--日期： 2019-04-28
--文件： UIItem.lua
--模块： UIItem
--描述： 物品格子公用组件
------------------------------------------------
local ItemBase = CS.Funcell.Code.Logic.ItemBase
local UIItem ={
    RootTrans = nil,
    RootGO = nil,
    --品质框图片
    QualitySpr = nil,
    --绑定图片
    BindSpr = nil,
    -- 帧动画
    EffectAniGO = nil,
    -- 装备物效
    EffectGO = nil,
    -- 不可使用
    UnUseTrans = nil,
    -- 数量
    NumLabel = nil,
    -- 装备阶数
    LevelLabel = nil,
    -- 装备星级
    StarGrid = nil,
    -- 向上箭头，表示该装备比身上装备评分更高
    UpTrans = nil,
    -- icon图标
    Icon = nil,
    Btn = nil,
    Location = ItemTipsLocation.Defult,
    IsBindBagNum = false,
    BindBagNumFormatString = nil,
    EnoughColor = "[00ff00]",
    NotEnoughColor = "[ff0000]",
    IsRegisterBagMsg = false,
    ShowNum = 0,
    IsShowTips = false,
    IsShowGet = false,
    ShowItemData = nil,
    SingleClick = nil,
}

function UIItem:New(res)
    local _M = Utils.DeepCopy(self)
    _M.RootTrans = res
    _M.RootGO = res.gameObject

    _M.QualitySpr = UIUtils.FindSpr(_M.RootTrans, "Quality")
    _M.Icon = UnityUtils.RequireComponent(UIUtils.FindTrans(_M.RootTrans, "Icon"), "Funcell.GameUI.Form.UIIconBase")
    local trans = UIUtils.FindTrans(_M.RootTrans, "Bind")
    if(trans ~= nil) then
        _M.BindSpr = trans:GetComponent("UISprite")
    end
    trans = UIUtils.FindTrans(_M.RootTrans, "Effect")
    if(trans ~= nil) then
        _M.EffectGO = trans.gameObject
    end
    trans = UIUtils.FindTrans(_M.RootTrans, "Effect1")
    if(trans ~= nil) then
        _M.EffectAniGO = trans.gameObject
        local _animation = UnityUtils.RequireComponent(trans, "UISpriteAnimation")
        if(_animation ~= nil) then
            _animation.namePrefix = "item_"
            _animation.framesPerSecond = 10
            _animation.PrefixSnap = false
        end
    end

    trans = UIUtils.FindTrans(_M.RootTrans, "Num")
    if(trans ~= nil) then
        _M.NumLabel = trans:GetComponent("UILabel")
    end
    trans = UIUtils.FindTrans(_M.RootTrans, "Level")
    if(trans ~= nil) then
        _M.LevelLabel = trans:GetComponent("UILabel")
    end

    trans = UIUtils.FindTrans(_M.RootTrans, "Grid")
    if(trans ~= nil) then
        _M.StarGrid = trans:GetComponent("UIGrid")
    end
    _M.UpTrans = UIUtils.FindTrans(_M.RootTrans, "up")
    _M.UnUseTrans = UIUtils.FindTrans(_M.RootTrans, "UnUseSprite")
    _M.Location = ItemTipsLocation.Defult

    _M.Btn = UIUtils.RequireUIButton(_M.RootTrans)
    UIUtils.AddBtnEvent(_M.Btn, _M.OnBtnItemClick, _M)
    _M.IsShowTips = true
    return _M
end

--克隆一个对象
function UIItem:Clone()
    local _trans = UnityUtils.Clone(self.RootGO)
    return UIItem:New(_trans.transform)
end

function UIItem:InitWithItemData(itemInfo, num, mastShowNum, isShowGetBtn, location)
    self.ShowItemData = itemInfo
    if self.UnUseTrans ~= nil then
        self.UnUseTrans.gameObject:SetActive(false)
    end
    if self.UpTrans ~= nil then
        self.UpTrans.gameObject:SetActive(false)
    end
    if self.LevelLabel ~= nil then
        self.LevelLabel.text = ""
    end

    if(isShowGetBtn ~= nil) then
        self.IsShowGet = isShowGetBtn
    end
    if location ~= nil then
        self.Location = location
    end
    if self.ShowItemData ~= nil and self.ShowItemData:IsValid() == true then
        if self.ShowItemData.Type == ItemType.Equip then
            self.Icon:UpdateIcon(self.ShowItemData.ItemInfo.Icon)
            self.QualitySpr.spriteName = ItemBase.GetQualitySpriteName(QualityCode.__CastFrom(self.ShowItemData.ItemInfo.Quality))
            self:OnSetStarSpr(self.ShowItemData.ItemInfo.DiamondNumber)
            self:OnSetEffect(self.ShowItemData.ItemInfo.Effect)
            local lp = GameCenter.GameSceneSystem:GetLocalPlayer()
            if lp ~= nil then
                local itemOcc = Occupation.__CastFrom(self.ShowItemData.ItemInfo.Gender)
                if (itemOcc == lp.Occ  or self.ShowItemData.ItemInfo.Gender == 9) and self.UpTrans ~= nil then
                    local itemFight = self.ShowItemData.ItemInfo.Score
                    local itemFightBody = 0
                    local BodyEquip = GameCenter.EquipmentSystem:GetPlayerDressEquip(EquipmentType.__CastFrom(self.ShowItemData.ItemInfo.Part))
                    if BodyEquip ~= nil then
                        itemFightBody = BodyEquip.ItemInfo.Score
                    end
                    if itemFight > itemFightBody then
                        self.UpTrans.gameObject:SetActive(true)
                    end
                end
            end
            if GameCenter.EquipmentSystem:OnCheckCanEquip(self.ShowItemData) and self.UnUseTrans ~= nil then
                self.UnUseTrans.gameObject:SetActive(true)
            end
            if self.LevelLabel ~= nil then
                self.LevelLabel.text = UIUtils.CSFormat(DataConfig.DataMessageString.Get("LEVEL_FOR_JIE"), self.ShowItemData.ItemInfo.Grade)
            end
        else
            self.Icon:UpdateIcon(self.ShowItemData.ItemInfo.Icon)
            self.QualitySpr.spriteName = ItemBase.GetQualitySpriteName(QualityCode.__CastFrom(self.ShowItemData.ItemInfo.Color))
            self:OnSetStarSpr(0)
            self:OnSetEffect(self.ShowItemData.ItemInfo.Effect)
        end
        if num > 1 or mastShowNum then
            if num > 9999 and num <= 9999999 then
                self.NumLabel.text = string.format("%dK", num // 1000)
            elseif num > 9999999 then
                self.NumLabel.text = string.format("%dM", num // 1000000)
            else
                self.NumLabel.text = tostring(num)
            end
        else
            self.NumLabel.text = ""
        end
        self.BindSpr.gameObject:SetActive(self.ShowItemData.IsBind)
        self.QualitySpr.gameObject:SetActive(true)
        self.ShowNum = num
    else
        self.Icon:UpdateIcon(-1)
        self.BindSpr.gameObject:SetActive(false)
        self.QualitySpr.gameObject:SetActive(false)
        self.NumLabel.text = ""
    end
    self.NumLabel.color = Color.white
end

function UIItem:InItWithCfgid(itemID, num, isBind, isShowGetBtn)
    itemID = tonumber(itemID);
    num = tonumber(num);
    local item = ItemBase.CreateItemBase(itemID)
    if(item ~= nil) then
        item.Count = num
        item.IsBind = isBind
    end
    self:InitWithItemData(item, num, false, isShowGetBtn, ItemTipsLocation.Defult)
end

--设置星星图片
function UIItem:OnSetStarSpr(diaNum)
    if self.StarGrid == nil then
        return
    end
    local oldCount = self.StarGrid.transform.childCount
    for i = 0, oldCount - 1 do
        self.StarGrid.transform:GetChild(i).gameObject:SetActive(false)
    end
    if diaNum > 0 then
        local childGo = nil
        for i = 1, diaNum do
            if i <= oldCount then
                childGo = self.StarGrid.transform:GetChild(i - 1).gameObject
            else
                childGo = UnityUtils.Clone(childGo)
            end
            if childGo ~= nil then
                childGo:SetActive(true)
            end
        end
    end
    self.StarGrid.repositionNow = true
end

--设置装备特效
function UIItem:OnSetEffect(effectID)
    if self.EffectGO ~= nil then
        self.EffectGO:SetActive(effectID == 1)
    end
    if self.EffectAniGO ~= nil then
        self.EffectAniGO:SetActive(effectID == 2)
    end
end

-- 绑定背包中的数量
function UIItem:BindBagNum(formatString)
    if formatString == nil then
        formatString = "%d/%d"
    end
    self.IsBindBagNum = true
    self.BindBagNumFormatString = formatString
    self:RegisterMsg()
    self:UpdateBagNum()
end

-- 取消绑定背包中的数量
function UIItem:CanelBindBagNum()
    self.IsBindBagNum = false
    self:UnRegisterMsg()
end

-- 设置数量
function UIItem:OnSetNum(sTx)
    if self.NumLabel ~= nil then
        self.NumLabel.text = sTx
    end
end

function UIItem:OnSetNumColor(clo)
    if self.NumLabel ~= nil then
        self.NumLabel.color = clo
    end
end

-- 按钮事件
function UIItem:OnBtnItemClick()
    if self.IsShowTips then
        if self.ShowItemData ~= nil then
            GameCenter.ItemTipsMgr:ShowTips(self.ShowItemData, self.RootGO, self.Location, self.IsShowGet)
        end
    end
    if self.SingleClick ~= nil then
        self.SingleClick(self)
    end
end

function UIItem:UpdateBagNum()
    if self.ShowItemData == nil then
        return
    end
    if not self.IsBindBagNum then
        return
    end

    local haveNum = GameCenter.ItemContianerSystem:GetItemCountFromCfgId(self.ShowItemData.CfgID)
    local formatString = nil
    if haveNum >= self.ShowNum then
        formatString = string.format("%s%s[-]", self.EnoughColor, self.BindBagNumFormatString)
    else
        formatString = string.format("%s%s[-]", self.NotEnoughColor, self.BindBagNumFormatString)
    end
    self:OnSetNum(string.format(formatString, haveNum, self.ShowNum))
end

function UIItem:OnBagItemChanged(obj, sender)
    if self.ShowItemData == nil then
        return
    end
    if not self.IsBindBagNum then
        return
    end
    local itemBase = obj
    if itemBase ~= nil then
        if itemBase.CfgID == self.ShowItemData.CfgID then
            self:UpdateBagNum()
        end
    end
end
function UIItem:RegisterMsg()
    if self.IsRegisterBagMsg then
        return
    end
    self.IsRegisterBagMsg = true
    GameCenter.RegFixEventHandle(LogicEventDefine.EVENT_BACKFORM_ITEM_UPDATE, self.OnBagItemChanged, self)
end
function UIItem:UnRegisterMsg()
    if not self.IsRegisterBagMsg then
        return
    end
    self.IsRegisterBagMsg = false
    GameCenter.UnRegFixEventHandle(LogicEventDefine.EVENT_BACKFORM_ITEM_UPDATE, self.OnBagItemChanged, self)
end
return UIItem