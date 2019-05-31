
------------------------------------------------
--作者： 王圣
--日期： 2019-05-14
--文件： UIFuDiBossForm.lua
--模块： UIFuDiBossForm
--描述： 福地BossUI
------------------------------------------------

-- c#类
local FuDiMenuItem = require "UI.Forms.UIFuDiBossForm.FuDiMenuItem"
local BossFuDiItem = require "UI.Forms.UIFuDiBossForm.BossFuDiItem"
local FuDiBoxItem = require "UI.Forms.UIFuDiBossForm.FuDiBoxItem"
local FuDiBossShowItem = require "UI.Forms.UIFuDiBossForm.FuDiBossShowItem"
local UIFuDiBossForm = {
    ZongLanPage = nil,
    BossPage = nil,
    RewardView = nil,
    ItemGrid = nil,
    RewardTable = nil,
    TempItem = nil,
    BoxTempItem = nil,
    ScoreSlider = nil,
    ZongLanScoreLabel = nil,
    RuleLabel = nil,
    RewardBtn = nil,
    CloseViewBtn = nil,
    GuildNameLabel = nil,
    GuildScoreLabel = nil,
    BossInfoUI = nil,
    BossName = nil,
    BossScore = nil,
    BossDrapGrid = nil,
    BossDrapTempItem = nil,
    BossGuanZhu = nil,
    BossStartDes = nil,
    EnterCopyBtn = nil,
    CloseBossInfoUIBtn = nil,
    CurFuDiEnum = 0,
    CurClickBoxId = 0,
    --外部传入指定bossId
    OpenBossId = 0,
    MenuList = List:New(),
    FuDiList = List:New(),
    --总揽展示掉落道具List
    ShowItemList = List:New(),
    --宝箱预览道具list
    PreviewItemList = List:New(),
    --宝箱list
    BoxItemList = List:New(),
    --boss展示list
    BossShowList = List:New(),
    --boss掉落List
    BossDrapList = List:New(),
}
--菜单
local MenuEnum = {
    ZongLan = 1,
    WangWu = 2,
    LuoFu = 3,
    ChiCheng = 4,
}
local FuDiEnum = {
    WangWu = 1,
    LuoFu = 2,
    ChiCheng = 3,
}
local FuDiBossShowEnum = {
    Leader = 1,
    Elet_1 = 2,
    Elet_2 = 3,
    Elet_3 = 4,
    HuWei_1 = 5,
    HuWei_2 = 6,
    HuWei_3 = 7,
    HuWei_4 = 8,
}
--继承Form函数
function UIFuDiBossForm:OnRegisterEvents()
	self:RegisterEvent(UIEventDefine.UIFuDiBossForm_Open,self.OnOpen)
    self:RegisterEvent(UIEventDefine.UIFuDiBossForm_Close,self.OnClose)
    self:RegisterEvent(LogicEventDefine.EID_EVENT_FUDIBOSS_ZONGLAN_UPDATE,self.OnUpdateZongLan)
    self:RegisterEvent(LogicEventDefine.EID_EVENT_FUDIBOSS_INFO_UPDATE,self.OnUpdateBossShow)
end

function UIFuDiBossForm:OnFirstShow()
    self:FindAllComponents()
end

function UIFuDiBossForm:OnShowAfter()
    --默认点击第一个按钮
    for i = 1,#self.MenuList do
        self.MenuList[i].Select.gameObject:SetActive(false)
    end
    if self.OpenBossId ~=0 then
        local Group = DataConfig.DataGuildBattleBoss[self.OpenBossId].Group
        for i = 1,#self.MenuList do
            if self.MenuList[i].MenuType ==  Group+1 then
                self:OpenPage(self.MenuList[i])
                break
            end
        end
    else
        self:OpenPage(self.MenuList[1])
    end
end

function UIFuDiBossForm:OnHideBefore()
    
end

function UIFuDiBossForm:OnOpen(obj, sender)
    self.CSForm:Show(sender)
    if obj ~= nil then
        self.OpenBossId = obj
    end
end

function UIFuDiBossForm:OnClicClose()
    self:OnClose()
end
--点击菜单
function UIFuDiBossForm:OnClickMenu()
    local menu = nil
    for i = 1,#self.MenuList do
        if self.MenuList[i].Btn == CS.UIButton.current then
            menu = self.MenuList[i]
        end
        self.MenuList[i].Select.gameObject:SetActive(false)
    end
    if menu then
        self:OpenPage(menu)
    end
