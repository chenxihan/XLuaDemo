------------------------------------------------
--作者： _SqL_
--日期： 2019-04-23
--文件： UIReportForm.lua
--模块： UIReportForm
--描述： 举报界面
------------------------------------------------

local UIReportForm = {
    PlayerID = nil,
    CloseBtn = nil,
    TypeOneBtn = nil,
    TypeTwoBtn = nil,
    TypeThreeBtn = nil,
    TypeOtherBtn = nil,
    SureBtn = nil,
    InputComp = nil,
    CurrSelectBtn = nil,
    IsOtherType = false,                            -- 是否是其它原因
    ReportType = 0,                                 -- 举报类型 1，2，3，4
    AnimMoudle = nil,
}

function  UIReportForm:OnRegisterEvents()
    self:RegisterEvent(UIEventDefine.UIReportForm_OPEN,self.OnOpen)
    self:RegisterEvent(UIEventDefine.UIReportForm_CLOSE,self.OnClose)
end

function UIReportForm:OnFirstShow()
    self:FindAllComponents()
    self:OnRegUICallBack()
    self:InitForm()
end

function UIReportForm:FindAllComponents()
    local _trans = self.CSForm.transform
    self.CloseBtn = UIUtils.FindBtn(_trans, "Center/CloseButton")
    self.TypeOneBtn = UIUtils.FindBtn(_trans, "Center/Offset/TypeOneBtn")
    self.TypeTwoBtn = UIUtils.FindBtn(_trans, "Center/Offset/TypeTwoBtn")
    self.TypeThreeBtn = UIUtils.FindBtn(_trans, "Center/Offset/TypeThreeBtn")
    self.TypeOtherBtn = UIUtils.FindBtn(_trans, "Center/Offset/TypeOtherBtn")
    self.SureBtn = UIUtils.FindBtn(_trans, "Center/Offset/SureBtn")
    self.InputComp = UIUtils.FindInput(_trans, "Center/Offset/Other/InputFiled")

    UIUtils.FindTrans(self.TypeOneBtn.transform, "selection").gameObject:SetActive(false)
    UIUtils.FindTrans(self.TypeTwoBtn.transform, "selection").gameObject:SetActive(false)
    UIUtils.FindTrans(self.TypeThreeBtn.transform, "selection").gameObject:SetActive(false)
    UIUtils.FindTrans(self.TypeOtherBtn.transform, "selection").gameObject:SetActive(false)

    self.AnimMoudle = UIAnimationModule(_trans)
    self.AnimMoudle:AddAlphaAnimation()
end

function UIReportForm:InitForm()
    UIUtils.FindLabel(self.TypeOneBtn.transform, "content").text = "发布广告/代充"
    UIUtils.FindLabel(self.TypeTwoBtn.transform, "content").text = "诱导添加微信"
    UIUtils.FindLabel(self.TypeThreeBtn.transform, "content").text = "非法外挂"
    UIUtils.FindLabel(self.TypeOtherBtn.transform, "content").text = "其它"
end

function UIReportForm:OnSelectedClick(t)
    if self.CurrSelectBtn then
        UIUtils.FindTrans(self.CurrSelectBtn.transform, "selection").gameObject:SetActive(false)
    end
    UIUtils.FindTrans(t.Btn.transform, "selection").gameObject:SetActive(true)
    if t.Othen then
        self.IsOtherType = true
    else
        self.IsOtherType = false
    end
    self.CurrSelectBtn = t.Btn
    self.ReportType = t.Type
end

function UIReportForm:OnSureBtnClick()
    if self.PlayerID == 0 then
        Debug.LogError("PlayerId Error!!!")
        return
    end
    if self.ReportType == 0 then
        GameCenter.MsgPromptSystem:ShowPrompt("未选中举报类型")
        return
    end
    if self.IsOtherType then
        local _miniLength = tonumber(Utils.SplitStr(DataConfig.DataGlobal[1475].Params,"_")[1])
        local _maxLength = tonumber(Utils.SplitStr(DataConfig.DataGlobal[1475].Params,"_")[2])
        if #self.InputComp.value < _miniLength then
            GameCenter.MsgPromptSystem:ShowPrompt(string.format("最少输入%d个字符", _miniLength))
            return
        elseif #self.InputComp.value > _maxLength then
            GameCenter.MsgPromptSystem:ShowPrompt(string.format("最多输入%d个字符", _maxLength))
            return
        end
    end
    GameCenter.FriendSystem:ReqReport(self.PlayerID, self.ReportType, self.InputComp.value)
    GameCenter.MsgPromptSystem:ShowPrompt( "举报成功" )
end

function UIReportForm:LoadBgTex()
    local _bgTex = UIUtils.FindTex(self.CSForm.transform, "Center/Back")
    self.CSForm:LoadTexture(_bgTex, AssetUtils.GetImageAssetPath(ImageTypeCode.UI, "bag_storebg"))
end

function UIReportForm:OnRegUICallBack()
    UIUtils.AddBtnEvent(self.CloseBtn, self.OnCLose, self)
    UIUtils.AddBtnEvent(self.SureBtn, self.OnSureBtnClick, self)
    UIUtils.AddBtnEvent(
        self.TypeOneBtn, self.OnSelectedClick, self, {Btn = self.TypeOneBtn, Type = 1})
    UIUtils.AddBtnEvent(
        self.TypeTwoBtn, self.OnSelectedClick, self, {Btn = self.TypeTwoBtn, Type = 2})
    UIUtils.AddBtnEvent(
        self.TypeThreeBtn, self.OnSelectedClick, self, {Btn = self.TypeThreeBtn, Type = 3})
    UIUtils.AddBtnEvent(
        self.TypeOtherBtn, self.OnSelectedClick, self, {Btn = self.TypeOtherBtn, Type = 1, Othen = true})
    end

function UIReportForm:OnOpen(obj, sender)
    self.CSForm:Show(sender)
    self:LoadBgTex()
    if obj then
        self.PlayerID = obj
    end
    self.AnimMoudle:PlayEnableAnimation()
end

function UIReportForm:OnCLose(obj, sender)
    self.CSForm:Hide()
end

return UIReportForm