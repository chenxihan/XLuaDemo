------------------------------------------------
--作者： yangqf
--日期： 2019-05-20
--文件： UISelectPKModeForm.lua
--模块： UISelectPKModeForm
--描述： 角色境界界面
------------------------------------------------

local UIItem = require "UI.Components.UIItem";

--//模块定义
local UISelectPKModeForm = {
    --关闭按钮
    CloseBtn = nil,
    --背景图片
    BackTex = nil,
    --pk模式toggle
    PkStateToggles = nil,
    --pk模式描述
    PkStateDescs = nil,
};

--继承Form函数
function UISelectPKModeForm:OnRegisterEvents()
    self:RegisterEvent(UIEventDefine.UISelectPKModeForm_OPEN, self.OnOpen);
    self:RegisterEvent(UIEventDefine.UISelectPKModeForm_CLOSE, self.OnClose);
end

function UISelectPKModeForm:OnFirstShow()
    self.CSForm:AddAlphaAnimation();

    self.CloseBtn = UIUtils.FindBtn(self.Trans, "CloseBtn");
    UIUtils.AddBtnEvent(self.CloseBtn, self.OnCloseBtnClick, self);

    self.PkStateToggles = {};
    self.PkStateDescs = {};
    self.BackTex = UIUtils.FindTex(self.Trans, "BackTex");
    for i = 0, 5 do
        local index = i + 1;
        self.PkStateToggles[index] = UIUtils.FindToggle(self.Trans, tostring(i));
        UIUtils.AddOnChangeEvent(self.PkStateToggles[index], self.OnToggleChanged, self);
        self.PkStateDescs[index] = UIUtils.FindGo(self.Trans, string.format("Desc%d", i));
    end
end

function UISelectPKModeForm:OnShowAfter()
    local _lp = GameCenter.GameSceneSystem:GetLocalPlayer();
    if _lp == nil then
        return;
    end
    local _curPkMode = UnityUtils.GetObjct2Byte(_lp.PkMode);
    for i = 1, 6 do
        self.PkStateToggles[i].value = ((_curPkMode + 1) == i);
    end
    self:OnToggleChanged();
end

function UISelectPKModeForm:OnHideBefore()
end

--开启事件
function UISelectPKModeForm:OnOpen(obj, sender)
    self.CSForm:Show(sender);
end

--关闭事件
function UISelectPKModeForm:OnClose(obj, sender)
    self.CSForm:Hide();
end

--关闭按钮点击
function UISelectPKModeForm:OnCloseBtnClick()
    self:OnClose(nil, nil);
end

--toggle点击
function UISelectPKModeForm:OnToggleChanged()
    local _lp = GameCenter.GameSceneSystem:GetLocalPlayer();
    if _lp == nil then
        return;
    end
    local _curPkMode = UnityUtils.GetObjct2Byte(_lp.PkMode);

    for i = 1, 6 do
        if self.PkStateToggles[i].value == true then
            self.PkStateDescs[i]:SetActive(true);
            if (_curPkMode + 1) ~= i then
                --发送消息
                GameCenter.Network.Send("MSG_Player.ReqUpdataPkState", {pkState = (i - 1)});
            end
        else
            self.PkStateDescs[i]:SetActive(false);
        end
    end
end

return UISelectPKModeForm;