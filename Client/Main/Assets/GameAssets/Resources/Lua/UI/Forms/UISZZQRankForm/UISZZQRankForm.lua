------------------------------------------------
--作者： yangqf
--日期： 2019-5-7
--文件： UISZZQRankForm.lua
--模块： UISZZQRankForm
--描述： 圣战之启副本内排名界面
------------------------------------------------
local UIListMenu = require "UI.Components.UIListMenu.UIListMenu"
local UISZZQRankItem = require "UI.Forms.UISZZQRankForm.UISZZQRankItem"

--//模块定义
local UISZZQRankForm = {
    --菜单
    ListMenu = nil,
    --关闭按钮
    CloseBtn = nil,
    --关闭按钮
    CloseBtn1 = nil,
    --滑动列表
    ScrollView = nil,
    --自己的排名
    SelfRank = nil,
    --自己的分数
    SelfScore = nil,
    --排名列表
    ItemList = nil,
    --排名资源
    ItemRes = nil;
    --阵营icon
    CampIcons = nil;
}

--继承Form函数
function UISZZQRankForm:OnRegisterEvents()
    self:RegisterEvent(UIEventDefine.UISZZQRankForm_OPEN, self.OnOpen)
    self:RegisterEvent(UIEventDefine.UISZZQRankForm_CLOSE, self.OnClose)
end

function UISZZQRankForm:OnFirstShow()
    self.CSForm:AddAlphaAnimation();

    --设置特殊的阵营Icon，用于展示到头顶
    local _compCfg = DataConfig.DataGlobal[1314];
    if _compCfg ~= nil then
        self.CampIcons = {};
        local _compIcons = Utils.SplitStrByTableS(_compCfg.Params);
        for i = 1, #_compIcons do
            self.CampIcons[_compIcons[i][1]] = _compIcons[i][2];
        end
    end

    self.ListMenu = UIListMenu:OnFirstShow(self.CSForm, UIUtils.FindTrans(self.Trans, "Center/Back/UIListMenu"))
    self.ListMenu:ClearSelectEvent();
    self.ListMenu:AddSelectEvent(Utils.Handler(self.OnMenuSelect, self))
    self.ListMenu:AddIcon(0, DataConfig.DataMessageString.Get("C_SZZQ_ALL"))
    self.ListMenu:AddIcon(1, DataConfig.DataMessageString.Get("C_SZZQ_CAMP1"))
    self.ListMenu:AddIcon(2, DataConfig.DataMessageString.Get("C_SZZQ_CAMP2"))
    self.ListMenu:AddIcon(3, DataConfig.DataMessageString.Get("C_SZZQ_CAMP3"))

    self.CloseBtn = UIUtils.FindBtn(self.Trans, "Center");
    self.CloseBtn1 = UIUtils.FindBtn(self.Trans, "Center/Back/CloseBtn");
    UIUtils.AddBtnEvent(self.CloseBtn, self.OnClickCloseBtn, self);
    UIUtils.AddBtnEvent(self.CloseBtn1, self.OnClickCloseBtn, self);

    self.ScrollView = UIUtils.FindScrollView(self.Trans, "Center/Back/ListPanel");
    self.SelfRank = UIUtils.FindLabel(self.Trans, "Center/Back/Self/RankValue");
    self.SelfScore = UIUtils.FindLabel(self.Trans, "Center/Back/Self/ScoreValue");

    self.ItemRes = UIUtils.FindGo(self.Trans, "Center/Back/ListPanel/Item");

    self.ItemList = List:New();
    local _itemParent = UIUtils.FindTrans(self.Trans, "Center/Back/ListPanel");
    for i = 0, _itemParent.childCount - 1 do
        self.ItemList:Add(UISZZQRankItem:New(_itemParent:GetChild(i)));
    end
end

function UISZZQRankForm:OnShowAfter()
end

function UISZZQRankForm:OnHideBefore()
end

--菜单选择事件
function UISZZQRankForm:OnMenuSelect(id, b)
    if b == true then
        local _index = 0;
        local _itemCount = #self.ItemList;
        for i = 1, _itemCount do
            if self.ItemList[i].Info == nil then
                self.ItemList[i]:SetIndex(-1);
            elseif (id == 0 or self.ItemList[i].CampID == id) then
                self.ItemList[i]:SetIndex(_index);
                _index = _index + 1;
            else
                self.ItemList[i]:SetIndex(-1);
            end
        end
        self.ScrollView:ResetPosition();
    end

end

--关闭按钮点击
function UISZZQRankForm:OnClickCloseBtn()
    self:OnClose(nil, nil);
end

--刷新界面
function UISZZQRankForm:RefreshPage(msg)
    if msg == nil then
        return;
    end
    local _itemUICount = #self.ItemList;
    for i = 1, _itemUICount do
        self.ItemList[i]:Refresh(nil, -1 ,0);
    end
    local _rankList = List:New(msg.rankInfo);
    _rankList:Sort(function(a,b)
        return a.points < b.points;
    end);
    local _rankCount = #_rankList;
    for i = 1, _rankCount do
        local _msgInfo = _rankList[i]
        local _itemUI = nil;
        if i <= #self.ItemList then
            _itemUI = self.ItemList[i];
        else
            _itemUI = UISZZQRankItem:New(UIUtility.Clone(self.ItemRes));
            self.ItemList:Add(_itemUI);
        end
        self.ItemList[i]:Refresh(_msgInfo, i ,self.CampIcons[_msgInfo.camp]);
    end
    self.SelfRank.text = DataConfig.DataMessageString.Get("C_SZZQ_RANK", msg.selfRank);
    self.SelfScore.text = DataConfig.DataMessageString.Get("C_SZZQ_TIMEMIN", msg.selfScore);
end

--开启事件
function UISZZQRankForm:OnOpen(obj, sender)
    self.CSForm:Show(sender);
    self:RefreshPage(obj);
    self.ListMenu:SetSelectById(1);
end

--关闭事件
function UISZZQRankForm:OnClose(obj, sender)
    self.CSForm:Hide()
end

return UISZZQRankForm;