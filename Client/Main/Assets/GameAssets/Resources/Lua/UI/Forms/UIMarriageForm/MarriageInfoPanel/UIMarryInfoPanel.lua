------------------------------------------------
--作者： dhq
--日期： 2019-05-13
--文件： UIMarryInfoPanel.lua
--模块： UIMarryInfoPanel
--描述： 婚姻信息界面
------------------------------------------------

local UICupidPanel = require "UI.Forms.UIMarriageForm.MarriageInfoPanel.UICupidPanel"
local UIAppellationPreviewPanel = require "UI.Forms.UIMarriageForm.MarriageInfoPanel.UIAppellationPreviewPanel"
local UIMarryRewardPanel = require "UI.Forms.UIMarriageForm.MarriageInfoPanel.UIMarryRewardPanel"
local UIMarryProcessPanel = require "UI.Forms.UIMarriageForm.MarriageInfoPanel.UIMarryProcessPanel"
local UIMarryTypePanel = require "UI.Forms.UIMarriageForm.MarriageType.UIMarryTypePanel"
local UIAppointmentPanel = require "UI.Forms.UIMarriageForm.MarriageInfoPanel.UIAppointmentPanel"
local UIInvitePanel = require "UI.Forms.UIMarriageForm.MarriageInfoPanel.UIInvitePanel"
local UIEngagementPanel = require "UI.Forms.UIMarriageForm.MarriageInfoPanel.UIEngagementPanel"

--//模块定义
local UIMarryInfoPanel = {
    --当前transform
    Trans = nil,
    --父
    Parent = nil,
    --动画模块
    AnimModule = nil,
    -- 称号预览按钮
    PreviewBtn = nil,
    -- 结婚奖励按钮
    RewardBtn = nil,
    -- 红娘按钮
    CupidBtn = nil,

    LeftPlayerSkin = nil,
    RightPlayerSkin = nil,
    LeftNameLabel = nil,
    RightNameLabel = nil,
    -- 亲密度
    IntimateLabel = nil,
    -- 结婚天数
    DaysLabel = nil,
    -- 称号名字
    AppellationNameLabel = nil,
    -- 称号进度
    AppellationProLabel = nil,

    -- 红娘面板
    CupidPanel = nil,
    -- 称号预览面板
    AppellationPreviewPanel = nil,
    -- 婚姻奖励面板
    MarryRewardPanel = nil,
    -- 信息面板的对象，主要是做打开其他面板时的隐藏显示
    InfoPanelGo = nil,
    -- 婚姻流程面板
    MarryProcessPanel = nil,
    -- 求婚选择婚礼类型的面板
    MarryTypePanel = nil,
    -- 预约婚礼
    AppointmentPanel = nil,
    -- 邀请宾客
    InvitePanel = nil,
    -- 缔结婚姻
    EngagementPanel = nil,
}

function UIMarryInfoPanel:OnFirstShow(trans, parent)
    self.Trans = trans
    self.Parent = parent

    --创建动画模块
    self.AnimModule = UIAnimationModule(self.Trans)
    --添加一个动画
    self.AnimModule:AddAlphaAnimation()

    self.PreviewBtn = UIUtils.FindBtn(self.Trans, "InfoPanel/PreviewBtn")
    UIUtils.AddBtnEvent(self.PreviewBtn, self.OnPreviewBtnClick, self)
    self.RewardBtn = UIUtils.FindBtn(self.Trans, "InfoPanel/RewardBtn")
    UIUtils.AddBtnEvent(self.RewardBtn, self.OnRewardBtnClick, self)
    self.CupidBtn = UIUtils.FindBtn(self.Trans, "InfoPanel/CupidBtn")
    UIUtils.AddBtnEvent(self.CupidBtn, self.OnCupidBtnClick, self)

    
    self.LeftPlayerSkin = UIUtils.RequireUIRoleSkinCompoent(self.Trans:Find("InfoPanel/Left/UIRoleSkinCompoent"))
    if self.LeftPlayerSkin then
        self.LeftPlayerSkin:OnFirstShow(self.this, FSkinTypeCode.Player)
    end
    self.RightPlayerSkin = UIUtils.RequireUIRoleSkinCompoent(self.Trans:Find("InfoPanel/Right/UIRoleSkinCompoent"))
    if self.RightPlayerSkin then
        self.RightPlayerSkin:OnFirstShow(self.this, FSkinTypeCode.Player)
    end

    self.LeftNameLabel = UIUtils.FindLabel(self.Trans, "InfoPanel/Left/Label")
    self.RightNameLabel = UIUtils.FindLabel(self.Trans, "InfoPanel/Right/Label")
    self.IntimateLabel = UIUtils.FindLabel(self.Trans, "InfoPanel/Intimate/Label")
    self.DaysLabel = UIUtils.FindLabel(self.Trans, "InfoPanel/Days/Label")
    self.AppellationNameLabel = UIUtils.FindLabel(self.Trans, "InfoPanel/Appellation/Name")
    self.AppellationProLabel = UIUtils.FindLabel(self.Trans, "InfoPanel/Appellation/Pro")

    self.InfoPanelGo = UIUtils.FindGo(self.Trans, "InfoPanel")

    self.CupidPanel = UICupidPanel:OnFirstShow(UIUtils.FindTrans(self.Trans, "CupidPanel"), self)
    self.AppellationPreviewPanel = UIAppellationPreviewPanel:OnFirstShow(UIUtils.FindTrans(self.Trans, "AppellationPreviewPanel"), self)
    self.MarryRewardPanel = UIMarryRewardPanel:OnFirstShow(UIUtils.FindTrans(self.Trans, "MarryRewardPanel"), self)
    self.MarryProcessPanel = UIMarryProcessPanel:OnFirstShow(UIUtils.FindTrans(self.Trans, "MarryProcessPanel"), self)
    self.MarryTypePanel = UIMarryTypePanel:OnFirstShow(UIUtils.FindTrans(self.Trans, "MarryTypePanel"), self)
    self.AppointmentPanel = UIAppointmentPanel:OnFirstShow(UIUtils.FindTrans(self.Trans, "AppointmentPanel"), self)
    self.InvitePanel = UIInvitePanel:OnFirstShow(UIUtils.FindTrans(self.Trans, "InvitePanel"), self)
    self.EngagementPanel = UIEngagementPanel:OnFirstShow(UIUtils.FindTrans(self.Trans, "EngagementPanel"), self)
    self.Trans.gameObject:SetActive(false)
    return self
