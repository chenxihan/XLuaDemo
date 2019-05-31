------------------------------------------------
--作者： 何健
--日期： 2019-05-27
--文件： UIRedPacketViewPanel.lua
--模块： UIRedPacketViewPanel
--描述： 查看红包窗体
------------------------------------------------
local L_Item = require "UI.Forms.UIRedPacketForm.UIRedPacketViewItem"
local UIRedPacketViewPanel = {
    Trans = nil,
    Go = nil,
    --发送红包的玩家
    SendPlayerNameLabel = nil,
    --手气最好的玩家
    BestPlayerNameLabel = nil,
    BestNumLabel = nil,
    --滑动区
    Grid = nil,
    GridTrans = nil,
    PlayerItem = nil,
    --玩家自己的抢到的数量
    MyNumLabel = nil,
    --关闭
    CloseBtn = nil,
    --TIPS提示信息
    TipsLabel = nil,
    --北景
    Texture = nil,
    --动画模块
    AnimModule = nil,
}

--创建一个新的对象
function UIRedPacketViewPanel:OnFirstShow(trans)
    local _m = Utils.DeepCopy(self)
    _m.Trans = trans
    _m.Go = trans.gameObject
    _m:FindAllComponents()    
    --创建动画模块
    _m.AnimModule = UIAnimationModule(_m.Trans)
    --添加一个动画
    _m.AnimModule:AddAlphaAnimation()
    return _m
end
-- 查找控件
function UIRedPacketViewPanel:FindAllComponents()
    self.CloseBtn = UIUtils.FindBtn(self.Trans, "bg")
    UIUtils.AddBtnEvent(self.CloseBtn, self.Close, self)
    self.CloseBtn = UIUtils.FindBtn(self.Trans, "RedPacket/Close")
    UIUtils.AddBtnEvent(self.CloseBtn, self.Close, self)
    self.Texture = UIUtils.FindTex(self.Trans, "RedPacket/Texture")
    self.TipsLabel = UIUtils.FindLabel(self.Trans, "RedPacket/tips/Label")
    self.SendPlayerNameLabel = UIUtils.FindLabel(self.Trans, "RedPacket/PlayerName")
    self.BestPlayerNameLabel = UIUtils.FindLabel(self.Trans, "RedPacket/Best/Name")
    self.BestNumLabel = UIUtils.FindLabel(self.Trans, "RedPacket/Best/Num")
    self.MyNumLabel = UIUtils.FindLabel(self.Trans, "RedPacket/Num")
    self.Grid = UIUtils.FindGrid(self.Trans, "RedPacket/ScrollView/Grid")
    self.GridTrans = UIUtils.FindTrans(self.Trans, "RedPacket/ScrollView/Grid")
    self.PlayerItem = L_Item:OnFirstShow(UIUtils.FindTrans(self.Trans, "RedPacket/ScrollView/Grid/Item"))
end

--打开
function UIRedPacketViewPanel:Open()
    self.Go:SetActive(true)
    GameCenter.TextureManager:LoadTexture(AssetUtils.GetImageAssetPath(ImageTypeCode.UI, "tex_hongbao_close_1"), Utils.Handler(self.LoadTexFinish,self))
    self.Trans.localScale = Vector3.zero
    self.AnimModule:RemoveTransAnimation(self.Trans)
    self.AnimModule:AddScaleAnimation(self.Trans, 0, 0, 1, 1, 0.4, false, false)
    self.AnimModule:PlayShowAnimation(self.Trans)
    self:RefreshForm()
end
--关闭
function UIRedPacketViewPanel:Close()
    GameCenter.TextureManager:UnLoadTexture(AssetUtils.GetImageAssetPath(ImageTypeCode.UI, "tex_hongbao_close_1"), Utils.Handler(self.LoadTexFinish,self))
    self.Go:SetActive(false)
end
--texture加载回调
function UIRedPacketViewPanel:LoadTexFinish(tex)
    if tex.Texture == nil then
        return
    end
    self.Texture.mainTexture = tex.Texture
end

function UIRedPacketViewPanel:RefreshForm()
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
    self.TipsLabel.text = UIUtils.CSFormat(DataConfig.DataMessageString.Get("RED_PACKAGE_HONGBAOSHULIANG"), _info.MaxNum - _data:Count(), _info.MaxNum, _info.MaxValue)
end
return UIRedPacketViewPanel