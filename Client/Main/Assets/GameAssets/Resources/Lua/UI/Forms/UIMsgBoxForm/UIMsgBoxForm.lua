------------------------------------------------
--作者： dhq
--日期： 2019-03-25
--文件： MsgBoxForm.lua
--模块： MsgBoxForm
--描述： 消息提示框
------------------------------------------------
local MsgPromptSystem = CS.Funcell.Code.Logic.MsgPromptSystem
local UIEventDefine = CS.Funcell.Plugins.Common.UIEventDefine
local MsgBoxSelectInfo = CS.Funcell.Code.Logic.MsgBoxSelectInfo

--//模块定义
local UIMsgBoxForm = {
    CN_BUTTON_SPACE_HALF = 10,
    --主心跳处理TimeTicker
    MainTicker = nil,
    --背景的图片
    BgSprite = nil,
    --背景的按钮信息
    BigBgCloseButton = nil,
    --按钮1
    Button1 = nil,
    ButtonText1 = nil,
    ButtonSprite1 = nil,
    --按钮2
    Button2 = nil,
    ButtonText2 = nil,
    ButtonSprite2 = nil,
    --信息文本
    InformationText = nil,
    --信息对象的位置
    InfomationTrans = nil,
    --自动隐藏的倒计时CD
    CdProgressBar = nil,
    --当前消息MsgBoxInfo
    CurrentMsgInfo = nil,
    --消息队列 List<MsgBoxInfo>
    MsgQueue = List:New(),
    --如果是两个按钮的话,按钮的位置的X分量的绝对值
    BtnPosX = 90,
    --选择框
    SelectBtn = nil,
    SelectSpriteTran = nil,
    SelectLabel = nil,
}

--继承Form函数
function UIMsgBoxForm:OnRegisterEvents()
    self:RegisterEvent(UIEventDefine.UIMESSAGEBOX_OPEN, self.OnOpen)
    self:RegisterEvent(UIEventDefine.UIMESSAGEBOX_SHOWINFO,self.OnSetInfoHandler);
    self:RegisterEvent(UIEventDefine.UIMESSAGEBOX_CLOSE, self.OnClose)
end

function UIMsgBoxForm:OnFirstShow()
    self:FindAllComponents()
    self.CSForm.UIRegion = CS.Funcell.Plugins.Common.UIFormRegion.TopRegion;
end

function UIMsgBoxForm:FindAllComponents()
    local _trans = self.CSForm.transform
    self.MainTicker = CS.Funcell.Core.Base.TimeTicker(1, self.OnTickerHandler, false);
    --读取背景的图片
    self.BgSprite = UIUtils.FindSpr(_trans,"Base/Frame")
    self.BgTex = UIUtils.FindTex(_trans, "Texture")
    --大背景关闭按钮
    self.BigBgCloseButton = UIUtils.FindBtn(_trans,"Base/BigBg")
    --Button1的信息
    self.Button1 = UIUtils.FindBtn(_trans,"Controller/Button_1")
    self.ButtonText1 = UIUtils.FindLabel(_trans, "Controller/Button_1/Text")
    self.ButtonSprite1 = UIUtils.FindSpr(_trans,"Controller/Button_1")
    --按钮的宽度
    --local widget = UIUtils.FindWid(_trans,"Controller/Button_1/UIWidget")
    local w = self.Button1.tweenTarget:GetComponent("UIWidget").width
    --计算按钮的位置
    self.BtnPosX = w / 2 + self.CN_BUTTON_SPACE_HALF;

    --Button2的信息
    self.Button2 = UIUtils.FindBtn(_trans,"Controller/Button_2")
    self.ButtonText2 = UIUtils.FindLabel(_trans, "Controller/Button_2/Text")
    self.ButtonSprite2 = UIUtils.FindSpr(_trans,"Controller/Button_2")
    
    --显示信息的
    self.InfomationTrans = UIUtils.FindTrans(_trans,"InformationText")
    self.InformationText = UIUtils.FindLabel(_trans, "InformationText/Text")

    --cd处理
    -- UIUtils.FindProgressBar(_trans, "CD/ProgressBar")
    self.CdProgressBar = UIUtils.FindTrans(_trans, "CD/ProgressBar"):GetComponent("UIProgressBar")
    self.SelectBtn = UIUtils.FindBtn(_trans,"SelectRoot/SelectBtn")
    self.SelectSpriteTran = UIUtils.FindSpr(_trans,"SelectRoot/SelectBtn/Sprite")
    self.SelectLabel = UIUtils.FindLabel(_trans, "SelectRoot/Label")
    UIUtils.AddBtnEvent(self.SelectBtn, self.OnClickSelectBtn, self)
    UIUtils.AddBtnEvent(self.Button1, self.OnMessageFinished, self)
    UIUtils.AddBtnEvent(self.Button2, self.OnMessageFinished, self)
