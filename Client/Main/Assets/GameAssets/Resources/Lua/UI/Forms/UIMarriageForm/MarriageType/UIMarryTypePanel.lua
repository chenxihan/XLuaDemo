------------------------------------------------
--作者： dhq
--日期： 2019-05-13
--文件： UIMarryTypePanel.lua
--模块： UIMarryTypePanel
--描述： 婚姻求婚界面
------------------------------------------------
local UIMarryTypeItem = require "UI.Forms.UIMarriageForm.MarriageType.UIMarryTypeItem"

--//模块定义
local UIMarryTypePanel = {
    --当前transform
    Trans = nil,
    --父
    Parent = nil,
    --动画模块
    AnimModule = nil,
    BackBtn = nil,
    TypeGrid = nil,
    TypeGo = nil,
    --我要结婚按钮
    HopeMarryBtn = nil,
    --向TA求婚按钮
    WithMarryBtn = nil,
    --结婚规则板子
    RuleTipsGo = nil,
    TypeItemList = nil,
    TypeData = nil,
}

--测试数据先拼装起来
local TestTypeData = 
{
    {TypeName = "普通婚礼", HouseTexName = "tex_wzlmback_2", AppellationName = "tex_chenghao_27", Award = "1003_10_0;1005_10_0", WifeName = "苏菲玛索", HusbandName = "特朗普", Price = 600},
    {TypeName = "奢想婚礼", HouseTexName = "tex_wzlmback_2", AppellationName = "tex_chenghao_28", Award = "1004_15_0;1006_15_0", WifeName = "苏菲玛索", HusbandName = "特朗普", Price = 1600},
    {TypeName = "豪华婚礼", HouseTexName = "tex_wzlmback_2", AppellationName = "tex_chenghao_29", Award = "1007_20_0;1008_20_0", WifeName = "苏菲玛索", HusbandName = "特朗普", Price = 2600},
}

function UIMarryTypePanel:OnFirstShow(trans, parent)
    self.Trans = trans
    self.Parent = parent

    self.TypeData = TestTypeData
    --创建动画模块
    self.AnimModule = UIAnimationModule(self.Trans)
    --添加一个动画
    self.AnimModule:AddAlphaAnimation()

    self.BackBtn = UIUtils.FindBtn(self.Trans, "BackBtn")
    UIUtils.AddBtnEvent(self.BackBtn, self.OnBackBtnClick, self)

    self.TypeGrid = UIUtils.FindGrid(self.Trans, "TypePanel/Grid")

    self.TypeItemList = List:New()
    self.TypeGo = UIUtils.FindGo(self.Trans, "TypePanel/Grid/Type")
    local _typeItem = UIMarryTypeItem:New(self.TypeGo, self)
    self.TypeItemList:Add(_typeItem)

    self.QueBtn = UIUtils.FindBtn(self.Trans, "QueBtn")
    UIUtils.AddBtnEvent(self.QueBtn, self.OnQueBtnClick, self)
    self.HopeMarryBtn = UIUtils.FindBtn(self.Trans, "HopeMarryBtn")
    UIUtils.AddBtnEvent(self.HopeMarryBtn, self.OnHopeMarryBtnClick, self)
    self.WithMarryBtn = UIUtils.FindBtn(self.Trans, "WithMarryBtn")
    UIUtils.AddBtnEvent(self.WithMarryBtn, self.OnWithMarryBtnClick, self)

    self.RuleTipsGo = UIUtils.FindGo(self.Trans, "RuleTips")
    self.RuleTipsGo:SetActive(false)
    self.Trans.gameObject:SetActive(false)
    return self
end

function UIMarryTypePanel:Show()
    --播放开启动画
    self.AnimModule:PlayEnableAnimation()
    self:UpdateData()
end

function UIMarryTypePanel:Hide()
    --播放关闭动画
    self.AnimModule:PlayDisableAnimation()
end

--关闭上层面板和此面板
function UIMarryTypePanel:HideSelfAndParentPanel()
    self:Hide()
    self.Parent.MarryProcessPanel:Show()
end

-- --返回按钮
function UIMarryTypePanel:OnBackBtnClick()
    self:HideSelfAndParentPanel()
end

--我要结婚按钮
function UIMarryTypePanel:OnHopeMarryBtnClick()
    --self:Hide()
end

--向TA求婚按钮
function UIMarryTypePanel:OnWithMarryBtnClick()
    --self:Hide()
end

--问题按钮
function UIMarryTypePanel:OnQueBtnClick()
    if self.RuleTipsGo.activeSelf then
        self.RuleTipsGo:SetActive(false)
    else
        self.RuleTipsGo:SetActive(true)
    end
end

-- 刷新数据
function UIMarryTypePanel:UpdateData()
    local _itemUICount = #self.TypeItemList;
    for i = 1, _itemUICount do
        self.TypeItemList[i]:Refresh(nil);
    end
    local _itemCount = #self.TypeData;
    for i = 1, _itemCount do
        local _dataInfo = self.TypeData[i]
        local _typeItem = nil;
        if i <= #self.TypeItemList then
            _typeItem = self.TypeItemList[i];
        else
            _typeItem = UIMarryTypeItem:New(UIUtility.Clone(self.TypeGo), self);
            self.TypeItemList:Add(_typeItem);
        end
        self.TypeItemList[i]:Refresh(_dataInfo);
    end
    self.TypeGrid.repositionNow = true;
end

return UIMarryTypePanel