------------------------------------------------
--作者： 何健
--日期： 2019-05-28
--文件： UIRedPackageMainAnimation.lua
--模块： UIRedPackageMainAnimation
--描述： 在外面打开的红包界面
------------------------------------------------
local L_Item = require "UI.Forms.UIRedPacketForm.UIRedPacketViewItem"
local UIRedPackageMainAnimation = {
    --特效
    VfxConpent = nil,
    --抢红包排行信息
    RedPacketViewTrans = nil,
    RedPacketViewGo = nil,
    --发送红包的玩家名字
    SendPlayerNameLabel = nil,
    --抢得最多的玩家
    BestPlayerNameLabel = nil,
    BestNumLabel = nil,
    Grid = nil,
    GridTrans = nil,
    PlayerItem = nil,
    --我抢到的数量
    MyNumLabel = nil,
    RedPacketViewCloseBtn = nil,
    RedPacketViewTexture = nil,
    RedPacketViewTipsLabel = nil,
    --已抢光
    UnerStockGo = nil,
}

function UIRedPackageMainAnimation:OnRegisterEvents()
	self:RegisterEvent(UIEventDefine.UIRedPackageMainAnimation_OPEN, self.OnOpen)
	self:RegisterEvent(UIEventDefine.UIRedPackageMainAnimation_CLOSE, self.OnClose)
    self:RegisterEvent(LogicEventDefine.EID_EVENT_ANIMATOIN_PAGE_VIEW_RED_PACKET, self.ViewRedPacket)
end

function UIRedPackageMainAnimation:OnFirstShow()
    self:FindAllComponents()
    self.CSForm:AddScaleAnimation(self.RedPacketViewTrans, 0, 0, 1, 1, 0.4, false, false)
    self.CSForm.UIRegion = UIFormRegion.NoticRegion
end

function UIRedPackageMainAnimation:OnShowAfter()
    self.CSForm:LoadTexture(self.RedPacketViewTexture, AssetUtils.GetImageAssetPath(ImageTypeCode.UI, "tex_hongbao_close_1"))
end
function UIRedPackageMainAnimation:OnHideAfter()
    self.VfxConpent:OnDestory()
    self.RedPacketViewGo:SetActive(false)
end
function UIRedPackageMainAnimation:FindAllComponents()
    self.VfxConpent =  UnityUtils.RequireComponent(UIUtils.FindTrans(self.Trans, "Center/UIVfxSkinCompoent"),"Funcell.GameUI.Form.UIVfxSkinCompoent")
    self.RedPacketViewTrans = UIUtils.FindTrans(self.Trans, "Center/RedPacketView")
    self.RedPacketViewGo = UIUtils.FindGo(self.Trans, "Center/RedPacketView")
    self.SendPlayerNameLabel = UIUtils.FindLabel(self.RedPacketViewTrans, "RedPacket/PlayerName")
    self.BestPlayerNameLabel = UIUtils.FindLabel(self.RedPacketViewTrans, "RedPacket/Best/Name")
    self.BestNumLabel = UIUtils.FindLabel(self.RedPacketViewTrans, "RedPacket/Best/Num")
    self.Grid = UIUtils.FindGrid(self.RedPacketViewTrans, "RedPacket/ScrollView/Grid")
    self.GridTrans = UIUtils.FindTrans(self.RedPacketViewTrans, "RedPacket/ScrollView/Grid")
    self.PlayerItem = L_Item:OnFirstShow(UIUtils.FindTrans(self.RedPacketViewTrans, "RedPacket/ScrollView/Grid/Item"))
    self.RedPacketViewTipsLabel = UIUtils.FindLabel(self.RedPacketViewTrans, "RedPacket/tips/Label")
    self.MyNumLabel = UIUtils.FindLabel(self.RedPacketViewTrans, "RedPacket/Num")
    self.RedPacketViewCloseBtn = UIUtils.FindBtn(self.Trans, "Center/Back")
    UIUtils.AddBtnEvent(self.RedPacketViewCloseBtn, self.OnClickCloseBtn, self)
    self.RedPacketViewCloseBtn = UIUtils.FindBtn(self.RedPacketViewTrans, "RedPacket/Close")
    UIUtils.AddBtnEvent(self.RedPacketViewCloseBtn, self.OnClickCloseBtn, self)
    self.UnerStockGo = UIUtils.FindGo(self.Trans, "Center/RedPacketView/RedPacket/UnerStock")
    self.RedPacketViewTexture = UIUtils.FindGo(self.Trans, "Center/RedPacketView/RedPacket/Texture")
end

function UIRedPackageMainAnimation:OnOpen(obj, sender)
    self.CSForm:Show(sender)
    self:GetMoneyBack(obj)
end
--点击界面上关闭按钮
function UIRedPackageMainAnimation:OnClickCloseBtn()
    self:OnClose()
end

function UIRedPackageMainAnimation:GetMoneyBack(obj)
    if not obj then
        return
    end

    if obj == 0 then
        -- //todo:成功动画
        self.VfxConpent:OnCreateAndPlay(ModelTypeCode.UIVFX, 073, LayerUtils.UITop)
        GameCenter.RedPacketSystem:ReqGetRedPacketInfo()
    elseif obj == 1 then --//红包已经不存在了
        -- //todo：失败动画
        self:OnClose()
    elseif obj == 2 then
        -- //todo：失败动画，已经抢光
        GameCenter.RedPacketSystem:ReqGetRedPacketInfo()
    end
end

function UIRedPackageMainAnimation:ViewRedPacket(obj, sender)
    self.RedPacketViewTrans.localScale = Vector3.zero
    self.RedPacketViewGo:SetActive(true)
    self.CSForm:PlayShowAnimation(self.RedPacketViewTrans)
    self:RefreshForm()
end
function UIRedPackageMainAnimation:RefreshForm()
    local _info = GameCenter.RedPacketSystem:GetRedPacketByCheckOrGet()
    if _info == nil then
        return
    end
    self.SendPlayerNameLabel.text = _info.RoleName .. DataConfig.DataMessageString.Get("RED_PACKET_HIS_PACKET")
    local _data = GameCenter.RedPacketSystem.CheckRpPlayerInfo
    -- //取第一个值作为手气最佳
    if #_data > 0 then
        local _bestInfo = _data[1]
        self.BestPlayerNameLabel.text = _bestInfo.RoleName
        self.BestNumLabel.text = tostring(_bestInfo.Rpvalue)
    end

    --隐藏所有控件
    for i = 0, self.GridTrans.childCount - 1 do
        self.GridTrans:GetChild(i).gameObject:SetActive(false)
    end

    local _myNum = 0
    for i = 1, #_data do
        local _item = nil
        if (i > self.GridTrans.childCount) then
            _item = self.PlayerItem:Clone()
        else
            _item = L_Item:OnFirstShow(self.GridTrans:GetChild(i - 1))
        end
        _item:SetData(_data[i])
        _item.Go:SetActive(true)

        -- //设置领取信息的同时找自己领取到的金钱
        local lpId = GameCenter.GameSceneSystem:GetLocalPlayerID()
        if _data[i].RoleID == lpId then
            _myNum = _data[i].Rpvalue
        end
    end
    self.Grid.repositionNow = true
    self.MyNumLabel.text = tostring(_myNum)
    self.RedPacketViewTipsLabel.text = UIUtils.CSFormat(DataConfig.DataMessageString.Get("RED_PACKAGE_HONGBAOSHULIANG"), _info.MaxNum - _data:Count(), _info.MaxNum, _info.MaxValue)
end
return UIRedPackageMainAnimation