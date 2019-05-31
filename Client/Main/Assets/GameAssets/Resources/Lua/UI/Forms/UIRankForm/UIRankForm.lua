
------------------------------------------------
--作者： 王圣
--日期： 2019-04-24
--文件： UIRankForm.lua
--模块： UIRankForm
--描述： 排行榜UI
------------------------------------------------

-- c#类
local PopupListMenu = require "UI.Components.UIPopoupListMenu.PopupListMenu"
local ItemComponent = require "UI.Forms.UIRankForm.RankItemGetComponent"
local UIRankCompare = require "UI.Forms.UIRankForm.UIRankCompare"
local RankType = require "Logic.Rank.RankType"
local UIRankForm = {
    --btn
    CloseBtn = nil,
    Praisebtn = nil,
    ComPareBtn = nil,
    CompareCloseBtn = nil,
    LocalServerBtn = nil,
    CrossServerBtn = nil,
    --label
    MyPowerLabel = nil,
    MyRankLabel = nil,
    PraiseLabel = nil,
    LeftPraiseLabel = nil,

    TempMenu = nil,
    TempItem = nil,
    ComparePanel = nil,
    PopupListMenu = nil,
    UIGrid = nil,
    UILoopGrid = nil,
    UIScroll = nil,
    --CompareUI = nil,
    IsSetFirstSelect = false,

    CompoentList = List:New(),
    Skin = nil,
}

--button 回调
function UIRankForm:OnClickClose()
    self.PopoupListMenu:CloseAll()
    self:OnClose()
end

--点击赞美
function UIRankForm:OnClickPraise()
    if GameCenter.RankSystem.CurRankData then
        GameCenter.RankSystem:ReqWorship(GameCenter.RankSystem.CurRankData.RoleId)
    end
end

--点击属性对比按钮
function UIRankForm:OnClickCompare()
    --请求属性对比
    GameCenter.RankSystem:ReqCompareAttr(GameCenter.RankSystem.CurRankData.RoleId)
end

--点击关闭属性对比UI
function UIRankForm:OnClickCompareUI()
    self:CloseCompareUI()
end

--点击排行对象
function UIRankForm:OnClickRankItem()
    for i = 1,#self.CompoentList do
        if self.CompoentList[i].SelectBtn == CS.UIButton.current then
            if self.CompoentList[i].IsSelect then
                return
            end
            self.CompoentList[i].IsSelect = true
            self.CompoentList[i].SelectSpr.gameObject:SetActive(true)
            GameCenter.RankSystem:ReqRankPlayerImageInfo(self.CompoentList[i].RoleId)
            for m = 1,#GameCenter.RankSystem.CurRankList do
                if self.CompoentList[i].RoleId == GameCenter.RankSystem.CurRankList[m].RoleId then
                    GameCenter.RankSystem.CurRankData = GameCenter.RankSystem.CurRankList[m]
                    break
                end
            end
        else
            self.CompoentList[i].IsSelect = false
            self.CompoentList[i].SelectSpr.gameObject:SetActive(false)
        end
    end
end

--点击本服按钮
function UIRankForm:OnClickLocalServer()
    if GameCenter.RankSystem.IsLocalServer then
        return
    end
    GameCenter.RankSystem.IsLocalServer = true
end

--点击跨服按钮
function UIRankForm:OnClickCrossServer()
    if not GameCenter.RankSystem.IsLocalServer then
        return
    end
    GameCenter.RankSystem.IsLocalServer = false
end

--点击子菜单
function UIRankForm:OnClickChildMenu(id)

    -- GameCenter.RankSystem.CurRankList = GameCenter.RankSystem:GetItemByChildMenuId(id)
    -- GameCenter.RankSystem.CurSelectRankIndex = 1
    -- if #GameCenter.RankSystem.CurRankList >=1 then
    --     GameCenter.RankSystem.CurRankData = GameCenter.RankSystem.CurRankList[1]
    -- end
    --self:RefreshData()
    self.IsSetFirstSelect = false
    GameCenter.RankSystem.CurFunctionId = id
    GameCenter.RankSystem:ReqRankInfo(id)
end

--loopGrid回调
function UIRankForm:LoopGridCallBack(trans,name,isClear)
    local index = tonumber(trans.name)
    local list = GameCenter.RankSystem.CurRankList
    if index <= #list then
        local compoent = nil
        for i = 1,#self.CompoentList do
            if self.CompoentList[i].Trans == trans then
                compoent = self.CompoentList[i]
            end
        end
        if compoent == nil then
            compoent = ItemComponent:New(trans,list[index].RoleId)
            UIUtils.AddBtnEvent(compoent.SelectBtn,self.OnClickRankItem,self)
            self.CompoentList:Add(compoent)
        end
        compoent:PraseData(list[index])
        if not self.IsSetFirstSelect then
            self.IsSetFirstSelect = true
            self:SetFirstData(trans)
            GameCenter.RankSystem.CurRankData = list[index]
        end
        if compoent.RoleId == GameCenter.RankSystem.CurRankData.RoleId then
            compoent.IsSelect = true
            compoent.SelectSpr.gameObject:SetActive(true)
        else
            compoent.IsSelect = false
            compoent.SelectSpr.gameObject:SetActive(false)
        end
    end