end
--点击前往
function UIFuDiBossForm:OnClickGoTo()
    local menuType = 1
    local menu = nil
    for i = 1,#self.FuDiList do
        if self.FuDiList[i].GoBtn == CS.UIButton.current then
            menuType = self.FuDiList[i].FuDiType
            break
        end
    end
    for i = 1,#self.MenuList do
        if self.MenuList[i].MenuType == menuType+1 then
            menu = self.MenuList[i]
        end
        self.MenuList[i].Select.gameObject:SetActive(false)
    end
    if menu then
        self:OpenPage(menu)
    end
end
--点击预览宝箱奖励
function UIFuDiBossForm:OnClickPreviewBox()
    local boxItem = nil
    for i = 1,#self.BoxItemList do
        if self.BoxItemList[i].Btn == CS.UIButton.current then
            boxItem = self.BoxItemList[i]
            break
        end
    end
    self.CurClickBoxId = boxItem.Score
    self:SetPreviewBoxReward(boxItem)
    self.RewardView.gameObject:SetActive(true)
end
--点击关闭预览宝箱UI
function UIFuDiBossForm:OnClickClosePreviewBox()
    self.CurClickBoxId = 0
    self.RewardView.gameObject:SetActive(false)
end
--点击领取宝箱奖励
function UIFuDiBossForm:OnClickReward()
    GameCenter.FuDiSystem:ReqDayScoreReward(self.CurClickBoxId)
end
--点击boss头像
function UIFuDiBossForm:OnClickBossHead()
    local showItem = nil
    local bossData = nil
    local bossDataList = GameCenter.FuDiSystem.BossShowData:GetBossListByKey(self.CurFuDiEnum)
    if bossDataList == nil then
        return
    end
    for i = 1,#self.BossShowList do
        if self.BossShowList[i].Btn == CS.UIButton.current then
            showItem = self.BossShowList[i]
            break
        end
    end
    for i = 1,#bossDataList do
        if bossDataList[i].Sort == showItem.Type then
            bossData = bossDataList[i]
            break
        end
    end
    self:SetBossInfoUI(bossData)
    self.BossInfoUI.gameObject:SetActive(true)
end
--点击关闭BossInfoUI
function UIFuDiBossForm:OnClickBossInfoUI()
    GameCenter.FuDiSystem.CurSelectBossId = 0
    self.BossInfoUI.gameObject:SetActive(false)
end
--点击关注(取消关注)
function UIFuDiBossForm:OnClickGuanZhu()
    local bossData = GameCenter.FuDiSystem.BossShowData:GetBossById(GameCenter.FuDiSystem.CurSelectBossId)
    if bossData == nil then
        return
    end
    if CS.UIToggle.current == self.BossGuanZhu then
        if self.BossGuanZhu.value then
            if bossData.IsAttention == false then
                GameCenter.FuDiSystem:ReqAttentionMonster(GameCenter.FuDiSystem.CurSelectBossId,1)
            end
        else
            if bossData.IsAttention  then
                GameCenter.FuDiSystem:ReqAttentionMonster(GameCenter.FuDiSystem.CurSelectBossId,2)
            end
        end
    end
end
--点击进入副本
function UIFuDiBossForm:OnClickEnterCopy()
    local cloneId = DataConfig.DataGuildBattleBoss[GameCenter.FuDiSystem.CurSelectBossId].MapID
    GameCenter.CopyMapSystem:ReqSingleEnterCopyMap(cloneId);
end

--更新总揽
function UIFuDiBossForm:OnUpdateZongLan(obj,sender)
    for i = 1, #GameCenter.FuDiSystem.PreviewData.ReMainList do
        self.FuDiList[i]:SetData(GameCenter.FuDiSystem.PreviewData.ReMainList[i])
    end
    --设置积分进度
    local key = 0
    local value = nil
    for k,v in pairs(DataConfig.DataGuildBattleScore) do
        key = k>key and k or key
    end
    if GameCenter.FuDiSystem.PreviewData.CurScore == -1 then
        self.ScoreSlider.value = 0
        --china
        self.ZongLanScoreLabel.text = "未加入帮派，暂无积分"
    else
        self.ScoreSlider.value = GameCenter.FuDiSystem.PreviewData.CurScore/key
        self.ZongLanScoreLabel.text = tostring(GameCenter.FuDiSystem.PreviewData.CurScore)
    end
    --设置宝箱状态
    for i = 1,#self.BoxItemList do
        if self.BoxItemList[i].Score<= GameCenter.FuDiSystem.PreviewData.CurScore then
            if GameCenter.FuDiSystem:BoxIsRecived(self.BoxItemList[i].Score) then
                --领取了
                self.BoxItemList[i].LockSpr.gameObject:SetActive(false)
                self.BoxItemList[i].OpenSpr.gameObject:SetActive(true)
            else 
                --未领取
                --宝箱激活了  显示红点 播放shake动画
                self.BoxItemList[i].LockSpr.gameObject:SetActive(true)
                self.BoxItemList[i].OpenSpr.gameObject:SetActive(false)
                self.BoxItemList[i].RedPointSpr.gameObject:SetActive(true)
                self.BoxItemList[i]:StartShake()
            end
        else
            --宝箱没有激活
            self.BoxItemList[i].LockSpr.gameObject:SetActive(true)
            self.BoxItemList[i].OpenSpr.gameObject:SetActive(false)
            self.BoxItemList[i].RedPointSpr.gameObject:SetActive(false)
            self.BoxItemList[i]:StopShake()
        end
      end
