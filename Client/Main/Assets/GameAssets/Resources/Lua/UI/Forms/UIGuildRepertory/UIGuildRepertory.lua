------------------------------------------------
--作者： 何健
--日期： 2019-05-21
--文件： UIGuildRepertory.lua
--模块： UIGuildRepertory
--描述： 宗派仓库主面板
------------------------------------------------
local UIGuildSubmitPanel = require "UI.Forms.UIGuildRepertory.UIGuildSubmitPanel"
local UIGuildRepertorySetPanel = require "UI.Forms.UIGuildRepertory.UIGuildRepertorySetPanel"
local UIPopSelectList = require "UI.Components.UIPopSelectList.UIPopSelectList"
local UICheckBox = require "UI.Components.UICheckBox"
local UIGuildRepertory = {
    --仓库物品的滑动窗
    RightScrollView = nil,
    --捐献记录的滑动窗
    RecordScrollView = nil,
    --仓库物品的网格
    RightGrid = nil,
    RightGridTrans = nil,
    --是否显示自己职业
    CheckBox = nil,
    --筛选按钮：等级
    LevelBtn = nil,
    --筛选按钮：品质
    QualityBtn = nil,
    --捐献按钮
    DonateBtn= nil,
    DonateBtnGo = nil,
    --仓库清理按钮
    CleanBtn = nil,
    CleanBtnGo = nil,
    --装备销毁按钮
    DestroyBtn = nil,
    DestroyBtnGo = nil,
    --退出装备销毁状态
    ExitDestroyBtn = nil,
    ExitDestroyBtnGo = nil,
    --兑换按钮
    ChangeBtn = nil,
    ChangeBtnGo = nil,
    --保存按钮
    SetBtn = nil,
    SetBtnGo = nil,
    --仓库积分
    Score = nil,
    --模板存放的父节点
    TempGo = nil,
    --item模板
    UiItemGo = nil,
    UiItemTrans = nil,
    --捐献记录的子控件模板
    RecordItemGo = nil,
    --捐献记录的Table控件
    RecordTable = nil,
    RecordTableTrans = nil,
    LevelSortID = 1,
    QualitySortID = 1,
    IsDestroyState = false,
    --捐献界面脚本
    DonatePanel = nil,
    --设置界面
    SetPanel = nil,
    --仓库存放的装备列表
    StoreItemList = List:New(),
    --固定物品列表
    FixedItemList = List:New(),
    --选中列表
    SelectItemList = List:New(),
    --仓库记录列表
    StoreRecordList = List:New(),

    --下拉菜单数据
    PopLevelList = List:New(),
    PopQualityList = List:New()
}
local PopLevelItem = {
    Text = nil,
    Level = 0
}
function PopLevelItem:New(text, level)
    local _M = Utils.DeepCopy(self)
    _M.Text = text
    _M.Level = level
    return _M
end
local PopQulityItem = {
    Text = nil,
    Quality = 0
}
function PopQulityItem:New(text, quality)
    local _M = Utils.DeepCopy(self)
    _M.Text = text
    _M.Quality = quality
    return _M
end

--继承Form函数
function UIGuildRepertory:OnRegisterEvents()
	self:RegisterEvent(UIEventDefine.UIGuildRepertory_OPEN, self.OnOpen)
    self:RegisterEvent(UIEventDefine.UIGuildRepertory_CLOSE, self.OnClose)
    -- //刷新仓库格子
    self:RegisterEvent(LogicEventDefine.EID_EVENT_REFRESH_STORE_GRID, self.EventRefreshBaseStore)
    self:RegisterEvent(LogicEventDefine.EID_EVENT_REFRESH_LOG, self.EventRefreshRecordList)
    self:RegisterEvent(LogicEventDefine.EID_EVENT_GUILD_DESTROY_ITEM, self.EventOnDestroyEquip)
    self:RegisterEvent(LogicEventDefine.EID_EVENT_GUILD_ADD_ITEM, self.EventOnSomeoneSubmitEquip)
    self:RegisterEvent(LogicEventDefine.EID_EVENT_GUILD_ADD_RECORD, self.EventOnAddOneLog)
    self:RegisterEvent(LogicEventDefine.EID_EVENT_GUILD_SUBMIT_ITEM_FINISH, self.OnSumbitResult)
    self:RegisterEvent(LogicEventDefine.EID_EVENT_GUILD_REFRESHSCORE, self.RefreshScore)
    self:RegisterEvent(LogicEventDefine.EID_EVENT_GUILD_STORESETTING_RESULT, self.OnSetResult)

    -- //穿装备事件，这里要刷新item，判断对比箭头
    self:RegisterEvent(LogicEventDefine.EID_EVENT_UI_EQUIPSKILLCOM_SUC, self.EventOnEquipOn);
