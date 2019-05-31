
------------------------------------------------
--作者： cy
--日期： 2019-04-16
--文件： UIOnHookForm.lua
--模块： UIOnHookForm
--描述： 离线挂机结算面板
------------------------------------------------

local handler = Utils.Handler

local UIOnHookForm = {
    AnimModule = nil,
    CloseBtn = nil,
    OfflineHookTimeLab = nil,
    OldLevelLab = nil,
    NewLevelLab = nil,
    GettedExpLab = nil,
    OnHookSettingBtn = nil,
    IKnowBtn = nil,
    ItemCloneRootTrs= nil,
    ItemsScorllView = nil,
    ItemsGrid = nil,
    ItemClone = nil,
    BgTexture = nil,
}

function UIOnHookForm:OnRegisterEvents()
    self:RegisterEvent(UIEventDefine.UIOnHookForm_OPEN, self.OnOpen)
    self:RegisterEvent(UIEventDefine.UIOnHookForm_CLOSE,self.OnCLose)
    self:RegisterEvent(LogicEventDefine.EID_EVENT_UPDATE_HOOKRESULT,self.UpdateHookResult)
end

function UIOnHookForm:OnOpen(obj, sender)
    self.CSForm:Show(sender)
end

function UIOnHookForm:OnCLose(obj, sender)
    self.CSForm:Hide()
end

function UIOnHookForm:OnFirstShow()
    self:FindAllComponents()
    self:RegUICallback()
end

function UIOnHookForm:OnShowBefore()
    
end

function UIOnHookForm:OnShowAfter()
    self:UpdateHookResult(GameCenter.OfflineOnHookSystem.OfflineHookResult,nil)
    self.CSForm:LoadTexture(self.BgTexture, AssetUtils.GetImageAssetPath(ImageTypeCode.UI, "bag_secon"))
end

function UIOnHookForm:OnHideBefore()
    
end

function UIOnHookForm:FindAllComponents()
    local trans = self.Trans
    self.CloseBtn = UIUtils.FindBtn(trans, "CloseButton")
    self.OfflineHookTimeLab = UIUtils.FindLabel(trans, "OfflineHookTime")
    self.OldLevelLab = UIUtils.FindLabel(trans, "LevelChange/OldLevel")
    self.NewLevelLab = UIUtils.FindLabel(trans, "LevelChange/NewLevel")
    self.GettedExpLab = UIUtils.FindLabel(trans, "GettedExp")
    self.OnHookSettingBtn = UIUtils.FindBtn(trans, "OnHookSettingBtn")
    self.IKnowBtn = UIUtils.FindBtn(trans, "IKnowBtn")
    self.ItemCloneRootTrs = UIUtils.FindTrans(trans, "GettedItem/Items")
    self.ItemsScorllView = self.ItemCloneRootTrs:GetComponent("UIScrollView")
    self.ItemsGrid = self.ItemCloneRootTrs:GetComponent("UIGrid")
    self.ItemClone = UIUtils.FindGo(trans, "GettedItem/ItemClone")
    self.BgTexture = UIUtils.FindTex(trans, "BgTexture")
    --创建动画模块
    self.AnimModule = UIAnimationModule(self.Trans)
    --添加一个动画
    self.AnimModule:AddAlphaAnimation()
end

function UIOnHookForm:RegUICallback()
    UIUtils.AddBtnEvent(self.CloseBtn, self.CloseBtnOnClick, self)
    UIUtils.AddBtnEvent(self.OnHookSettingBtn, self.OnHookSettingBtnOnClick, self)
    UIUtils.AddBtnEvent(self.IKnowBtn, self.IKnowBtnOnClick, self)
end


--按钮点击事件
function UIOnHookForm:CloseBtnOnClick()
    self:OnCLose(nil)
end

function UIOnHookForm:OnHookSettingBtnOnClick()
    GameCenter.PushFixEvent(UIEventDefine.UIOnHookSettingForm_OPEN)
end

function UIOnHookForm:IKnowBtnOnClick()
    self:OnCLose(nil)
end

--游戏内event回调
function UIOnHookForm:UpdateHookResult(obj, sender)
    if obj ~= nil then
    local h, m = GameCenter.OfflineOnHookSystem:GetHourAndMinuteBySecond(obj.offlineTime)
    local useTimeStr
    if h > 0 then
        useTimeStr = UIUtils.CSFormat(DataConfig.DataMessageString.Get("HOOK_HOURMINUTE"), h, m)
        -- string.format( "%d小时%d分钟", h, m)
    else
        useTimeStr = UIUtils.CSFormat(DataConfig.DataMessageString.Get("HOOK_MINUTE"), m)
        -- string.format( "%d分钟", m)
    end
    local remainH, remainM = GameCenter.OfflineOnHookSystem:GetHourAndMinuteBySecond(obj.hookRemainTime)
    local remainTimeStr
    if remainH > 0 then
        remainTimeStr = UIUtils.CSFormat(DataConfig.DataMessageString.Get("HOOK_REMAINHOURMINUTE"), remainH, remainM)
        -- string.format( "(剩余%d小时%d分钟)", remainH, remainM)
    else
        remainTimeStr = UIUtils.CSFormat(DataConfig.DataMessageString.Get("HOOK_REMAINMINUTE"), remainM)
        -- string.format( "(剩余%d分钟)", remainM)
    end
    self.OfflineHookTimeLab.text = useTimeStr..remainTimeStr
    self.OldLevelLab.text = tostring(obj.oldLevel)
    self.NewLevelLab.text = tostring(obj.newLevel)
    self.GettedExpLab.text = tostring(obj.addedExp)
    self:CloneItems(obj.itemInfoList)
    end
end

--私有函数
function UIOnHookForm:CloneItems(itemInfoList)
    if itemInfoList ~= nil then
        for i = 1, Utils.GetTableLens(itemInfoList) do
            local _go = nil
            if i - 1 < self.ItemCloneRootTrs.childCount then
                _go = self.ItemCloneRootTrs:GetChild(i - 1).gameObject
            else
                _go = GameObject.Instantiate(self.ItemClone);
                _go.transform.parent = self.ItemCloneRootTrs
                UnityUtils.ResetTransform(_go.transform)
            end
            local _item = UIUtils.RequireUIItem(_go.transform)
            if _item then
                _item:InitializationWithIdAndNum(itemInfoList[i].itemModelId, itemInfoList[i].num, itemInfoList[i].isbind, true)
            end
            _go:SetActive(true)
        end
        self.ItemsScorllView:ResetPosition()
        self.ItemsGrid.repositionNow = true
    end
end

return UIOnHookForm