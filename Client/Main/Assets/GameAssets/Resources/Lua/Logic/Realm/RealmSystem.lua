
------------------------------------------------
--作者： _SqL_
--日期： 2019-05-16
--文件： RealmSystem.lua
--模块： RealmSystem
--描述： 境界系统
------------------------------------------------
local RealmGiftData = require "Logic.Realm.RealmGiftData"
local RealmTaskData = require "Logic.Realm.RealmTaskData"

local RealmSystem = {
    Progress = 0,                                   -- 境界进度
    TargetValue = 0,                                -- 境界目标值
    CurrRealmId = nil,                              -- 当前境界的id
    NextRealmId = nil,                              -- 下个境界的id
    RealmTaskList = List:New(),                     -- 当前境界对应的任务列表
    RealmLv = nil,                                  -- 境界等级
    TopLevel = 0,                                   -- 满级
    OpenForm = false,                               -- 是否发打开开界面
    ShowPackage = false,                            -- 显示礼包
    PackageList = List:New(),                       -- 境界礼包列表
    CurrGiftId = nil,                               -- 当前显示礼包的id
    CurrGiftCD = nil,                               -- 当前礼包剩余的显示时间
    TimerAction = nil,                              -- 计时器委托
    CDTime = 0,                                     -- 倒计时时间
    CacheGameTime = 0,                              -- 开始倒计时 缓存的游戏时间
    IntervalTime = 0,                               -- 间隔时间 间隔时间段 玩家没有打开或关闭界面 视为玩家未在看着游戏
    PlayerBehabivior = nil,                         -- 检测玩家是否有操作(打开和关闭界面)
    PlayerBehabiviorTime = 0,                       -- 玩家打开或者关闭界面的时候记录 游戏时间
    GiftBtnID = 0,                                  -- 礼包按钮的id
    GiftBtnInfo = nil,                          
}

function RealmSystem:Initialize()
    for k, v in pairs(DataConfig.DataStatePower) do
        if v.Id > self.TopLevel then
            self.TopLevel = v.Id
        end
    end
    self.ShowPackage = false
    self:SetIntervalTime()
end

function RealmSystem:UnInitialize()
    local _cfg = DataConfig.DataStatePackage[self.CurrGiftId]
    if _cfg and self.GiftBtnInfo then
        local _cd = math.Round(self.GiftBtnInfo.RemainTime) + _cfg.CdTime * 60
        if self.CurrGiftId == 0 then
            _cd = 0
        end
        Debug.LogError("Quit Game",self.CurrGiftId, _cd)
        self:ReqRealmGift(self.CurrGiftId, _cd)
    end
    self.RealmTaskList:Clear()
    self.PackageList:Clear()
end

function RealmSystem:Update(deltaTime)
    if self.PlayerBehabivior then
        self.IntervalTime = self.IntervalTime - (Time.GetRealtimeSinceStartup() - self.PlayerBehabiviorTime)
        if self.IntervalTime <= 0 then
            self.PlayerBehabivior = false
        end
    end
    if self.TimerAction then
        self.CDTime = self.Time - (Time.GetRealtimeSinceStartup() - self.CacheGameTime)
        if self.CDTime <= 0 then
            self.TimerAction()
            self.CacheGameTime = 0
            self.TimerAction = nil
        end
    end
    if self.ShowPackage and self.PlayerBehabivior then
        self:ShowRealmPackage(self.CurrGiftId, self.CurrGiftCD)
    end
end

-- 设置当前已突破的最高境界  
function RealmSystem:SetCurrRealmId(group)
    -- 未突破第一层境界
    if group == 1 then
        self.RealmLv = 0
        return
    end
    local _group = 0
    for k, v in pairs(DataConfig.DataState)  do
        if v.Group < group then
            if v.Group > _group then
                _group = v.Group
                self.RealmLv = v.Group
                self.CurrRealmId = k
            end
        end
    end
end

-- 境界等级
function RealmSystem:GetRealmLv()
    return self.RealmLv
end

-- 境界最高等级
function RealmSystem:GetRealmTopLv()
    return self.TopLevel
end

-- 获取境界任务的进度
function RealmSystem:GetRealmProgress()
    return self.Progress
end

-- 获取境界任务的目标值
function RealmSystem:GetRealmTargetValue()
    return self.TargetValue
end

-- 获取礼包主界面按钮的id
function RealmSystem:GetGiftBtnId()
    return self.GiftBtnID
end

-- 获取当前显示的礼包id
function RealmSystem:GetCurrGiftId()
    return self.CurrGiftId