end

--继承Form函数
function UIRankForm:OnRegisterEvents()
	self:RegisterEvent(UIEventDefine.UI_RANK_FORM_OPEN,self.OnOpen)
    self:RegisterEvent(UIEventDefine.UI_RANK_FORM_CLOSE,self.OnClose)
    self:RegisterEvent(LogicEventDefine.EID_EVENT_RANK_REFRESH,self.OnRefresh)
    self:RegisterEvent(LogicEventDefine.EID_EVENT_RANK_UPDATE_MODEL,self.SetModel)
    --self:RegisterEvent(LogicEventDefine.EID_EVENT_RANK_SHOWSHENG,self.SetPariseLabel)
    self:RegisterEvent(LogicEventDefine.EID_EVENT_RANK_SHOWCOMPARE,self.OnShowCompare)
end

function UIRankForm:OnFirstShow()
    self:FindAllComponents()
    --添加PopoupListMenu
    self.PopoupListMenu = PopupListMenu:CreateMenu()
    local data = GameCenter.RankSystem.Data
    data.MenuList:Sort(function(a,b) 
        return a.MenuType<b.MenuType
     end )
    for i = 1, #data.MenuList do
        local list = List:New()
        local menu = data.MenuList[i]
        for k,v in pairs(menu.ChildMenuDic) do
            local tab = {Id = v.Cfg.Id ,Name = v.Cfg.Name}
            list:Add(tab)
        end
        self.PopoupListMenu:AddMenu(self.TempMenu, menu.MenuType, data.MenuList[i].MenuName, list,Utils.Handler(self.OnClickChildMenu,self))
    end
end

function UIRankForm:OnShowAfter()
end

function UIRankForm:OnHideBefore()
    if self.Skin then
        self.Skin:ResetSkin()
    end
end

function UIRankForm:OnOpen(obj, sender)
    self.CSForm:Show(sender)
    local cfg = DataConfig.DataRankBase[RankType.Level]
    -- if cfg ~= nil then
    GameCenter.RankSystem.CurFunctionId = RankType.Level
    -- end
    self.PopoupListMenu:OpenMenuList(GameCenter.RankSystem.CurFunctionId)
end

function UIRankForm:OnRefresh(obj,sender)
    self.CompoentList:Clear()
    self.MyPowerLabel.text = tostring(GameCenter.RankSystem.Data.MyPower)
    GameCenter.RankSystem.CurRankList = GameCenter.RankSystem:GetItemByChildMenuId(GameCenter.RankSystem.CurFunctionId)
    --设置我的战斗力
    local lp = GameCenter.GameSceneSystem:GetLocalPlayer()
    if lp ~= nil then
        local data = GameCenter.RankSystem:GetRankDataByPlayerId(lp.ID)
        if data == nil then
            --china
            self.MyRankLabel.text = "未上榜"
        else
            GameCenter.RankSystem.Data.MyRank = data.Rank
            self.MyRankLabel.text = tostring(GameCenter.RankSystem.Data.MyRank)
        end
    end
    self.UILoopGrid:Init(#GameCenter.RankSystem.CurRankList)
    self.UIScroll:ResetPosition()
    self.UILoopGrid:ResetPos()
end

--查找UI上各个控件
function UIRankForm:FindAllComponents()
    self.TempMenu = self.Trans:Find("Left/Panel/PopoupList/MenuTemp")
    self.TempItem = self.Trans:Find("Right/RankScroll/RankGrid/TempItem")
    --self.TempItem.gameObject:SetActive(false)
    self.ComparePanel = self.Trans:Find("Center/ComparePanel")
    self.ComparePanel.gameObject:SetActive(false)
    --btn 
    self.CloseBtn = self.Trans:Find("Top/CloseBtn"):GetComponent("UIButton")
    self.Praisebtn = self.Trans:Find("Center/PraiseBtn"):GetComponent("UIButton")
    self.ComPareBtn = self.Trans:Find("Center/Compare"):GetComponent("UIButton")
    self.CompareCloseBtn = self.Trans:Find("Center/ComparePanel/CloseBtn"):GetComponent("UIButton")
    self.LocalServerBtn = self.Trans:Find("Right/LocalServerBtn"):GetComponent("UIButton")
    self.CrossServerBtn = self.Trans:Find("Right/CrossServerBtn"):GetComponent("UIButton")
    UIUtils.AddBtnEvent(self.CloseBtn, self.OnClickClose, self)
    UIUtils.AddBtnEvent(self.Praisebtn, self.OnClickPraise, self)
    UIUtils.AddBtnEvent(self.ComPareBtn, self.OnClickCompare, self)
    UIUtils.AddBtnEvent(self.CompareCloseBtn, self.OnClickCompareUI, self)
    UIUtils.AddBtnEvent(self.LocalServerBtn, self.OnClickLocalServer, self)
    UIUtils.AddBtnEvent(self.CrossServerBtn, self.OnClickCrossServer, self)
    --label
    self.MyPowerLabel = self.Trans:Find("Center/PowerTitle/FightPoint"):GetComponent("UILabel")
    self.MyRankLabel = self.Trans:Find("Right/MyRank"):GetComponent("UILabel")
    self.PraiseLabel = self.Trans:Find("Center/PraiseTitle/PraiseCount"):GetComponent("UILabel")
    self.LeftPraiseLabel = self.Trans:Find("Left/LeftPraise/Count"):GetComponent("UILabel")

    self.Skin = UnityUtils.RequireComponent( UIUtils.FindTrans(self.Trans,"Center/UIRoleSkinCompoent"),"Funcell.GameUI.Form.UIPlayerSkinCompoent");
    if self.Skin then
        self.Skin:OnFirstShow(self.this, FSkinTypeCode.Custom)
    end

    self.UIScroll = UnityUtils.RequireComponent(self.Trans:Find("Right/RankScroll"),"UIScrollView")
    local gridTrans = self.Trans:Find("Right/RankScroll/RankGrid")
    self.UIGrid = UnityUtils.RequireComponent(gridTrans,"UIGrid")
    self.UILoopGrid = UnityUtils.RequireComponent(gridTrans,"Funcell.Plugins.Common.UILoopScrollViewBase")
    self.UILoopGrid:SetDelegate(Utils.Handler(self.LoopGridCallBack,self))--self.LoopGridCallBack)
    self.UIGrid.repositionNow = true
