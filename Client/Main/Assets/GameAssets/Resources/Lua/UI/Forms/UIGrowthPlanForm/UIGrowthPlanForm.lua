------------------------------------------------
--作者： xihan
--日期： 2019-04-26
--文件： UIGrowthPlanForm.lua
--模块： UIGrowthPlanForm
--描述： 成长基金窗体
------------------------------------------------

local CompentItem = require "UI.Forms.UIGrowthPlanForm.CompentItem"
local PwCompoentItem = require "UI.Forms.UIGrowthPlanForm.PwCompoentItem"

--模块定义
local UIGrowthPlanForm = {
    --是否已经初始化
    IsInit = false,
    --贴图
    Texture = nil,
    --贴图1
    Texture1 = nil,
    --购买按钮
    Buy = nil,
    --奖励按钮
    _RewardPw = nil,
    --scrollview
    Levels = nil,
    --Grid
    Grid = nil,
    --描述text
    Des = nil,
    --描述
    DesStr = nil,
    --活动结束
    ActivityOverLabel = nil,
    --number
    Num = nil,
    --完成次数
    FinishNum = nil,
    --已购买
    YiGouMaiq = nil,
    --已购买次数
    YiGouMaiCount = nil,
    --时间
    LeftTime = nil,
    --baseitem
    Item = nil,
    --红点
    RedPoint = nil,
    --点
    Point = nil,
    --遮罩
    Mask = nil,
    --花费
    Cost = nil,
    --全局id=1206 -->Params = 1000
    GlobalCfg = nil,
    --CompentItems
    CompentList = nil,
    --pwCompentLists
    PwCompentList = nil,
}

--继承Form函数
function UIGrowthPlanForm:OnRegisterEvents()
	self:RegisterEvent(UIEventDefine.UIGrowthPlanForm_OPEN,self.OnOpen)
	self:RegisterEvent(UIEventDefine.UIGrowthPlanForm_CLOSE,self.OnClose)
    self:RegisterEvent(LogicEventDefine.EID_EVENT_REFRESH_GROWTHPLAN_UI,self.UpdateUI)
end

function UIGrowthPlanForm:OnFirstShow()
	self:FindAllComponents()
    self:RegUICallback()
    -- local DataGlobal = require("config/dataglobal")
    self.GlobalCfg = DataConfig.DataGlobal[1206]
    if self.GlobalCfg ~= nil then
        self.Num.text = self.GlobalCfg.Params
    end
    self.CompentList = List:New()
    self.PwCompentList = List:New()
end

function UIGrowthPlanForm:OnShowAfter()
    if not self.DesStr then
        --Debug.Log(string.gsub(self.Des.text,'{0}','%%s'))
        self.DesStr = self.Des.text
    end
    --加载texture
    self:LoadTextures()
    GameCenter.WelfareSystem:ReqOpenWelfarePanel(WelfareDefine.Welfare_Growth)
end

function UIGrowthPlanForm:OnHideAfter()
	self:UnloadTextures()
	-- self.CSForm:OnHideAfter()
end

function UIGrowthPlanForm:OnFormDestroy()
    -- Debug.Log("UIGrowthPlanForm:OnFormDestroy")
    -- if #self.CompentList > 0 then
    --     for i=1, #self.CompentList do

    --     end
    -- end
    self.IsInit = false
