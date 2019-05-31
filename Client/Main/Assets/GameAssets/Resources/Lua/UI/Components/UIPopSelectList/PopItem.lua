------------------------------------------------
--作者： 何健
--日期： 2019-05-22
--文件： PopItem.lua
--模块： PopItem
--描述： POP下拉菜单的子菜单
------------------------------------------------

local PopItem = {
    Trans = nil,
    Go = nil,
    TextLabel = nil,
    ID = 0,
    CallBack = nil,
}

function PopItem:NewWithTrans(trans)
    local _M = Utils.DeepCopy(self)
    _M.Trans = trans
    _M.Go = trans.gameObject
    _M.TextLabel = UIUtils.FindLabel(trans, "PopItemLabel")
    local _btn = trans:GetComponent("UIButton")
    UIUtils.AddBtnEvent(_btn, _M.OnClickBtn, _M)
    return _M
end
function PopItem:NewWithGo(go)
    local _M = Utils.DeepCopy(self)
    _M.Trans = go.transform
    _M.Go = go
    _M.TextLabel = UIUtils.FindLabel(_M.Trans, "PopItemLabel")
    local _btn = _M.Trans:GetComponent("UIButton")
    UIUtils.AddBtnEvent(_btn, _M.OnClickBtn, _M)
    return _M
end

function PopItem:OnClickBtn()
    if self.CallBack ~= nil then
        self.CallBack(self.ID)
    end
end

function PopItem:SetText(text, id)
    self.TextLabel.text = text;
    self.ID = id;
end

function PopItem:SetOnClickCallback(func)
    self.CallBack = func
end
return PopItem