end

function UIGuildRepertory:OnFirstShow()
    self:FindAllComponents()
    self.CSForm:AddAlphaAnimation()
    self.DonatePanel:SetTempItem(self.UiItemGo)
    self:Initialize()
end
function UIGuildRepertory:OnHideBefore()
    self.CheckBox:SetChecked(false)
    self.LevelBtn:SetSelect(1)
    self.QualityBtn:SetSelect(1)
    self:ClearStoreItemsAndRecord()
    GameCenter.GuildRepertorySystem:ClearDatasWhileCloseForm()
end
function UIGuildRepertory:OnShowAfter()
    GameCenter.Network.Send("MSG_Guild.ReqGuildStoreHouse", {})
    self.DonatePanel:Close()
    self.SetPanel:Close()
    self.TempGo:SetActive(false)
    self.CleanBtnGo:SetActive(false)
    self.DestroyBtnGo:SetActive(false)
    self:RefreshUIWhileOpen()
end
--查找UI上各个控件
function UIGuildRepertory:FindAllComponents()
    local trans = self.Trans

    self.RightScrollView = UIUtils.FindScrollView(trans, "Right/RightScrollView")
    self.RecordScrollView = UIUtils.FindScrollView(trans, "Left/RecordScrollView")
    self.RightGrid = UIUtils.FindGrid(trans, "Right/RightScrollView/RightGrid")
    self.RightGridTrans = UIUtils.FindTrans(trans, "Right/RightScrollView/RightGrid")
    -- self.CheckBox =  UnityUtils.RequireComponent(UIUtils.FindTrans(self.Trans, "Top/CheckBox"), "Funcell.Plugins.Common.UICheckBox")
    -- self.LevelBtn =  UnityUtils.RequireComponent(UIUtils.FindTrans(self.Trans, "Top/LevelSelect"), "Funcell.GameUI.Form.UIPopSelectList")
    -- self.QualityBtn =  UnityUtils.RequireComponent(UIUtils.FindTrans(self.Trans, "Top/QualitySelect"), "Funcell.GameUI.Form.UIPopSelectList")
    self.CheckBox = UICheckBox:OnFirstShow(UIUtils.FindTrans(trans, "Top/CheckBox"))
    self.LevelBtn = UIPopSelectList:OnFirstShow(UIUtils.FindTrans(trans, "Top/LevelSelect"))
    self.QualityBtn = UIPopSelectList:OnFirstShow(UIUtils.FindTrans(trans, "Top/QualitySelect"))
    self.DonateBtn = UIUtils.FindBtn(trans, "Bottom/DonateBtn")
    self.DonateBtnGo = UIUtils.FindGo(trans, "Bottom/DonateBtn")
    self.CleanBtn = UIUtils.FindBtn(trans, "Bottom/CleanBtn")
    self.CleanBtnGo = UIUtils.FindGo(trans, "Bottom/CleanBtn")
    self.DestroyBtn = UIUtils.FindBtn(trans, "Bottom/DestroyBtn")
    self.DestroyBtnGo = UIUtils.FindGo(trans, "Bottom/DestroyBtn")
    self.ExitDestroyBtn = UIUtils.FindBtn(trans, "Bottom/ExitDestroy")
    self.ExitDestroyBtnGo = UIUtils.FindGo(trans, "Bottom/ExitDestroy")
    self.ChangeBtn = UIUtils.FindBtn(trans, "Bottom/ChangeBtn")
    self.ChangeBtnGo = UIUtils.FindGo(trans, "Bottom/ChangeBtn")
    self.SetBtn = UIUtils.FindBtn(trans, "Bottom/SetBtn")
    self.SetBtnGo = UIUtils.FindGo(trans, "Bottom/SetBtn")
    self.Score = UIUtils.FindLabel(trans, "Bottom/Score")
    self.TempGo = UIUtils.FindGo(trans, "Temp")
    self.UiItemGo = UIUtils.FindGo(trans, "Temp/UIItem")
    self.UiItemTrans = UIUtils.FindTrans(trans, "Temp/UIItem")
    self.RecordItemGo = UIUtils.FindGo(trans, "Temp/RecordItem")
    self.RecordTable = UIUtils.FindTable(trans, "Left/RecordScrollView/RecordTable")
    self.RecordTableTrans = UIUtils.FindTrans(trans, "Left/RecordScrollView/RecordTable")

    self.DonatePanel = UIGuildSubmitPanel:OnFirstShow(UIUtils.FindTrans(trans, "Center"))
    self.SetPanel = UIGuildRepertorySetPanel:OnFirstShow(UIUtils.FindTrans(trans, "SetPanel"))

    self.CheckBox:SetOnClickFunc(Utils.Handler(self.OnClickCheckBox, self))
    UIUtils.AddBtnEvent(self.ChangeBtn, self.OnClickChangeBtn, self)
    UIUtils.AddBtnEvent(self.DestroyBtn, self.OnClickDestroyBtn, self)
    UIUtils.AddBtnEvent(self.CleanBtn, self.OnClickCleanBtn, self)
    UIUtils.AddBtnEvent(self.DonateBtn, self.OnClickDonateBtn, self)
    UIUtils.AddBtnEvent(self.SetBtn, self.OnClickSetBtn, self)
    UIUtils.AddBtnEvent(self.ExitDestroyBtn, self.OnClickExitDestroyBtn, self)