end
--obj bool
function UIGrowthPlanForm:UpdateUI(obj, sender)
    if not self.IsInit then
        return
    end

    -- local _t1 = os.clock()
	local id = 0
	local hasNum = 0
	if obj ~= nil then
        self:SetBuyBtn(obj)
	end
	--排序
    -- XLuaHelper.SortWelfareItem(GameCenter.GameCenter.GrowthPlanSystem.DataList)
    GameCenter.GrowthPlanSystem:SortWelfareItem()
    -- Debug.Log("DataList.Count ========== ",GameCenter.GameCenter.GrowthPlanSystem.DataList.Count)
	if self.CompentList ~= nil then
        -- for i=1,GameCenter.GameCenter.GrowthPlanSystem.DataList.Count do
        for i=1,#GameCenter.GrowthPlanSystem.DataList do
            -- Debug.Log("for =============== ",i)
            --CompentItem
            local item = nil
            if #self.CompentList < i then
                if i == 1 then
                    -- item = CompentItem.New(self.Item.transform, GameCenter.GameCenter.GrowthPlanSystem.DataList[i-1])
                    item = CompentItem.New(self.Item.transform, GameCenter.GrowthPlanSystem.DataList[i])
                else
                    local go = UnityUtils.Clone(self.Item.gameObject)
                    if go then
                        item = CompentItem.New(go.transform, GameCenter.GrowthPlanSystem.DataList[i])
					end
                end
                self.CompentList:Add(item)
                -- table.insert(self.CompentList,item)
            else
                item = self.CompentList[i]
            end
            --设置item数据
            local num = 0
            if i ~=  1 then
                item:SetCompentData(GameCenter.GrowthPlanSystem.DataList[i], self)
            end
            if GameCenter.GrowthPlanSystem.DataList[i].IsAward then
                hasNum = hasNum + num
            end
        end
        if self.CompentList ~= nil and #self.CompentList ~= 0 then
            if GameCenter.GrowthPlanSystem.DataList ~= nil and #GameCenter.GrowthPlanSystem.DataList ~= 0 then
                self.CompentList[1]:SetCompentData(GameCenter.GrowthPlanSystem.DataList[1], self)
            end
        end
    end

    if self.PwCompentList ~= nil then
        for i=1,Utils.GetTableLens(DataConfig.DataGrowthFundAll) do
            -- Debug.Log("for DataGrowthFundAll i = ",i)
            --PwCompoentItem
            local item = nil
            if #self.PwCompentList < i then
                item = PwCompoentItem.New(self.Trans:Find(string.format("Bottom/Grid/FanLiItem_%s", i-1)), i)
                self.PwCompentList:Add(item)
                -- table.insert(self.PwCompentList,item)
            else
                item = self.PwCompentList[i]
            end
            --设置item数据
            if item ~= nil then
                if #GameCenter.GrowthPlanSystem.PeopleWelfareList > i - 1 then
                    item:SetCompoentData(GameCenter.GrowthPlanSystem.PeopleWelfareList[i],self)
                end
            end
        end
    end

    --_rewardDes.UpdateIcon(id)
    self.FinishNum.text = tostring(hasNum)
    self.Grid.repositionNow = true
    self.Levels:ResetPosition()
    --全民福利领取按钮状态
    local isShow = false
    for i=1,#GameCenter.GrowthPlanSystem.PeopleWelfareList do
        if GameCenter.GrowthPlanSystem.PeopleWelfareList[i].State == 1 then
            isShow = true
            break
        end
    end
    if isShow then
        self._RewardPw.enabled = true
        self.Mask.gameObject:SetActive(false)
        self.Point.gameObject:SetActive(true)
    else
        self._RewardPw.enabled = false
        self.Mask.gameObject:SetActive(true)
        self.Point.gameObject:SetActive(false)
        GameCenter.RedPointSystem:RemoveFuncCondition(FunctionStartIdCode.GrowthPlan, 200)
    end

    self.YiGouMaiCount.text = string.format("%s", GameCenter.GrowthPlanSystem.BuyNum)
    -- local _t2 = os.clock()
    -- Debug.Log("Lua UpdateUI ==============",(_t2-_t1)*1000,"/ms")
end

--点击领取全名福利
function UIGrowthPlanForm:OnClickRewardPw()
    GameCenter.Network.Send("MSG_Welfare.ReqReceiveUniversalReward",{})
end

--点击购买成长基金
function UIGrowthPlanForm:OnClickBuy()
    local num = tonumber(self.GlobalCfg.Params) and tonumber(self.GlobalCfg.Params) or -1
    if num ~= -1 and num <= GameCenter.ItemContianerSystem:GetEconomyWithType(ItemTypeCode.Gold) then
        GameCenter.MsgPromptSystem:ShowMsgBox(DataConfig.DataMessageString.Get("GROWTHPLAN_GOUMAI_DES"), function (code)
            if code == MsgBoxResultCode.Button2 then
                GameCenter.GrowthPlanSystem:ReqActiveGrowthFind()
            end
        end)
    else
        -- Debug.Log("ItemTypeCode.Gold = ",ItemTypeCode.Gold,type(ItemTypeCode.Gold))
        -- Debug.Log("FunctionStartIdCode.GrowthPlan = ",FunctionStartIdCode.GrowthPlan,type(FunctionStartIdCode.GrowthPlan))
        --(int)ItemTypeCode.Gold
        GameCenter.ItemQuickGetSystem:OpenItemQuickGetForm(ItemTypeCode.__CastFrom("Gold"))
    end
end

