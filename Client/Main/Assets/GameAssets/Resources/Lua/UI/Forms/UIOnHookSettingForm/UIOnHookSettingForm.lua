
------------------------------------------------
--作者： cy
--日期： 2019-04-16
--文件： UIOnHookSettingForm.lua
--模块： UIOnHookSettingForm
--描述： 离线挂机设置面板
------------------------------------------------

local handler = Utils.Handler

local UIOnHookSettingForm = {
    AnimModule = nil,
    CloseBtn = nil,
    LeftActivePlayModeLab = nil,
    AddHookTimeBtn = nil,
    OfflineHookTimeLab = nil,
    OfflineHookTips1Lab = nil,
    OfflineHookTips2Lab = nil,
    HookEfficiencyLab = nil,
    FightAddRateLab = nil,
    RightActivePlayModeLab = nil,
    ItemExpAddTrs = nil,
    VIPExpAddTrs = nil,
    WorldLvExpAddTrs = nil,
    BgTexture = nil,
}

function UIOnHookSettingForm:OnRegisterEvents()
    self:RegisterEvent(UIEventDefine.UIOnHookSettingForm_OPEN, self.OnOpen)
    self:RegisterEvent(UIEventDefine.UIOnHookSettingForm_CLOSE, self.OnClose)
    self:RegisterEvent(LogicEventDefine.EID_EVENT_UPDATE_HOOKSITTING, self.UpdateFormInfos)
end

function UIOnHookSettingForm:OnOpen(obj, sender)
    self.CSForm:Show(sender)
end

function UIOnHookSettingForm:OnClose(obj, sender)
    self.CSForm:Hide()
end

function UIOnHookSettingForm:OnFirstShow()
    self:FindAllComponents()
    self:RegUICallback()
end

function UIOnHookSettingForm:OnShowBefore()
    GameCenter.OfflineOnHookSystem:ReqHookSetInfo()
end

function UIOnHookSettingForm:OnShowAfter()
    self.CSForm:LoadTexture(self.BgTexture, AssetUtils.GetImageAssetPath(ImageTypeCode.UI, "bag_secon"))
end

function UIOnHookSettingForm:OnHideBefore()
    
end

function UIOnHookSettingForm:FindAllComponents()
    local trans = self.Trans
    self.CloseBtn = UIUtils.FindBtn(trans, "CloseButton")
    self.LeftActivePlayModeLab = UIUtils.FindLabel(trans, "Left/ActivePlayMode")
    self.AddHookTimeBtn = UIUtils.FindBtn(trans, "Left/AddHookTimeBtn")
    self.OfflineHookTimeLab = UIUtils.FindLabel(trans, "Left/OfflineHookTime")
    self.OfflineHookTips1Lab = UIUtils.FindLabel(trans, "Left/OfflineHookTips1")
    self.OfflineHookTips2Lab = UIUtils.FindLabel(trans, "Left/OfflineHookTips2")
    self.HookEfficiencyLab = UIUtils.FindLabel(trans, "Left/HookEfficiency")
    self.FightAddRateLab = UIUtils.FindLabel(trans, "Left/FightAddRate")
    self.RightActivePlayModeLab = UIUtils.FindLabel(trans, "Right/ActivePlayMode")
    self.ItemExpAddTrs = UIUtils.FindTrans(trans, "Right/ExpAddType/ItemExpAdd")
    self.VIPExpAddTrs = UIUtils.FindTrans(trans, "Right/ExpAddType/VIPExpAdd")
    self.WorldLvExpAddTrs = UIUtils.FindTrans(trans, "Right/ExpAddType/WorldLvExpAdd")
    self.BgTexture = UIUtils.FindTex(trans, "BgTexture")
    --创建动画模块
    self.AnimModule = UIAnimationModule(self.Trans)
    --添加一个动画
    self.AnimModule:AddAlphaAnimation()

    self:SetAllTips()
end


function UIOnHookSettingForm:RegUICallback()
    self.CloseBtn.onClick:Clear()
    EventDelegate.Add(self.CloseBtn.onClick, handler(self.CloseBtnOnClick, self))
    self.AddHookTimeBtn.onClick:Clear()
    EventDelegate.Add(self.AddHookTimeBtn.onClick, handler(self.AddHookTimeBtnOnClick, self))
    UIEventListener.Get(UIUtils.FindGo(self.ItemExpAddTrs, "AddBtn")).onClick = handler(self.ItemExpAddBtnOnClick, self)
    UIEventListener.Get(UIUtils.FindGo(self.VIPExpAddTrs, "AddBtn")).onClick = handler(self.VIPExpAddBtnOnClick, self)
end


--界面按钮回调
function UIOnHookSettingForm:CloseBtnOnClick()
    self:OnClose(nil)
end

function UIOnHookSettingForm:ItemExpAddBtnOnClick(go)
    --使用经验加成道具
    local expItemsTable = GameCenter.OfflineOnHookSystem.AddExpItemID
    local haveItem = false
    for k,v in pairs(expItemsTable) do
        local ownNum = GameCenter.ItemContianerSystem:GetItemCountFromCfgId(v)
        if ownNum > 0 then
            local itemList = GameCenter.ItemContianerSystem:GetItemListByCfgid(ContainerType.ITEM_LOCATION_BAG, v)
            if itemList.Count > 0 then
                GameCenter.PushFixEvent(UIEventDefine.UIITEMBATCH_OPEN, itemList[0])
            end
            haveItem = true
            break
        end
    end
    if not haveItem then
        --"你有没任何经验道具"
        GameCenter.MsgPromptSystem:ShowPrompt(DataConfig.DataMessageString.Get("HOOK_NOEXPITEM"))
    end
