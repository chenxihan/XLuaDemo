------------------------------------------------
--作者： 何健
--日期： 2019-04-15
--文件： UIListMenuIcon.lua
--模块： UIListMenuIcon
--描述： 列表菜单中单个子项
------------------------------------------------
local UIListMenuIcon = {
    RootGo = nil,
    NormalName = nil,
    SelectName = nil,
    RedPoint = nil,
    SelectGo = nil,
    NormalSpr = nil,
    SelectSpr = nil,
    SelectSpr2 = nil,
    Btn = nil,
    Data = nil,
    Parent = nil,
    Select = false,
}

-- 设置选中
function UIListMenuIcon:IsSelect(value)
    if self.Select ~= value or value == true then
        self.Select = value
        self.Parent:OnSelectChanged(self)
        self.NormalName.gameObject:SetActive(not self.Select)
        self.SelectName.gameObject:SetActive(self.Select)
        self.SelectGo:SetActive(self.Select)
        if self.SelectSpr2 ~= nil then
            self.SelectSpr2.gameObject:SetActive(self.Select)
        end
    end
end

--创建一个新的对象
function UIListMenuIcon:New(res, parent)
    local _M = Utils.DeepCopy(self)
    _M.Parent = parent
    _M.RootGo = res

    local toggle = _M.RootGo:GetComponent("UIToggle")
    if toggle ~= nil then
        GameObject.Destroy(toggle);
    end

    _M.NormalName = _M.RootGo.transform:Find("NormalName"):GetComponent("UILabel")
    _M.SelectName = _M.RootGo.transform:Find("SelectName"):GetComponent("UILabel")
    _M.RedPoint = _M.RootGo.transform:Find("RedPoint").gameObject
    _M.SelectGo = _M.RootGo.transform:Find("Select").gameObject
    _M.NormalSpr = _M.RootGo:GetComponent("UISprite")
    _M.SelectSpr = _M.RootGo.transform:Find("Select"):GetComponent("UISprite")
    local spr2Trans = _M.RootGo.transform:Find("Select2")
    if(spr2Trans ~= nil) then
        _M.SelectSpr2 = _M.RootGo.transform:Find("Select2"):GetComponent("UISprite")
    end

    _M.Btn = UIUtils.RequireUIButton(_M.RootGo.transform)
    _M.Btn.onClick:Clear()
    EventDelegate.Add(_M.Btn.onClick, Utils.Handler(_M.OnBtnClick, _M))

    _M.NormalName.gameObject:SetActive(not _M.Select)
    _M.SelectName.gameObject:SetActive(_M.Select)
    _M.SelectGo:SetActive(_M.Select)
    if(_M.SelectSpr2 ~= nil) then
        _M.SelectSpr2.gameObject:SetActive(_M.Select)
    end
    return  _M
end

--克隆一个对象
function UIListMenuIcon:Clone()
    local _trans = UnityUtils.Clone(self.RootGo).transform
    return UIListMenuIcon:New(_trans, self.Parent);
end

function UIListMenuIcon:OnBtnClick()
    --已经选中的情况下直接返回
    if self.Select then
        return
    end

    if self.Data.FuncInfo ~= nil then
        if not self.Data.FuncInfo.IsVisible then
            GameCenter.MainFunctionSystem:ShowNotOpenTips(self.Data.FuncInfo)
            return
        end
    end
    self.Parent:SetSelectById(self.Data.ID)
end

function UIListMenuIcon:SetInfo(data)
    self.Data = data
    self.SelectName.text = data.Text
    self.NormalName.text = data.Text
    if self.Data.FuncInfo == nil then
        self.RedPoint:SetActive(data.ShowRedPoint)
    end
    if data.NormalSpr ~= nil then
        self.NormalSpr.spriteName = data.NormalSpr
    end
    if data.SelectSpr ~= nil then
        self.SelectSpr.spriteName = data.SelectSpr
    end
    if data.SelectSpr2 ~= nil and self.SelectSpr2 ~= nil then
        self.SelectSpr2.spriteName = data.SelectSpr2
    end
end

return UIListMenuIcon