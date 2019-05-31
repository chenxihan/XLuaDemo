------------------------------------------------
--作者： _SqL_
--日期： 2019-04-30
--文件： UIRealmUpgradeRoot.lua
--模块： UIRealmUpgradeRoot
--描述： 境界 升级
------------------------------------------------

local UIRealmUpgradeRoot = {
    Owner = nil,
    Trans = nil,
    ListPanel = nil,                    -- 任务Item 父对象
    TaskItem = nil,                     -- 任务Item
    UpgradeBtn = nil,                   -- 突破按钮
    TopLevelNotice = nil,               -- 满级提示
    CurrRealm = nil,                    -- 当前境界
    NextRealm = nil,                    -- 下一境界
    Arrow = nil,
}

function  UIRealmUpgradeRoot:New(owner, trans)
    self.Owner = owner
    self.Trans = trans
    self:FindAllComponents()
    self:OnRegUICallBack()
    return self
end

function UIRealmUpgradeRoot:FindAllComponents()
    self.ListPanel = UIUtils.FindTrans(self.Trans, "Up/Property")
    self.TaskItem = UIUtils.FindTrans(self.Trans, "Up/Property/Item")
    self.UpgradeBtn = UIUtils.FindBtn(self.Trans, "Up/UpGradeBtn")
    self.Arrow = UIUtils.FindTrans(self.Trans, "Up/Title/Arrow")
    self.CurrRealm = UIUtils.FindLabel(self.Trans, "Up/Title/CurrRealm")
    self.NextRealm = UIUtils.FindLabel(self.Trans, "Up/Title/NextRealm")
    self.TopLevelNotice = UIUtils.FindTrans(self.Trans, "TopLvNotice")
end

-- 刷新数据
function UIRealmUpgradeRoot:RefreshData()
    local _id = 0
    local _topLv = false
    local _zeroLv = false
    local _sys = GameCenter.RealmSystem
    if _sys.RealmLv > 0 and _sys.RealmLv < _sys.TopLevel then
        _id = _sys.RealmLv + 1
        self:SetObjActive(false, false)
        self.CurrRealm.text = self:GetRealmName(_sys.RealmLv)
        self.NextRealm.text = self:GetRealmName(_sys.RealmLv + 1)
    elseif _sys.RealmLv == 0 then
        _zeroLv = true
        _id = _sys.RealmLv + 1
        self:SetObjActive(true, false)
        self.NextRealm.text = self:GetRealmName(_sys.RealmLv + 1)
    elseif _sys.RealmLv == _sys.TopLevel then
        _topLv = true
        _id = _sys.RealmLv
        self:SetObjActive(false, true)
        self.CurrRealm.text = self:GetRealmName(_sys.RealmLv)
    end
    local _cfg = DataConfig.DataStatePower[_id]
    self:RefreshProperty(_cfg.Value, _zeroLv, _topLv)
end

-- 获取境界的名字 根据state表的group statepower表的id
function UIRealmUpgradeRoot:GetRealmName(id)
    local _cfg = DataConfig.DataStatePower[id]
    if _cfg then
        return _cfg.Name
    else
        Debug.LogError("DataStatePower not contains key = ", id)
        return ""
    end
end

-- 设置acitve
function UIRealmUpgradeRoot:SetObjActive(zeroLv, toplv)
    self.NextRealm.gameObject:SetActive(not zeroLv)
    self.UpgradeBtn.gameObject:SetActive(not toplv)
    self.TopLevelNotice.gameObject:SetActive(toplv)
    self.CurrRealm.gameObject:SetActive(zeroLv or (not toplv))
    self.Arrow.gameObject:SetActive((not zeroLv) and (not toplv))
end

-- 刷新属性信息
function UIRealmUpgradeRoot:RefreshProperty(strs, zeroLv, toplv)
    for i = 0, self.ListPanel.childCount - 1 do
        self.ListPanel:GetChild(i).gameObject:SetActive(false)
    end

    local _index = 0
    local _p = Utils.SplitStr(strs, ";")
    for i = 1, #_p do
        local _s = Utils.SplitStr(_p[i], "_")
        local _cfg = DataConfig.DataAttributeAdd[tonumber(_s[1])]
        if not _cfg then
            Debug.LogError("DataAttributeAdd not contains key = ", _s[1])
            return
        end
        if _index < self.ListPanel.childCount then
            self:PropertyTool(self.ListPanel:GetChild(_index), zeroLv, toplv, _cfg.Name, _s[2], i)
        else
            local _go = UnityUtils.Clone(self.TaskItem.gameObject, self.ListPanel)
            self:PropertyTool(_go.transform, zeroLv, toplv, _cfg.Name, _s[2], i)
        end
        _index = _index + 1
    end
end

function UIRealmUpgradeRoot:PropertyTool(trans, zeroLv, toplv, name, value, index)
    if zeroLv then
        self:SetProperty(trans, name, "0", value)
    elseif toplv then
        self:SetProperty(trans, name, value, "Top Level")
    else
        local _c = DataConfig.DataStatePower[GameCenter.RealmSystem.RealmLv]
        if not _c then
            Debug.LogError("DataStatePower not contains key = ", GameCenter.RealmSystem.RealmLv)
        end
        local _v = Utils.SplitStr(_c.Value,";")[index]
        local _currValue = "0"
        if _v then
            _currValue = Utils.SplitStr(_v, "_")[2]
        end
        self:SetProperty(trans, name, _currValue, value)
    end
end

-- 设置属性
function UIRealmUpgradeRoot:SetProperty(trans, name, currValue, nextValue)
    trans.gameObject:SetActive(true)
    UIUtils.FindLabel(trans, "Name").text = name
    UIUtils.FindLabel(trans, "CurrValue").text = currValue
    UIUtils.FindLabel(trans, "NextValue").text = nextValue
end

function UIRealmUpgradeRoot:OnRegUICallBack()
    UIUtils.AddBtnEvent(self.UpgradeBtn, self.OnUpgradeBtnClick, self)
end

-- 突破按钮Callback
function UIRealmUpgradeRoot:OnUpgradeBtnClick()
    GameCenter.RealmSystem:ReqUpgradeRealm()
end

function UIRealmUpgradeRoot:OnOpen()
    self.Trans.gameObject:SetActive(true)
    self:RefreshData()
end

function UIRealmUpgradeRoot:OnClose()
    self.Trans.gameObject:SetActive(false)
end

return UIRealmUpgradeRoot