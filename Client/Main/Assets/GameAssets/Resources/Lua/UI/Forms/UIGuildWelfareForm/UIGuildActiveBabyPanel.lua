------------------------------------------------
--作者： 何健
--日期： 2019-05-17
--文件： UIGuildActiveBabyPanel.lua
--模块： UIGuildActiveBabyPanel
--描述： 宗派活动之活跃宝贝
------------------------------------------------
local UIActiveBabyRewardItem = require "UI.Forms.UIGuildWelfareForm.UIActiveBabyRewardItem"
local UIActiveBabyRankItem = require "UI.Forms.UIGuildWelfareForm.UIActiveBabyRankItem"

local UIGuildActiveBabyPanel = {
    Trans = nil,
    Go = nil,
    CloseBtn = nil,
    RewardGrid = nil,
    RewardGridTrans = nil,
    RewardScrollView = nil,
    RankGrid = nil,
    RankGridTrans = nil,
    RankScrollView = nil,
    RewardTipsGo = nil,
    RankTipsGo = nil,
}

--创建一个新的对象
function UIGuildActiveBabyPanel:OnFirstShow(trans)
    local _m = Utils.DeepCopy(self)
    _m.Trans = trans
    _m.Go = trans.gameObject
    _m:FindAllComponents()
    return _m
 end

--查找UI上各个控件
function UIGuildActiveBabyPanel:FindAllComponents()
    self.CloseBtn = UIUtils.FindBtn(self.Trans, "CenterCloseBtn")
    self.RewardTipsGo = UIUtils.FindGo(self.Trans, "ItemContaner/LeftBack/DefaultLabel")
    self.RankTipsGo = UIUtils.FindGo(self.Trans, "ItemContaner/RightBack/DefaultLabel")
    self.RewardGrid = UIUtils.FindGrid(self.Trans, "ItemContaner/RewardScrollView/Grid")
    self.RewardGridTrans = UIUtils.FindTrans(self.Trans, "ItemContaner/RewardScrollView/Grid")
    self.RankGrid = UIUtils.FindGrid(self.Trans, "ItemContaner/RankScrollView/Grid")
    self.RankGridTrans = UIUtils.FindTrans(self.Trans, "ItemContaner/RankScrollView/Grid")
    self.RewardScrollView = UIUtils.FindScrollView(self.Trans, "ItemContaner/RewardScrollView")
    self.RankScrollView = UIUtils.FindScrollView(self.Trans, "ItemContaner/RankScrollView")

    UIUtils.AddBtnEvent(self.CloseBtn, self.Close, self)
end

function UIGuildActiveBabyPanel:Open()
    self.Go:SetActive(true)
    self:OnUpdateForm()
    GameCenter.GuildSystem:ReqGuildActiveBabyInfo()
end
function UIGuildActiveBabyPanel:Close()
    self.Go:SetActive(false)
end
--更新物品
function UIGuildActiveBabyPanel:OnUpdateForm()
    --先隐藏两个滑动块控件
    for i = 0, self.RewardGridTrans.childCount - 1 do
        local _trans = self.RewardGridTrans:GetChild(i)
        _trans.gameObject:SetActive(false)
    end
    for i = 0, self.RankGridTrans.childCount - 1 do
        local _trans = self.RankGridTrans:GetChild(i)
        _trans.gameObject:SetActive(false)
    end

    --加载上次获奖的玩家数据
    local _rewardData = GameCenter.GuildSystem.ActiveBabyRewardDic
    if _rewardData.Count == 0 then
        self.RewardTipsGo:SetActive(true)
    else
        local _index = 1
        local _go = nil
        self.RewardTipsGo:SetActive(false)
        local _e = _rewardData:GetEnumerator()
        while _e:MoveNext() do
            if _index > self.RewardGridTrans.childCount then
                _go = _go:Clone()
            else
                _go = UIActiveBabyRewardItem:OnFirstShow(self.RewardGridTrans:GetChild(_index - 1))
            end
            if _go ~= nil then
                _go:OnUpdateItem(_e.Current.Value, _e.Current.Key)
                _go.Trans.name = tostring(_index)
                _go.Go:SetActive(true)
                _index = _index + 1
            end
        end
        self.RewardGrid.repositionNow = true
    end
    self.RewardScrollView:ResetPosition()

    --加载活跃排行数据
    local _rankData = GameCenter.GuildSystem.ActiveBabyRankDic
    if _rankData.Count == 0 then
        self.RankTipsGo:SetActive(true)
    else
        local _index = 1
        local _go = nil
        self.RankTipsGo:SetActive(false)
        local _e = _rankData:GetEnumerator()
        while _e:MoveNext() do
            if _index > self.RankGridTrans.childCount then
                _go = _go:Clone()
            else
                _go = UIActiveBabyRankItem:OnFirstShow(self.RankGridTrans:GetChild(_index - 1))
            end
            if _go ~= nil then
                _go:OnUpdateItem(_index, _e.Current.Key, _e.Current.Value)
                _go.Trans.name = tostring(_index)
                _go.Go:SetActive(true)
                _index = _index + 1
            end
        end
        self.RankGrid.repositionNow = true
    end
    self.RankScrollView:ResetPosition()
end
return  UIGuildActiveBabyPanel