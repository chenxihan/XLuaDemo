--==============================--
--作者： yangqf
--日期： 2019-05-07
--文件： UISZZQAwardForm.lua
--模块： UISZZQAwardForm
--描述： 圣战之启排名奖励展示界面
--==============================--
local UIItem = require "UI.Components.UIItem";

local UISZZQAwardForm = {
    --关闭按钮
    CloseBtn = nil,
    CloseBtn2 = nil,
    --滑动列表
    ScrollView = nil,
    --物品列表
    ExpAwardItem = nil,
};

--注册事件函数, 提供给CS端调用.
function UISZZQAwardForm:OnRegisterEvents()
    self:RegisterEvent(UIEventDefine.UISZZQAwardForm_OPEN, self.OnOpen)
    self:RegisterEvent(UIEventDefine.UISZZQAwardForm_CLOSE, self.OnClose)
end

--第一只显示函数, 提供给CS端调用.
function UISZZQAwardForm:OnFirstShow()
    self.CloseBtn = UIUtils.FindBtn(self.Trans, "Center/Back/CloseBtn");
    self.CloseBtn2 = UIUtils.FindBtn(self.Trans, "Center");
    UIUtils.AddBtnEvent(self.CloseBtn, self.OnClickCloseBtn, self);
    self.ScrollView = UIUtils.FindScrollView(self.Trans, "Center/Back/ListPanel");
    local _resGo = UIUtils.FindGo(self.Trans, "Center/Back/ListPanel/Item");
    local _startY = 341.0;
    self.ExpAwardItem = List:New();

    local _resList = List:New();
    local _itemParent = UIUtils.FindTrans(self.Trans, "Center/Back/ListPanel");
    for i = 0, _itemParent.childCount - 1 do
        _resList:Add(_itemParent:GetChild(i).gameObject);
    end
    local _resCount = #_resList;
    for i = 1, #DataConfig.DataSZZQAward do
        local _uiGo = nil;
        if i <= _resCount then
            _uiGo = _resList[i];
        else
            _uiGo = UIUtility.Clone(_resGo);
        end

        local _trans = _uiGo.transform;
        _trans.localPosition = Vector3(-68, _startY, 0);
        local _name = UIUtils.FindLabel(_trans, "Name");
        local _icon = UnityUtils.RequireComponent(UIUtils.FindTrans(_trans, "Icon"), "Funcell.GameUI.Form.UIIcon");
        local _uiItems = List:New();
        for j = 1, 5 do
            _uiItems:Add(UIItem:New(UIUtils.FindTrans(_trans, tostring(j))));
        end
        self.ExpAwardItem:Add(_uiItems[1]);
        _uiItems[1].RootGO:SetActive(true);
        local _cfg = DataConfig.DataSZZQAward[i];
        _name.text = _cfg.Name;
        _icon:UpdateIcon(_cfg.ResIcon);
        local _awardItms = Utils.SplitStrByTableS(_cfg.Award);
        local _awardCount = #_awardItms;
        for k = 2, 5 do
            local _awardIndex = k - 1;
            if _awardIndex <= _awardCount then
                _uiItems[k].RootGO:SetActive(true);
                _uiItems[k]:InItWithCfgid(_awardItms[_awardIndex][1], _awardItms[_awardIndex][2], false, false)
            else
                _uiItems[k].RootGO:SetActive(false);
            end
        end
        _startY = _startY - 95.0;
    end
    self.CSForm:AddAlphaAnimation();
end

--显示之前的操作, 提供给CS端调用.
function UISZZQAwardForm:OnShowBefore()
end

--显示后的操作, 提供给CS端调用.
function UISZZQAwardForm:OnShowAfter()
    local _levelCfg = DataConfig.DataCharacters[GameCenter.GameSceneSystem:GetLocalPlayerLevel()];
    if _levelCfg ~= nil then
        local _expItemCount = #self.ExpAwardItem;
        local _itemParams = Utils.SplitStr(_levelCfg.SZZQEXPRankAward, ';');
        local _itemParCount = #_itemParams;
        for i = 1, #DataConfig.DataSZZQAward do
            local _cfg = DataConfig.DataSZZQAward[i];
            if i <= _expItemCount and _cfg.UesExpIndex >= 0 and _cfg.UesExpIndex < _itemParCount then
                self.ExpAwardItem[i]:InItWithCfgid(UnityUtils.GetObjct2Int(ItemTypeCode.Exp), tonumber(_itemParams[_cfg.UesExpIndex + 1]), false, false);
            end
        end
    end
    self.ScrollView:ResetPosition();
end

--隐藏之前的操作, 提供给CS端调用.
function UISZZQAwardForm:OnHideBefore()
end

--隐藏之后的操作, 提供给CS端调用.
function UISZZQAwardForm:OnHideAfter()
end

--开启事件
function UISZZQAwardForm:OnOpen(obj, sender)
    self.CSForm:Show(sender);
end

--关闭事件
function UISZZQAwardForm:OnClose(obj, sender)
    self.CSForm:Hide()
end

function UISZZQAwardForm:OnClickCloseBtn()
    self:OnClose(nil, nil);
end

return UISZZQAwardForm;