end

--刷新排行榜显示
function UIRankForm:RefreshData()
    
    --设置我的排名
    
end


--設置第一個數據
function UIRankForm:SetFirstData(trans)
    for i = 1,#self.CompoentList do
        if self.CompoentList[i].Trans == trans then
            if self.CompoentList[i].IsSelect then
                return
            end
            self.CompoentList[i].SelectSpr.gameObject:SetActive(true)
            GameCenter.RankSystem:ReqRankPlayerImageInfo(self.CompoentList[i].RoleId)
        else
            self.CompoentList[i].SelectSpr.gameObject:SetActive(false)
        end
    end
end

--设置模型显示
function UIRankForm:SetModel(info)
    if self.Skin then
        self.Skin:ResetRot()
        self.Skin:ResetSkin()
        self.Skin:SetCameraSize(1.5)
    end
    --設置body模型
    self:SetPariseLabel()

    if not info.FashionBodyID == 0  then
        self.Skin:SetEquip(FSkinPartCode.Body, RoleVEquipTool:GetFashionModelID(info.Career,info.FashionBodyID,info.FashionLayer))
    else
        self.Skin:SetEquip(FSkinPartCode.Body, RoleVEquipTool:GetBodyModelID(info.Career,info.ClothesEquipId, info.FashionLayer))
    end
    if not info.FashionWeaponID == 0 then
        self.Skin:SetEquip(FSkinPartCode.Weapon, RoleVEquipTool:GetFashionModelID(info.Career,info.FashionWeaponID, info.WeaponStar))
    else
        self.Skin:SetEquip(FSkinPartCode.Weapon, RoleVEquipTool:GetWeaponModelID(info.Career,info.WeaponsEquipId, info.WeaponStar))
    end
    --设置赞美次数
    self.PraiseLabel.text = tostring(info.BePraiseNum)
end
 
--设置崇拜次数
function UIRankForm:SetPariseLabel()
    self.PraiseLabel.text = GameCenter.RankSystem.CurRankData.PraiseCount
    self.LeftPraiseLabel.text = GameCenter.RankSystem.TodayRemainPraiseNum
end

--打开属性对比UI
function UIRankForm:OnShowCompare(obj ,sender)
    self:OpenCompareUI()
end


--打开属性对比UI
function UIRankForm:OpenCompareUI()
    --设置数据
    if self.CompareUI == nil then
        self.CompareUI = UIRankCompare:New(self.ComparePanel)
    end
    self.CompareUI:SetData()
    self.ComparePanel.gameObject:SetActive(true)
end

--关闭属性对比UI
function UIRankForm:CloseCompareUI()
    self.ComparePanel.gameObject:SetActive(false)
end

function UIRankForm:Update(dt)
    if self.PopoupListMenu then
        self.PopoupListMenu:Update(dt)
    end
end
return UIRankForm