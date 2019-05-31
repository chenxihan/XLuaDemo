------------------------------------------------
--作者： 何健
--日期： 2019-05-27
--文件： UIRedPacketForm.lua
--模块： UIRedPacketForm
--描述： 红包窗体处理
------------------------------------------------
local L_SendPanel = require "UI.Forms.UIRedPacketForm.UISendRedPacketPanel"
local L_RedPacketItem = require "UI.Forms.UIRedPacketForm.UIRedpackageItem"
local L_CheckPanel = require "UI.Forms.UIRedPacketForm.UIRedPacketViewPanel"
local UIRedPacketForm = {
    CloseBtn = nil,
    --发送红包按钮，点击打开红包发送界面
    SendPacketBtn = nil,
    --发送红包界面
    SendPanel = nil,
    -- 查看界面
    CheckPanel = nil,
    --日志
    RecordLoopScroll = nil,
    RecordLoopTrans = nil,
    RecordScroll = nil,
    --红包
    RedPacketLoopScroll = nil,
    RedPacketLoopTrans = nil,
    --特效
    VfxConpent = nil,
}

function UIRedPacketForm:OnRegisterEvents()
	self:RegisterEvent(UIEventDefine.UIRedPacketForm_OPEN, self.OnOpen)
	self:RegisterEvent(UIEventDefine.UIRedPacketForm_CLOSE, self.OnClose)
    self:RegisterEvent(LogicEventDefine.EID_EVENT_UPDATE_REDPACKET_LOG, self.Refreshlog)
    self:RegisterEvent(LogicEventDefine.EID_EVENT_CLOSE_PACKAGE_PACKET_PANEL, self.ClosePackagePacketPanel)
    self:RegisterEvent(LogicEventDefine.EID_EVENT_UPDATE_RED_PACKKET, self.RefreshRedPackage)
    self:RegisterEvent(LogicEventDefine.EID_EVENT_GET_PACKET_BACK, self.GetMoneyBack)
    self:RegisterEvent(LogicEventDefine.EID_EVENT_VIEW_RED_PACKET, self.ViewRedPacket)
    self:RegisterEvent(LogicEventDefine.EID_EVENT_OPEN_SENDPACKETREDSYSTEM, self.OnSendSystemRedPacket)
end
function UIRedPacketForm:OnFirstShow()
    self:FindAllComponents()
    self.CSForm:AddAlphaAnimation()
    self.RecordLoopScroll:SetDelegate(Utils.Handler(self.OnRecordChange, self))
    self.RedPacketLoopScroll:SetDelegate(Utils.Handler(self.OnRedPackageChange, self))
end
function UIRedPacketForm:OnShowAfter()
    GameCenter.RedPacketSystem.IsOpenPanel = true
    GameCenter.Network.Send("MSG_redpacket.ReqRedpacketList", {})
    self.CheckPanel:Close()
    self.SendPanel:Close()
end
function UIRedPacketForm:OnHideAfter()
    GameCenter.RedPacketSystem.IsOpenPanel = false
    self.VfxConpent:OnDestory()
end
function UIRedPacketForm:FindAllComponents()
    self.CloseBtn = UIUtils.FindBtn(self.Trans, "CloseBtn")
    UIUtils.AddBtnEvent(self.CloseBtn, self.OnCloseBtnClick, self)
    self.SendPacketBtn = UIUtils.FindBtn(self.Trans, "Bottom/PackageRedPacket")
    UIUtils.AddBtnEvent(self.SendPacketBtn, self.OnSendPacketBtnClick, self)
    self.SendPanel = L_SendPanel:OnFirstShow(UIUtils.FindTrans(self.Trans, "Center/SendRedPacket"))
    self.CheckPanel = L_CheckPanel:OnFirstShow(UIUtils.FindTrans(self.Trans, "Center/RedPacketView"))
    self.RecordScroll = UIUtils.FindScrollView(self.Trans, "Left/RecordBg/RecordScrollView")
    self.RecordLoopScroll =  UnityUtils.RequireComponent(UIUtils.FindTrans(self.Trans, "Left/RecordBg/RecordScrollView/Grid"),"Funcell.Plugins.Common.UILoopScrollViewBase")
    self.RecordLoopTrans = UIUtils.FindTrans(self.Trans, "Left/RecordBg/RecordScrollView/Grid")
    self.RedPacketLoopScroll =  UnityUtils.RequireComponent(UIUtils.FindTrans(self.Trans, "Center/RedpacketBg/ScrollView/Grid"),"Funcell.Plugins.Common.UILoopScrollViewBase")
    self.RedPacketLoopTrans = UIUtils.FindTrans(self.Trans, "Center/RedpacketBg/ScrollView/Grid")
    self.VfxConpent =  UnityUtils.RequireComponent(UIUtils.FindTrans(self.Trans, "Center/UIVfxSkinCompoent"),"Funcell.GameUI.Form.UIVfxSkinCompoent")
end

--界面关闭按钮
function UIRedPacketForm:OnCloseBtnClick()
    self:OnClose()
end
--发红包按钮
function UIRedPacketForm:OnSendPacketBtnClick()
    self.SendPanel:Open(2)
