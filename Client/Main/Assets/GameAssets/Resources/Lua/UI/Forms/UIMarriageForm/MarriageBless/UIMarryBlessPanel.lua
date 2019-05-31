------------------------------------------------
--作者： dhq
--日期： 2019-05-13
--文件： UIMarryBlessPanel.lua
--模块： UIMarryBlessPanel
--描述： 婚姻祈福界面
------------------------------------------------

--//模块定义
local UIMarryBlessPanel = {
    --当前transform
    Trans = nil,
    --父
    Parent = nil,
    --动画模块
    AnimModule = nil,
    --等级
    LevelLabel = nil,
    -- 进度条
    Progress = nil,
    -- 进度条上的数据显示
    ProLabel = nil,
    -- 收取果实的按钮
    GetRewardBtn = nil,
    AttrGrid = nil,
    SelfBuyCountLabel = nil,
    OtherBuyCount = nil,
    --自己购买许愿次数
    SelfBuyBtn = nil,
    --请求伴侣购买许愿次数
    SpouseBuyBtn = nil,
    --购买祈福次数的价格
    PriceLabel = nil,
    --每次祈福获得的奖励
    RewardUIItem = nil,
    --剩余的祈福次数
    BlessCountLabel = nil,
    --祈福按钮
    BlessBtn = nil,
    --邀请伴侣按钮
    InviteMateBtn = nil,
    --邀请好友按钮
    InviteFriendBtn = nil,
    --等待应答的界面
    WaittingGo = nil,
    --祈福结果的界面
    BlessResultGo = nil,
    --祈福的对题界面
    BlessTopicGo = nil,
}

function UIMarryBlessPanel:OnFirstShow(trans, parent)
    self.Trans = trans
    self.Parent = parent

    --创建动画模块
    self.AnimModule = UIAnimationModule(self.Trans)
    --添加一个动画
    self.AnimModule:AddAlphaAnimation()

    self.LevelLabel = UIUtils.FindLabel(self.Trans, "Left/Level/Level")
    self.Progress = UIUtils.FindProgressBar(self.Trans, "Left/ProgressF")
    self.ProLabel = UIUtils.FindLabel(self.Trans, "Left/ProgressF/Label")
    self.GetRewardBtn = UIUtils.FindBtn(self.Trans, "Left/GetRewardBtn")
    UIUtils.AddBtnEvent(self.GetRewardBtn, self.OnGetRewardBtnClcik, self)

    self.AttrGrid = UIUtils.FindGrid(self.Trans, "Right/Attr/Grid")

    self.AttrItemList = List:New()
    for _index = 1, 6 do
        local _attrItem = UIUtils.FindTrans(self.Trans, string.format( "Right/Attr/Grid/%s", _index))
        local _attrUIItem = UIUtils.RequireUIItem(_attrItem)
        self.AttrItemList:Add(_attrUIItem)
    end

    self.SelfBuyCountLabel = UIUtils.FindLabel(self.Trans, "Right/SelfBuyCount/Label")
    self.OtherBuyCount = UIUtils.FindLabel(self.Trans, "Right/OtherBuyCount/Label")

    self.SelfBuyBtn = UIUtils.FindBtn(self.Trans, "Right/SelfBuyBtn")
    UIUtils.AddBtnEvent(self.SelfBuyBtn, self.OnSelfBuyBtnClcik, self)
    self.SpouseBuyBtn = UIUtils.FindBtn(self.Trans, "Right/SpouseBuyBtn")
    UIUtils.AddBtnEvent(self.SpouseBuyBtn, self.OnSpouseBuyBtnClcik, self)

    self.PriceLabel = UIUtils.FindLabel(self.Trans, "Right/Price/Num")

    local _rewardItem = UIUtils.FindTrans(self.Trans, "Right/Des/Item")
    self.RewardUIItem = UIUtils.RequireUIItem(_rewardItem)

    self.BlessCountLabel = UIUtils.FindLabel(self.Trans, "Right/BlessCount/Num")

    self.BlessBtn = UIUtils.FindBtn(self.Trans, "Right/BlessBtn")
    UIUtils.AddBtnEvent(self.BlessBtn, self.OnBlessBtnClcik, self)
    
    self.InviteMateBtn = UIUtils.FindBtn(self.Trans, "Right/Bottom/InviteMate")
    UIUtils.AddBtnEvent(self.InviteMateBtn, self.OnInviteMateBtnClcik, self)
    self.InviteFriendBtn = UIUtils.FindBtn(self.Trans, "Right/Bottom/InviteFriend")
    UIUtils.AddBtnEvent(self.InviteFriendBtn, self.OnInviteFriendBtnClcik, self)

    self.WaittingGo = UIUtils.FindGo(self.Trans, "Waitting")
    self.BlessResultGo = UIUtils.FindGo(self.Trans, "BlessResult")
    self.BlessTopicGo = UIUtils.FindGo(self.Trans, "BlessTopic")

    self.Trans.gameObject:SetActive(false)
    return self
end

function UIMarryBlessPanel:Show(childId)
    --播放开启动画
    self.AnimModule:PlayEnableAnimation()
    self:UpdatePageData()
end

function UIMarryBlessPanel:Hide()
    --播放关闭动画
    self.AnimModule:PlayDisableAnimation()
end

--收取果实按钮
function UIMarryBlessPanel:OnGetRewardBtnClcik()

end

--自己购买
function UIMarryBlessPanel:OnSelfBuyBtnClcik()

end

--请求伴侣购买
function UIMarryBlessPanel:OnSpouseBuyBtnClcik()

end

--祈福按钮
function UIMarryBlessPanel:OnBlessBtnClcik()

end

--邀请伴侣祈福
function UIMarryBlessPanel:OnInviteMateBtnClcik()

end

--邀请好友祈福
function UIMarryBlessPanel:OnInviteFriendBtnClcik()

end

function UIMarryBlessPanel:UpdatePageData()
    self.LevelLabel.text = string.format( "Lv.%s", 2 )
    local _curPro = 5
    local _need = 10
    self.Progress.value = _curPro / _need
    self.ProLabel.text = string.format( "%s/%s",_curPro, _need )

    for _index = 1, #self.AttrItemList do
        self.AttrItemList[_index]:InitializationWithIdAndNum(19002, 0, false, false)
    end
    self.AttrGrid.repositionNow = true;

    local _selfBuyNum = 0
    local _reqBuyNum = 0
    local _blessNum = 0
    local _global = DataConfig.DataGlobal[1505]
    if _global ~= nil then
        local _strs = Utils.SplitStr(_global.Params, '_')
        if #_strs >= 3 then
            _selfBuyNum = tonumber(_strs[1])
            _reqBuyNum = tonumber(_strs[2])
            _blessNum = tonumber(_strs[3])
        end
    end
    if GameCenter.MarrySystem.MarryData ~= nil then
        local _wishBuyCount = GameCenter.MarrySystem.MarryData.WishBuyCount
        local _partnerWishBuyCount = GameCenter.MarrySystem.MarryData.PartnerWishBuyCount
        self.SelfBuyCountLabel.text = string.format( "%s/%s", _wishBuyCount, _selfBuyNum )
        self.OtherBuyCount.text = string.format( "%s/%s", _partnerWishBuyCount, _reqBuyNum )
        self.PriceLabel.text = "150"

        self.RewardUIItem:InitializationWithIdAndNum(19002, 0, false, false)
        local _wishCount = GameCenter.MarrySystem.MarryData.WishCount
        self.BlessCountLabel.text = string.format( "%s/%s", _wishCount, _blessNum )
    end
end

return UIMarryBlessPanel