--查找UI上各个控件
function UIGrowthPlanForm:FindAllComponents()
    -- local _t1 = os.clock()
    local _tf = self.Trans
    self.Texture = _tf:Find("Left/Texture"):GetComponent("UITexture")
    self.Texture1 = _tf:Find("Left/Texture1"):GetComponent("UITexture")
    self.Buy = _tf:Find("Bottom/Buy"):GetComponent("UIButton")
    self._RewardPw = _tf:Find("Bottom/RewardPw"):GetComponent("UIButton")
    self.Levels = _tf:Find("Right/Levels"):GetComponent("UIScrollView")
    self.Grid = _tf:Find("Right/Levels/Grid"):GetComponent("UIGrid")
    self.Des = _tf:Find("Right/Levels/Grid/Item/Des"):GetComponent("UILabel")
    self.ActivityOverLabel = _tf:Find("Bottom/ActivityOverLabel"):GetComponent("UILabel")
    self.Num = _tf:Find("Bottom/Cost/Num"):GetComponent("UILabel")
    self.FinishNum = _tf:Find("Left/RewardDes/Num"):GetComponent("UILabel")
    self.YiGouMaiq = _tf:Find("Bottom/YiGouMai"):GetComponent("UILabel")
    self.YiGouMaiCount = _tf:Find("Bottom/YiGouMai/YiGouMaiCount"):GetComponent("UILabel")
    self.LeftTime = _tf:Find("Right/LeftTimeTitle/LeftTime"):GetComponent("UILabel")
    self.Item = _tf:Find("Right/Levels/Grid/Item"):GetComponent("UISprite")
    self.RedPoint = _tf:Find("Bottom/Buy/RedPoint"):GetComponent("UISprite")
    self.Point = _tf:Find("Bottom/RewardPw/Point"):GetComponent("UISprite")
    self.Mask = _tf:Find("Bottom/RewardPw/Mask"):GetComponent("UISprite")
    self.Cost = _tf:Find("Bottom/Cost"):GetComponent("UISprite")
    self.ActivityOverLabel.gameObject:SetActive(false)
    self.LeftTime.gameObject:SetActive(false)
    self.RedPoint.gameObject:SetActive(false)
    -- local _t2 = os.clock()
    -- Debug.LogError("Lua FindAllComponents ==============", (_t2-_t1)*1000, "/ms")
    self.IsInit = true
end

--注册UI上面的事件，比如点击事件等
function UIGrowthPlanForm:RegUICallback()
    self.Buy.onClick:Clear()
    EventDelegate.Add(self.Buy.onClick, Utils.Handler(self.OnClickBuy, self))
    self._RewardPw.onClick:Clear()
    EventDelegate.Add(self._RewardPw.onClick, Utils.Handler(self.OnClickRewardPw, self))
end

--bool isBuy
function UIGrowthPlanForm:SetBuyBtn(isBuy)
    if isBuy then
        self.Cost.gameObject:SetActive(false)
        self.Buy.gameObject:SetActive(false)
    else
        self.Cost.gameObject:SetActive(true)
        self.Buy.gameObject:SetActive(true)
    end
end

--加载texture
function UIGrowthPlanForm:LoadTextures()    
    self.CSForm:LoadTexture(self.Texture1,AssetUtils.GetImageAssetPath(ImageTypeCode.UI, "tex_vip_back1"))
    self.CSForm:LoadTexture(self.Texture,AssetUtils.GetImageAssetPath(ImageTypeCode.UI, "tex_vip_back2"))
end

--TextureInfo tex
function UIGrowthPlanForm:LoadTexFinish(tex)
    if tex.Texture == nil then
        return
    end
    self.Texture.mainTexture = tex.Texture
end

function UIGrowthPlanForm:Update(deltaTime)
    if not self.IsInit then
        return
    end
    if not GameCenter.GrowthPlanSystem.RemainTime then
        return
    end
    if GameCenter.GrowthPlanSystem.RemainTime > 0 then
        --ulong
        local day = 0
        --ulong
        local hour = 0
        --ulong
        local min = 0
        --ulong
        local second = 0
        day, hour, min, second = Time.SplitTime(GameCenter.GrowthPlanSystem.RemainTime)
        if not self.LeftTime.gameObject.activeSelf then
            self.LeftTime.gameObject:SetActive(true)
        end
        local _str = string.gsub(DataConfig.DataMessageString.Get("GROWTHPLAN_TIME_DES"),"{0:D2}",day)
        _str = string.gsub(_str,"{1:D2}",hour)
        _str = string.gsub(_str,"{2:D2}",min)
        self.LeftTime.text = _str
    else
        self.YiGouMaiCount.text = DataConfig.DataMessageString.Get("GROWTHPLAN_DES_OVER")
        self.ActivityOverLabel.text = DataConfig.DataMessageString.Get("GROWTHPLAN_DES_OVER")
        self.YiGouMaiq.gameObject:SetActive(false)
        self.ActivityOverLabel.gameObject:SetActive(true)
    end
end

return UIGrowthPlanForm