end

-- 是否能能突破境界
function RealmSystem:IsUpgradeRealm()
    for i = 1, self.RealmTaskList:Count() do
        if not self.RealmTaskList[i].Status then
            return false
        end
    end
    return true
end

-- 境界任务列表排序
function RealmSystem:Sort()
    table.sort(self.RealmTaskList, function(a, b)
        if a.Sort and b.Sort then
            return a.Sort < b.Sort
        end
    end)
end

-- 显示境界礼包
function RealmSystem:ShowRealmPackage(id , cd)
    if not self.ShowPackage then
        return
    end

    local _cfg = DataConfig.DataStatePackage[id]
    if not _cfg then
        -- Debug.LogError("DataStatePackage not contains key = ", id)
        return
    end
    if self.GiftBtnID ~= 0 then
        GameCenter.MainCustomBtnSystem:RemoveBtn(self.GiftBtnID)
    end
    self.GiftBtnID = GameCenter.MainCustomBtnSystem:AddBtn(_cfg.Icon, _cfg.Name, cd, nil, function(data)
        GameCenter.PushFixEvent(UIEventDefine.UIGiftPackageForm_OPEN, data)
    end, false, false)
    self:SetBtnInfo()
    self.ShowPackage = false
end

-- 获取礼包的排序 序号
function RealmSystem:GetGiftSort(id)
    for i = 1, self.PackageList:Count() do
        if id == self.PackageList[i].ID then
            return self.PackageList[i].Sort
        end
    end
end

-- 获取显示的礼包id
function RealmSystem:GetRealmGift(id)
    if (not self.ShowPackage) or self.PackageList:Count() == 0 then
        self.CurrGiftId = 0
        self.CurrGiftCD = 0
        return
    end
    if self.PackageList:Contains(id) then
        for i = 1, self.PackageList:Count() do
            if self.PackageList[i].Sort > self:GetGiftSort(id) then
                return self.PackageList[i].ID, self.PackageList[i].ShowTime
            end
        end
        return self.PackageList[1].ID, self.PackageList[1].ShowTime
    else
        return self.PackageList[1].ID, self.PackageList[1].ShowTime
    end
end

-- 检测礼包cd是否走完
function RealmSystem:CheckGiftCDTime(id, cd)
    for i = 1, self.PackageList:Count() do
        if self.PackageList[i].ID == id then
            if self.PackageList[i].CdTime < cd then
                return cd - self.PackageList[i].CdTime
            else
                return false
            end
        end
    end
    return false
end

-- 设置间隔时间
function RealmSystem:SetIntervalTime()
    local _cfg = DataConfig.DataGlobal[1510]
    if _cfg then
        self.IntervalTime = tonumber(_cfg.Params) * 60
    end
end

-- 设置玩家行为状态
function RealmSystem:SetPlayerBehavior()
    if not self.PlayerBehabivior then
        self.PlayerBehabivior = true
        self.PlayerBehabiviorTime = Time.GetRealtimeSinceStartup()
        self:SetIntervalTime()
    end
end

-- 设置倒计时
function RealmSystem:SetCountDown(cd)
    local function _CallBack()
        self.ShowPackage = true
        -- self.CurrGiftId, self.CurrGiftCD = self:GetRealmGift(msg.id)
    end
    self.Time = cd
    self.CacheGameTime = Time.GetRealtimeSinceStartup()
    self.TimerAction = _CallBack
end

-- 设置礼包 Cd
function RealmSystem:SetGiftCDTime(id)
    local _cfg = DataConfig.DataStatePackage[id]
    if _cfg then
        self:SetCountDown(_cfg.CdTime)
        if _cfg.Nature == 1 then
            self:ReqDelRealmGift(id)
        end
    else
        Debug.LogError("DataStatePackage not contains key = ", id)
    end
end

function RealmSystem:SetBtnInfo()
    do
    return;
    end
    local _list = GameCenter.MainCustomBtnSystem.BtnList
    for i = 0, _list:Count() do
        if _list[i].ID == self.GiftBtnID then
            self.GiftBtnInfo = _list[i]
        end
    end
    Debug.LogError("SetBtnInfo error")
end

-- MSG
-- 请求境界任务
function RealmSystem:ReqRealmTask()
    -- 到达满级不需要再请求境界任务
    if self.RealmLv == self.TopLevel then
        GameCenter.PushFixEvent(UIEventDefine.UIRealmForm_OPEN)
        return
    end
    self.OpenForm = true
    GameCenter.Network.Send("MSG_StateVip.ReqStateVip",{})