end

function UIMarryInfoPanel:Show(childId)
    --播放开启动画
    self.AnimModule:PlayEnableAnimation()
    self:IsHideInfoPanel(false);
    self:UpdatePage()
end

function UIMarryInfoPanel:Hide()
    --播放关闭动画
    self.AnimModule:PlayDisableAnimation()
    self.AppellationPreviewPanel:Hide()
    self.MarryRewardPanel:Hide()
    self.CupidPanel:Hide()
    self.MarryProcessPanel:Hide()
    self.MarryTypePanel:Hide()
    self.AppointmentPanel:Hide()
    self.InvitePanel:Hide()
    self.EngagementPanel:Hide()

    self.LeftPlayerSkin:ResetSkin()
end

function UIMarryInfoPanel:IsHideInfoPanel(state)
    if state then
        self.InfoPanelGo:SetActive(false);
    else
        self.InfoPanelGo:SetActive(true);
    end
end

-- 称号预览界面
function UIMarryInfoPanel:OnPreviewBtnClick()
    self:IsHideInfoPanel(true);
    self.AppellationPreviewPanel:Show()
end

function UIMarryInfoPanel:OnRewardBtnClick()
    self:IsHideInfoPanel(true);
    self.MarryRewardPanel:Show()
end

function UIMarryInfoPanel:OnCupidBtnClick()
    self:IsHideInfoPanel(true);
    self.CupidPanel:Show()
end

function UIMarryInfoPanel:UpdatePage()
    self:UpdateUI()
    self:UpdatePartnerModel()
    self:UpdateSelfModel()
end

-- 界面文字的显示
function UIMarryInfoPanel:UpdateUI()
    local _marryData = GameCenter.MarrySystem.MarryData
    --如果有伴侣了
    if GameCenter.MarrySystem:HasPartner() then
        self.RightNameLabel.text = _marryData.PartnerName
    else
        self.RightNameLabel.text = "还没有伴侣"
    end
    local _lp = GameCenter.GameSceneSystem:GetLocalPlayer();
    if _lp ~= nil then
        self.LeftNameLabel.text = _lp.Name
    end
    self.IntimateLabel.text = _marryData.IntimacyValue
    self.DaysLabel.text = _marryData.MarryDays
    self.AppellationProLabel.text = string.format( "称号获取进度:%s", "80%")
end

--显示伴侣的模型
function UIMarryInfoPanel:UpdatePartnerModel()
    --配偶的外观信息
    local _mateInfo = GameCenter.MarrySystem.MarryData.PartnerMateInfo
    if _mateInfo ~= nil then
        self.RightPlayerSkin:ResetRot()
        self.RightPlayerSkin:ResetSkin()
        self.RightPlayerSkin:SetCameraSize(2.3)
        --配偶职业
        local _occ = _mateInfo.Career
        if (_mateInfo.FashionBodyId ~= 0) then
            self.RightPlayerSkin:SetEquip(FSkinPartCode.Body, RoleVEquipTool.GetFashionModelID(_occ, _mateInfo.FashionBodyId, _mateInfo.FashionLevel));
        else
            self.RightPlayerSkin:SetEquip(FSkinPartCode.Body, RoleVEquipTool.GetBodyModelID(_occ, _mateInfo.ClothesEquipId, _mateInfo.FashionLevel));
        end
        if (_mateInfo.FashionWeaponId ~= 0) then
            self.RightPlayerSkin:SetEquip(FSkinPartCode.Weapon, RoleVEquipTool.GetFashionModelID(_occ, _mateInfo.FashionWeaponId,_mateInfo.WeaponStar));
        else
            self.RightPlayerSkin:SetEquip(FSkinPartCode.Weapon, RoleVEquipTool.GetWeaponModelID(_occ, _mateInfo.WeaponsEquipId, _mateInfo.WeaponStar));
        end
        self.RightPlayerSkin:SetEquip(FSkinPartCode.Wing, RoleVEquipTool.GetWingModelID(_occ, _mateInfo.WingID));
    end
end

-- 显示自己的模型
function UIMarryInfoPanel:UpdateSelfModel()
    self.LeftPlayerSkin:ResetRot()
    self.LeftPlayerSkin:ResetSkin()
    self.LeftPlayerSkin:SetCameraSize(2.3)
    self.LeftPlayerSkin:SetEquip(FSkinPartCode.Body, RoleVEquipTool.GetLPBodyModel())
    self.LeftPlayerSkin:SetEquip(FSkinPartCode.Weapon, RoleVEquipTool.GetLPWeaponModel())
    self.LeftPlayerSkin:SetEquip(FSkinPartCode.Wing, RoleVEquipTool.GetLPWingModel());
    self.LeftPlayerSkin:SetEquip(FSkinPartCode.StrengthenVfx, RoleVEquipTool.GetLPStrengthenVfx());
end

return UIMarryInfoPanel