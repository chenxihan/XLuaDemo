------------------------------------------------
--作者： dhq
--日期： 2019-05-16
--文件： UIMarryRewardItem.lua
--模块： UIMarryRewardItem
--描述： 结婚奖励Item类
------------------------------------------------

--排名item
local UIMarryRewardItem = {
    --root
    RootGo = nil,
    Trans = nil,
    -- 亲密度
    IntimateLabel = nil,
    -- 结婚时间
    TimeLabel = nil,
    --Item列表
    ItemList = nil,
    --领取按钮
    ReceiveBtn = nil,
    --领取按钮的文字
    ReceiveBtnLabel = nil,
}

function UIMarryRewardItem:New(go)
    local _result = Utils.DeepCopy(self);
    _result.RootGo = go;
    _result.Trans = go.transform;
    _result:OnFirstShow();
    return _result
end

function UIMarryRewardItem:OnFirstShow()
    self.ItemList = List:New();
    self.IntimateLabel = UIUtils.FindLabel(self.Trans, "Intimate/Label");
    self.TimeLabel = UIUtils.FindLabel(self.Trans, "Time/Label");
    for _id = 1, 4 do
        local _item = UIUtils.FindTrans(self.Trans, tostring(_id));
        local _uiItem = UIUtils.RequireUIItem(_item)
        _uiItem.transform.gameObject:SetActive(false)
        self.ItemList:Add(_uiItem)
    end
    self.ReceiveBtn = UIUtils.FindBtn(self.Trans, "ReceiveBtn");
    self.ReceiveBtnLabel = UIUtils.FindLabel(self.Trans, "ReceiveBtn/Label");
    UIUtils.AddBtnEvent(self.ReceiveBtn, self.OnReceiveBtnClick, self)
end

--刷新
function UIMarryRewardItem:Refresh(info)
    self.Info = info;
    if self.Info ~= nil then
        -- 亲密度 500/2000
        self.IntimateLabel.text = string.format("%s/%s",self.Info.Intimate, self.Info.IntimateAll)
        -- 结婚时间 5/10
        self.TimeLabel.text = string.format("%s/%s",self.Info.DaysCur, self.Info.DaysAll)

        local _itemArr = Utils.SplitStr(self.Info.Award, ';')
        for i = 1, #_itemArr do
            if #self.ItemList >= i then
                local _strs = Utils.SplitStr(self.Info.Award, '_')
                if #_strs >= 2 then
                    local _id = tonumber(_strs[1]) and tonumber(_strs[1]) or -1
                    local _num = tonumber(_strs[2]) and tonumber(_strs[2]) or -1
                    --local _bind = tonumber(_strs[3]) and tonumber(_strs[3]) or -1
                    --self.ItemList[i]:InitializationWithIdAndNum(_id, _num, _bind == 1, false)
                    self.ItemList[i]:InitializationWithIdAndNum(_id, _num, false, false)
                    self.ItemList[i].transform.gameObject:SetActive(true)
                end
            end
        end

        if self.Info.Status == GameCenter.MarrySystem.IntimacyState.Receiving then
            self.ReceiveBtnLabel.text = "领取"
        elseif self.Info.Status == GameCenter.MarrySystem.IntimacyState.Received then
            self.ReceiveBtnLabel.text = "已领取"
        else
            self.ReceiveBtnLabel.text = "未达成"
        end
    end
end

-- 领取按钮的响应
function UIMarryRewardItem:OnReceiveBtnClick()

end

return UIMarryRewardItem