end

--更新boss信息
function UIFuDiBossForm:OnUpdateBossShow(obj,sender)
    local data = GameCenter.FuDiSystem.BossShowData
    if data == nil then
        return
    end
    self.GuildNameLabel.text = GameCenter.FuDiSystem.PreviewData.ReMainList[self.CurFuDiEnum].GuildName
    self.GuildScoreLabel.text = tostring(data.Score)
    for i = 1,#self.BossShowList do
        local bossData = data:GetBossDataByType(self.CurFuDiEnum,self.BossShowList[i].Type)
        if bossData ~= nil then
            self.BossShowList[i]:SetData(bossData)
        end
    end
    self.ZongLanPage.gameObject:SetActive(false)
    self.BossPage.gameObject:SetActive(true)
end

function UIFuDiBossForm:FindAllComponents()
    --初始化菜单组件
    local length = Utils.GetTableLens(MenuEnum)
    for i = 1,length do
        local path = string.format( "MenuList/Menu_%s",i-1 )
        local trans = self.Trans:Find(path)
        local menu = FuDiMenuItem:New(trans,i)
        menu.Select.gameObject:SetActive(false)
        UIUtils.AddBtnEvent(menu.Btn, self.OnClickMenu, self)
        self.MenuList:Add(menu)
    end
    --初始化福地
    length = Utils.GetTableLens(FuDiEnum)
    for i = 1,length do
        local path = string.format( "Center/Page_0/FuDiItem_%s",i-1)
        local trans = self.Trans:Find(path)
        local fudiItem = BossFuDiItem:New(trans,i)
        UIUtils.AddBtnEvent(fudiItem.GoBtn, self.OnClickGoTo, self)
        self.FuDiList:Add(fudiItem)
    end
    --初始化宝箱
    local keyList = List:New()
    for k,v in pairs(DataConfig.DataGuildBattleScore) do
        keyList:Add(k)
    end
    keyList:Sort(function(a,b) 
        return a<b
     end )
    for i =1,#keyList do
        local path = string.format( "Center/Page_0/ScoreReward/Box_%s",i-1)
        local trans = self.Trans:Find(path)
        local boxItem = FuDiBoxItem:New(trans,keyList[i])
        boxItem:ReSet()
        UIUtils.AddBtnEvent(boxItem.Btn, self.OnClickPreviewBox, self)
        self.BoxItemList:Add(boxItem)
    end
    --初始化bossShow
    length = Utils.GetTableLens(FuDiBossShowEnum)
    for i = 1,length do
        local path = string.format( "Center/Page_1/Head/BossHead_%s",i-1)
        local trans = self.Trans:Find(path)
        local showItem = FuDiBossShowItem:New(trans,i)
        UIUtils.AddBtnEvent(showItem.Btn,self.OnClickBossHead,self)
        self.BossShowList:Add(showItem)
    end
    --Other
    self.ZongLanPage = self.Trans:Find("Center/Page_0")
    self.BossPage = self.Trans:Find("Center/Page_1")
    self.RewardView = self.Trans:Find("Center/Page_0/RewarView")
    self.RewardView.gameObject:SetActive(false)
    self.ItemGrid = self.Trans:Find("Center/Page_0/BossReward/BRGrid"):GetComponent("UIGrid")
    for i = 1,self.ItemGrid.transform.childCount-1 do
        local item = UIUtils.RequireUIItem(self.ItemGrid.transform.GetChild(i))
        self.ShowItemList:Add(item)
    end
    self.TempItem = self.Trans:Find("Center/Page_0/BossReward/BRGrid/TempItem")
    UIUtils.RequireUIItem(self.TempItem)
    self.TempItem.gameObject:SetActive(false)
    self.ScoreSlider = self.Trans:Find("Center/Page_0/ScoreReward/RewardProcess"):GetComponent("UISlider")
    self.ZongLanScoreLabel = UIUtils.RequireUILabel(self.Trans:Find("Center/Page_0/ScoreReward/RewardProcess/Des/Score"))
    self.BoxTempItem = self.Trans:Find("Center/Page_0/RewarView/RewardTable/TempUIItem")
    self.BoxTempItem.gameObject:SetActive(false)
    self.RewardTable = self.Trans:Find("Center/Page_0/RewarView/RewardTable"):GetComponent("UITable")
    for i = 1,self.RewardTable.transform.childCount-1 do
        local item = UIUtils.RequireUIItem(self.RewardTable.transform.GetChild(i))
        self.PreviewItemList:Add(item)
    end
    self.CloseViewBtn = self.Trans:Find("Center/Page_0/RewarView/CloseView"):GetComponent("UIButton")
    UIUtils.AddBtnEvent(self.CloseViewBtn, self.OnClickClosePreviewBox, self)
    self.RewardBtn = self.Trans:Find("Center/Page_0/RewarView/Reward"):GetComponent("UIButton")
    UIUtils.AddBtnEvent(self.RewardBtn, self.OnClickReward, self)
    self.RuleLabel = self.Trans:Find("Center/Page_0/GuiZeDes"):GetComponent("UILabel")
    self.GuildNameLabel = self.Trans:Find("Center/Page_1/DesBg/Label/GuildName"):GetComponent("UILabel")
    self.GuildScoreLabel = self.Trans:Find("Center/Page_1/DesBg/Label1/GuildScore"):GetComponent("UILabel")
    self.BossInfoUI = self.Trans:Find("Center/Page_1/BossDes")
    self.BossInfoUI.gameObject:SetActive(false)
    self.BossName = self.Trans:Find("Center/Page_1/BossDes/BossName/Name"):GetComponent("UILabel")
    self.BossScore = self.Trans:Find("Center/Page_1/BossDes/ScoreDes/KillScore"):GetComponent("UILabel")
    self.BossDrapGrid = UIUtils.RequireUIGrid(self.Trans:Find("Center/Page_1/BossDes/Label (1)/DrapGrid"))
    for i = 1,self.BossDrapGrid.transform.childCount-1 do
        local item = UIUtils.RequireUIItem(self.BossDrapGrid.transform.GetChild(i))
        self.BossDrapList:Add(item)
    end
    self.BossDrapTempItem = UIUtils.RequireUIItem(self.Trans:Find("Center/Page_1/BossDes/Label (1)/DrapGrid/Temp"))
    self.BossDrapTempItem.gameObject:SetActive(false)
    self.BossGuanZhu = UIUtils.RequireUIToggle(self.Trans:Find("Center/Page_1/BossDes/GuanZhu"))
    self.EnterCopyBtn = UIUtils.RequireUIButton(self.Trans:Find("Center/Page_1/BossDes/Button"))
    UIUtils.AddBtnEvent(self.EnterCopyBtn, self.OnClickEnterCopy, self)
    self.BossStartDes = UIUtils.RequireUILabel(self.Trans:Find("Center/Page_1/BossDes/StartDes"))
    self.CloseBossInfoUIBtn = UIUtils.RequireUIButton(self.Trans:Find("Center/Page_1/BossDes/Close"))
    UIUtils.AddBtnEvent(self.CloseBossInfoUIBtn, self.OnClickBossInfoUI, self)