end

function UIGuildRepertory:Initialize()
    local _list = List:New()
    self.PopLevelList:Clear()
    self.PopQualityList:Clear()
    _list:Add(PopLevelItem:New(DataConfig.DataMessageString.Get("C_GUILD_SORT_LEVEL"), 0))
    _list:Add(PopLevelItem:New(DataConfig.DataMessageString.Get("C_GUILD_SORT_LEVEL_1"), 1))
    _list:Add(PopLevelItem:New(DataConfig.DataMessageString.Get("C_GUILD_SORT_LEVEL_2"), 2))
    _list:Add(PopLevelItem:New(DataConfig.DataMessageString.Get("C_GUILD_SORT_LEVEL_3"), 3))
    _list:Add(PopLevelItem:New(DataConfig.DataMessageString.Get("C_GUILD_SORT_LEVEL_4"), 4))
    _list:Add(PopLevelItem:New(DataConfig.DataMessageString.Get("C_GUILD_SORT_LEVEL_5"), 5))
    _list:Add(PopLevelItem:New(DataConfig.DataMessageString.Get("C_GUILD_SORT_LEVEL_6"), 6))
    _list:Add(PopLevelItem:New(DataConfig.DataMessageString.Get("C_GUILD_SORT_LEVEL_7"), 7))
    _list:Add(PopLevelItem:New(DataConfig.DataMessageString.Get("C_GUILD_SORT_LEVEL_8"), 8))
    _list:Add(PopLevelItem:New(DataConfig.DataMessageString.Get("C_GUILD_SORT_LEVEL_9"), 9))
    _list:Add(PopLevelItem:New(DataConfig.DataMessageString.Get("C_GUILD_SORT_LEVEL_10"), 10))
    _list:Add(PopLevelItem:New(DataConfig.DataMessageString.Get("C_GUILD_SORT_LEVEL_11"), 11))
    _list:Add(PopLevelItem:New(DataConfig.DataMessageString.Get("C_GUILD_SORT_LEVEL_12"), 12))
    _list:Add(PopLevelItem:New(DataConfig.DataMessageString.Get("C_GUILD_SORT_LEVEL_13"), 13))
    _list:Add(PopLevelItem:New(DataConfig.DataMessageString.Get("C_GUILD_SORT_LEVEL_14"), 14))
    _list:Add(PopLevelItem:New(DataConfig.DataMessageString.Get("C_GUILD_SORT_LEVEL_15"), 15))
    local glbal = DataConfig.DataGlobal[1285]
    local levelLimit = tonumber(glbal.Params)
    for _,v  in pairs(_list) do
        if v.Level >= levelLimit or v.Level == 0 then
            self.PopLevelList:Add(v)
        end
    end
    _list:Clear()
    _list:Add(PopQulityItem:New(DataConfig.DataMessageString.Get("C_GUILD_SORT_QUALITY"), 0))
    _list:Add(PopQulityItem:New(DataConfig.DataMessageString.Get("C_GUILD_SORT_QUALITY_WHITE"), 1))
    _list:Add(PopQulityItem:New(DataConfig.DataMessageString.Get("C_GUILD_SORT_QUALITY_GREEN"), 2))
    _list:Add(PopQulityItem:New(DataConfig.DataMessageString.Get("C_GUILD_SORT_QUALITY_BLUE"), 3))
    _list:Add(PopQulityItem:New(DataConfig.DataMessageString.Get("C_GUILD_SORT_QUALITY_PURPLE"), 4))
    _list:Add(PopQulityItem:New(DataConfig.DataMessageString.Get("C_GUILD_SORT_QUALITY_ORANGE"), 5))
    _list:Add(PopQulityItem:New(DataConfig.DataMessageString.Get("C_GUILD_SORT_QUALITY_GOLD"), 6))
    _list:Add(PopQulityItem:New(DataConfig.DataMessageString.Get("C_GUILD_SORT_QUALITY_RED"), 7))
    _list:Add(PopQulityItem:New("粉色", 8))
    _list:Add(PopQulityItem:New("暗金", 9))
    _list:Add(PopQulityItem:New("七彩", 10))
    glbal = DataConfig.DataGlobal[1286]
    local limit = Utils.SplitStr(glbal.Params, "_")
    if #limit == 2 then
        levelLimit = tonumber(limit[1])
    end
    for _,v in pairs(_list) do
        if v.Quality >= levelLimit or v.Quality == 0 then
            self.PopQualityList:Add(v)
        end
    end
