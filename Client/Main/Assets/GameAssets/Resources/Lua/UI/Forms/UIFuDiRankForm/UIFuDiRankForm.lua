
------------------------------------------------
--作者： 王圣
--日期： 2019-05-10
--文件： UIFuDiRankForm.lua
--模块： UIFuDiRankForm
--描述： 福地排行榜Form
------------------------------------------------

-- c#类
local UIFuDiItem = require "UI.Forms.UIFuDiRankForm.UIFuDiItem"
local UIFuDiRankItem = require "UI.Forms.UIFuDiRankForm.UIFuDiRankItem"
local UIFuDiRankForm = {
    CurFuDiID = 1,
    RankArea1 = nil,
    RankArea2 = nil,
    RankArea3 = nil,
    TitlePic1 = nil,
    TitlePic2 = nil,
    TitlePic3 = nil,
    AddFightLabel1 = nil,
    AddFightLabel2 = nil,
    AddFightLabel3 = nil,
    MyGuildRankLabel = nil,
    MyInGuildRankLabel = nil,
    CurFuDiName = nil,
    RankList1 = List:New(),
    RankList2 = List:New(),
    RankList3 = List:New(),
    FuDiItemCount = 3,
    FuDiList = List:New(),
    RankScorll = nil,
    RankGuildBtn = nil,
    RankInGuildBtn = nil,
    HelpBtn = nil,
}
--继承Form函数
function UIFuDiRankForm:OnRegisterEvents()
	self:RegisterEvent(UIEventDefine.UIFuDiRankForm_Open,self.OnOpen)
    self:RegisterEvent(UIEventDefine.UIFuDiRankForm_Close,self.OnClose)
    self:RegisterEvent(LogicEventDefine.EID_EVENT_UPDATE_FUDIRANKFORM,self.UpdateForm)
end

function UIFuDiRankForm:OnFirstShow()
    self:FindAllComponents()
end

function UIFuDiRankForm:OnShowAfter()
    
end

function UIFuDiRankForm:OnHideBefore()
    
end

------------OnClickEnd

function UIFuDiRankForm:OnOpen(obj, sender)
    self.CSForm:Show(sender)
    GameCenter.FuDiSystem:ReqOpenRankPanel()
end

function UIFuDiRankForm:UpdateForm(obj,sender) 
    if obj == nil then
        self:SetForm(1)
    else
        self:SetForm(obj)
    end
end

--点击福地
function UIFuDiRankForm:OnClickFuDi()
    local index = 1
    for i=1, #self.FuDiList do
        if self.FuDiList[i].Btn == CS.UIButton.current then
            index = i
            break;
        end
    end
    self:SetForm(index)
end

--点击宗派排名
function UIFuDiRankForm:OnClickGuildRank()
end

--点击宗内排名
function UIFuDiRankForm:OnClickInGuildRank()
end

--点击帮助
function UIFuDiRankForm:OnClickHelp()
end

------------OnClickEnd

function UIFuDiRankForm:FindAllComponents()
    --初始化福地Item
    for i = 1,self.FuDiItemCount do
        local path = string.format( "Center/FudiGrid/TempFuDi_%s",i-1 )
        local trans = self.Trans:Find(path)
        local fudiItem = UIFuDiItem:New(trans)
        UIUtils.AddBtnEvent(fudiItem.Btn, self.OnClickFuDi, self)
        self.FuDiList:Add(fudiItem)
    end
    --初始化排行item
    local trans = self.Trans:Find("Center/Scroll View/Item_0/Rank_0")
    local uiRankItem = UIFuDiRankItem:New(trans)
    self.RankList1:Add(uiRankItem)
    for i = 1,3 do
        trans = self.Trans:Find(string.format( "Center/Scroll View/Item_1/Rank_%s",i-1 ))
        uiRankItem = UIFuDiRankItem:New(trans)
        self.RankList2:Add(uiRankItem)
    end
    for i = 1,6 do
        trans = self.Trans:Find(string.format( "Center/Scroll View/Item_2/Rank_%s",i-1 ))
        uiRankItem = UIFuDiRankItem:New(trans)
        self.RankList3:Add(uiRankItem)
    end
    self.RankArea1 = self.Trans:Find("Center/Scroll View/Item_0")
    self.RankArea2 = self.Trans:Find("Center/Scroll View/Item_1")
    self.RankArea3 = self.Trans:Find("Center/Scroll View/Item_2")
    self.RankArea1.gameObject:SetActive(false)
    self.RankArea2.gameObject:SetActive(false)
    self.RankArea3.gameObject:SetActive(false)
    self.TitlePic1 = self.Trans:Find("Center/Scroll View/Item_0/ChengHao"):GetComponent("UITexture")
    self.TitlePic1.gameObject:SetActive(false)
    self.TitlePic2 = self.Trans:Find("Center/Scroll View/Item_1/ChengHao"):GetComponent("UITexture")
    self.TitlePic2.gameObject:SetActive(false)
    self.TitlePic3 = self.Trans:Find("Center/Scroll View/Item_2/ChengHao"):GetComponent("UITexture")
    self.TitlePic3.gameObject:SetActive(false)
    self.AddFightLabel1 = self.Trans:Find("Center/Scroll View/Item_0/ChengHao/AddFightPoint"):GetComponent("UILabel")
    self.AddFightLabel1.gameObject:SetActive(false)
    self.AddFightLabel2 = self.Trans:Find("Center/Scroll View/Item_1/ChengHao/AddFightPoint"):GetComponent("UILabel")
    self.AddFightLabel2.gameObject:SetActive(false)
    self.AddFightLabel3 = self.Trans:Find("Center/Scroll View/Item_2/ChengHao/AddFightPoint"):GetComponent("UILabel")
    self.AddFightLabel3.gameObject:SetActive(false)
    self.MyGuildRankLabel = self.Trans:Find("Center/Bottom/MyRankTitle/MyRank"):GetComponent("UILabel")
    self.MyInGuildRankLabel = self.Trans:Find("Center/Bottom/MyGuildRankTitle/MygGuildRank"):GetComponent("UILabel")
    self.CurFuDiName = self.Trans:Find("Center/Bottom/LingDiTitle/LingDi"):GetComponent("UILabel")
    self.RankGuildBtn = self.Trans:Find("Center/Bottom/Rank2"):GetComponent("UIButton")
    self.RankInGuildBtn = self.Trans:Find("Center/Bottom/Rank1"):GetComponent("UIButton")
    self.HelpBtn = self.Trans:Find("Center/Bottom/RefreshTime/Help"):GetComponent("UIButton")
    self.RankScorll = self.Trans:Find("Center/Scroll View"):GetComponent("UIScrollView")
    UIUtils.AddBtnEvent(self.RankGuildBtn, self.OnClickGuildRank, self)
    UIUtils.AddBtnEvent(self.RankInGuildBtn, self.OnClickInGuildRank, self)
    UIUtils.AddBtnEvent(self.HelpBtn, self.OnClickHelp, self)
