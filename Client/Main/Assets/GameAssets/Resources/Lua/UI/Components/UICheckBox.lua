------------------------------------------------
--作者： 何健
--日期： 2019-05-22
--文件： UICheckBox.lua
--模块： UICheckBox
--描述： 选择框控件
------------------------------------------------

local UICheckBox ={
    Trans = nil,
    Go = nil,
    --选中图标
    OkGo = nil,
    --点击
    CheckBtn = nil,
    IsChecked = false,
    CallBack = nil
}

function UICheckBox:OnFirstShow(trans)
    local _M = Utils.DeepCopy(self)
    _M.Trans = trans
    _M.Go = trans.gameObject
    _M.OkGo = UIUtils.FindGo(trans, "Ok")
    _M.CheckBtn = trans:GetComponent("UIButton")
    _M.OkGo:SetActive(_M.IsChecked)
    UIUtils.AddBtnEvent(_M.CheckBtn, _M.onClickCheckBtn, _M)
    return _M
end

--设置点击事件
function UICheckBox:SetOnClickFunc(func)
    self.CallBack = func
end

--设置选中
function UICheckBox:SetChecked(ischeck)
    self.IsChecked = ischeck
    self.OkGo:SetActive(self.IsChecked)
end

function UICheckBox:onClickCheckBtn()
    self.IsChecked = not self.IsChecked
    self.OkGo:SetActive(self.IsChecked)
    if self.CallBack ~= nil then
        self.CallBack(self.IsChecked)
    end
end
return UICheckBox