end

function UIGuildRepertory:RefreshUIWhileOpen()
    self.LevelBtn:SetOnSelectCallback(Utils.Handler(self.OnLevelBtnSelectCallback, self))
    self.QualityBtn:SetOnSelectCallback(Utils.Handler(self.OnQualityBtnSelectCallback, self))

    self.LevelBtn:SetData(self.PopLevelList)
    self.QualityBtn:SetData(self.PopQualityList)

    self.IsDestroyState = false

    self:RefreshDestroyState()
    self:RefreshScore()

    self.CheckBox:SetChecked(false)
    self.LevelBtn:SetSelect(1)
    self.QualityBtn:SetSelect(1)
end

--显示可穿装备点击
function UIGuildRepertory:OnClickCheckBox(check)
    self:DoSort()
end

--捐献按钮
function UIGuildRepertory:OnClickDonateBtn()
    self.DonatePanel:Open()
    self.LevelBtn:SetSelect(1)
    self.QualityBtn:SetSelect(1)
    self.CheckBox:SetChecked(false)
    self:DoSort()
end

--清理背包按钮
function UIGuildRepertory:OnClickCleanBtn()
    self.IsDestroyState = true
    self.LevelBtn:SetSelect(1)
    self.QualityBtn:SetSelect(1)
    self.CheckBox:SetChecked(false)
    self:DoSort()
    self:RefreshDestroyState()
end

--销毁按钮
function UIGuildRepertory:OnClickDestroyBtn()
    local _req = {}
    local _temp = {}
    for i = 1, #self.SelectItemList do
        if self.SelectItemList[i].ItemInfo ~= nil then
            table.insert(_temp, self.SelectItemList[i].ItemInfo.DBID)
        end
    end

    if #_temp > 0 then
        _req.itemId = _temp
        _req.type = 3
        GameCenter.Network.Send("MSG_Guild.ReqGuildStoreHouseOperation", _req)
    end

    self.SelectItemList:Clear()
end

