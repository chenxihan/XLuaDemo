
------------------------------------------------
--作者： 王圣
--日期： 2019-05-16
--文件： UIFuDiCopyInfoForm.lua
--模块： UIFuDiCopyInfoForm
--描述： 宗派福地副本信息Form
------------------------------------------------

-- c#类
local UIFuDiBossInfo = require "UI.Forms.UIFuDiCopyInfoForm.UIFuDiBossInfo"
local UIFuDiCopyInfoForm = {
    AngerLabel = nil,
    AngerSlider = nil,
    Scroll = nil,
    Grid = nil,
    TempInfo = nil,
    RightTopTrans = nil,
    ShopBtn = nil,
    LeaveBtn = nil,
    FuDiType = 0,
    TotalAnger = 0,
    InfoList = List:New()
}
--继承Form函数
function UIFuDiCopyInfoForm:OnRegisterEvents()
	self:RegisterEvent(UIEventDefine.UIFuDiCopyInfoForm_Open,self.OnOpen)
    self:RegisterEvent(UIEventDefine.UIFuDiCopyInfoForm_Close,self.OnClose)
    self:RegisterEvent(LogicEventDefine.EID_EVENT_FUDIBOSS_INFO_UPDATE,self.OnUpdateInfo)
    self:RegisterEvent(LogicEventDefine.EID_EVENT_ON_MAINMENU_OPEN, self.OnMainMenuOpen)
    self:RegisterEvent(LogicEventDefine.EID_EVENT_ON_MAINMENU_CLOSE, self.OnMainMenuClose)
end

function UIFuDiCopyInfoForm:OnFirstShow()
    local list = List:New()
    self:FindAllComponents()
    for k,v in pairs(DataConfig.DataGuildBattleBoss) do
        if v.Group == self.FuDiType then
            list:Add(v)
        end
    end
    --排序
    list:Sort(function(a,b) 
        return a.Sort<b.Sort
     end )
    for i = 1,#list do
        local component = self:GetInfoComponent(list[i].Id)
        component:SetDefaultData(list[i])
    end
    local globCfg = DataConfig.DataGlobal[1493]
    if globCfg ~= nil then
        self.TotalAnger = tonumber(globCfg.Params)
    end
end

function UIFuDiCopyInfoForm:OnShowAfter()
end

function UIFuDiCopyInfoForm:OnHideBefore()
    
end

function UIFuDiCopyInfoForm:OnOpen(obj, sender)
    if obj ~= nil then
        self.FuDiType = obj.type
    end
    self.CSForm:Show(sender)
    self:SetInfos(obj)
    --设置选中的boss
    for i = 1,#self.InfoList do
        if GameCenter.FuDiSystem.CurSelectBossId == 0 then
            if i == 1 then
                self.InfoList[i].Select.gameObject:SetActive(true)
                GameCenter.PathSearchSystem:SearchPathToPosBoss(true, self.InfoList[i].Pos, self.InfoList[i].MonsterId)
            else
                self.InfoList[i].Select.gameObject:SetActive(false)
            end
        else
            if self.InfoList[i].Id == GameCenter.FuDiSystem.CurSelectBossId then
                self.InfoList[i].Select.gameObject:SetActive(true)
                GameCenter.PathSearchSystem:SearchPathToPosBoss(true, self.InfoList[i].Pos, self.InfoList[i].MonsterId)
            else
                self.InfoList[i].Select.gameObject:SetActive(false)
            end
        end
    end
    self.AngerLabel.text = tostring(GameCenter.FuDiSystem.Anger)
    self.AngerSlider.value = GameCenter.FuDiSystem.Anger/self.TotalAnger
    self.Grid.repositionNow = true
    --self.Scroll:ResetPosition()
    self:MoveBossItem()
end

function UIFuDiCopyInfoForm:OnUpdateInfo(obj,sender)
    self.AngerLabel.text = tostring(GameCenter.FuDiSystem.Anger)
    self.AngerSlider.value = GameCenter.FuDiSystem.Anger/self.TotalAnger
    self:SetInfos(obj)
end

function UIFuDiCopyInfoForm:OnClickBossInfo()
    for i = 1,#self.InfoList do
        if self.InfoList[i].Btn == CS.UIButton.current then
            self.InfoList[i].Select.gameObject:SetActive(true)
            GameCenter.PathSearchSystem:SearchPathToPosBoss(true, self.InfoList[i].Pos, self.InfoList[i].MonsterId);
        else
            self.InfoList[i].Select.gameObject:SetActive(false)
        end
    end
end

--主界面菜单打开处理
function UIFuDiCopyInfoForm:OnMainMenuOpen(obj, sender)
    self.CSForm:PlayHideAnimation(self.RightTopTrans)
end