end

function UIFuDiBossForm:OpenPage(menu)
    --点击总揽
    if menu.MenuType == MenuEnum.ZongLan then
        --请求福地总揽数据
        self.CurFuDiEnum = 0
        GameCenter.FuDiSystem:ReqOpenAllBossPanel()
        self.ZongLanPage.gameObject:SetActive(true)
        self.BossPage.gameObject:SetActive(false)
        self:OpenZongLan()
    --点击王屋
    elseif menu.MenuType == MenuEnum.WangWu then
        self.CurFuDiEnum = 1
        self:OpenBoss()
    --点击罗浮
    elseif menu.MenuType == MenuEnum.LuoFu then
        self.CurFuDiEnum = 2
        self:OpenBoss()
    --点击赤城
    elseif menu.MenuType == MenuEnum.ChiCheng then
        self.CurFuDiEnum = 3
        self:OpenBoss()
    end
    menu.Select.gameObject:SetActive(true)
end

function UIFuDiBossForm:OpenZongLan()
      --设置玩法规则
      self.RuleLabel.text = ""
      --设置道具奖励
      local cfg = DataConfig.DataGlobal[1492]
      if cfg == nil then
        return
      end
      local key = tonumber(cfg.Params)
      cfg = DataConfig.DataDaily[key]
      if cfg == nil then
        return
      end
      local strs = Utils.SplitStr(cfg.Reward,'_')
      local itemIdList = List:New()
      for i = 1,#strs do
        itemIdList:Add(tonumber(strs[i]))
      end
      for i = 1,#self.ShowItemList do
        self.ShowItemList[i].gameObject:SetActive(false)
      end
      for i = 1,#itemIdList do
        local item = nil
        if i> #self.ShowItemList then
            local go = UIUtility.Clone(self.TempItem.gameObject)
            item = UIUtils.RequireUIItem(go.transform)
            self.ShowItemList:Add(item)
            item.gameObject:SetActive(true)
        else
            item = self.ShowItemList[i]
            item.gameObject:SetActive(true)
        end
        item:InitializationWithIdAndNum(itemIdList[i],0)
      end
      self.ItemGrid.repositionNow = true