end

function UIMsgBoxForm:OnHideBefore()
    self.MainTicker:SetEnable(false)
    self.CdProgressBar.value = 0
    self.MsgQueue:Clear()
    self.CurrentMsgInfo = nil
end

function UIMsgBoxForm:Update()
    if self.MainTicker ~= nil then
        self.MainTicker:Update(CS.Time.deltaTime)
        if (self.MainTicker:GetEnable() == true and self.CurrentMsgInfo ~=nil and self.CurrentMsgInfo:IsAutoHide() == true) then
            local value = self.CdProgressBar.value - CS.Time.deltaTime
            self.CdProgressBar.value = value / self.CurrentMsgInfo.ShowLifeTime
        end
    end
end

--外部发来的消息处理
function UIMsgBoxForm:OnSetInfoHandler(obj, sender)
    local newMsg = obj;
    if newMsg ~= nil then
        if self.CSForm.IsVisible == false then
            self.CSForm:Show(sender);
            self.CSForm:LoadTexture(self.BgTex, AssetUtils.GetImageAssetPath(ImageTypeCode.UI, "bag_storebg"))
        end

        if self.CurrentMsgInfo == nil then
            --显示新的消息
            self:SetInfo(newMsg);
        else
            if (newMsg.MsgBoxInfoType >= CS.MsgBoxInfo.MsgBoxInfoTypeCode.AlwaysLatestBegin and newMsg.MsgBoxInfoType == self.CurrentMsgInfo.MsgBoxInfoType) then
                --一直展示最后一个,前面的消息会被丢弃掉.
                self:SetInfo(newMsg)
            else
                if (self.CurrentMsgInfo.Priority < newMsg.Priority) then
                    --把当前消息放入到队列中
                    self.MsgQueue:Insert(0, self.CurrentMsgInfo);
                    --显示新的消息
                    self:SetInfo(newMsg);
                else
                    --把新消息放到队列中
                    self.MsgQueue:Add(newMsg)
                end
            end
        end
    end
end

--针对那些自动关闭的消息的回调
function UIMsgBoxForm:OnTickerHandler()
    self.MainTicker:SetEnable(false);
    self.CdProgressBar.value = 0;
    self:OnMessageFinished();
end

--某个消息处理完毕后的回调
function UIMsgBoxForm:OnMessageFinished()
    if (self.CurrentMsgInfo == nil) then
        return
    end
    if (self.CurrentMsgInfo.OnCallBack ~= nil) then
        if (CS.UIButton.current == self.Button1) then
            self.CurrentMsgInfo.OnCallBack(MsgBoxResultCode.Button1)
        elseif (CS.UIButton.current == self.Button2) then
            self.CurrentMsgInfo.OnCallBack(MsgBoxResultCode.Button2);
        else
            self.CurrentMsgInfo.OnCallBack(MsgBoxResultCode.None);
        end
    end
    --下一个消息
    if (self:SetInfo(self:DeQueue()) == false) then
        --如果消息队列中没有消息了,那么关闭
        self.CSForm:Hide()
    end
end

--点击选择框
function UIMsgBoxForm:OnClickSelectBtn()
    local state = self.SelectSpriteTran.gameObject.activeSelf;
    if state == true then
        state = false
    end
    self.SelectSpriteTran.gameObject:SetActive(state);
    local info = self.CurrentMsgInfo
    if (info.OnSelectCallBack ~= nil) then
        info:OnSelectCallBack(state);
    end
end

function UIMsgBoxForm:SetInfo(info)
    self.CurrentMsgInfo = info
    if self.CurrentMsgInfo ~= nil then
        self:SetAlphaValue()
        self:SetAutoHide()
        self:SetInfomationText()
        self:SetButtonActive()
        self:SetButtonSprite()
        self:SetButtonText()
        self:SetButtonCallBack()
        self:SetButtonPosition()
        self:ShowSelectBtn()
        return true
    end
    return false
end

--设置Alpha
function UIMsgBoxForm:SetAlphaValue()
    -- if self.BgSprite ~= nil then
    --     self.BgSprite.alpha = self.CurrentMsgInfo.AlphaValue;
    -- end
    if self.BgTex ~= nil then
        self.BgTex.alpha = self.CurrentMsgInfo.AlphaValue;
    end
    if self.CurrentMsgInfo.Button1 ~= nil then
        self.ButtonSprite1.alpha = self.CurrentMsgInfo.AlphaValue
    end
    if self.CurrentMsgInfo.Button2 ~= nil then
        self.ButtonSprite2.alpha = self.CurrentMsgInfo.AlphaValue;
    end
