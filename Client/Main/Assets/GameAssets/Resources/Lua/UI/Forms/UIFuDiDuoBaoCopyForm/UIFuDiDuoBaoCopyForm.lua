
------------------------------------------------
--作者： 王圣
--日期： 2019-05-18
--文件： UIFuDiDuoBaoCopyForm.lua
--模块： UIFuDiDuoBaoCopyForm
--描述： 福地夺宝副本UI
------------------------------------------------

-- c#类
local UIDuoBaoDamgeItem = require "UI.Forms.UIFuDiDuoBaoCopyForm.UIDuoBaoDamgeItem"
local UIDuoBaoRankRewardItem = require "UI.Forms.UIFuDiDuoBaoCopyForm.UIDuoBaoRankRewardItem"
local UIFuDiDuoBaoCopyForm = {
    CurBoLabel = nil,
    ReMainLabel = nil,
    Scroll = nil,
    DamgeGrid = nil,
    TempDamge = nil,
    DamageList = List:New(),
    MyRankLabel = nil,
    MyDamgeLabel = nil,
    RewardBtn = nil,
    RankUI = nil,
    RankUICloseBtn = nil,
    RankGrid = nil,
    RightTopTrans = nil,
    ShopBtn = nil,
    LeaveBtn = nil,
    RankList = List:New(),
}
--继承Form函数
function UIFuDiDuoBaoCopyForm:OnRegisterEvents()
	self:RegisterEvent(UIEventDefine.UIFuDiDuoBaoCopy_Open,self.OnOpen)
    self:RegisterEvent(UIEventDefine.UIFuDiDuoBaoCopy_Close,self.OnClose)
    self:RegisterEvent(LogicEventDefine.EID_EVENT_UPDATE_FUDIDUOBAO_COPYINFO,self.OnUpdateForm)
    self:RegisterEvent(LogicEventDefine.EID_EVENT_ON_MAINMENU_OPEN, self.OnMainMenuOpen)
    self:RegisterEvent(LogicEventDefine.EID_EVENT_ON_MAINMENU_CLOSE, self.OnMainMenuClose)
end

function UIFuDiDuoBaoCopyForm:OnFirstShow()
    self:FindAllComponents()
end

function UIFuDiDuoBaoCopyForm:OnShowAfter()
    
end

function UIFuDiDuoBaoCopyForm:OnHideBefore()
    
end

function UIFuDiDuoBaoCopyForm:OnOpen(obj, sender)
    self.CSForm:Show(sender)
    GameCenter.FuDiSystem:ReqPanelReady()
    --self:SetForm()
end

function UIFuDiDuoBaoCopyForm:OnUpdateForm(obj, sender)
    self:SetForm()
end

--点击查看奖励排行
function UIFuDiDuoBaoCopyForm:OnClickRankRewardBtn()
    self:ShowRankUI()
end

--点击关闭奖励排行
function UIFuDiDuoBaoCopyForm:OnClickCloseRankRewardUI()
    self:CloseRankUI()
end

--主界面菜单打开处理
function UIFuDiDuoBaoCopyForm:OnMainMenuOpen(obj, sender)
    self.CSForm:PlayHideAnimation(self.RightTopTrans)
end

--主界面菜单关闭处理
function UIFuDiDuoBaoCopyForm:OnMainMenuClose(obj, sender)
    self.CSForm:PlayShowAnimation(self.RightTopTrans)
end

--离开按钮点击
function UIFuDiDuoBaoCopyForm:OnLeaveBtnClick()
    GameCenter.MapLogicSystem:SendLeaveMapMsg(false)
	GameCenter.PushFixEvent(LogicEventDefine.EID_EVENT_INITIATIVE_EXIT_PLANECOPY)
end

--商店按钮点击
function UIFuDiDuoBaoCopyForm:OnShopBtnClick()
    GameCenter.MainFunctionSystem:DoFunctionCallBack(FunctionStartIdCode.Mall, nil)
end

