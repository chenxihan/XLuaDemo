------------------------------------------------
--作者： dhq
--日期： 2019-05-13
--文件： UIMarryChildPanel.lua
--模块： UIMarryChildPanel
--描述： 婚姻仙娃界面
------------------------------------------------
local UIChildItem = require "UI.Forms.UIMarriageForm.UIChildItem"

--//模块定义
local UIMarryChildPanel = {
    --当前transform
    Trans = nil,
    --父
    Parent = nil,
    --动画模块
    AnimModule = nil,
    ChildGrid = nil,
    ChildGo = nil,
    ChildData = nil,
    ChildItemData = nil,

    --FightPower = nil,
    NameLabel = nil,
    SkillItemList = nil,

    ChildSkin = nil,
    SkillData = nil,
}

--测试数据先拼装起来
local TestChildData = 
{
    {IconId = 780, Name = "曹操", States = 1},
    {IconId = 781, Name = "司马懿", States = 2},
    {IconId = 782, Name = "刘备", States = 2},
    {IconId = 783, Name = "关羽", States = 0},
    {IconId = 784, Name = "张飞", States = 1},
    {IconId = 785, Name = "诸葛亮", States = 0},
    {IconId = 786, Name = "孙策", States = 2},
    {IconId = 787, Name = "周瑜", States = 1},
    {IconId = 788, Name = "夏侯渊", States = 1},
}

--测试数据先拼装起来
local TestSkillData = 
{
    19001,
    19002,
    19003,
    19004,
}

function UIMarryChildPanel:OnFirstShow(trans, parent)
    self.Trans = trans
    self.Parent = parent

    self.ChildData = TestChildData
    self.SkillData = TestSkillData
    --创建动画模块
    self.AnimModule = UIAnimationModule(self.Trans)
    --添加一个动画
    self.AnimModule:AddAlphaAnimation()

    self.ChildGrid = UIUtils.FindGrid(self.Trans, "Left/Scroll View/Grid")

    self.ChildItemList = List:New();
    self.ChildGo = UIUtils.FindGo(self.Trans, "Left/Scroll View/Grid/Child")
    local _childItem = UIChildItem:New(self.ChildGo);
    self.ChildItemList:Add(_childItem)

    self.NameLabel = UIUtils.FindLabel(self.Trans, "Middle/Name/Label")
    
    self.ChildSkin = UIUtils.RequireUIRoleSkinCompoent(self.Trans:Find("Middle/UIRoleSkinCompoent"))
    if self.ChildSkin then
        self.ChildSkin:OnFirstShow(self.this, FSkinTypeCode.Player)
    end

    self.SkillItemList = List:New();
    for _skillItemId = 1, 4 do
        local _skillTrans = UIUtils.FindTrans(self.Trans, string.format( "Middle/Skill%s", _skillItemId ))
        local _skillItem = UIUtils.RequireUIItem(_skillTrans)
        self.SkillItemList:Add(_skillItem)
    end

    self.FightPower = UIUtils.FindLabel(self.Trans, "Right/Attr/FightPower")
    local _rightItem = UIUtils.FindTrans(self.Trans, "Right/Item")
    self.RightItem = UIUtils.RequireUIItem(_rightItem)

    self.ActiviteBtn = UIUtils.FindBtn(self.Trans, "Right/ActiviteBtn")
    UIUtils.AddBtnEvent(self.ActiviteBtn, self.OnActiviteBtnBtn, self)
    

    self.Trans.gameObject:SetActive(false)
    return self
end

function UIMarryChildPanel:Show(childId)
    --播放开启动画
    self.AnimModule:PlayEnableAnimation()
    self:UpdateChildData()
    self:SetModelShow()
    self:UpdateSkillShow()
    self:UpdatePageData()
end

function UIMarryChildPanel:Hide()
    --播放关闭动画
    self.AnimModule:PlayDisableAnimation()
    self.ChildSkin:ResetSkin()
end

-- 激活按钮
function UIMarryChildPanel:OnActiviteBtnBtn()

end

function UIMarryChildPanel:UpdatePageData()
    self.FightPower.text = string.format( "战斗力:%s", "1006811" )
    self.RightItem:InitializationWithIdAndNum(19003, 0, false, false)
end

-- 显示模型
function UIMarryChildPanel:SetModelShow()
    self.ChildSkin:ResetRot()
    self.ChildSkin:ResetSkin()
    self.ChildSkin:SetCameraSize(2.3)
    self.ChildSkin:SetEquip(FSkinPartCode.Body, RoleVEquipTool.GetLPBodyModel())
    self.ChildSkin:SetEquip(FSkinPartCode.Weapon, RoleVEquipTool.GetLPWeaponModel())
end

function UIMarryChildPanel:UpdateSkillShow()
    for _index = 1, #self.SkillItemList do
        local _id = self.SkillData[_index]
        self.SkillItemList[_index]:InitializationWithIdAndNum(_id, 0, false, false)
    end
end

-- 刷新界面的数据
function UIMarryChildPanel:UpdateChildData()
    local _itemUICount = #self.ChildItemList;
    for i = 1, _itemUICount do
        self.ChildItemList[i]:Refresh(nil);
    end
    local _itemCount = #self.ChildData;
    for i = 1, _itemCount do
        local _dataInfo = self.ChildData[i]
        local _childUI = nil;
        if i <= #self.ChildItemList then
            _childUI = self.ChildItemList[i];
        else
            _childUI = UIChildItem:New(UIUtility.Clone(self.ChildGo));
            self.ChildItemList:Add(_childUI);
        end
        self.ChildItemList[i]:Refresh(_dataInfo);
    end
    self.ChildGrid.repositionNow = true;
end

return UIMarryChildPanel