end

function UIFuDiRankForm:SetForm(index)
    if index>#GameCenter.FuDiSystem.RankList then
        return
    end
    local rankData = GameCenter.FuDiSystem.RankList[index]
    self:SetSelectFuDi(index)
    if rankData.MyRank == -1 then
        --china
        self.MyGuildRankLabel.text = "无"
    else
        self.MyGuildRankLabel.text = tostring(rankData.MyRank)
    end 
    --我的帮内排名
    self.MyInGuildRankLabel.text = ""
    --设置第一名
    local info = nil
    if #rankData.PersonList>=1 then
        info = rankData.PersonList[1]
        self.RankList1[1]:SetData(info)
        self.RankList1[1].Trans.gameObject:SetActive(true)
    else
        self.RankList1[1].Trans.gameObject:SetActive(false)
    end
    --设置第二阶梯排名
    for i = 2,4 do
        if i<=#rankData.PersonList then
            info = rankData.PersonList[i]
            self.RankList2[i-1]:SetData(info)
            self.RankList2[i-1].Trans.gameObject:SetActive(true)
        else
            self.RankList2[i-1].Trans.gameObject:SetActive(false)
        end
    end
    --设置第三阶梯排名
    for i = 5,10 do
        if i<=#rankData.PersonList then
            info = rankData.PersonList[i]
            self.RankList3[i-4]:SetData(info)
            self.RankList3[i-4].Trans.gameObject:SetActive(true)
        else
            self.RankList3[i-4].Trans.gameObject:SetActive(false)
        end
    end
    self.RankScorll:ResetPosition()
    --设置称号pic
    --设置称号添加的战斗力
    if 1<=#rankData.PersonList then
        local cfgId = self.CurFuDiID * 100 + 1
        self.AddFightLabel1.text = tostring(DataConfig.DataGuildTitle[cfgId].TitleFighting)
        self.AddFightLabel1.gameObject:SetActive(true)
        self.CSForm:LoadTexture(self.TitlePic1,AssetUtils.GetImageAssetPath(ImageTypeCode.UI,DataConfig.DataGuildTitle[cfgId].ShowPic))
        self.TitlePic1.gameObject:SetActive(true)
        self.RankArea1.gameObject:SetActive(true)
    else
        self.AddFightLabel1.gameObject:SetActive(false)
        self.TitlePic1.gameObject:SetActive(false)
        self.RankArea1.gameObject:SetActive(false)
    end
    if 2<=#rankData.PersonList then
        local cfgId = self.CurFuDiID * 100 + 2
        self.AddFightLabel2.text = tostring(DataConfig.DataGuildTitle[cfgId].TitleFighting)
        self.AddFightLabel2.gameObject:SetActive(true)
        self.CSForm:LoadTexture(self.TitlePic2,AssetUtils.GetImageAssetPath(ImageTypeCode.UI,DataConfig.DataGuildTitle[cfgId].ShowPic))
        self.TitlePic2.gameObject:SetActive(true)
        self.RankArea2.gameObject:SetActive(true)
    else
        self.AddFightLabel2.gameObject:SetActive(false)
        self.TitlePic2.gameObject:SetActive(false)
        self.RankArea2.gameObject:SetActive(false)
    end
    if 5<=#rankData.PersonList then
        local cfgId = self.CurFuDiID * 100 + 3
        self.AddFightLabel3.text = tostring(DataConfig.DataGuildTitle[cfgId].TitleFighting)
        self.AddFightLabel3.gameObject:SetActive(true)
        self.CSForm:LoadTexture(self.TitlePic3,AssetUtils.GetImageAssetPath(ImageTypeCode.UI,DataConfig.DataGuildTitle[cfgId].ShowPic))
        self.TitlePic3.gameObject:SetActive(true)
        self.RankArea3.gameObject:SetActive(true)
    else
        self.AddFightLabel3.gameObject:SetActive(false)
        self.TitlePic3.gameObject:SetActive(false)
        self.RankArea3.gameObject:SetActive(false)
    end
end

function UIFuDiRankForm:SetSelectFuDi(index)
    for i = 1,#self.FuDiList do
        local item = self.FuDiList[i]
        if i == index then
            item.Select.gameObject:SetActive(true)
            self.CurFuDiID = i
        else
            item.Select.gameObject:SetActive(false)
        end
    end

    --设置当前选择的福地名字
    local cfgId = self.CurFuDiID * 100 + 1
    self.CurFuDiName.text = DataConfig.DataGuildTitle[cfgId].Name
end

return UIFuDiRankForm