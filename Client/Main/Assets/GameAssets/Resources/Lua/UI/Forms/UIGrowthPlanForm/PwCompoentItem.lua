------------------------------------------------
--作者： xihan
--日期： 2019-04-28
--文件： PwCompoentItem.lua
--模块： PwCompoentItem
--描述： 全民福利组件
------------------------------------------------

local PwCompoentItem = {}
PwCompoentItem.__index = PwCompoentItem
--Transform trans,  int index
function PwCompoentItem.New(trans, index)
    local _M = {}
    if not trans then
        return
    end
    setmetatable(_M, PwCompoentItem)
    --int
    _M.Index = index
    --Transform
    _M.Trans = trans
    --Transform
    _M.Flag = trans:Find("Flag") --Transform
    --Transform
    _M.Flag_1 = trans:Find("Flag_1") --Transform
    --UIItem
    _M.Item = UIUtils.RequireUIItem(trans:Find("UIItem"))
    --UISlider
    _M.Slider = trans:Find("Process"):GetComponent("UISlider")
    --UILabel
    _M.NumLabel = trans:Find("Scale"):GetComponent("UILabel")
    if _M.Flag then
        _M.Flag.gameObject:SetActive(false)
    end
    if _M.Flag_1 then
        _M.Flag_1.gameObject:SetActive(false)
    end

    return _M
end
--PeopleWelfareData data
function PwCompoentItem:SetCompoentData(data)
    local _index = 1
    local _oldNum = 0
    --DeclareGrowthFundAll
    local _cfg = nil
    -- Debug.Log(self.Index)
    -- try
    -- DataGrowthFundAll = require('config/datagrowthfundall')
    for k, v in pairs(DataConfig.DataGrowthFundAll) do
        if self.Index == _index + 1 then
            _oldNum = v.Number
        end
        if self.Index == _index then
            _cfg = v
            break
        end
        _index = _index + 1
    end
    --设置道具显示
    if _cfg ~= nil and self.Item ~= nil then
        if self.Item ~= nil then
            local strs = Utils.SplitStr(_cfg.Award, '_')
            -- Debug.LogTable(strs)
            if #strs >= 3 then
                local id = tonumber(strs[1]) and tonumber(strs[1]) or -1
                local num = tonumber(strs[2]) and tonumber(strs[2]) or -1
                local bind = tonumber(strs[3]) and tonumber(strs[3]) or -1
                self.Item:InitializationWithIdAndNum(id, num, bind == 1, false)
            end
        end
        --设置进度条
        if self.Slider ~= nil then
            if GameCenter.GrowthPlanSystem.BuyNum - _oldNum <= 0 then
                -- Debug.Log("BuyNum = ", GameCenter.GrowthPlanSystem.BuyNum, "_oldNum = ", _oldNum, "=========>>", 0)
                self.Slider.value = 0
            else
                self.Slider.value = (GameCenter.GrowthPlanSystem.BuyNum - _oldNum) / (_cfg.Number - _oldNum)
                -- Debug.Log("BuyNum = ", GameCenter.GrowthPlanSystem.BuyNum, "_oldNum = ", _oldNum, "_cfg.Number = ", _cfg.Number, "=========>>", self.Slider.value)
            end
        end
        --设置flag
        if data ~= nil then
            if data.State == 1 then
                self.Flag.gameObject:SetActive(false)
                self.Flag_1.gameObject:SetActive(true)
            elseif data.State == 2 then
                self.Flag.gameObject:SetActive(true)
                self.Flag_1.gameObject:SetActive(false)
            else
                self.Flag.gameObject:SetActive(false)
                self.Flag_1.gameObject:SetActive(false)
            end
        end
        if self.NumLabel then
            self.NumLabel.text = tostring(_cfg.Number)
        end
    end
end
return  PwCompoentItem
