------------------------------------------------
--作者： 何健
--日期： 2019-05-30
--文件： UIItemBatchForm.lua
--模块： UIItemBatchForm
--描述： 物品批量使用界面
------------------------------------------------
local L_ItemBase = CS.Funcell.Code.Logic.ItemBase
local UIItemBatchForm = {
    --背景，用于计算位置
    BackTrans = nil,
    --数量
    InPutLabel = nil,
    --名字
    NameLabel = nil,
    --数量
    Number = 1,
    --物品数据
    Data = nil,
}

-- 继承Form函数
function UIItemBatchForm:OnRegisterEvents()
	self:RegisterEvent(UIEventDefine.UIITEMBATCH_OPEN,self.OnOpen)
	self:RegisterEvent(UIEventDefine.UIITEMBATCH_CLOSE,self.OnClose)
end

function UIItemBatchForm:OnFirstShow()
    self.BackTrans = UIUtils.FindTrans(self.Trans, "Container/Back")
    self.InPutLabel = UIUtils.FindLabel(self.Trans, "Container/Back/InputLabel/Label")
    self.NameLabel = UIUtils.FindLabel(self.Trans, "Container/Back/NameLabel")
    self.Number = 1
    local _btn = UIUtils.FindBtn(self.Trans, "Container/Back/OneBtn")
    UIUtils.AddBtnEvent(_btn, self.OnBtnOne, self)
    _btn = UIUtils.FindBtn(self.Trans, "Container/Back/MaxBtn")
    UIUtils.AddBtnEvent(_btn, self.OnBtnMax, self)
    _btn = UIUtils.FindBtn(self.Trans, "Container/Back/InputLabel")
    UIUtils.AddBtnEvent(_btn, self.OnBtnInput, self)
    _btn = UIUtils.FindBtn(self.Trans, "Container/Back/SureBtn")
    UIUtils.AddBtnEvent(_btn, self.OnBtnSure, self)
    _btn = UIUtils.FindBtn(self.Trans, "Container/Back/CancelBtn")
    UIUtils.AddBtnEvent(_btn, self.OnBtnCancel, self)

    self.CSForm:AddAlphaAnimation()
end

function UIItemBatchForm:OnShowAfter()
    self.Number = 1
    self.InPutLabel.text = tostring(self.Number)
    self.CSForm.UIRegion = UIFormRegion.TopRegion
end

function UIItemBatchForm:OnOpen(obj, sender)

    -- //如果是C#传过来的
    self.Data = obj

    self.CSForm:Show(sender)
    if self.Data ~= nil and self.Data.Type ~= ItemType.Equip then
        self.NameLabel.text = self.Data.Name
        self.NameLabel.color = L_ItemBase.GetQualityColor(self.Data.ItemInfo.Color)
    end
end

function UIItemBatchForm:UnInit()
    self.InPutLabel.text = tostring(self.Number)
    self.Number = 1
end

function UIItemBatchForm:OnBtnOne()
    self.Number = 1;
    self.InPutLabel.text = "1"
end

function UIItemBatchForm:OnBtnMax()
    self.Number = self.Data.Count
    self.InPutLabel.text = tostring(self.Number)
end

function UIItemBatchForm:OnBtnSure()
    if self.Number <= 0 then
        self.Number = 1
    end
    if self.Data.CfgID == GameCenter.OfflineOnHookSystem.AddOnHookTimeItemID then
        -- 增加离线挂机时间道具批量使用，如果超出离线挂机上线，需要给提示
        local remainTime = GameCenter.OfflineOnHookSystem.RemainOnHookTime    -- //单位：秒
        local maxStorageTime = tonumber(DataConfig.DataGlobal[1467].Params) --//此处取出来的是分钟
        maxStorageTime = maxStorageTime * 60; --//转换成秒
        local item = DataConfig.DataItem[GameCenter.OfflineOnHookSystem.AddOnHookTimeItemID]
        local arr = Utils.SplitStr(item.EffectNum, "_")
        local oneItemAddTime = tonumber(arr[2]) --//此处item配的单位也是 秒
        if( remainTime + (oneItemAddTime * self.Number) > maxStorageTime ) then
            GameCenter.MsgPromptSystem:ShowMsgBox( "您使用的道具将使离线挂机时间超出上限，确定要使用？",
                DataConfig.DataMessageString.Get("C_MSGBOX_CANEL"),
                DataConfig.DataMessageString.Get("C_MSGBOX_AGREE"), function(x)
                if( x == MsgBoxResultCode.Button2 ) then
                    -- //确定
                    GameCenter.Network.Send("MSG_backpack.ReqUseItem", {itemId = self.Data.DBID, num = self.Number})
                    GameCenter.NumberInputSystem:CloseInput()
                    self:UnInit()
                    self:OnClose()
                end
            end, false, false, 5, CS.Funcell.Code.Logic.MsgInfoPriority.Highest, 1, nil, nil, CS.Funcell.Code.Logic.MsgBoxInfoTypeCode.None )
        else
            GameCenter.Network.Send("MSG_backpack.ReqUseItem", {itemId = self.Data.DBID, num = self.Number})
            GameCenter.NumberInputSystem:CloseInput();
            self:UnInit();
            self:OnClose()
        end
    else
        GameCenter.Network.Send("MSG_backpack.ReqUseItem", {itemId = self.Data.DBID, num = self.Number})
        GameCenter.NumberInputSystem:CloseInput();
        self:UnInit()
        self:OnClose()
    end
end

function UIItemBatchForm:OnBtnCancel()
    GameCenter.NumberInputSystem:CloseInput();
    self:UnInit()
    self:OnClose()
end

function UIItemBatchForm:OnBtnInput()
    GameCenter.NumberInputSystem:OpenInput(
        self.Data.Count, Vector3(161, self.BackTrans.localPosition.y, self.BackTrans.localPosition.z),
        function(num)
            if (num <= 0) then
                num = 1
            end
            self.Number = num
            self.InPutLabel.text = tostring(num)
        end, 0)
end
return UIItemBatchForm