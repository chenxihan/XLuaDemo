------------------------------------------------
--作者： _SqL_
--日期： 2019-04-30
--文件： UIPermissionRoot.lua
--模块： UIPermissionRoot
--描述： 境界 权限
------------------------------------------------

local UIPermissionRoot = {
    Owner = nil,
    Trans = nil,
    DetailsBtn = nil,                           -- 查看详细权限按钮
    ListPanel = nil,                            -- 权限item 父对象
    PermissionImte = nil,                       -- 权限item
    CurrRealm = nil,                            -- 当前境界
    NextRealm = nil,                            -- 下个境界
    Arrow = nil,                                -- 箭头显示
}

function  UIPermissionRoot:New(owner, trans)
    self.Owner = owner
    self.Trans = trans
    self:FindAllComponents()
    self:OnRegUICallBack()
    return self
end

function UIPermissionRoot:FindAllComponents()
    self.Arrow = UIUtils.FindTrans(self.Trans, "Title/Arrow")
    self.CurrRealm = UIUtils.FindLabel(self.Trans, "Title/CurrRealm")
    self.NextRealm = UIUtils.FindLabel(self.Trans, "Title/NextRealm")
    self.DetailsBtn = UIUtils.FindBtn(self.Trans, "Title/DetailsBtn")
    self.ListPanel = UIUtils.FindTrans(self.Trans, "ListPanel")
    self.PermissionImte = UIUtils.FindTrans(self.ListPanel, "Item")
end

function UIPermissionRoot:OnRegUICallBack()
    UIUtils.AddBtnEvent(self.DetailsBtn, self.OnDetailsBtnClick, self)
end

-- 详细按钮事件
function UIPermissionRoot:OnDetailsBtnClick()
    
end

-- 刷新数据
function UIPermissionRoot:RefreshData()
    local _id = 0
    local _sys = GameCenter.RealmSystem
    if _sys.RealmLv > 0 and _sys.RealmLv < _sys.TopLevel then
        self.Arrow.gameObject:SetActive(true)
        self.CurrRealm.gameObject:SetActive(true)
        UnityUtils.SetLocalPosition(self.NextRealm.transform, 136, 0, 0)
        local _cfg = DataConfig.DataStatePower[_sys.RealmLv]
        if _cfg then
            self.CurrRealm.text = _cfg.Name
        else
            Debug.LogError("DataStatePower not contains key = ", _sys.RealmLv)
        end
        -- 显示正在突破的境界权限
        _id = _sys.RealmLv + 1
    else
        self.Arrow.gameObject:SetActive(false)
        self.CurrRealm.gameObject:SetActive(false)
        UnityUtils.SetLocalPosition(self.NextRealm.transform, 40, 0, 0)
        if _sys.RealmLv == 0 then
            _id = _sys.RealmLv + 1
        else
            _id = _sys.RealmLv
        end
    end
    local _cfg = DataConfig.DataStatePower[_id]
    if not _cfg then
        Debug.LogError("DataStatePower not contains key = ", _id)
        return
    end
    self.NextRealm.text = _cfg.Name
    self:RefreshPermissionInfo(_cfg.PowerList)
end

-- 刷新权限信息
function UIPermissionRoot:RefreshPermissionInfo(ids)
    for i = 0, self.ListPanel.childCount - 1 do
        self.ListPanel:GetChild(i).gameObject:SetActive(false)
    end

    local _index = 0
    local _ids = Utils.SplitStr(ids, "_")
    for i = 1, #_ids do
        if _index < self.ListPanel.childCount then
            self:SetPermission(self.ListPanel:GetChild(_index), tonumber(_ids[i]))
        else
            local _go = UnityUtils.Clone(self.PermissionImte.gameObject, self.ListPanel)
            self:SetPermission(_go.transform, tonumber(_ids[i]))
        end
        _index = _index + 1
    end
    UnityUtils.GridResetPosition(self.ListPanel)
    UnityUtils.ScrollResetPosition(self.ListPanel)
end

function UIPermissionRoot:SetPermission(trans, id)
    trans.gameObject:SetActive(true)
    local _cfg = DataConfig.DataStateSeniority[id]
    if not _cfg then
        Debug.LogError("DataStateSeniority not contains key = ",id)
    end
    UIUtils.FindLabel(trans, "Show").text = _cfg.Des
end

function UIPermissionRoot:OnOpen()
    self.Trans.gameObject:SetActive(true)
    self:RefreshData()
end

function UIPermissionRoot:OnClose()
    self.Trans.gameObject:SetActive(false)
end

return UIPermissionRoot