end

function UIOnHookSettingForm:VIPExpAddBtnOnClick(go)
    
end

function UIOnHookSettingForm:AddHookTimeBtnOnClick()
    --使用增加离线挂机时间道具
    local addHookTimeItemID = GameCenter.OfflineOnHookSystem.AddOnHookTimeItemID
    local ownNum = GameCenter.ItemContianerSystem:GetItemCountFromCfgId(addHookTimeItemID)
    local itemName = DataConfig.DataItem[addHookTimeItemID].Name
    if ownNum > 0 then
        local itemList = GameCenter.ItemContianerSystem:GetItemListByCfgid(ContainerType.ITEM_LOCATION_BAG, addHookTimeItemID)
        if itemList.Count > 0 then
            GameCenter.PushFixEvent(UIEventDefine.UIITEMBATCH_OPEN, itemList[0])
        end
    else
        --"你没有"..itemName
        GameCenter.MsgPromptSystem:ShowPrompt(UIUtils.CSFormat(DataConfig.DataMessageString.Get("HOOK_NOITEM0"), itemName))
    end
end

--游戏内event回调
function UIOnHookSettingForm:UpdateFormInfos(obj, sender)
    local h, m = GameCenter.OfflineOnHookSystem:GetHourAndMinuteBySecond(obj.hookRemainTime)
    self.OfflineHookTimeLab.text = UIUtils.CSFormat(DataConfig.DataMessageString.Get("HOOK_HOURMINUTE"), h, m)
    --string.format( "%d小时%d分钟", h, m )
    self.HookEfficiencyLab.text = self:GetExpEfficiencyStr(obj.hookExpAddRate)
    self.FightAddRateLab.text = UIUtils.CSFormat(DataConfig.DataMessageString.Get("HOOK_FIGHTADDRATE"), obj.fightExpAddRate)
    -- string.format( "战力加成:%d%%", obj.fightExpAddRate) 
    local itemExpAddRateLab = UIUtils.FindLabel(self.ItemExpAddTrs, "AddPercent")
    itemExpAddRateLab.text = string.format( "+%d%%", obj.itemExpAddRate)
    local vipExpAddRateLab = UIUtils.FindLabel(self.VIPExpAddTrs, "AddPercent")
    vipExpAddRateLab.text = string.format( "+%d%%", obj.vipExpAddRate)
    local worldLvExpAddRateLab = UIUtils.FindLabel(self.WorldLvExpAddTrs, "AddPercent")
    worldLvExpAddRateLab.text = string.format( "+%d%%", obj.worldLvExpAddRate)
end

--私有函数

function UIOnHookSettingForm:GetExpEfficiencyStr(totalExp)
    if (totalExp / 100000000) > 1 then
        -- x - x % 0.01   (保留2位小数)
        local value = (totalExp / 100000000) - ((totalExp / 100000000) % 0.01)
        return UIUtils.CSFormat(DataConfig.DataMessageString.Get("HOOK_YIPERMINUTE"), value)
        --string.format( "%.2f亿/分", totalExp / 100000000)
    elseif (totalExp / 10000) > 1 then
        -- x - x % 1    (保留整数)
        local intValue = (totalExp / 10000) - ((totalExp / 10000) % 1)
        return UIUtils.CSFormat(DataConfig.DataMessageString.Get("HOOK_WANPERMINUTE"), intValue)
        --string.format( "%d万/分", intValue)
    else
        return UIUtils.CSFormat(DataConfig.DataMessageString.Get("HOOK_PERMINUTE"), totalExp)
        --string.format( "%d/分", totalExp)
    end
end

function UIOnHookSettingForm:SetAllTips()
    local offlineGetExpTimeCfg = DataConfig.DataGlobal[1471]
    if offlineGetExpTimeCfg ~= nil then
        local txt = UIUtils.CSFormat(DataConfig.DataMessageString.Get("HOOK_GETEXPTIME"), tonumber(offlineGetExpTimeCfg.Params))
        self.OfflineHookTips1Lab.text = txt
        -- string.format( "离线时间>%d分钟才会获得经验", tonumber(offlineGetExpTimeCfg.Params))
    end
    local maxStorageTimeCfg = DataConfig.DataGlobal[1467]
    if maxStorageTimeCfg ~= nil then
        --maxStorageTimeCfg.params是分钟，因此乘以60
        local hour = GameCenter.OfflineOnHookSystem:GetHourAndMinuteBySecond(tonumber(maxStorageTimeCfg.Params) * 60)
        self.OfflineHookTips2Lab.text = UIUtils.CSFormat(DataConfig.DataMessageString.Get("HOOK_MAXSTORAGETIME"), hour)
        -- string.format( "最多储备%d小时", hour)  HOOK_MAXSTORAGETIME
    end
    local worldLvDesc = UIUtils.FindLabel(self.WorldLvExpAddTrs, "Name") -- self.WorldLvExpAddTrs:Find("Name"):GetComponent("UILabel")
    worldLvDesc.text = UIUtils.CSFormat(DataConfig.DataMessageString.Get("HOOK_WORLDLEVEL"), GameCenter.WorldLevelSystem.CurWorldLevel)
    -- string.format( "世界等级%d级", GameCenter.WorldLevelSystem.CurWorldLevel)
end

return UIOnHookSettingForm