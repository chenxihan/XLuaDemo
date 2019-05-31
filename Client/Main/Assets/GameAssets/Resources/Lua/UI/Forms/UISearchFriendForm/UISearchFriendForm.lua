------------------------------------------------
--作者： _SqL_
--日期： 2019-05-13
--文件： UISearchFriendForm.lua
--模块： UISearchFriendForm
--描述： 搜索好友界面
------------------------------------------------
local UISearchCommonRoot = require "UI.Forms.UISearchFriendForm.Root.UISearchCommonRoot"

local UISearchFriendForm = {
    CloseBtn = nil,
    SearchBtn = nil,
    InputComp = nil,
    ChangeBtn = nil,
    CancelBtn = nil,
    RecommendRoot = nil,
    SearchResultRoot = nil,
    BgTex = nil,
    CurrRoot = nil,
    AnimModule = nil,
}

function  UISearchFriendForm:OnRegisterEvents()
    self:RegisterEvent(UIEventDefine.UISearchFriendForm_OPEN,self.OnOpen)
    self:RegisterEvent(UIEventDefine.UISearchFriendForm_CLOSE,self.OnClose)
end

function UISearchFriendForm:OnFirstShow()
    self:FindAllComponents()
    self:OnRegUICallBack()
end

function UISearchFriendForm:LoadBgTex()
    self.CSForm:LoadTexture(self.BgTex, AssetUtils.GetImageAssetPath(ImageTypeCode.UI, "bag_storebg"))
end

function UISearchFriendForm:FindAllComponents()
    local _trans = self.CSForm.transform
    self.CloseBtn = UIUtils.FindBtn(_trans, "Top/closeButton")
    self.SearchBtn = UIUtils.FindBtn(_trans, "Top/searchBtn")
    self.InputComp = UIUtils.FindInput(_trans, "Top/Input")
    self.ChangeBtn = UIUtils.FindBtn(_trans, "Center/changeBtn")
    self.CancelBtn = UIUtils.FindBtn(_trans, "Center/CancelBtn")
    self.BgTex = UIUtils.FindTex(_trans, "Center/Back")
    self.AnimModule = UIAnimationModule( _trans)
    self.AnimModule:AddAlphaAnimation()

    local _recommendTrans = UIUtils.FindTrans(_trans, "Center/RecommendRoot")
    self.RecommendRoot = UISearchCommonRoot:New(self, _recommendTrans)
    local _resultTrans = UIUtils.FindTrans(_trans, "Center/ResultRoot")
    self.SearchResultRoot = UISearchCommonRoot:New(self, _resultTrans)

    self.CancelBtn.gameObject:SetActive(false)
    self.ChangeBtn.gameObject:SetActive(false)
    self.RecommendRoot:OnCLose()
    self.SearchResultRoot:OnCLose()
end

function UISearchFriendForm:OnRegUICallBack()
    UIUtils.AddBtnEvent(self.CloseBtn, self.OnCLose, self)
    UIUtils.AddBtnEvent(self.SearchBtn, self.OnSearchBtnClick, self)
    UIUtils.AddBtnEvent(self.CancelBtn, self.OnCancelBtnClick, self)
    UIUtils.AddBtnEvent(self.ChangeBtn, self.OnChangeBtnClick, self)
end

function UISearchFriendForm:OnChangeBtnClick()
    GameCenter.FriendSystem:ReqGetRelationList( FriendType.Recommend )
end

function UISearchFriendForm:OnCancelBtnClick()
    if self.SearchResultRoot.Show then
        self.SearchResultRoot:OnCLose()
        self.CancelBtn.gameObject:SetActive(false)
        self.ChangeBtn.gameObject:SetActive(true)
        self.RecommendRoot:RefreshPlayerList(GameCenter.FriendSystem.RecommendInfoList)
    end
end

function UISearchFriendForm:OnSearchBtnClick()
    if self.InputComp.value ~= "" then
        GameCenter.FriendSystem:ReqDimSelect(self.InputComp.value)
    end
end

function UISearchFriendForm:OnOpen(obj, sender)
    self.CSForm:Show(sender)
    self:LoadBgTex()
    if self.CurrRoot then
        self.CurrRoot:OnCLose()
    end
    if obj then
        if self.SearchResultRoot then
            self.ChangeBtn.gameObject:SetActive(false)
            self.CancelBtn.gameObject:SetActive(true)
            self.SearchResultRoot:OnOpen()
            self.SearchResultRoot:RefreshPlayerList(GameCenter.FriendSystem.DimSelectList)
            self.CurrRoot = self.SearchResultRoot
        end
    else
        if self.RecommendRoot then
            self.ChangeBtn.gameObject:SetActive(true)
            self.CancelBtn.gameObject:SetActive(false)
            self.RecommendRoot:OnOpen()
            self.RecommendRoot:RefreshPlayerList(GameCenter.FriendSystem.RecommendInfoList)
            self.CurrRoot = self.RecommendRoot
        end
    end
    --播放开启动画
    -- self.AnimModule:PlayEnableAnimation()
end

function UISearchFriendForm:OnCLose(obj, sender)
    self.CSForm:Hide()
    GameCenter.FriendSystem:ReqGetRelationList(FriendType.Friend)
    GameCenter.FriendSystem.CurUIType = FriendType.Friend
end

return UISearchFriendForm