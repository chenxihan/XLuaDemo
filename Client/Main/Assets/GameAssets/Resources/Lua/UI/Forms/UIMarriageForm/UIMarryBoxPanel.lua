------------------------------------------------
--作者： dhq
--日期： 2019-05-13
--文件： UIMarryBoxPanel.lua
--模块： UIMarryBoxPanel
--描述： 婚姻宝匣界面
------------------------------------------------

--//模块定义
local UIMarryBoxPanel = {
    --当前transform
    Trans = nil,
    --父
    Parent = nil,
    --动画模块
    AnimModule = nil,
    -- 伴侣的模型
    SpouseSkin = nil,
    -- 左边宝盒的价格
    PriceLabel = nil,
    -- 左边的领取按钮
    LReceiveBtn = nil,
    LReceiveBtnLabel = nil,
    -- 右边的领取按钮
    RReceiveBtn = nil,
    RReceiveBtnLabel = nil,
    -- 自己宝盒的剩余时间
    SelfTimeLabel = nil,
    -- 请求伴侣赠送
    ReqGiftBtn = nil,
    -- 给伴侣买盒子的按钮
    BuyBtn = nil,
    -- 伴侣名字
    SpouseNameLabel = nil,
    -- 伴侣宝盒剩余时间
    SpouseTimeLabel = nil,
}

function UIMarryBoxPanel:OnFirstShow(trans, parent)
    self.Trans = trans
    self.Parent = parent

    --创建动画模块
    self.AnimModule = UIAnimationModule(self.Trans)
    --添加一个动画
    self.AnimModule:AddAlphaAnimation()

    self.PriceLabel = UIUtils.FindLabel(self.Trans, "Left/Left/PriceLabel")
    self.LReceiveBtn = UIUtils.FindBtn(self.Trans, "Left/Left/ReceiveBtn")
    UIUtils.AddBtnEvent(self.LReceiveBtn, self.OnLReceiveBtnClcik, self)
    self.LReceiveBtnLabel = UIUtils.FindLabel(self.Trans, "Left/Left/ReceiveBtn/Label")
    
    -- TODO 这里暂时先这样写，后面换成正式的
    local _rewardTrans1 = UIUtils.FindTrans(self.Trans, "Left/Right/1")
    local _rewardItem1 = UIUtils.RequireUIItem(_rewardTrans1)
    local _rewardTrans2 = UIUtils.FindTrans(self.Trans, "Left/Right/2")
    local _rewardItem2 = UIUtils.RequireUIItem(_rewardTrans2)
    _rewardItem1:InitializationWithIdAndNum(19002, 0, false, false)
    _rewardItem2:InitializationWithIdAndNum(19003, 0, false, false)
    
    self.RReceiveBtn = UIUtils.FindBtn(self.Trans, "Left/Right/ReceiveBtn")
    UIUtils.AddBtnEvent(self.RReceiveBtn, self.OnRReceiveBtnClcik, self)
    self.RReceiveBtnLabel = UIUtils.FindLabel(self.Trans, "Left/Right/ReceiveBtn/Label")

    self.SelfTimeLabel = UIUtils.FindLabel(self.Trans, "Left/Days/TimeLabel")

    self.ReqGiftBtn = UIUtils.FindBtn(self.Trans, "Left/GetGift/Label")
    UIUtils.AddBtnEvent(self.ReqGiftBtn, self.OnReqGiftBtnClcik, self)

    self.SpouseNameLabel = UIUtils.FindLabel(self.Trans, "Right/Spouse/Name")

    self.BuyBtn = UIUtils.FindBtn(self.Trans, "Right/BuyBtn")
    UIUtils.AddBtnEvent(self.BuyBtn, self.OnBuyBtnClcik, self)

    self.SpouseTimeLabel = UIUtils.FindLabel(self.Trans, "Right/Days/TimeLabel")    

    --伴侣的模型
    self.SpouseSkin = UIUtils.RequireUIRoleSkinCompoent(self.Trans:Find("Right/UIRoleSkinCompoent"))
    if self.SpouseSkin then
        self.SpouseSkin:OnFirstShow(self.this, FSkinTypeCode.Player)
    end

    self.Trans.gameObject:SetActive(false)
    return self
end

function UIMarryBoxPanel:Show(childId)
    --播放开启动画
    self.AnimModule:PlayEnableAnimation()
    self:SetModelShow()
    self:UpdatePageData()
end

function UIMarryBoxPanel:Hide()
    --播放关闭动画
    self.AnimModule:PlayDisableAnimation()
    self.SpouseSkin:ResetSkin()
end

-- 显示模型
function UIMarryBoxPanel:SetModelShow()
    self.SpouseSkin:ResetRot()
    self.SpouseSkin:ResetSkin()
    self.SpouseSkin:SetCameraSize(2.3)
    self.SpouseSkin:SetEquip(FSkinPartCode.Body, RoleVEquipTool.GetLPBodyModel())
    self.SpouseSkin:SetEquip(FSkinPartCode.Weapon, RoleVEquipTool.GetLPWeaponModel())
end

-- 左边框的领取按钮
function UIMarryBoxPanel:OnLReceiveBtnClcik()

end

--右边框的领取按钮
function UIMarryBoxPanel:OnRReceiveBtnClcik()

end

-- 请求伴侣赠送盒子
function UIMarryBoxPanel:OnReqGiftBtnClcik()

end

function UIMarryBoxPanel:OnBuyBtnClcik()

end

function UIMarryBoxPanel:UpdatePageData()
    self.PriceLabel.text = string.format( "%s绑元", 520 )
    self.SelfTimeLabel.text = string.format( "剩余%s天", 2)
    self.SpouseTimeLabel.text = string.format( "剩余%s天", 3)
    local _lp = GameCenter.GameSceneSystem:GetLocalPlayer();
    if _lp ~= nil then
        -- 这个伴侣的名字要服务器发，目前用的自己的
        self.SpouseNameLabel.text = _lp.Name
    end
end

return UIMarryBoxPanel