------------------------------------------------
--作者： _SqL_
--日期： 2019-04-23
--文件： UITaskItem.lua
--模块： UITaskItem
--描述： 条件Item
------------------------------------------------

local UITaskItem = {
    -- 天书任务 ID
    ID = 0,
    Owner = nil,
    Trans = nil,
    -- 任务名字
    Name = nil,
    -- 任务进度显示
    Progress = nil,
    -- 前往按钮
    GoToBtn = nil,
    -- 获取奖励按钮
    GetBtn = nil,
    -- 任务完成显示
    FinishedTrans = nil,
    -- 属性显示Parent
    AttributesTrans  =nil,
}

function UITaskItem:New(owner, trans,id)
    local _m = Utils.DeepCopy(self)
    _m.Owner = self.owner
    _m.Trans = trans
    _m.ID = id
    _m:FindAllComponents()
    _m:RegUICallback()
    _m:Show()
    return _m
end

function UITaskItem:FindAllComponents()
    self.Name = UIUtils.FindLabel(self.Trans, "Name")
    self.Progress = UIUtils.FindLabel(self.Trans, "Progress")
    self.GoToBtn = UIUtils.FindBtn(self.Trans, "GoToBtn")
    self.GetBtn = UIUtils.FindBtn(self.Trans, "GetBtn")
    self.FinishedTrans = UIUtils.FindTrans(self.Trans, "Finish")
    self.AttributesTrans = UIUtils.FindTrans(self.Trans, "Attributes")

    -- 功能还未确定
    self.GoToBtn.gameObject:SetActive(false)
end

function UITaskItem:RegUICallback()
    UIUtils.AddBtnEvent(self.GetBtn, self.OnGetBtnClick, self)
    UIUtils.AddBtnEvent(self.GoToBtn, self.OnGoToBtnClick, self)
end

function UITaskItem:UpdateData(info)
    local _cfg = DataConfig.DataAmuletCondition[self.ID]
    local _finshsed = false
    if info.Status == AmuletTaskStatusEnum.Available then
        self.FinishedTrans.gameObject:SetActive(false)
        self.GetBtn.gameObject:SetActive(true)
    elseif info.Status == AmuletTaskStatusEnum.RECEIVED then
        self.FinishedTrans.gameObject:SetActive(true)
        self.GetBtn.gameObject:SetActive(false)
        _finshsed = true
    elseif info.Status == AmuletTaskStatusEnum.UnFinished then
        self.FinishedTrans.gameObject:SetActive(false)
        self.GetBtn.gameObject:SetActive(false)
    end

    if _finshsed then
        self.Progress.text = tostring(info.TargetValue)
    else
        self.Progress.text = string.format( "%d/%d", info.Progress, info.TargetValue)
    end
    self.Name.text = self:GetDesc(_cfg)
    self:SetAttibutes(_cfg.Property)
end

function UITaskItem:GetDesc(cfg)
    local _str = {}
    table.insert(_str, cfg.Des)
    if cfg.Type == AmuletConditionEnum.KillMonster then
        local _ids = Utils.SplitStr(cfg.Show,";")
        for i = 1, #_ids do
            local _data = DataConfig.DataMonster[tonumber(Utils.SplitStr(_ids[i], "_")[#_ids])]
            if _data ~= nil then
                if i == 1 then
                    table.insert(_str, "(")
                end
                table.insert(_str, _data.Name)
                if i == #_ids then
                    table.insert(_str, ")")
                else
                    table.insert(_str, ",")
                end
            end
        end
    end
    return table.concat( _str )
end



function UITaskItem:SetAttibutes(str)
    local _attr = Utils.SplitStr(str,";")
    for i = 1, 2 do
        local _strs = Utils.SplitStr(_attr[i],"_")
        local _attrName = DataConfig.DataAttributeAdd[tonumber(_strs[1])].Name
        self.AttributesTrans:GetChild(i - 1):GetComponent("UILabel").text = string.format( "%s  %s",_attrName, _strs[2])
    end
end

function UITaskItem:OnGoToBtnClick()

end

function UITaskItem:OnGetBtnClick()
    if self.ID ~= 0 then
        GameCenter.GodBookSystem:ReqGetReward(self.ID)
    end
end

function UITaskItem:Clone(owner, go, parentTrans, id)
    local obj = UnityUtils.Clone(go, parentTrans).transform
    return self:New(owner, obj, id)
end

function UITaskItem:Show()
    if not self.Trans.gameObject.activeSelf then
        self.Trans.gameObject:SetActive(true)
    end
end

function UITaskItem:Close()
    self.Trans.gameObject:SetActive(false)
end

return UITaskItem