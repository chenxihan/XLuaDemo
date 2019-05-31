------------------------------------------------
--作者： 何健
--日期： 2019-05-27
--文件： UISendRedPacketPanel.lua
--模块： UISendRedPacketPanel
--描述： 发送红包窗体
------------------------------------------------
local L_AddReduce = require "UI.Components.UIAddReduce"
local UISendRedPacketPanel = {
    Trans = nil,
    Go = nil,
    --红包数量设置
    RedPacketNum = nil,
    CurPacketNum = 0,
    --钻石数量设置
    DiamondNum = nil,
    CurDiaNum = 0,
    --发送红包的金额
    AmountLabel = nil,
    --红包发送
    SendBtn = nil,
    --关闭发红包界面
    CloseBtn = nil,
    --最小钻石输入数量
    MinDiamond = 50,
    --最大钻石输入数量
    MaxDiamond = 300,
    --最小红包数量
    MinPacket = 10,
    --最大红包数量
    MaxPacket = 50,
    --红包类型 1为系统发，2为玩家自己发的红包
    CurPacketType = 1,
    --Data 缓存系统红包数据
    Data = nil,
    --背景
    Texture = nil,
}

--创建一个新的对象
function UISendRedPacketPanel:OnFirstShow(trans)
    local _m = Utils.DeepCopy(self)
    _m.Trans = trans
    _m.Go = trans.gameObject
    _m:FindAllComponents()
    return _m
end

--查找控件
function UISendRedPacketPanel:FindAllComponents()
    self.RedPacketNum = L_AddReduce:OnFirstShow(UIUtils.FindTrans(self.Trans, "RedPacket/PacketNumber"))
    self.RedPacketNum:SetCallBack(Utils.Handler(self.OnClickPacketAddReduce, self), Utils.Handler(self.OnClickPacketAddReduceInput, self))
    self.DiamondNum = L_AddReduce:OnFirstShow(UIUtils.FindTrans(self.Trans, "RedPacket/DiamondNumber"))
    self.DiamondNum:SetCallBack(Utils.Handler(self.OnClickDiamondAddReduce, self), Utils.Handler(self.OnClickDiamondAddReduceInput, self))
    self.AmountLabel = UIUtils.FindLabel(self.Trans, "RedPacket/Money/num")
    self.SendBtn = UIUtils.FindBtn(self.Trans, "RedPacket/SendBtn")
    self.CloseBtn = UIUtils.FindBtn(self.Trans, "RedPacket/CloseBtn")
    self.Texture = UIUtils.FindTex(self.Trans, "RedPacket/Texture")
    local _backBtn = UIUtils.FindBtn(self.Trans, "bg")
    UIUtils.AddBtnEvent(self.SendBtn, self.OnSendPackageClick, self)
    UIUtils.AddBtnEvent(self.CloseBtn, self.Close, self)
    UIUtils.AddBtnEvent(_backBtn, self.Close, self)
end

--打开
function UISendRedPacketPanel:Open(type, info)
    self.Go:SetActive(true)
    self.CurPacketType = type
    self.CurPacketNum = self.MinPacket
    self.RedPacketNum:SetValueLabel(tostring(self.MinPacket))
    GameCenter.TextureManager:LoadTexture(AssetUtils.GetImageAssetPath(ImageTypeCode.UI, "tex_hongbao_close_1"), Utils.Handler(self.LoadTexFinish,self))
    if type == 2 then
        self.DiamondNum.Go:SetActive(true)
        self.CurDiaNum = self.MinDiamond
        self.DiamondNum:SetValueLabel(tostring(self.MinDiamond))
        self.AmountLabel.text = tostring(self.MinDiamond)
    else
        self.DiamondNum.Go:SetActive(false)
        if info ~= nil then
            self.Data = info
            self.AmountLabel.text = tostring(info.maxValue)
        end
    end
end
function UISendRedPacketPanel:LoadTexFinish(tex)
    if tex.Texture == nil then
        return
    end
    self.Texture.mainTexture = tex.Texture
