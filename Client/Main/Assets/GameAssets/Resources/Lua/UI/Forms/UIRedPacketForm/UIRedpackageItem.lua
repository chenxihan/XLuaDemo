------------------------------------------------
--作者： 何健
--日期： 2019-05-28
--文件： UIRedpackageItem.lua
--模块： UIRedpackageItem
--描述： 红包列表中的子项
------------------------------------------------

local UIRedpackageItem = {
    Trans = nil,
    Go = nil,
    PlayerNameLabel = nil,
    TipsLabel = nil,
    StateOpenGo = nil,
    StateLabel = nil,
    StateGiveGo = nil,
    MoneyLabel = nil,
    Texture = nil,
    Parent = nil,
    Data = nil,
}
--创建一个新的对象
function UIRedpackageItem:OnFirstShow(trans, parent)
    local _m = Utils.DeepCopy(self)
    _m.Trans = trans
    _m.Go = trans.gameObject
    _m.Parent = parent
    _m:FindAllComponents()
    return _m
end

--克隆一个
function UIRedpackageItem:Clone()
    local _go = UnityUtils.Clone(self.Go)
    return self:OnFirstShow(_go.transform)
end

--查找控件
function UIRedpackageItem:FindAllComponents()
    self.PlayerNameLabel = UIUtils.FindLabel(self.Trans, "PlayerName")
    self.TipsLabel = UIUtils.FindLabel(self.Trans, "Tips")
    self.StateLabel = UIUtils.FindLabel(self.Trans, "State/Label")
    self.MoneyLabel = UIUtils.FindLabel(self.Trans, "Money")
    self.StateGiveGo = UIUtils.FindGo(self.Trans, "State/Give")
    self.StateOpenGo = UIUtils.FindGo(self.Trans, "State/Open")
    self.Texture = UIUtils.FindTex(self.Trans, "BG")

    local _btn = self.Trans:GetComponent("UIButton")
    UIUtils.AddBtnEvent(_btn, self.OnClickBtn, self)
end

function UIRedpackageItem:OnClickBtn()
    if (self.Data.OwnType == 1) then   --//自有红包
       GameCenter.PushFixEvent(LogicEventDefine.EID_EVENT_OPEN_SENDPACKETREDSYSTEM, self.Data)
    else
        if self.Data.Mark then
            GameCenter.Network.Send("MSG_redpacket.ReqGetRedPacketInfo", {rpId = self.Data.RpID})
        else
            if self.Data.CurNum == 0 then
                GameCenter.Network.Send("MSG_redpacket.ReqGetRedPacketInfo", {rpId = self.Data.RpID})
            else
                GameCenter.Network.Send("MSG_redpacket.ReqClickRedpacket", {rpId = self.Data.RpID})
            end
        end
    end
end

function UIRedpackageItem:RefreshInfo(info)
    self.Data = info
    self.PlayerNameLabel.text = info.RoleName
    self.TipsLabel.text = GameCenter.LanguageConvertSystem:ConvertLan(info.Demo)
    self.MoneyLabel.text = info.MaxValue
    self.Parent:UnloadTexture(self.Texture)
    if info.OwnType == 1 then --//自有红包
        self.StateOpenGo:SetActive(false)
        self.StateLabel.text = ""
        self.StateGiveGo:SetActive(true)
        self.Parent:LoadTexture(self.Texture, AssetUtils.GetImageAssetPath(ImageTypeCode.UI, "tex_hongbao_close"))
    else
        if info.Mark then
            self.StateOpenGo:SetActive(false)
            self.StateLabel.text = DataConfig.DataMessageString.Get("RED_PACKET_GOTED")
            self.StateLabel.color = Color.green
            self.StateGiveGo:SetActive(false)
            self.Parent:LoadTexture(self.Texture, AssetUtils.GetImageAssetPath(ImageTypeCode.UI, "tex_hongbao_open"))
        else
            if info.CurNum == 0 then
                self.StateOpenGo:SetActive(false)
                self.StateLabel.text = DataConfig.DataMessageString.Get("RED_PACKET_NO_PACKET")
                self.StateLabel.color = Color.red;
                self.StateGiveGo:SetActive(false)
                -- 查看红包
                self.Parent:LoadTexture(self.Texture, AssetUtils.GetImageAssetPath(ImageTypeCode.UI, "tex_hongbao_open1"))
            else
                self.StateOpenGo:SetActive(true)
                self.StateGiveGo:SetActive(false)
                self.StateLabel.text = ""
                self.Parent:LoadTexture(self.Texture, AssetUtils.GetImageAssetPath(ImageTypeCode.UI, "tex_hongbao_close"))
            end
        end
    end
end
return UIRedpackageItem