--主界面菜单关闭处理
function UIFuDiCopyInfoForm:OnMainMenuClose(obj, sender)
    self.CSForm:PlayShowAnimation(self.RightTopTrans)
end

--离开按钮点击
function UIFuDiCopyInfoForm:OnLeaveBtnClick()
    GameCenter.MapLogicSystem:SendLeaveMapMsg(false)
	GameCenter.PushFixEvent(LogicEventDefine.EID_EVENT_INITIATIVE_EXIT_PLANECOPY)
end

--商店按钮点击
function UIFuDiCopyInfoForm:OnShopBtnClick()
    GameCenter.MainFunctionSystem:DoFunctionCallBack(FunctionStartIdCode.Mall, nil)
end

function UIFuDiCopyInfoForm:FindAllComponents()
    self.AngerLabel = UIUtils.RequireUILabel(self.Trans:Find("Center/NuQi/Label/Value"))
    self.AngerSlider = UIUtils.RequireUISlider(self.Trans:Find("Center/NuQi/Process"))
    self.Scroll = UIUtils.RequireUIScrollView(self.Trans:Find("Center/Scroll View"))
    self.Grid = UIUtils.RequireUIGrid(self.Trans:Find("Center/Scroll View/Grid"))
    for i = 1,self.Grid.transform.childCount - 1 do
        local child = self.Grid.transform:GetChild(i)
        local compoent = UIFuDiBossInfo:New(child)
        self.InfoList:Add(compoent)
    end
    self.TempInfo = self.Trans:Find("Center/Scroll View/Grid/TempInfo")
    self.TempInfo.gameObject:SetActive(false)
    self.RightTopTrans = self.Trans:Find("RightTop")
    self.ShopBtn = UIUtils.RequireUIButton(self.Trans:Find("RightTop/Shop"))
    UIUtils.AddBtnEvent(self.ShopBtn,self.OnShopBtnClick,self)
    self.LeaveBtn = UIUtils.RequireUIButton(self.Trans:Find("RightTop/Leave"))
    UIUtils.AddBtnEvent(self.LeaveBtn,self.OnLeaveBtnClick,self)
end

function UIFuDiCopyInfoForm:SetInfos(msg)
    if msg.resurgenceTime ~= nil then
        for i = 1,#msg.resurgenceTime do
            local component = self:GetInfoComponent(msg.resurgenceTime[i].monsterModelId)
            component:SetData(msg.resurgenceTime[i])
            component.Trans.gameObject:SetActive(true)
        end
    end
end

function UIFuDiCopyInfoForm:GetInfoComponent(id)
    local component = nil
    for i = 1,#self.InfoList do
        if self.InfoList[i].Id == id then
            component = self.InfoList[i]  
            break   
        end    
    end
    if component == nil then
        local go = UIUtility.Clone(self.TempInfo.gameObject)
        component = UIFuDiBossInfo:New(go.transform)
        UIUtils.AddBtnEvent(component.Btn,self.OnClickBossInfo,self)
        component.Trans.gameObject:SetActive(true)
        self.InfoList:Add(component)
    end
    return component
end

function UIFuDiCopyInfoForm:MoveBossItem()
    local itemdis = 0;
    local minIndex = 0;
    local resIndex = 0;
    local minDisLevel = 2147483647;
    local dis = 16.5
    local level = 0
    --self.Scroll:ResetPosition()
    if GameCenter.FuDiSystem.CurSelectBossId == 0 then
        level = 0
    else
        level = GameCenter.FuDiSystem.CurSelectBossId
    end
    for i = 1, #self.InfoList do
        local dis = math.abs(self.InfoList[i].Id - level)
        if dis < minDisLevel then
            minIndex = resIndex
            minDisLevel = dis
        end
        resIndex = resIndex + 1
    end   
    local height = self.TempInfo:GetComponent("UIWidget").height
    itemdis = (minIndex + 1) * (height + dis)
    local originPos = self.Scroll.transform.localPosition
    local scrollHeight = self.Scroll:GetComponent("UIPanel").finalClipRegion.w
    local maxMoveDis = resIndex * (height + dis) - scrollHeight + 10;
    local spring = UIUtils.RequireSpringPanel(self.Scroll.transform)
    spring.strength = 50
    if itemdis > scrollHeight then
        if minIndex * (height + dis) < maxMoveDis then
            spring.target = Vector3(originPos.x, originPos.y + minIndex * (height + dis), 0)
        else
            spring.target = Vector3(originPos.x, originPos.y + maxMoveDis, 0)
        end
    else
        spring.target = originPos
    end
    spring.enabled = true; 
    return minIndex;
end

function UIFuDiCopyInfoForm:Update(dt)
    for i = 1,#self.InfoList do
        self.InfoList[i]:Update(dt)
    end
end
return UIFuDiCopyInfoForm