end

-- 请求境界任务奖励
function RealmSystem:ReqGetRealmTaskReward(id)
    local _req = {}
    _req.id = id
    GameCenter.Network.Send("MSG_StateVip.ReqGetReward", _req)
end

-- 请求突破境界
function RealmSystem:ReqUpgradeRealm()
    GameCenter.Network.Send("MSG_StateVip.ReqStateVipUp", {})
end

-- 设置当前礼包 (下线发送)
function RealmSystem:ReqRealmGift(id, cd)
    local _req = {}
    _req.id = id
    _req.cd = cd
    GameCenter.Network.Send("MSG_StateVip.ReqStateVipGift", _req)
end

-- 删除礼包
function RealmSystem:ReqDelRealmGift(id)
    local _req = {}
    _req.id = id
    GameCenter.Network.Send("MSG_StateVip.ReqDelStateVipGift", _req)
end

-- 境界任务奖励返回
function RealmSystem:GS2U_ResGetRealmTaskReward(msg)
    if msg.id then
        for i = 1, self.RealmTaskList:Count() do
            if self.RealmTaskList[i].ID == msg.id then
                local _t = {
                    id = msg.id,
                    status = true,
                    progress = self.RealmTaskList[i].TargetValue,
                }
                self.RealmTaskList[i]:RefreshData(_t)
                self:Sort()
                break
            end
        end
        
        local _upgrade = self:IsUpgradeRealm()
        if _upgrade then
            GameCenter.PushFixEvent(UIEventDefine.UIRealmForm_OPEN, _upgrade)
        else
            GameCenter.PushFixEvent(LogicEventDefine.EID_EVENT_REFRESH_REALM_TASKLIST)
        end
    end
end

-- 境界任务返回   服务器返回空list(升到最大级)
function RealmSystem:GS2U_ResRealmTask(msg)
    if not msg.stateVips then
        Debug.LogError("MSG_StateVip.ResStateVip msg.stateVips = nil")
        return
    end
    if #msg.stateVips > 0 then
        local _num = 0
        self.RealmTaskList:Clear()
        for i = 1, #msg.stateVips do
            self.RealmTaskList:Add(RealmTaskData:New(msg.stateVips[i]))
            if msg.stateVips[i].status then
                _num = _num + 1
            end
        end
        self.Progress = _num
        self.TargetValue = self.RealmTaskList:Count()
        local _cfg = DataConfig.DataState[self.RealmTaskList[1].ID]
        if _cfg then
            self.NextRealmId =  _cfg.Id
            self:SetCurrRealmId(_cfg.Group)
        else
            Debug.LogError("DataState not contains key = ", self.RealmTaskList[1].ID)
        end
        self:Sort()
    elseif #msg.stateVips == 0 then
        self.RealmLv = self.TopLevel
    end
    if self.OpenForm then
        GameCenter.PushFixEvent(UIEventDefine.UIRealmForm_OPEN, self:IsUpgradeRealm())
        self.OpenForm = false
    end
end

-- 上线发送当前礼包
function RealmSystem:GS2U_ResRealmGift(msg)
    -- 没有显示任何礼包
    if msg.id == 0 then
        self.ShowPackage = true
        self.CurrGiftId, self.CurrGiftCD = self:GetRealmGift(msg.id)
    else
        if msg.cd <= 0 then
            self.ShowPackage = true
            self.CurrGiftId, self.CurrGiftCD = self:GetRealmGift(msg.id)
        else
            self.CurrGiftId = msg.id
            local _cd = self:CheckGiftCDTime(msg.id, msg.cd)
            if _cd then
                self.CurrGiftCD = _cd
                self.ShowPackage = true
            else
                self.ShowPackage = false
                self:SetCountDown(msg.cd)
            end
        end
    end
end

-- 境界礼包列表返回
function RealmSystem:GS2U_ResRealmGiftList(msg)
    if not msg.list then
        Debug.LogError("MSG_StateVip.ResStateVipGiftList msg.list = nil")
        return
    end
    for i = 1, #msg.list do
        self.PackageList:Add(RealmGiftData:New(msg.list[i]))
    end
    if self.PackageList:Count() > 1 then
        table.sort(self.PackageList, function(a, b)
            return a.Sort < b.Sort
        end)
    end
end

-- 境界升级广播
function RealmSystem:GS2U_RealmLevelUp(msg)
    Debug.LogError("GS2U_RealmLevelUp")
end

-- 境界红点
function RealmSystem:GS2U_RealmShowRedPoint(msg)
    
end

return RealmSystem