--兑换按钮
function UIGuildRepertory:OnClickChangeBtn()
    local _req = {}
    local _temp = {}
    for i = 1, #self.SelectItemList do
        if self.SelectItemList[i].ItemInfo ~= nil then
            table.insert(_temp, self.SelectItemList[i].ItemInfo.DBID)
        end
    end

    if #_temp > 0 then
        _req.itemId = _temp
        _req.type = 2
        GameCenter.Network.Send("MSG_Guild.ReqGuildStoreHouseOperation", _req)
    end

    self.SelectItemList:Clear()
end

--退出清理按钮
function UIGuildRepertory:OnClickExitDestroyBtn()
    self.IsDestroyState = false
    self:RefreshDestroyState()

    for i = 1, #self.SelectItemList do
        self.SelectItemList[i]:SelectItem(false)
    end
    self.SelectItemList:Clear()
end

--等级筛选
function UIGuildRepertory:OnLevelBtnSelectCallback(index, data)
    if self.LevelSortID == index then
        return;
    end
    self.LevelSortID = index
    self:DoSort()
end

--品质筛选
function UIGuildRepertory:OnQualityBtnSelectCallback(index, data)
    if self.QualitySortID == index then
        return;
    end
    self.QualitySortID = index
    self:DoSort()
end

-- 点击仓库中item
function UIGuildRepertory:OnClikStoreItem(obj)
    local _tmpBpItem = UnityUtils.RequireComponent(obj.transform, "Funcell.GameUI.Form.UIPlayerBagItem")
    if _tmpBpItem.ItemInfo == nil then
        return;
    end
    -- 选中固定物品跳过
    local _storeIndex = self.FixedItemList:IndexOf(_tmpBpItem)
    if _storeIndex >= 1 and self.IsDestroyState then
        return;
    end
    local _selectIndex = self.SelectItemList:IndexOf(_tmpBpItem)
    if _selectIndex >= 1 then
        _tmpBpItem:SelectItem(false)
        self.SelectItemList:RemoveAt(_selectIndex)
    else
        _tmpBpItem:SelectItem(true)
        self.SelectItemList:Add(_tmpBpItem);
    end
end

--打开设置界面
function UIGuildRepertory:OnClickSetBtn()
    self.SetPanel:Open()
end

--仓库积分更新
function UIGuildRepertory:RefreshScore(obj, sender)
    self.Score.text = tostring(GameCenter.GuildRepertorySystem.MyStoreScore)
end

--按钮状态更新
function UIGuildRepertory:RefreshDestroyState()
    local _hasPriorityToDestroy = GameCenter.GuildRepertorySystem:CanDestroyEquip()
    self.DestroyBtnGo:SetActive(self.IsDestroyState and _hasPriorityToDestroy)
    self.ExitDestroyBtnGo:SetActive(self.IsDestroyState and _hasPriorityToDestroy)
    self.CleanBtnGo:SetActive( not self.IsDestroyState and _hasPriorityToDestroy)
    self.DonateBtnGo:SetActive(not self.IsDestroyState)
    self.ChangeBtnGo:SetActive( not self.IsDestroyState)
    self.SetBtnGo:SetActive(GameCenter.GuildRepertorySystem:CanCleanSet() and not self.IsDestroyState)
end