end
--红包发送点击
function UISendRedPacketPanel:OnSendPackageClick()
    if self.CurPacketType == 1 and self.Data ~= nil then
        GameCenter.Network.Send("MSG_redpacket.ReqSendMineRechargeRedpacket", {rpId = self.Data.rpId, maxNum = self.CurPacketNum})
    elseif self.CurPacketType == 2 then
        GameCenter.MsgPromptSystem:ShowMsgBox(UIUtils.CSFormat(DataConfig.DataMessageString.Get("RED_PACKAGE_SHIFOUYONGLANZUANFAHONGBAO"), self.CurDiaNum), function (code)
            if code == MsgBoxResultCode.Button2 then
                GameCenter.Network.Send("MSG_redpacket.ReqSendRedpacket", {maxValue = self.CurDiaNum, maxNum = self.CurPacketNum, notice = ""})
            end
        end)
    end
end

--关闭
function UISendRedPacketPanel:Close()
    GameCenter.TextureManager:UnLoadTexture(AssetUtils.GetImageAssetPath(ImageTypeCode.UI, "tex_hongbao_close_1"), Utils.Handler(self.LoadTexFinish,self))
    self.Go:SetActive(false)
end

--数量判断 是否超过上下限制
function UISendRedPacketPanel:FixPacketNum()
    if self.CurPacketNum < self.MinPacket then
        self.CurPacketNum = self.MinPacket
    end
    if self.CurPacketNum > self.MaxPacket then
        self.CurPacketNum = self.MaxPacket
    end
end
--红包数量加减
function UISendRedPacketPanel:OnClickPacketAddReduce(add)
    if add then
        self.CurPacketNum = self.CurPacketNum + 1
    else
        self.CurPacketNum = self.CurPacketNum - 1
    end

    self:FixPacketNum()
    self.RedPacketNum:SetValueLabel(tostring(self.CurPacketNum))
end

--手动输入红包数量
function UISendRedPacketPanel:OnClickPacketAddReduceInput()
    GameCenter.NumberInputSystem:OpenInput(self.MaxPacket, Vector3(-200, 0, 0), function(num)
        if num < 1 then
            num = 1
        end
        self.CurPacketNum = num
        self.RedPacketNum:SetValueLabel(tostring(num))
    end, 0, function()
        self:FixPacketNum()
        self.RedPacketNum:SetValueLabel(tostring(self.CurPacketNum))
    end)
end

--数量判断 是否超过上下限制
function UISendRedPacketPanel:FixDiaNum()
    if self.CurDiaNum < self.MinDiamond then
        self.CurDiaNum = self.MinDiamond
    end
    if self.CurDiaNum > self.MaxDiamond then
        self.CurDiaNum = self.MaxDiamond
    end
end
--钻石数量加减
function UISendRedPacketPanel:OnClickDiamondAddReduce(add)
    if add then
        self.CurDiaNum = self.CurDiaNum + 1
    else
        self.CurDiaNum = self.CurDiaNum - 1
    end

    self:FixDiaNum()
    self.AmountLabel.text = tostring(self.CurDiaNum)
    self.DiamondNum:SetValueLabel(tostring(self.CurDiaNum))
end

--手动输入钻石数量
function UISendRedPacketPanel:OnClickDiamondAddReduceInput()
    GameCenter.NumberInputSystem:OpenInput(self.MaxDiamond, Vector3(-200, 0, 0), function(num)
        if num < 1 then
            num = 1
        end
        self.CurDiaNum = num
        self.AmountLabel.text = tostring(num)
        self.DiamondNum:SetValueLabel(tostring(num))
    end, 0, function()
        self:FixDiaNum()
        self.AmountLabel.text = tostring(self.CurDiaNum)
        self.DiamondNum:SetValueLabel(tostring(self.CurDiaNum))
    end)
end
return UISendRedPacketPanel