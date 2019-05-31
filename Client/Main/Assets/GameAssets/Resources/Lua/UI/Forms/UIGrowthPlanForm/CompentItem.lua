------------------------------------------------
--作者： xihan
--日期： 2019-04-28
--文件： CompentItem.lua
--模块： CompentItem
--描述： 成长基金组件
------------------------------------------------
local CompentItem = {}
CompentItem.__index = CompentItem

--Transform trans, GrowthPlanData data
function CompentItem.New(trans, data)
    local _M = {}
    if not trans then
        return _M
    end
    setmetatable(_M, CompentItem)
    --Transform
    _M.Trans = trans
    --UILabel
    _M._des = trans:Find("Des"):GetComponent("UILabel")
    --UIItem
    _M.Item = UIUtils.RequireUIItem(trans:Find("GoodsGrid/UIItem"))
    --UIGrid
    _M.Grid = trans:Find("GoodsGrid"):GetComponent("UIGrid")
    --UIButton
    _M.Reward = trans:Find("Button"):GetComponent("UIButton")
    --Transform
    _M.Flag1 = trans:Find("Flag")
    --Transform
    _M.Flag2 = trans:Find("Flag_1")
    --Transform
    _M.RedPoint = trans:Find("RedPoint")
    --数据
    _M.Data = data
    --gameObjects
    _M.ItemList = {}

    return _M
end

--设置显示数据 GrowthPlanData data
function CompentItem:SetCompentData(data, uiGrowth)
    self.Data = data
    self._des.text = string.gsub(uiGrowth.DesStr, "{0}", self.Data.Cfg.Level)
    local _strs = Utils.SplitStr(self.Data.Cfg.Award, ';')
    if self.ItemList ~= nil then
    	for i=1, #self.ItemList do
    		self.ItemList[i].gameObject:SetActive(false)
    	end
    end
    for i=1, #_strs do
        local _item = nil--UIItem
        local _values = Utils.SplitStr(_strs[i], '_')
        -- Debug.LogTable(_values, "_strs")
        local _id = tonumber(_values[1]) and tonumber(_values[1]) or -1
        local _num = tonumber(_values[2]) and tonumber(_values[2]) or -1

        if #_values >= 2 then
            if #self.ItemList < i  then
                if i == 1 then
                    _item = self.Item
                else
                    local go = UnityUtils.Clone(self.Item.gameObject)
                    if go ~= nil then
                        go.transform.localScale = go.transform.localScale * 0.8
                        _item = UIUtils.RequireUIItem(go.transform)
                    end
                end
                table.insert(self.ItemList, _item)
            else
                _item = self.ItemList[i]
            end
            if _item ~= nil then
                _item.gameObject:SetActive(true)
                _item:InitializationWithIdAndNum(_id, _num, true, false)
            end
        end
    end
    self:SetRewardState()
    if self.Grid then
        self.Grid.repositionNow = true
    end
end

function CompentItem:SetRewardState()
    if self.Data.IsAward then
        --领取了
        self.Reward.gameObject:SetActive(false)
        self.Flag1.gameObject:SetActive(true)
        self.Flag2.gameObject:SetActive(false)
        self.RedPoint.gameObject:SetActive(false)
    else
        local _lv = 0
        -- for i=1, 20 do
            -- local _t1 = os.clock()
            _lv = GameCenter.GameSceneSystem:GetLocalPlayerLevel()
            -- local _t2 = os.clock()
            -- Debug.LogError("GameCenter.GameSceneSystem:GetLocalPlayerLevel =", (_t2-_t1)*1000, "/ms")
        -- end
        -- local _lv = GameCenter.GameSceneSystem:GetLocalPlayerLevel()
        if _lv >= self.Data.Cfg.Level then
            self.Reward.gameObject:SetActive(GameCenter.GrowthPlanSystem.IsBuy)
            self.RedPoint.gameObject:SetActive(GameCenter.GrowthPlanSystem.IsBuy)
            self.Flag1.gameObject:SetActive(false)
            self.Flag2.gameObject:SetActive(false)
        else
            --没有达到要求
            self.Flag2.gameObject:SetActive(GameCenter.GrowthPlanSystem.IsBuy)
            self.Flag1.gameObject:SetActive(false)
            self.Reward.gameObject:SetActive(false)
            self.RedPoint.gameObject:SetActive(false)
        end
    end
    if self.Reward then
        self.Reward.onClick:Clear()
        self.Reward.onClick:Add(CS.EventDelegate(function ()
            GameCenter.GrowthPlanSystem:ReqReceiveGrowthFind(self.Data.Cfg.Level)
        end))
    end
end
return CompentItem
