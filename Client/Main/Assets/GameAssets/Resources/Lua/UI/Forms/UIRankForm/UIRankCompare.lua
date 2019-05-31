------------------------------------------------
--作者： 王圣
--日期： 2019-04-30
--文件： UIRankCompare.lua
--模块： UIRankCompare
--描述： 排行榜行属性对比脚本
------------------------------------------------

-- c#类
local CompareItem = require "UI.Forms.UIRankForm.RankCompareItem"
local UIRankCompare = {
    Trans = nil,
    TempItem = nil,
    --label
    MyTitlePowerLabel = nil,
    MyTitleRankLabel = nil,
    MyNameLabel = nil,
    MyPowerLabel = nil,
    OtherNameLabel = nil,
    OtherPowerLabel = nil,
    --btn
    CloseBtn = nil,
    --spr
    OtherHeadSpr = nil,
    MyHeadSpr = nil,

    ComponentList = List:New(),
}

function UIRankCompare:OnClickClose()
    self.Trans.gameObject:SetActive(false)
end

function UIRankCompare:New(trans)
    local _m = Utils.DeepCopy(self)
    _m.Trans = trans
    _m:FindAllComponent()
    return _m
end

function UIRankCompare:FindAllComponent()
    if self.Trans == nil then
        return
    end
    self.TempItem = self.Trans:Find("Scroll/CompareGrid/Item")
    self.TempItem.gameObject:SetActive(false)
    self.MyTitlePowerLabel = self.Trans:Find("Title1/MyPower/Point"):GetComponent("UILabel");
    self.MyTitleRankLabel = self.Trans:Find("Title2/MyRank/Point"):GetComponent("UILabel");
    self.MyNameLabel = self.Trans:Find("Head2/Name"):GetComponent("UILabel");
    self.MyPowerLabel = self.Trans:Find("Head2/Title/Point"):GetComponent("UILabel");
    self.OtherNameLabel = self.Trans:Find("Head1/Name"):GetComponent("UILabel");
    self.OtherPowerLabel = self.Trans:Find("Head1/Title/Point"):GetComponent("UILabel");
    self.CloseBtn = self.Trans:Find("CloseBtn"):GetComponent("UIButton")
    UIUtils.AddBtnEvent(self.CloseBtn, self.OnClickClose, self)
    self.OtherHeadSpr = UIUtils.RequireUISprite(self.Trans:Find("Head1"))
    self.MyHeadSpr = UIUtils.RequireUISprite(self.Trans:Find("Head2"))
end

function UIRankCompare:SetData()
    local data = GameCenter.RankSystem.CompareData
    if data == nil then
        return
    end
    for i = 1,#self.ComponentList do
        self.ComponentList[i].Trans.gameObject:SetActive(false)
    end
    for i = 1, #data.AttrList do
        local item = nil
        if i>#self.ComponentList then
            local trans = UnityUtils.Clone(self.TempItem.gameObject).transform
            item = CompareItem:New(trans)
            self.ComponentList:Add(item)
        else
            item = self.ComponentList[i]
        end
        item:SetData(data.AttrList[i])
        item.Trans.gameObject:SetActive(true)
    end
    --设置我的排名
    self.MyTitleRankLabel.text = tostring(GameCenter.RankSystem.Data.MyRank)
    self.MyTitlePowerLabel.text = tostring(GameCenter.RankSystem.Data.MyPower)
    self.MyPowerLabel.text = tostring(GameCenter.RankSystem.Data.MyPower)
    --设置我的名字
    local lp = GameCenter.GameSceneSystem:GetLocalPlayer()
    local name = lp.Name
    self.MyNameLabel.text = name
    --设置对比方名字
    self.OtherNameLabel.text = data.Name
    self.OtherPowerLabel.text = tostring(data.Power)
    local caree = UnityUtils.GetObjct2Int(lp.Occ)
    self.MyHeadSpr.spriteName = CommonUtils.GetPlayerHeaderSpriteName(lp.Level,caree)
    caree = GameCenter.RankSystem:GetRankDataByPlayerId(GameCenter.RankSystem.CurRankData.RoleId).Career
    self.OtherHeadSpr.spriteName = CommonUtils.GetPlayerHeaderSpriteName(data.Level,caree)
end
return UIRankCompare