function UIGuildRepertory:DoSort()
    GameCenter.GuildRepertorySystem:SelectSort(self.PopLevelList[self.LevelSortID].Level, self.PopQualityList[self.QualitySortID].Quality, self.CheckBox.IsChecked)
    self.FixedItemList:Clear()

    -- //筛选前，重置之前的状态
    self:ClearSelectItems()

    if #self.StoreItemList == 0 then
        self:EventRefreshBaseStore(nil)
    else
        -- //固定物品
        local fixedItemIds = GameCenter.GuildRepertorySystem.SortedItems
        -- //装备
        local equipItems = GameCenter.GuildRepertorySystem.SortedEquipItems

        local idIndex = 0;
        local equipIndex = 0;
        -- //清空格子数据
        for i = 1, #self.StoreItemList do
            self.StoreItemList[i]:UpdateItem(nil)
            self.StoreItemList[i].gameObject:SetActive(true)
            local _isSet = false
            -- //物品
            if (idIndex < fixedItemIds.Count) then
                self.FixedItemList:Add(self.StoreItemList[i])
                self.StoreItemList[i]:UpdateItem(fixedItemIds[idIndex])
                idIndex = idIndex + 1
                _isSet = true
            end

            -- //装备
            if equipIndex < equipItems.Count and idIndex >= fixedItemIds.Count and not _isSet then
                self.StoreItemList[i]:UpdateItem(equipItems[equipIndex])
                equipIndex = equipIndex + 1
            end
        end
    end

    self.RightScrollView:ResetPosition()
    self.RightGrid:Reposition()

    -- //以防万一
    self:ClearSelectItems()
    -- Debug.LogError(self.LevelSortID)
    -- -- //销毁状态，有筛选，则全部勾选
    -- if self.IsDestroyState and (self.LevelSortID > 1 or  self.QualitySortID > 1) then
    --     for i = 1, #self.StoreItemList do
    --         if self.StoreItemList[i] ~= nil then
    --             if self.StoreItemList[i].ItemInfo ~= nil then
    --                 local selectIndex = self.SelectItemList:IndexOf(self.StoreItemList[i])
    --                 if selectIndex == 0 then
    --                     self.StoreItemList[i]:SelectItem(true)
    --                     self.SelectItemList:Add(self.StoreItemList[i])
    --                 end
    --             end
    --         end
    --     end
    -- end
end

-- //取消所有item的选中状态
function UIGuildRepertory:ClearSelectItems()
    for i = 1, #self.SelectItemList do
        self.SelectItemList[i]:SelectItem(false)
    end

    self.SelectItemList:Clear()
end

function UIGuildRepertory:EventRefreshBaseStore(obj, sender)
    -- //总格子数
    local maxNum = GameCenter.GuildRepertorySystem.TotalCellNums
    -- //固定物品
    local fixedItemIds = GameCenter.GuildRepertorySystem.SortedItems
    -- //装备
    local equipItems = GameCenter.GuildRepertorySystem.SortedEquipItems
    local idIndex = 0;
    local equipIndex = 0;
    for i = 0, maxNum - 1 do
        local childTrans = nil
        if i >= self.RightGridTrans.childCount then
            childTrans = GameObject.Instantiate(self.UiItemGo).transform
            childTrans.parent = self.RightGridTrans
            UnityUtils.ResetTransform(childTrans)
        else
            childTrans = self.RightGridTrans:GetChild(i)
        end
        childTrans.gameObject:SetActive(true)
        local drag = UnityUtils.RequireComponent(childTrans, "UIDragScrollView")
        drag.scrollView = self.RightScrollView;
        local bagItemScript = UnityUtils.RequireComponent(childTrans, "Funcell.GameUI.Form.UIPlayerBagItem")
        bagItemScript.IsOpened = true;

        -- //保存到临时列表
        self.StoreItemList:Add(bagItemScript);
        local _isSet = false
        -- //物品
        if idIndex < fixedItemIds.Count then
            self.FixedItemList:Add(bagItemScript)
            bagItemScript:UpdateItem(fixedItemIds[idIndex])
            bagItemScript.SingleClick = Utils.Handler(self.OnClikStoreItem, self)
            idIndex = idIndex + 1;
            _isSet = true
        end

        -- //装备
        if equipIndex < equipItems.Count and idIndex >= fixedItemIds.Count and not _isSet then
            bagItemScript:UpdateItem(equipItems[equipIndex])
            bagItemScript.SingleClick = Utils.Handler(self.OnClikStoreItem, self)
            equipIndex = equipIndex + 1
            _isSet = true
        end

        -- //空格子
        if not _isSet then
            bagItemScript:UpdateItem(nil)
        end
    end

    self.RightGrid:Reposition()
    self.RightScrollView:ResetPosition()

    self:RefreshScore()
end

-- 某人捐献了装备，需要在仓库中显示
function UIGuildRepertory:EventOnSomeoneSubmitEquip(obj, sender)
    local datas = obj
    local index = tonumber(datas[0])
    local item = datas[1]
    if index < #self.StoreItemList then
        self.StoreItemList[index + 1]:UpdateItem(item)
        self.StoreItemList[index + 1].SingleClick = Utils.Handler(self.OnClikStoreItem, self)
    end