end

function UIFuDiBossForm:OpenBoss()
    --请求福地boss宗派详细信息
    -- if self.CurFuDiEnum >#GameCenter.FuDiSystem.PreviewData.ReMainList then
    --     return 
    -- end
    -- local data = GameCenter.FuDiSystem.PreviewData.ReMainList[self.CurFuDiEnum]
    -- if data == nil then
    --     return
    -- end
    GameCenter.FuDiSystem:ReqOpenDetailBossPanel(self.CurFuDiEnum)
    self.BossStartDes.text = ""
end
--设置宝箱预览UI
function UIFuDiBossForm:SetPreviewBoxReward(boxItem)
    for i = 1,#self.PreviewItemList do
        self.PreviewItemList[i].gameObject:SetActive(false)
    end
    local cfg = DataConfig.DataGuildBattleScore[boxItem.Score]
    if cfg == nil then
        return
    end
    local itemIdList = Utils.SplitStr(cfg.ShowItem,'_')
    for i = 1,#itemIdList do
        local item = nil
        if i>#self.PreviewItemList then
            local go = UIUtility.Clone(self.BoxTempItem.gameObject)
            item = UIUtils.RequireUIItem(go.transform)
            self.PreviewItemList:Add(item)
            item.gameObject:SetActive(true)
        else
            item = self.PreviewItemList[i]
            item.gameObject:SetActive(true)
        end
        item:InitializationWithIdAndNum(tonumber(itemIdList[i]),0)
    end
    --设置领取按钮enable
    if GameCenter.FuDiSystem.PreviewData.CurScore<boxItem.Score then
        --不能领取
        self.RewardBtn.enabled = false
    else
        --可以领取
        self.RewardBtn.enabled = true
    end
    self.RewardTable.repositionNow = true
end
--设置bossInfoUI  
function UIFuDiBossForm:SetBossInfoUI(bossData)
    if bossData == nil then
        return
    end
    GameCenter.FuDiSystem.CurSelectBossId = bossData.Id
    self.BossName.text = bossData.Name
    self.BossScore.text = bossData.Score
    UIUtils.AddOnChangeEvent(self.BossGuanZhu,self.OnClickGuanZhu,self)
    self.BossGuanZhu.value = bossData.IsAttention
    for i = 1,#self.BossDrapList do
        self.BossDrapList[i].gameObject:SetActive(false)
    end
    for i = 1,#bossData.ItemIdList do
        local item = nil
        if i> #self.BossDrapList then
            local go = UIUtility.Clone(self.BossDrapTempItem.gameObject)            
            item = UIUtils.RequireUIItem(go.transform)
            item.gameObject:SetActive(true)
            self.BossDrapList:Add(item)
        else
            item = self.BossDrapList[i]
            item.gameObject:SetActive(true)
        end
        item:InitializationWithIdAndNum(bossData.ItemIdList[i],0)
    end
end

function UIFuDiBossForm:Update(dt)
    if self.BossShowList then
        for i = 1,#self.BossShowList do
            self.BossShowList[i]:Update(dt)
        end
    end
end

return UIFuDiBossForm