end

--设置是否自动隐藏
function UIMsgBoxForm:SetAutoHide()
    if (self.CurrentMsgInfo.IsAutoHide and self.CurrentMsgInfo.ShowLifeTime > 0) then
        self.CdProgressBar.gameObject:SetActive(true);
        self.CdProgressBar.value = 1;
        self.MainTicker:Reset(self.CurrentMsgInfo.ShowLifeTime);
        self.MainTicker:SetEnable(true);
    else
        self.MainTicker:SetEnable(false);
        self.CdProgressBar.gameObject:SetActive(false);
    end
end
--设置提示信息
function UIMsgBoxForm:SetInfomationText()
    self.InformationText.text = self.CurrentMsgInfo.Msg;
    --设置文本的位置.
    if (self.CurrentMsgInfo.Button1 == nil and self.CurrentMsgInfo.Button2 == nil) then
        self.InfomationTrans.localPosition = Vector3.zero;
    else
        self.InfomationTrans.localPosition = Vector3(0, 35, 0);
    end
end

--设置按钮是否被激活
function UIMsgBoxForm:SetButtonActive()
    self.Button1.gameObject:SetActive(self.CurrentMsgInfo.Button1 ~= nil);
    self.Button2.gameObject:SetActive(self.CurrentMsgInfo.Button2 ~= nil);
end

--设置按钮的图片
function UIMsgBoxForm:SetButtonSprite()
    if (self.CurrentMsgInfo.Button1 ~= nil and self.CurrentMsgInfo.Button1.resName ~= nil) then
        self.Button1.normalSprite = self.CurrentMsgInfo.Button1.resName;
        self.Button1.hoverSprite = self.CurrentMsgInfo.Button1.resName;
        self.Button1.pressedSprite = self.CurrentMsgInfo.Button1.resName;
        self.Button1.disabledSprite = self.CurrentMsgInfo.Button1.resName;
    end
    if (self.CurrentMsgInfo.Button2 ~= nil) then
        self.Button2.normalSprite = self.CurrentMsgInfo.Button2.resName;
        self.Button2.hoverSprite = self.CurrentMsgInfo.Button2.resName;
        self.Button2.pressedSprite = self.CurrentMsgInfo.Button2.resName;
        self.Button2.disabledSprite = self.CurrentMsgInfo.Button2.resName;
    end
end

--设置按钮的文本
function UIMsgBoxForm:SetButtonText()
    if (self.CurrentMsgInfo.Button1 ~= nil) then
        self.ButtonText1.text = self.CurrentMsgInfo.Button1.buttonName;
    end
    if (self.CurrentMsgInfo.Button2 ~= nil) then
        self.ButtonText2.text = self.CurrentMsgInfo.Button2.buttonName;
    end
end

--设置按钮的回调
function UIMsgBoxForm:SetButtonCallBack()
    if (self.CurrentMsgInfo.IsClickBGClose) then
        UIUtils.AddBtnEvent(self.BigBgCloseButton, self.OnMessageFinished, self)
    end
end

--设置按钮的位置
function UIMsgBoxForm:SetButtonPosition()
    if (self.CurrentMsgInfo.Button1 ~= nil and self.CurrentMsgInfo.Button2 ~= nil) then
        self.Button1.transform.localPosition = Vector3(-self.BtnPosX, 0, 0);
        self.Button2.transform.localPosition = Vector3(self.BtnPosX, 0, 0);
    else
        self.Button1.transform.localPosition = Vector3.zero;
        self.Button2.transform.localPosition = Vector3.zero;
    end
end

--往消息队列中写数据
function UIMsgBoxForm:EnQueue(msgBoxInfo)
    if msgBoxInfo == nil then
        return
    end
    MsgPromptSystem.EnQueue(self.MsgQueue, msgBoxInfo)
end

--从消息队列中读取数据
function UIMsgBoxForm:DeQueue()
    if self.MsgQueue ~= nil then
        MsgPromptSystem:DeQueueMsgBoxInfo(self.MsgQueue);
    end
end

--设置选择框
function UIMsgBoxForm:ShowSelectBtn()
    if (type(self.CurrentMsgInfo) == self.MsgBoxSelectInfo) then
        local info = self.CurrentMsgInfo
        self.SelectBtn.transform.parent.gameObject:SetActive(true);
        self.SelectSpriteTran.gameObject:SetActive(false);
        self.SelectLabel.text = info.SelectText;
    else
        self.SelectBtn.transform.parent.gameObject:SetActive(false);
    end
end

return UIMsgBoxForm;