end

-- //打开界面刷新所有仓库记录
function UIGuildRepertory:EventRefreshRecordList(obj, sender)
    local allRecords = GameCenter.GuildRepertorySystem.RepertoryRecords
    for i = 0, allRecords.Count - 1 do
        self:AddOnLog(allRecords[i])
    end

    self.RecordTable:Reposition()
end
function UIGuildRepertory:AddOnLog(log, insertTop)
    local childTrans = nil
    if #self.StoreRecordList < self.RecordTableTrans.childCount then
        childTrans = self.RecordTableTrans:GetChild(#self.StoreRecordList)
    else
        childTrans = GameObject.Instantiate(self.RecordItemGo).transform
        childTrans.parent = self.RecordTable.transform
        UnityUtils.ResetTransform(childTrans)
    end
    local drag = UnityUtils.RequireComponent(childTrans, "UIDragScrollView")
    drag.scrollView = self.RecordScrollView

    local label = childTrans:GetComponent("UILabel")
    label.text = log
    local bounds = CS.NGUIMath.CalculateRelativeWidgetBounds(childTrans, childTrans)
    local boxCollider = UnityUtils.RequireComponent(childTrans, "BoxCollider")
    boxCollider.size = bounds.size;
    local btn = UnityUtils.RequireComponent(childTrans, "UIButton")
    UIUtils.AddBtnEvent(btn, self.OnClickRecordLable, self)

    self.StoreRecordList:Add(label)

    if (insertTop) then
        childTrans:SetSiblingIndex(0)
    end
end

-- 添加一条仓库记录
function UIGuildRepertory:EventOnAddOneLog(obj, sender)
    local log = tostring(obj)
    self:AddOnLog(log, true)
    self.RecordTable:Reposition()
    self.RecordScrollView.contentPivot = CS.UIWidget.Pivot.Top
    self.RecordScrollView:ResetPosition()
end

-- 穿装备事件，这里要刷新item，判断对比箭头
function UIGuildRepertory:EventOnEquipOn(obj, sender)
    for i = 1, #self.StoreItemList do
        if self.StoreItemList[i] ~= nil then
            if self.StoreItemList[i].ItemInfo ~= nil then
                self.StoreItemList[i]:UpdateItem(self.StoreItemList[i].ItemInfo)
            end
        end
    end
end

--积分变化
function UIGuildRepertory:OnSumbitResult(obj, sender)
    self:RefreshScore()
    self.DonatePanel:OnSumbitResult(obj)
end

--设置数据返回
function UIGuildRepertory:OnSetResult(obj, sender)
    self.SetPanel:RefreshForm()
end

-- 兑换或销毁装备后，需要删除格子
function UIGuildRepertory:EventOnDestroyEquip(obj, sender)
    local id = tonumber(obj)
    if id < #self.StoreItemList then
        self.StoreItemList[id + 1]:UpdateItem(nil)
    end

    self:RefreshScore()
end

-- 清空仓库物品和日志
function UIGuildRepertory:ClearStoreItemsAndRecord()
    for i = 1, #self.StoreRecordList do
        self.StoreRecordList[i].text = ""
    end
    for i = 1, #self.StoreItemList do
        self.StoreItemList[i].gameObject:SetActive(false)
    end

    self.StoreRecordList:Clear()
    self.StoreItemList:Clear()
    self.SelectItemList:Clear()
end

function UIGuildRepertory:OnClickRecordLable()
    local label = CS.UIButton.current.transform:GetComponent("UILabel");
    if label ~= nil then
        local url = label:GetUrlAtPosition(CS.UICamera.lastHit.point)
        if url ~= nil and url ~= "" then
            local equipIndex = tonumber(url);
            local equipment = GameCenter.GuildRepertorySystem:GetEquipFromRecordList(equipIndex)
            if equipment ~= nil then
                GameCenter.ItemTipsMgr:ShowTips(equipment, label.gameObject, ItemTipsLocation.Defult)
            end
        end
    end
end
return UIGuildRepertory