end
function UIRedPacketForm:ClosePackagePacketPanel(obj, sender)
    self.SendPanel:Close()
end

--打开发送红包界面，系统红包
function UIRedPacketForm:OnSendSystemRedPacket(obj, sender)
    self.SendPanel:Open(1, obj)
end

--查看红包消息返回，打开查看界面
function UIRedPacketForm:ViewRedPacket(obj, sender)
    self.CheckPanel:Open()
end

--结果返回
function UIRedPacketForm:GetMoneyBack(obj, sender)
    -- //成功
    if (obj == 0) then
        -- //todo:成功动画
        self.VfxConpent:OnCreateAndPlay(ModelTypeCode.UIVFX, 073, LayerUtils.UITop);
        GameCenter.RedPacketSystem:ReqGetRedPacketInfo()
    elseif (obj == 2) then
        -- //todo：失败动画，已经抢光
        GameCenter.RedPacketSystem:ReqGetRedPacketInfo()
    end
    -- //抢红包后刷新红包界面状态
    GameCenter.Network.Send("MSG_redpacket.ReqRedpacketList", {})
end

--刷新日志
function UIRedPacketForm:Refreshlog(obj, sender)
    for i = 0, self.RecordLoopTrans.childCount - 1 do
        self.RecordLoopTrans:GetChild(i).gameObject:SetActive(false)
    end
    self.RecordLoopScroll:Init(GameCenter.RedPacketSystem.RpLogList:Count())
    self.RecordScroll:ResetPosition()
end

--刷新红包
function UIRedPacketForm:RefreshRedPackage(obj, sender)
    for i = 0, self.RedPacketLoopTrans.childCount - 1 do
        self.RedPacketLoopTrans:GetChild(i).gameObject:SetActive(false)
    end
    self.RedPacketLoopScroll:Init(GameCenter.RedPacketSystem.RpInfoList:Count());
end

--刷新一条日志
function UIRedPacketForm:OnRecordChange(trans, name, isClear)
    local index = tonumber(trans.name)
    local item = GameCenter.RedPacketSystem.RpLogList[index]
    if item ~= nil then
        local content = UIUtils.FindLabel(trans, "content")
        content.text = self:GetReason(item)
        trans.gameObject:SetActive(true)
    end
end

--刷新一条红包数据
function UIRedPacketForm:OnRedPackageChange(trans, name, isClear)
    local index = tonumber(trans.name)
    local data = GameCenter.RedPacketSystem.RpInfoList[index]
    if data ~= nil then
        local item = L_RedPacketItem:OnFirstShow(trans, self.CSForm)
        item.Go:SetActive(true)
        item:RefreshInfo(data)
    end
end

--获取日志描述
function UIRedPacketForm:GetReason(log)
    local time = Time.StampToDateTime(log.SendTime)
    local reason = UIUtils.CSFormat(DataConfig.DataMessageString.Get("RED_PACKAGE_WANJIAMINGZI"), time, log.RoleName)
    local FenXiang = DataConfig.DataMessageString.Get("REDPACKAGE_FENXIANG")

    if log.Reason == 1 then
        reason = reason .. UIUtils.CSFormat(DataConfig.DataMessageString.Get("RED_PACKET_SHOU_CHONG"), log.Huozhuang)
    elseif log.Reason == 2 then
        reason = reason .. UIUtils.CSFormat(DataConfig.DataMessageString.Get("RED_PACKET_LEI_JI_CHONG_ZHI"), log.Value, log.Huozhuang)
    elseif log.Reason == 3 then
        reason = reason .. UIUtils.CSFormat(DataConfig.DataMessageString.Get("RED_PACKET_MEI_RI_SHOU_CHONG"), log.Huozhuang)
    elseif log.Reason == 4 then
        reason = reason .. UIUtils.CSFormat(DataConfig.DataMessageString.Get("RED_PACKET_MEI_RI_LEI_JI_CHONG_ZHI"), log.Value, log.Huozhuang)
    elseif log.Reason == 5 then
        reason = reason .. UIUtils.CSFormat(DataConfig.DataMessageString.Get("RED_PACKET_WAN_JIA_FA_FANG"), log.Huozhuang)
    elseif log.Reason == 6 then
        reason = reason .. UIUtils.CSFormat(DataConfig.DataMessageString.Get("RED_PACKET_SHOU_CHONG"), log.Huozhuang)
        reason = reason .. FenXiang
    elseif log.Reason == 7 then
        reason = reason .. UIUtils.CSFormat(DataConfig.DataMessageString.Get("RED_PACKET_LEI_JI_CHONG_ZHI"), log.Value, log.Huozhuang);
        reason = reason .. FenXiang
    elseif log.Reason == 8 then
        reason = reason .. UIUtils.CSFormat(DataConfig.DataMessageString.Get("RED_PACKET_MEI_RI_SHOU_CHONG"), log.Huozhuang);
        reason = reason .. FenXiang
    elseif log.Reason == 9 then
        reason = reason .. UIUtils.CSFormat(DataConfig.DataMessageString.Get("RED_PACKET_MEI_RI_LEI_JI_CHONG_ZHI"), log.Value, log.Huozhuang);
        reason = reason .. FenXiang
    end
    return reason
end
return UIRedPacketForm