function UIFuDiDuoBaoCopyForm:FindAllComponents()
    self.CurBoLabel = UIUtils.RequireUILabel(self.Trans:Find("Left/Info1/Label/Label (2)/Bo"))
    self.ReMainLabel = UIUtils.RequireUILabel(self.Trans:Find("Left/Info1/Label (1)/MonsterNum"))
    self.Scroll = UIUtils.RequireUIScrollView(self.Trans:Find("Left/Info2/Scroll View"))
    self.DamgeGrid = UIUtils.RequireUIGrid(self.Trans:Find("Left/Info2/Scroll View/Grid"))
    for i = 1,self.DamgeGrid.transform.childCount-1 do
        local item = UIDuoBaoDamgeItem:New(self.DamgeGrid.transform.GetChild(i))
        self.DamageList:Add(item)
    end
    self.TempDamge = self.Trans:Find("Left/Info2/Scroll View/Grid/Temp")
    self.TempDamge.gameObject:SetActive(false)
    self.MyRankLabel = UIUtils.RequireUILabel(self.Trans:Find("Left/Info2/Label (1)/Rank"))
    self.MyDamgeLabel = UIUtils.RequireUILabel(self.Trans:Find("Left/Info2/Label (1)/Rank/Damge"))
    self.RewardBtn = UIUtils.RequireUIButton(self.Trans:Find("Left/Info2/RwardBtn"))
    UIUtils.AddBtnEvent(self.RewardBtn,self.OnClickRankRewardBtn,self)
    self.RankUI = self.Trans:Find("Center/RankRewardUI")
    self.RankUI.gameObject:SetActive(false)
    self.RankUICloseBtn = UIUtils.RequireUIButton(self.Trans:Find("Center/RankRewardUI/Close"))
    UIUtils.AddBtnEvent(self.RankUICloseBtn,self.OnClickCloseRankRewardUI,self)
    self.RankGrid = UIUtils.RequireUIGrid(self.Trans:Find("Center/RankRewardUI/RankGrid"))
    local index = 1
    for k,v in pairs(DataConfig.DataGuildTreasure) do
        local path = string.format( "Center/RankRewardUI/RankGrid/Rank%s",index)
        local trans = self.Trans:Find(path)
        local rankRewardItem = UIDuoBaoRankRewardItem:New(trans,index)
        rankRewardItem:SetItem(v.Reward)
        self.RankList:Add(rankRewardItem)
        index = index +1
    end
    self.RightTopTrans = self.Trans:Find("RightTop")
    self.ShopBtn = UIUtils.RequireUIButton(self.Trans:Find("RightTop/Shop"))
    UIUtils.AddBtnEvent(self.ShopBtn,self.OnShopBtnClick,self)
    self.LeaveBtn = UIUtils.RequireUIButton(self.Trans:Find("RightTop/Leave"))
    UIUtils.AddBtnEvent(self.LeaveBtn,self.OnLeaveBtnClick,self)
end

function UIFuDiDuoBaoCopyForm:SetForm()
    self.CurBoLabel.text = string.format( "%s/%s",GameCenter.FuDiSystem.DuoBaoCopyInfo.Degree,GameCenter.FuDiSystem.DuoBaoCopyInfo.MaxCount)
    self.ReMainLabel.text = tostring(GameCenter.FuDiSystem.DuoBaoCopyInfo.ReMain)
    self.MyRankLabel.text = tostring(GameCenter.FuDiSystem.DuoBaoCopyInfo.MyRank)
    if GameCenter.FuDiSystem.DuoBaoCopyInfo.MyDamage>10000 then
        --China
        local des = string.format( "%s万",GameCenter.FuDiSystem.DuoBaoCopyInfo.MyDamage/10000 )
        self.MyDamgeLabel.text = des
    else
        self.MyDamgeLabel.text = tostring(GameCenter.FuDiSystem.DuoBaoCopyInfo.MyDamage)
    end
    for i = 1,#self.DamageList do
        self.DamageList[i].Trans.gameObject:SetActive(false)
    end
    for i = 1,#GameCenter.FuDiSystem.DuoBaoCopyInfo.DamageList do
        local damge = nil
        if i>#self.DamageList then
            local go = UIUtility.Clone(self.TempDamge.gameObject)
            damge = UIDuoBaoDamgeItem:New(go.transform)
            self.DamageList:Add(damge)
        else
            damge = self.DamageList[i]
        end
        damge.NameLabel.text = string.format( "%s.%s",GameCenter.FuDiSystem.DuoBaoCopyInfo.DamageList[i].Rank, GameCenter.FuDiSystem.DuoBaoCopyInfo.DamageList[i].Name)
        if GameCenter.FuDiSystem.DuoBaoCopyInfo.DamageList[i].Damage > 10000 then
            --China
            local des = string.format( "%s万",GameCenter.FuDiSystem.DuoBaoCopyInfo.DamageList[i].Damage/10000 )
            damge.DamgeLabel.text = des
        else
            damge.DamgeLabel.text = tostring(GameCenter.FuDiSystem.DuoBaoCopyInfo.DamageList[i].Damage)
        end
        damge.Trans.gameObject:SetActive(true)
    end
    self.Scroll:ResetPosition()
    self.DamgeGrid.repositionNow = true
end

function UIFuDiDuoBaoCopyForm:ShowRankUI()
    self.RankUI.gameObject:SetActive(true)
    self.RankGrid.repositionNow = true
end

function UIFuDiDuoBaoCopyForm:CloseRankUI()
    self.RankUI.gameObject:SetActive(false)
end

return UIFuDiDuoBaoCopyForm