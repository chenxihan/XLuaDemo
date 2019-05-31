------------------------------------------------
--作者： _SqL_
--日期： 2019-04-30
--文件： UIRealmTaskRoot.lua
--模块： UIRealmTaskRoot
--描述： 境界 任务
------------------------------------------------
local ItemModel = CS.Funcell.Code.Logic.ItemModel

local UIRealmTaskRoot = {
    Owner = nil,
    Trans = nil,
    ListPanel = nil,                    -- 任务Item 父对象
    TaskItem = nil,                     -- 任务Item
}

function  UIRealmTaskRoot:New(owner, trans)
    self.Owner = owner
    self.Trans = trans
    self:FindAllComponents()
    return self
end

function UIRealmTaskRoot:FindAllComponents()
    self.ListPanel = UIUtils.FindTrans(self.Trans, "ListPanel")
    self.TaskItem = UIUtils.FindTrans(self.Trans, "ListPanel/Item")
end

-- 刷新任务列表
function UIRealmTaskRoot:RefreshTaskList()
    local _index = 0
    local _list = GameCenter.RealmSystem.RealmTaskList
    for i = 0, self.ListPanel.childCount - 1 do
        self.ListPanel:GetChild(i).gameObject:SetActive(false)
    end
    for i = 1, _list:Count() do
        if _index < self.ListPanel.childCount then
            self:SetTaskItem(self.ListPanel:GetChild(_index),_list[i])
        else
            local _go = UnityUtils.Clone(self.TaskItem.gameObject,self.ListPanel)
            UnityUtils.ResetTransform(_go.transform)
            self:SetTaskItem(_go.transform, _list[i])
        end
        _index = _index + 1
    end
    UnityUtils.GridResetPosition(self.ListPanel)
    UnityUtils.ScrollResetPosition(self.ListPanel)
end

-- 设置任务info
function UIRealmTaskRoot:SetTaskItem(trans, info)
    trans.gameObject:SetActive(true)
    UIUtils.FindLabel(trans, "Desc").text = info.TaskName
    if info.Status then
        UIUtils.FindLabel(trans, "Progress").text = tostring(info.TargetValue)
    else
        UIUtils.FindLabel(trans, "Progress").text = string.format("%d/%d", info.Progress, info.TargetValue)
    end

    local _goToBtn = UIUtils.FindBtn(trans, "GoToBtn")
    local _getBtn = UIUtils.FindBtn(trans, "GetBtn")
    local _recive = UIUtils.FindTrans(trans, "Recive")
    if info.Status then
        _recive.gameObject:SetActive(true)
        _getBtn.gameObject:SetActive(false)
        _goToBtn.gameObject:SetActive(false)
    else
        if info.Progress >= info.TargetValue then
            _getBtn.gameObject:SetActive(true)
            _goToBtn.gameObject:SetActive(false)
        else
            _getBtn.gameObject:SetActive(false)
            _goToBtn.gameObject:SetActive(true)
        end
        _recive.gameObject:SetActive(false)
    end
    local _cfg = DataConfig.DataState[info.ID]
    local _itemId = 0
    if _cfg then
        _itemId = tonumber(Utils.SplitStr(_cfg.Reward,"_")[1])
        self:SetReward(UIUtils.FindTrans(trans, "Reward"), _cfg.Reward)
    else
        Debug.LogError("DataState not contains key = ", info.ID)
    end
    UIUtils.AddBtnEvent(_getBtn, self.OnGetBtnClick, self, {Id = info.ID})
    UIUtils.AddBtnEvent(_goToBtn, self.OnGoToBtnClick, self, {ItemId = _itemId})
end

-- 设置奖励物品
function UIRealmTaskRoot:SetReward(itemTrans, str)
    local _item = UIUtils.RequireUIItem(itemTrans)
    local _data = Utils.SplitStr(str, "_")
    _item:InitializationWithIdAndNum(ItemModel(tonumber(_data[1])), tonumber(_data[2]), false, false)
end

-- 领取按钮CallBack
function UIRealmTaskRoot:OnGetBtnClick(data)
    if data.Id then
        GameCenter.RealmSystem:ReqGetRealmTaskReward(data.Id)
    end
end

-- 前往按钮Callback
function UIRealmTaskRoot:OnGoToBtnClick(data)
    if data.ItemId then
        local _cfg = DataConfig.DataItem[data.ItemId]
        if not _cfg then
            Debug.LogError("DataItem not contains key = ",data.ItemId)
            return
        end
        if _cfg.UesUIId ~= 0 then
            GameCenter.MainFunctionSystem:DoFunctionCallBack(FunctionStartIdCode.__CastFrom(_cfg.UesUIId), nil)
        end
    end
end

function UIRealmTaskRoot:OnOpen()
    self.Trans.gameObject:SetActive(true)
    self:RefreshTaskList()
end

function UIRealmTaskRoot:OnClose()
    self.Trans.gameObject:SetActive(false)
end

return UIRealmTaskRoot